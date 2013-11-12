#!/bin/bash

set -o errexit

if [ "$RUN_CLI" = "" ]; then
  exit 0
fi

INFO_DIR="${PROJECT_DIR}/build/test-coverage/"
OUTPUT_DIR="${PROJECT_DIR}/build/test-coverage/${PRODUCT_NAME}"
LCOV_PATH=${SRCROOT}/Scripts/lcov-1.10/bin
LCOV=${LCOV_PATH}/lcov

mkdir -p "$OUTPUT_DIR"
mkdir -p "$INFO_DIR"

TITLE="${PROJECT_NAME} - ${PRODUCT_NAME}"
SOCIALIZE_LIB_DIR="Socialize-profiling.build"
SOCIALIZE_NOARC_LIB_DIR="Socialize-noarc-profiling.build"
INFO_TMP_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage_tmp.info"
INFO_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage.info"

"${LCOV}" --test-name "${TITLE}" --output-file "$INFO_TMP_FILE" --capture --directory "$CONFIGURATION_TEMP_DIR/$SOCIALIZE_LIB_DIR/Objects-normal/i386/" --directory "$CONFIGURATION_TEMP_DIR/$SOCIALIZE_NOARC_LIB_DIR/Objects-normal/i386/"

"${LCOV}" --extract "${INFO_TMP_FILE}" "*/Socialize*/*" --output-file "${INFO_FILE}"

"${LCOV_PATH}/genhtml" --title "${TITLE}"  --output-directory "$OUTPUT_DIR" "$INFO_FILE" --legend

exit $RETVAL
