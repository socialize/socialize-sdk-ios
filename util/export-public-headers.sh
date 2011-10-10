#!/bin/bash

SOCIALIZE_DIR=${PROJECT_DIR}/Socialize
PUBLIC_HEADERS_FILE="${SOCIALIZE_DIR}/public-headers"

HEADERS_OUT="${CONFIGURATION_BUILD_DIR}/${PUBLIC_HEADERS_FOLDER_PATH}"
echo "Wiping headers in $HEADERS_OUT"
rm -rf "$HEADERS_OUT"

echo "Copying public headers to $HEADERS_OUT"
mkdir -p "$HEADERS_OUT"
for f in $(cat "$PUBLIC_HEADERS_FILE"); do
  cp "${SOCIALIZE_DIR}/$f" "$HEADERS_OUT"
done
