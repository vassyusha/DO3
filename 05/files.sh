#!/bin/bash

report_file_counts() {
    local dir="$1"

    local total_files
    total_files=$(find "$dir" -type f 2>/dev/null | wc -l)
    echo "Total number of files = $total_files"

    local conf_count log_count archive_count symlink_count exec_count text_count
    conf_count=$(find "$dir" -type f -name "*.conf" 2>/dev/null | wc -l)
    log_count=$(find "$dir" -type f -name "*.log" 2>/dev/null | wc -l)
    archive_count=$(find "$dir" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" -o -name "*.tgz" -o -name "*.rar" -o -name "*.7z" -o -name "*.bz2" \) 2>/dev/null | wc -l)
    symlink_count=$(find "$dir" -type l 2>/dev/null | wc -l)
    exec_count=$(find "$dir" -type f -executable 2>/dev/null | wc -l)
    text_count=$(find "$dir" -type f 2>/dev/null | while read -r f; do file --mime-type -b "$f" 2>/dev/null; done | grep -c "^text/")

    echo "Number of:"
    echo "Configuration files (with the .conf extension) = $conf_count"
    echo "Text files = $text_count"
    echo "Executable files = $exec_count"
    echo "Log files (with the extension .log) = $log_count"
    echo "Archive files = $archive_count"
    echo "Symbolic links = $symlink_count"
}