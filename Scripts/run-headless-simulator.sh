#!/bin/sh

# If we aren't running from the command line, then exit
if [ "$GHUNIT_CLI" = "" ] && [ "$GHUNIT_AUTORUN" = "" ]; then
  exit 0
fi


TEST_TARGET_EXECUTABLE_PATH="$TARGET_BUILD_DIR/$EXECUTABLE_FOLDER_PATH"

if [ ! -e "$TEST_TARGET_EXECUTABLE_PATH" ]; then
  echo ""
  echo "  ------------------------------------------------------------------------"
  echo "  Missing executable path: "
  echo "     $TEST_TARGET_EXECUTABLE_PATH."
  echo "  The product may have failed to build."
  echo "  ------------------------------------------------------------------------"
  echo ""
  exit 1
fi

MY_TMPDIR=`/usr/bin/getconf DARWIN_USER_TEMP_DIR`
RESULTS_DIR="${MY_TMPDIR}test-results"

RUN_CMD="ios-sim launch \"$TEST_TARGET_EXECUTABLE_PATH\"  --setenv SZEventTrackingDisabled=1 --setenv WRITE_JUNIT_XML=1 --setenv JUNIT_XML_DIR=$RESULTS_DIR --setenv GHUNIT_CLI=1 --setenv GHUNIT_AUTORUN=1 --setenv GHUNIT_AUTOEXIT=1"

echo "Running: $RUN_CMD"
set +o errexit # Disable exiting on error so script continues if tests fail
eval $RUN_CMD
RETVAL=$?
set -o errexit

OUTPUTDIR="$PROJECT_DIR/build/${PRODUCT_NAME}-test-results"
echo "Making dir $OUTPUTDIR"
mkdir -p "$OUTPUTDIR"

if [ -n "$WRITE_JUNIT_XML" ]; then
  echo "Dir: $RESULTS_DIR"
  echo "BUILD $BUILD_DIR"
  if [ -d "$RESULTS_DIR" ]; then
  `$CP -r "$RESULTS_DIR" "$OUTPUTDIR" && rm -r "$RESULTS_DIR"`
  fi
fi

exit $RETVAL
