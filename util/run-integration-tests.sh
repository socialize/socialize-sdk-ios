#!/bin/bash

if [ -z "$RUN_CLI" ]; then
  exit 0
fi

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR="$PWD/$THISDIR"

${THISDIR}/simulator-force-location-enabled.py com.getsocialize.samplesdk

GHUNIT_CLI=1 exec $THISDIR/run-simulator.sh
