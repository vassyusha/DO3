#!/bin/bash

report_folders() {
    local dir="$1"

    local total_folders
    total_folders=$(find "$dir" -mindepth 1 -type d 2>/dev/null | wc -l)
    echo "Total number of folders (including all nested ones) = $total_folders"

    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"

    find "$dir" -mindepth 1 -type d 2>/dev/null | while read -r d; do
        local size
        size=$(du -sb "$d" 2>/dev/null | cut -f1)
        echo "$size $d"
    done | sort -rn | head -5 | {
        local i=1
        while read -r size path; do
            local hsize
            hsize=$(human_size "$size")
            echo "$i - ${path}/, $hsize"
            i=$((i+1))
        done
    }
}