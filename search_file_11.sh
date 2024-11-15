#!/bin/bash
out_file="$1"
ext="$2"
dir="$3"

if [[ ! -d "$dir" ]]; then
    echo " Directory: "$dir" unavailable or does not exist " 
    exit 1
fi

find "$dir" -name "*$ext" > "$out_file"
echo "File names with specified extensions have been move to the file $out_file"

