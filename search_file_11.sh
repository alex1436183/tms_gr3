#!/bin/bash
out_file="$1"
ext="$2"
dir="$3"
find "$dir" -name "*$ext" > "$out_file"
echo "Имена файлов с заданными расширениями перемещены в файл $out_file"
 
