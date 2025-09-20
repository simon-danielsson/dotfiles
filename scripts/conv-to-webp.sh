#!/bin/bash

if [ -z "$1" ]; then
        echo "Usage: $0 /path/to/folder"
        exit 1
fi

INPUT_DIR="$1"

if [ ! -d "$INPUT_DIR" ]; then
        echo "Error: Directory $INPUT_DIR does not exist."
        exit 1
fi

for file in "$INPUT_DIR"/*.{png,jpg,jpeg,JPG,JPEG,PNG}; do
        [ -e "$file" ] || continue

        filename=$(basename "$file")
        name="${filename%.*}"

        output="$INPUT_DIR/$name.webp"

        ffmpeg -i "$file" -lossless 1 "$output"

        echo "Converted: $file → $output"
done

echo "Conversion complete!"

