#!/bin/bash

#set -o errexit

if [ "$RUN_CLI" = "" ]; then
  exit 0
fi

INFO_DIR="${PROJECT_DIR}/build/test-coverage/"
OUTPUT_DIR="${PROJECT_DIR}/build/test-coverage/${PRODUCT_NAME}"

mkdir -p "$OUTPUT_DIR"
mkdir -p "$INFO_DIR"

TITLE="${PROJECT_NAME} - ${PRODUCT_NAME}"
SOCIALIZE_LIB_DIR="Socialize-Profiling.build"
INFO_TMP_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage_tmp.info"
INFO_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage.info"

eval "lcov --test-name \"${TITLE}\" --output-file \"$INFO_TMP_FILE\" --capture --directory \"$CONFIGURATION_TEMP_DIR\"/\"$SOCIALIZE_LIB_DIR\"/Objects-normal/i386/"

eval "lcov --extract \"${INFO_TMP_FILE}\" \"*/Socialize*/Classes*\" --output-file \"${INFO_FILE}\""

rm -f "${INFO_TMP_FILE}"

eval "genhtml --title \"${TITLE}\"  --output-directory \"$OUTPUT_DIR\" \"$INFO_FILE\" --legend"

exit $RETVAL
