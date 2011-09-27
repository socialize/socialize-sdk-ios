#!/bin/bash

[ -n "$PROJECT_DIR" ] || { echo "Script must be run from xcode"; exit 1; }
[ -n "$PRODUCT_NAME" ] || { echo "Script must be run from xcode"; exit 1; }
OUTDIR="${PROJECT_DIR}/build"
mkdir -p "$OUTDIR"

set | egrep -v 'SHELLOPTS|PPID|UID|BASH_VERSINFO|com.' > "${OUTDIR}/${PRODUCT_NAME}-env"
