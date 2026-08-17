#!/bin/bash

# Проверка параметра
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/directory/"
    exit 1
fi

DIR_PATH="$1"

# Проверка, что параметр заканчивается на "/"
if [[ ! "$DIR_PATH" =~ /$ ]]; then
    echo "Error: Parameter must end with '/'"
    echo "Example: $0 /var/log/"
    exit 1
fi

# Проверка существования каталога
if [[ ! -d "$DIR_PATH" ]]; then
    echo "Error: Directory '$DIR_PATH' does not exist"
    exit 1
fi

# Время начала выполнения
START_TIME=$(date +%s.%N)

# Функция для форматирования размера
format_size() {
    local size=$1
    if (( $(echo "$size >= 1073741824" | bc -l) )); then
        printf "%.2f GB" "$(echo "scale=2; $size/1073741824" | bc)"
    elif (( $(echo "$size >= 1048576" | bc -l) )); then
        printf "%.2f MB" "$(echo "scale=2; $size/1048576" | bc)"
    elif (( $(echo "$size >= 1024" | bc -l) )); then
        printf "%.2f KB" "$(echo "scale=2; $size/1024" | bc)"
    else
        printf "%d B" "$size"
    fi
}

# Функция для определения типа файла
get_file_type() {
    local file="$1"
    
    # Проверка на символическую ссылку
    if [[ -L "$file" ]]; then
        echo "Symbolic link"
        return
    fi
    
    # Проверка на исполняемый файл
    if [[ -x "$file" ]] && [[ ! -d "$file" ]]; then
        echo "Executable file"
        return
    fi
    
    # Проверка на файлы по расширениям
    case "$file" in
        *.conf)
            echo "Configuration file"
            ;;
        *.log)
            echo "Log file"
            ;;
        *.zip|*.tar|*.gz|*.bz2|*.xz|*.7z|*.rar|*.tgz)
            echo "Archive file"
            ;;
        *.txt|*.text|*.md|*.rst)
            echo "Text file"
            ;;
        *)
            echo "Other file"
            ;;
    esac
}

# Функция для получения расширения файла
get_extension() {
    local file="$1"
    local ext="${file##*.}"
    if [[ "$ext" != "$file" ]]; then
        echo "$ext"
    else
        echo "no_ext"
    fi
}

# Функция для получения MD5 хеша
get_md5_hash() {
    local file="$1"
    if [[ -f "$file" ]] && [[ -x "$file" ]]; then
        md5sum "$file" 2>/dev/null | awk '{print $1}'
    else
        echo ""
    fi
}

echo "Starting analysis of directory: $DIR_PATH"
echo "----------------------------------------"

# 1. Общее число папок (включая вложенные)
TOTAL_FOLDERS=$(find "$DIR_PATH" -type d 2>/dev/null | wc -l)
echo "Total number of folders (including all nested ones) = $TOTAL_FOLDERS"

# 2. Топ-5 папок с самым большим весом
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
find "$DIR_PATH" -type d 2>/dev/null | while read -r dir; do
    size=$(du -sb "$dir" 2>/dev/null | awk '{print $1}')
    if [[ -n "$size" ]]; then
        echo "$size|$dir"
    fi
done | sort -rn | head -5 | awk -F'|' '{
    size=$1
    path=$2
    if (size >= 1073741824) {
        size_str = sprintf("%.2f GB", size/1073741824)
    } else if (size >= 1048576) {
        size_str = sprintf("%.2f MB", size/1048576)
    } else if (size >= 1024) {
        size_str = sprintf("%.2f KB", size/1024)
    } else {
        size_str = sprintf("%d B", size)
    }
    printf "%d - %s, %s\n", NR, path, size_str
}'

# 3. Общее число файлов
TOTAL_FILES=$(find "$DIR_PATH" -type f 2>/dev/null | wc -l)
echo "Total number of files = $TOTAL_FILES"

# 4. Подсчет файлов по типам
echo "Number of:"
CONF_FILES=$(find "$DIR_PATH" -type f -name "*.conf" 2>/dev/null | wc -l)
echo "Configuration files (with the .conf extension) = $CONF_FILES"

TEXT_FILES=$(find "$DIR_PATH" -type f \( -name "*.txt" -o -name "*.text" -o -name "*.md" -o -name "*.rst" \) 2>/dev/null | wc -l)
echo "Text files = $TEXT_FILES"

EXEC_FILES=$(find "$DIR_PATH" -type f -executable 2>/dev/null | wc -l)
echo "Executable files = $EXEC_FILES"

LOG_FILES=$(find "$DIR_PATH" -type f -name "*.log" 2>/dev/null | wc -l)
echo "Log files (with the extension .log) = $LOG_FILES"

ARCH_FILES=$(find "$DIR_PATH" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.bz2" -o -name "*.xz" -o -name "*.7z" -o -name "*.rar" -o -name "*.tgz" \) 2>/dev/null | wc -l)
echo "Archive files = $ARCH_FILES"

SYMLINKS=$(find "$DIR_PATH" -type l 2>/dev/null | wc -l)
echo "Symbolic links = $SYMLINKS"

# 5. Топ-10 файлов с самым большим весом
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
find "$DIR_PATH" -type f 2>/dev/null | while read -r file; do
    size=$(stat -c %s "$file" 2>/dev/null)
    if [[ -n "$size" ]]; then
        type=$(get_file_type "$file")
        echo "$size|$file|$type"
    fi
done | sort -rn | head -10 | awk -F'|' '{
    size=$1
    path=$2
    type=$3
    if (size >= 1073741824) {
        size_str = sprintf("%.2f GB", size/1073741824)
    } else if (size >= 1048576) {
        size_str = sprintf("%.2f MB", size/1048576)
    } else if (size >= 1024) {
        size_str = sprintf("%.2f KB", size/1024)
    } else {
        size_str = sprintf("%d B", size)
    }
    printf "%d - %s, %s, %s\n", NR, path, size_str, type
}'

# 6. Топ-10 исполняемых файлов с самым большим весом
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and hash):"
find "$DIR_PATH" -type f -executable 2>/dev/null | while read -r file; do
    size=$(stat -c %s "$file" 2>/dev/null)
    if [[ -n "$size" ]]; then
        hash=$(get_md5_hash "$file")
        if [[ -n "$hash" ]]; then
            echo "$size|$file|$hash"
        fi
    fi
done | sort -rn | head -10 | awk -F'|' '{
    size=$1
    path=$2
    hash=$3
    if (size >= 1073741824) {
        size_str = sprintf("%.2f GB", size/1073741824)
    } else if (size >= 1048576) {
        size_str = sprintf("%.2f MB", size/1048576)
    } else if (size >= 1024) {
        size_str = sprintf("%.2f KB", size/1024)
    } else {
        size_str = sprintf("%d B", size)
    }
    printf "%d - %s, %s, %s\n", NR, path, size_str, hash
}'

# 7. Время выполнения скрипта
END_TIME=$(date +%s.%N)
EXECUTION_TIME=$(echo "$END_TIME - $START_TIME" | bc)
printf "Script execution time (in seconds) = %.2f\n" "$EXECUTION_TIME"