#!/bin/bash

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR=$PWD/$THISDIR
OUTPUT_DIR="$THISDIR/../build/test-coverage/combined"
LCOV_PATH="$THISDIR/../Scripts/lcov-1.10/bin"

mkdir -p "$OUTPUT_DIR"

"${LCOV_PATH}/genhtml" --title "${TITLE}"  --output-directory "$OUTPUT_DIR" "$@" --legend
