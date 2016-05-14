#!/bin/bash
#
# This script runs the unittests in parallel for the entire
# set of custom built ImageMagick versions.
# 
# The output of each test is written to a file named after the version
# of IM tested.
#
# At the end, the test reports with failures are
# listed.
#

echo "Started running tests ..."

BUILD_PATHS=$(find custom-build/ -maxdepth 1 -mindepth 1)
OUT_DIR=$(mktemp -d)
for P in $BUILD_PATHS; do
    # extract IM version from the directory
    DIR_VERSION=$(echo "$P" | perl -ne 'm{(\d+(?:\.\d+)+[^\/]*)\/?} && print "$1"')
    # build output path
    OUT_FILE="$OUT_DIR/$DIR_VERSION"'.txt'
    # run the tests using a custom built version of imagemagick
    # (prepend custom built path so it can be used by the tests)
    NEW_PATH="$PWD/$P/bin:$PATH"
    CMD="PATH=\"""$NEW_PATH""\" ./run-tests.sh >$OUT_FILE 2>&1;"
    echo "$CMD"
done | xargs -I% -P 6 /bin/bash -c '%';

echo "$OUT_DIR"
echo "Test reports with failures:"
grep -lir FAIL "$OUT_DIR"
