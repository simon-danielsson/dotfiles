#!/usr/bin/env bash

set -euo pipefail

INPUT="$(realpath "$1")"
INDIR="$(dirname "$INPUT")"
BASENAME="$(basename "$INPUT" .pdf)"
OUTPUT="$INDIR/${BASENAME}-aged.pdf"

WORKDIR="$(mktemp -d)"
echo "Working in $WORKDIR"

pdftocairo -png -r 300 "$INPUT" "$WORKDIR/page"

for img in "$WORKDIR"/*.png; do
        base=$(basename "$img")
        ffmpeg -loglevel error -y -i "$img" \
                -vf "geq=r='r(X+0.3*sin(Y/30),Y)':g='g(X+0.6*sin(Y/20),Y)':b='b(X+0.6*sin(Y/30),Y)',gblur=sigma=0.8,noise=alls=70:allf=t+u,gblur=sigma=1.5,eq=contrast=3.2:brightness=-0.6:gamma=0.2,format=gray" \
                "$WORKDIR/out-$base"
        done

        img2pdf "$WORKDIR"/out-*.png -o "$OUTPUT"
        echo "Done! Output written to $OUTPUT"
