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

for f in $(find ./samples/sample.* -type f -regex '.*\.\(dcm\|jpg\|jpeg\|png\|gif\)'); do
    identify -verbose $f > "$f.txt"
    python ImageMagickIdentifyParser.py -i $f -x > "$f.xml"
    python ImageMagickIdentifyParser.py -i $f -j > "$f.json"
done

echo "Done."
