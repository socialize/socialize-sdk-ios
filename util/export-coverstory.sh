#!/bin/bash -x

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR="$PWD/$THISDIR"

. "${THISDIR}/../build/unitTests-env"

GCDADIR="${CONFIGURATION_TEMP_DIR}/Socialize-Profiling.build/Objects-normal/i386/"
OUTDIR="${PROJECT_DIR}/build/coverstory-export"

rm -rf "${OUTDIR}"
osascript ${THISDIR}/export-coverstory.scpt "${GCDADIR}" "${OUTDIR}"
