#!/bin/ksh

#set -o errexit

if [ "$GHUNIT_UI_CLI" = "" ] && [ "$GHUNIT_AUTORUN" = "" ]; then
  exit 0
fi

#export DYLD_ROOT_PATH="$SDKROOT"
#export DYLD_FRAMEWORK_PATH="$CONFIGURATION_BUILD_DIR"
export IPHONE_SIMULATOR_ROOT="$SDKROOT"

export NSDebugEnabled=YES
export NSZombieEnabled=YES
export NSDeallocateZombies=NO
export NSHangOnUncaughtException=YES
export NSAutoreleaseFreedObjectCheckEnabled=YES


TEST_TARGET_EXECUTABLE_PATH="$TARGET_BUILD_DIR/$EXECUTABLE_PATH"
SIMULATOR_PATH="/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone Simulator.app/Contents/MacOS/iPhone Simulator"

KILL_SIMULATOR="killall -m -KILL \"iPhone Simulator\""
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

eval $KILL_SIMULATOR
eval "killall unitTests"
failure_regex="test failures: (.*)"
FAILURES="1"
#execute the simulatory and run the application and unit tests, read the 
#standard out and kill the simulator when the tests are done
"$SIMULATOR_PATH" -SimulateRestart NO -SimulateApplication "$TEST_TARGET_EXECUTABLE_PATH" | while read line
do
    echo $line
    if [[ $line =~ $failure_regex ]]; then
        FAILURES=${BASH_REMATCH[1]}
        eval $KILL_SIMULATOR
        exit $FAILURES
    fi
done
RETVAL=$?
if [[ "$RETVAL" != "0" ]]; then
    echo "$RETVAL unit tests failed, exiting..."
    exit 10
fi
unset DYLD_ROOT_PATH
unset DYLD_FRAMEWORK_PATH
unset IPHONE_SIMULATOR_ROOT

OUTPUT_DIR="${PROJECT_DIR}/build/"

if [ -n "$WRITE_JUNIT_XML" ]; then
  MY_TMPDIR=`/usr/bin/getconf DARWIN_USER_TEMP_DIR`
  RESULTS_DIR="${MY_TMPDIR}test-results"

  if [ -d "$RESULTS_DIR" ]; then
	`$CP -r "$RESULTS_DIR" "$OUTPUT_DIR" && rm -r "$RESULTS_DIR"`
  fi
fi

if [ ! -e "$OUTPUT_DIR/test-coverage/" ]; then
    mkdir -p "$OUTPUT_DIR/test-coverage/"

fi

SOCIALIZE_LIB_DIR="Socialize-Profiling.build"

eval "lcov --test-name \"Socialize iOS SDK\" --output-file \"$OUTPUT_DIR\"/test-coverage/SocializeSDK-iOS-Coverage_tmp.info --capture --directory \"$CONFIGURATION_TEMP_DIR\"/\"$SOCIALIZE_LIB_DIR\"/Objects-normal/i386/"

eval "lcov --extract \"$OUTPUT_DIR\"/test-coverage/SocializeSDK-iOS-Coverage_tmp.info \"*/Socialize*/Classes*\" --output-file \"$OUTPUT_DIR\"/test-coverage/SocializeSDK-iOS-Coverage.info"

eval "rm -rf \"$OUTPUT_DIR\"/test-coverage/SocializeSDK-iOS-Coverage_tmp.info"

eval "genhtml --title \"Socialize SDK iOS\"  --output-directory \"$OUTPUT_DIR\"/test-coverage \"$OUTPUT_DIR\"/test-coverage/SocializeSDK-iOS-Coverage.info --legend"


exit $RETVAL
