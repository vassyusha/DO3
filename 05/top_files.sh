#!/bin/bash

report_top_files() {
    local dir="$1"

    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"

    find "$dir" -type f 2>/dev/null | while read -r f; do
        local size
        size=$(stat -c%s "$f" 2>/dev/null)
        echo "$size $f"
    done | sort -rn | head -10 | {
        local i=1
        while read -r size path; do
            local hsize type
            hsize=$(human_size "$size")
            type=$(get_type "$path")
            echo "$i - $path, $hsize, $type"
            i=$((i+1))
        done
    }
}

report_top_executables() {
    local dir="$1"

    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"

    find "$dir" -type f -executable 2>/dev/null | while read -r f; do
        local size
        size=$(stat -c%s "$f" 2>/dev/null)
        echo "$size $f"
    done | sort -rn | head -10 | {
        local i=1
        while read -r size path; do
            local hsize hash
            hsize=$(human_size "$size")
            hash=$(md5sum "$path" 2>/dev/null | cut -d' ' -f1)
            echo "$i - $path, $hsize, $hash"
            i=$((i+1))
        done
    }
}