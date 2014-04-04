#!/bin/bash

set -o errexit

if [ "$RUN_CLI" = "" ]; then
  exit 0
fi

export INFO_DIR="${PROJECT_DIR}/build/test-coverage/"
export OUTPUT_DIR="${PROJECT_DIR}/build/test-coverage/${PRODUCT_NAME}"
export LCOV_PATH=${SRCROOT}/Scripts/lcov-1.10/bin
export LCOV=${LCOV_PATH}/lcov
echo $INFO_DIR
echo $OUTPUT_DIR
echo $LCOV_PATH
echo $LCOV

mkdir -p "$OUTPUT_DIR"
mkdir -p "$INFO_DIR"

export TITLE="${PROJECT_NAME} - ${PRODUCT_NAME}"
export SOCIALIZE_LIB_DIR="Socialize.build"
export INFO_TMP_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage_tmp.info"
export INFO_FILE="${INFO_DIR}/${PRODUCT_NAME}-Coverage.info"
export INPUT_DIR="$CONFIGURATION_TEMP_DIR/$SOCIALIZE_LIB_DIR/Objects-normal/i386/"

echo $TITLE
echo $INPUT_DIR
echo "${LCOV} --test-name ${TITLE} --output-file $INFO_TMP_FILE --capture --directory $INPUT_DIR"

"${LCOV}" --test-name "${TITLE}" --output-file "$INFO_TMP_FILE" --capture --directory "$INPUT_DIR"
"${LCOV}" --extract "${INFO_TMP_FILE}" "*/Socialize*/*" --output-file "${INFO_FILE}"

"${LCOV_PATH}/genhtml" --title "${TITLE}"  --output-directory "$OUTPUT_DIR" "$INFO_FILE" --legend

exit $RETVAL
