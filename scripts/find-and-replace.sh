#!/usr/bin/env bash

help() {
    echo "Usage: replace <path> <str_to_replace> <replacement_str> [include_glob]"
    echo "Example: replace ./src foo bar '*.js'"
    exit 1
}

[[ -z "$1" || -z "$2" || -z "$3" ]] && help

path="$1"
to_replace="$2"
replacement="$3"
include="${4:-*}"

OS="$(uname)"

files=$(grep -rl --include="$include" "$to_replace" "$path")

if [[ -z "$files" ]]; then
    echo "No matching files found."
    exit 0
fi

echo "Files to update:"
echo "$files"

while IFS= read -r file; do
    if [[ "$OS" == "Linux" ]]; then
        sed -i "s|$to_replace|$replacement|g" "$file"
    elif [[ "$OS" == "Darwin" ]]; then
        sed -i '' "s|$to_replace|$replacement|g" "$file"
    else
        echo "Unknown OS: $OS"
        exit 1
    fi
done <<< "$files"
