#!/bin/bash

source "./utils.sh"
source "./folders.sh"
source "./files.sh"
source "$SCRIPT_DIR/lib/top_files.sh"

START_TIME=$(date +%s.%N)

if [ -z "$1" ]; then
    echo "there should be a path to the directory"
    exit 1
fi

DIR="$1"

if [[ "$DIR" != */ ]]; then
    echo "there should be a / in the end"
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "this directory doesnt exist"
    exit 1
fi

report_folders "$DIR"
report_file_counts "$DIR"
report_top_files "$DIR"
report_top_executables "$DIR"

END_TIME=$(date +%s.%N)
ELAPSED=$(awk "BEGIN {printf \"%.1f\", $END_TIME - $START_TIME}")
echo "Script execution time (in seconds) = $ELAPSED"