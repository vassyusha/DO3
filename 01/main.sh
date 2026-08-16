#!/bin/bash

if [[ "$1" =~ ^-?[0-9]+$ ]];
then
    echo "its should be text, not a number"
elif [[ -n "$1" ]]
then
    echo "$1"
else
    echo "input shouldn't be empty"
fi