#!/usr/bin/env bash

set -euo pipefail

INPUT="$(realpath "$1")"
INDIR="$(dirname "$INPUT")"
FILENAME="$(basename "$INPUT")"

# Safety: skip already-inverted PDFs
case "$FILENAME" in
  *inv.pdf)
    echo "Skipping already inverted file: $FILENAME"
    exit 0
    ;;
esac

BASENAME="$(basename "$INPUT" .pdf)"
OUTPUT="$INDIR/${BASENAME}-inv.pdf"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
echo "Working in $WORKDIR"

pdftocairo -png -r 300 "$INPUT" "$WORKDIR/page"

for img in "$WORKDIR"/*.png; do
    base=$(basename "$img")
    ffmpeg -loglevel error -y -i "$img" \
        -vf "negate,curves=r='0/0.141 1/0.863':g='0/0.141 1/0.863':b='0/0.176 1/0.922'" \
        "$WORKDIR/out-$base"
done

img2pdf "$WORKDIR"/out-*.png -o "$OUTPUT"

echo "Done! Output written to $OUTPUT"
