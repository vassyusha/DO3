#!/bin/bash

if [[ $# -ne 4 ]]; then
    echo "you need to input 4 parametrs"
    echo "colors: 1-white, 2-red, 3-green, 4-blue, 5-purple, 6-black"
    exit 1
fi

bash ./check.sh "$1" "$2" "$3" "$4"

source ./get_info.sh

bash ./color.sh "$1" "$2" "$3" "$4"