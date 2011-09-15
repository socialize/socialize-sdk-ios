#!/bin/bash

THISDIR=$(dirname $0)
SRCDIR="$THISDIR/.."

killall "iPhone Simulator"

set -o errexit
set -o verbose

# Build the "Integration Tests" target to run in the simulator
cd "$SRCDIR" && xcodebuild -target "SampleSdkApp Integration Tests" -configuration Distribution -sdk iphonesimulator build

# Run the app we just built in the simulator and send its output to a file
# /path/to/MyApp.app should be the relative or absolute path to the application bundle that was built in the previous step
"$THISDIR/waxsim" -f "iphone" "$SRCDIR/build/Release-iphonesimulator/SampleSdkApp Integration Tests.app" > /tmp/KIF-$$.out 2>&1

killall "iPhone Simulator"

# WaxSim hides the return value from the app, so to determine success we search for a "no failures" line
grep -q "TESTING FINISHED: 0 failures" /tmp/KIF-$$.out
