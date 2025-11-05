#!/bin/bash
DIR="$1"  # the folder you pass as argument

# Make sure the folder exists
if [ ! -d "$DIR" ]; then
        echo "Directory not found: $DIR"
        exit 1
fi

# Convert each .m4a to .flac in the same folder, delete original after success
for f in "$DIR"/*.m4a; do
        [ -e "$f" ] || continue  # skip if no files match
        ffmpeg -i "$f" -map_metadata 0 -c:a flac "${f%.m4a}.flac" && rm "$f"
done

