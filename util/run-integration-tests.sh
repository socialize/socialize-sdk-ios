#!/bin/bash

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR=$PWD/$THISDIR
SRCDIR="$THISDIR/../SampleSdkApp"
APPNAME="SampleSdkApp Integration Tests"
XCODE_ENVIRONMENT="${SRCDIR}/build/${APPNAME}-env"

killall "iPhone Simulator" >/dev/null 2>&1

set -o errexit
#set -o verbose


function cleanup() {
  set +o errexit
  for pid in $simPID $tailPID; do
    if [ -n "$pid" ] && kill -0 $pid >/dev/null 2>&1; then
      kill $pid > /dev/null 2>&1 
    fi
  done
  echo "Cleanup complete"
}
trap cleanup INT TERM EXIT

# Build the "Integration Tests" target to run in the simulator
cd "$SRCDIR" && xcodebuild -workspace SampleSdkApp.xcworkspace -scheme "${APPNAME}" -configuration Release -sdk iphonesimulator build

[ -e "${XCODE_ENVIRONMENT}" ] || { echo "Can't find ${XCODE_ENVIRONMENT}. You must run dump-xcode-environment.sh from the xcode target."; exit 1; }
source "${XCODE_ENVIRONMENT}"

# Run the app we just built in the simulator and send its output to a file
# /path/to/MyApp.app should be the relative or absolute path to the application bundle that was built in the previous step

OUTFILE="/tmp/KIF-$$.out"

# Force location enabled ahead of time
${THISDIR}/simulator-enable-location.py com.pointabout.SampleSdkApp-Integration-Tests

# pipe from waxsim to tee does not work
touch "$OUTFILE"
KIF_CLI=1 "$THISDIR/waxsim" -f "iphone" "$CONFIGURATION_BUILD_DIR/${APPNAME}.app" >"$OUTFILE" 2>&1 &
simPID=$!

tail -f "$OUTFILE" &
tailPID=$!

echo "waiting for $simPID"
wait $simPID
echo "Simulator run complete!"

# WaxSim hides the return value from the app, so to determine success we search for a "no failures" line

set +o errexit

kifLine=$(grep -q "TESTING FINISHED: 0 failures" "$OUTFILE")
KIFGrepResult=$?
if [ "$KIFGrepResult" -ne 0 ]; then
  echo "$0: Failed to find '0 failures' line in $OUTFILE"
else
  echo "$0: KIF Test run succeeded!"
fi

ghLine=$(grep -q "GHUNIT TESTS SUCCEEDED" "$OUTFILE")
GHGrepResult=$?
if [ "$GHGrepResult" -ne 0 ]; then
  echo "$0: Failed to find 'GHUNIT TESTS SUCCEEDED' line in $OUTFILE"
else
  echo "$0: GHUnit Test run succeeded!"
fi

if [ $GHGrepResult -ne 0 ] || [ $KIFGrepResult -ne 0 ]; then
  echo "There was a test failure. Exiting with error!"
  echo "GHUnit result: $GHGrepResult"
  echo "KIF result: $KIFGrepResult"
  exit 1
fi

echo "$0: All tests succeeded!"
exit 0
