#!/bin/bash

set -o errexit

PROJECT_DIR=$(PWD)
PRODUCT_NAME='UIIntegrationTests'
CONFIGURATION_TEMP_DIR=`xcodebuild -workspace Socialize.xcworkspace -scheme TestApp -configuration Debug -showBuildSettings -sdk iphonesimulator | grep CONFIGURATION_TEMP_DIR | cut -c30-`
echo "CONFIGURATION_TEMP_DIR: ${CONFIGURATION_TEMP_DIR}"
PROJECT_NAME='Socialize'

INFO_DIR="${PROJECT_DIR}/build/test-coverage/"
echo "INFO_DIR: ${INFO_DIR}"

OUTPUT_DIR="${PROJECT_DIR}/build/test-coverage/${PRODUCT_NAME}"
echo "OUTPUT_DIR: ${OUTPUT_DIR}"
LCOV_PATH="${PROJECT_DIR}/Scripts/lcov-1.10/bin"
echo "LCOV_PATH: ${LCOV_PATH}"
LCOV="${LCOV_PATH}/lcov"
echo "LCOV: ${LCOV}"

mkdir -p "$OUTPUT_DIR"
echo "Created directory: ${OUTPUT_DIR}"
mkdir -p "$INFO_DIR"
echo "Created directory: ${INFO_DIR}"

TITLE="${PROJECT_NAME} - ${PRODUCT_NAME}"
echo "TITLE: ${TITLE}"
SOCIALIZE_LIB_DIR="Socialize.build"
echo "SOCIALIZE_LIB_DIR: ${SOCIALIZE_LIB_DIR}"
INFO_TMP_FILE="${INFO_DIR}${PRODUCT_NAME}-Coverage_tmp.info"
echo "INFO_TMP_FILE: ${INFO_TMP_FILE}"
INFO_FILE="${INFO_DIR}${PRODUCT_NAME}-Coverage.info"
echo "INFO_FILE: ${INFO_FILE}"

"${LCOV}" --test-name "${TITLE}" --output-file "$INFO_TMP_FILE" --capture --directory "$CONFIGURATION_TEMP_DIR/$SOCIALIZE_LIB_DIR/Objects-normal/i386/"

"${LCOV}" --extract "${INFO_TMP_FILE}" "*/Socialize*/*" --output-file "${INFO_FILE}"

"${LCOV_PATH}/genhtml" --title "${TITLE}"  --output-directory "$OUTPUT_DIR" "$INFO_FILE" --legend

exit $RETVAL
