#!/bin/bash
# This script runs a series of tests to make sure
# the output is valid.

echo "Checking deps..."
command -v identify >/dev/null 2>&1 || {
    echo >&2 \
"[ERROR] Identify not installed.
         To install: sudo apt-get install imagemagick"
    exit 1;
}

echo "Generating samples...."
#OPT="2>/dev/null >/dev/null"
OPT=""

for f in $(find ./samples -type f \( -iname \*.dcm -o -iname \*.jpg -o -iname \*.png \)); do
    identify -verbose $f > "$f.txt"
    python ImageMagickIdentifyParser.py -t xml $f > "$f.xml"
    python ImageMagickIdentifyParser.py -t json $f > "$f.json"
done

echo "Done."
