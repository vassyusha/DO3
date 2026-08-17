#!/bin/bash

if [[ $# -ne 4 ]]; then
    echo "you need to input 4 parametrs"
    echo "colors: 1-white, 2-red, 3-green, 4-blue, 5-purple, 6-black"
    exit 1
fi

for param in "$@"; do
    if ! [[ "$param" =~ ^[1-6]$ ]]; then
        echo "params should be in range [1 до 6]"
        echo "but got: $param"
        exit 1
    fi
done

if [[ $1 -eq $2 ]]; then
    echo "background and font colors should be different, but got the same (1 and 2)"
    echo "please, try again"
    exit 1
fi

if [[ $3 -eq $4 ]]; then
    echo "background and font colors should be different, but got the same (3 and 4)"
    echo "please, try again"
    exit 1
fi