#!/bin/bash

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR=$PWD/$THISDIR
OUTPUT_DIR="$THISDIR/../build/test-coverage/combined"

mkdir -p "$OUTPUT_DIR"

genhtml --title "${TITLE}"  --output-directory "$OUTPUT_DIR" "$@" --legend
