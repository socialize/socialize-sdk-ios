#!/bin/bash

# most of this taken from
# http://code.google.com/p/google-toolbox-for-mac/source/browse/trunk/UnitTesting/

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR="$PWD/$THISDIR"

# If we aren't running from the command line, then exit
if [ -z "$RUN_CLI" ]; then
  exit 0
fi

if [ -n "$SIMVER_OVERRIDE" ]; then
    export SDKROOT="$DEVELOPER_DIR/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${SIMVER_OVERRIDE}.sdk/"
fi

echo DYLD_ROOT_PATH = "$SDKROOT"
export DYLD_ROOT_PATH="$SDKROOT"
export DYLD_FRAMEWORK_PATH="$CONFIGURATION_BUILD_DIR"
export IPHONE_SIMULATOR_ROOT="$SDKROOT"

export NSDebugEnabled=YES
export NSZombieEnabled=YES
export NSDeallocateZombies=NO
export NSHangOnUncaughtException=YES
export NSAutoreleaseFreedObjectCheckEnabled=YES

export DYLD_FRAMEWORK_PATH="$CONFIGURATION_BUILD_DIR"

TEST_TARGET_EXECUTABLE_PATH="$TARGET_BUILD_DIR/$EXECUTABLE_PATH"

if [ ! -e "$TEST_TARGET_EXECUTABLE_PATH" ]; then
  echo ""
  echo "  ------------------------------------------------------------------------"
  echo "  Missing executable path: "
  echo "     $TEST_TARGET_EXECUTABLE_PATH."
  echo "  The product may have failed to build or could have an old xcodebuild in your path (from 3.x instead of 4.x)."
  echo "  ------------------------------------------------------------------------"
  echo ""
  exit 1
fi

export CFFIXED_USER_HOME="$TEMP_FILES_DIR/iPhone Simulator User Dir"

# Cleanup user home directory
if [ -d "$CFFIXED_USER_HOME" ]; then
  rm -rf "$CFFIXED_USER_HOME"
fi
mkdir "$CFFIXED_USER_HOME"
mkdir "$CFFIXED_USER_HOME/Documents"
mkdir -p "$CFFIXED_USER_HOME/Library/Caches"

# securityd for keychain / auth
LAUNCHNAME="RunIPhoneLaunchDaemons"
launchctl submit -l $LAUNCHNAME -- "${THISDIR}/RunIPhoneLaunchDaemons.sh" $IPHONE_SIMULATOR_ROOT $CFFIXED_USER_HOME
trap "launchctl remove $LAUNCHNAME" INT TERM EXIT

killall "iPhone Simulator" >/dev/null 2>&1
#RUN_CMD="gdb --args \"$TEST_TARGET_EXECUTABLE_PATH\" -RegisterForSystemEvents"
RUN_CMD="\"$TEST_TARGET_EXECUTABLE_PATH\" -RegisterForSystemEvents"

echo "Running: $RUN_CMD"
set +o errexit # Disable exiting on error so script continues if tests fail
eval $RUN_CMD
RETVAL=$?
set -o errexit

unset DYLD_ROOT_PATH
unset DYLD_FRAMEWORK_PATH
unset IPHONE_SIMULATOR_ROOT

OUTPUTDIR="$PROJECT_DIR/build/${PRODUCT_NAME}-test-results"
echo "Making dir $OUTPUTDIR"
mkdir -p "$OUTPUTDIR"

# GHUnit can write JUNIT xml, if this was done, copy to $BUILD_DIR
if [ -n "$WRITE_JUNIT_XML" ]; then
  MY_TMPDIR=`/usr/bin/getconf DARWIN_USER_TEMP_DIR`
  RESULTS_DIR="${MY_TMPDIR}test-results"

  if [ -d "$RESULTS_DIR" ]; then
    `$CP -r "$RESULTS_DIR/." "$OUTPUTDIR" && rm -r "$RESULTS_DIR"`
  fi
fi

exit $RETVAL
