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
find "$dir" -name "*$extension" > "$out_file"
echo "Имена файлов с заданными расширениями перемещены в файл $out_file"
 
