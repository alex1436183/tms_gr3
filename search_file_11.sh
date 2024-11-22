#!/bin/bash
#check for number of input parameters
if [ "$#" -ne 3 ]
then
  echo "Incorrect number of arguments"
  exit 1
fi
out_file="$1"
extension="$2"
dir="$3"


if [[ ! -d "$dir" ]]; then
    echo " Directory: "$dir" unavailable or does not exist " 
    exit 1
fi

find "$dir" -name "*$extension" > "$out_file"
echo "File names with specified extensions have been move to the file $out_file"

