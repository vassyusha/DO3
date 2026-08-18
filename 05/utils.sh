#!/bin/bash

human_size() {
    local bytes=$1
    if (( bytes >= 1073741824 )); then
        awk "BEGIN {printf \"%.2f GB\", $bytes/1073741824}"
    elif (( bytes >= 1048576 )); then
        awk "BEGIN {printf \"%.2f MB\", $bytes/1048576}"
    elif (( bytes >= 1024 )); then
        awk "BEGIN {printf \"%.2f KB\", $bytes/1024}"
    else
        echo "${bytes} B"
    fi
}

get_type() {
    local f="$1"
    case "$f" in
        *.conf) echo "conf" ;;
        *.txt)  echo "txt" ;;
        *.log)  echo "log" ;;
        *.zip|*.tar|*.gz|*.tgz|*.rar|*.7z|*.bz2) echo "archive" ;;
        *)
            if [ -L "$f" ]; then
                echo "symlink"
            elif [ -x "$f" ] && [ -f "$f" ]; then
                echo "exe"
            else
                echo "other"
            fi
            ;;
    esac
}