#!/bin/bash

if [ "$RUN_CLI" = "" ]; then
  exit 0
fi

export IPHONE_SIMULATOR_ROOT="$SDKROOT"

export NSDebugEnabled=YES
export NSZombieEnabled=YES
export NSDeallocateZombies=NO
export NSHangOnUncaughtException=YES
export NSAutoreleaseFreedObjectCheckEnabled=YES


THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR=$PWD/$THISDIR
SRCDIR="$THISDIR/../SampleSdkApp"

killall "iPhone Simulator" >/dev/null 2>&1

set -o errexit
#set -o verbose


function cleanup() {
  set +o errexit
  for pid in $simPID $tailPID; do
    if [ -n "$pid" ] && kill -0 $pid >/dev/null 2>&1; then
      kill -KILL $pid > /dev/null 2>&1 
    fi
  done
  echo "Cleanup complete"
}
trap cleanup INT TERM EXIT

# Run the app we just built in the simulator and send its output to a file
# /path/to/MyApp.app should be the relative or absolute path to the application bundle that was built in the previous step

OUTFILE="/tmp/KIF-$$.out"

# pipe from waxsim to tee does not work
touch "$OUTFILE"
"$THISDIR/waxsim" -f "iphone" "$CONFIGURATION_BUILD_DIR/${FULL_PRODUCT_NAME}" >"$OUTFILE" 2>&1 &
simPID=$!

tail -f "$OUTFILE" &
tailPID=$!
echo "Tail running with $tailPID"

echo "waiting for $simPID"
wait $simPID
