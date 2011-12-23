#!/bin/bash

if [ "$RUN_CLI" = "" ]; then
  exit 0
fi

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR="$PWD/$THISDIR"

# Simulator needs to be dead before we force loc
#killall "iPhone Simulator" >/dev/null 2>&1

${THISDIR}/simulator-force-location-enabled.py com.getsocialize.samplesdk

DATAFILE=/tmp/$$.data
trap "rm -f $DATAFILE" INT TERM EXIT

$THISDIR/run-simulator.sh |tee $DATAFILE

failure_regex="KIF TEST RUN FINISHED: (.*) failures"
while read line; do
    echo $line
    if [[ $line =~ $failure_regex ]]; then
        FAILURES=${BASH_REMATCH[1]}
    fi
done <$DATAFILE

[ -z "$FAILURES" ] && { echo "Failed to find failures line!!"; exit 1; }
echo "Found $FAILURES failures"
exit $FAILURES
