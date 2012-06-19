#!/bin/bash

if [ -z "$RUN_CLI" ]; then
  exit 0
fi

THISDIR=$(dirname "$0")
[[ $THISDIR =~ ^/ ]] || THISDIR="$PWD/$THISDIR"

${THISDIR}/force-simulator-location-enabled.py com.getsocialize.IntegrationTests

GHUNIT_CLI=1 exec $THISDIR/run-simulator.sh
