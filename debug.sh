#!/bin/bash -x

APPNAME=SampleSdkApp
thisdir=$(dirname $0)
APPENV=${thisdir}/build/${APPNAME}-env
[ -e "${APPENV}" ] || { echo "can't find ${APPENV}"; exit 1; }
. ${APPENV}

waxsim ${CONFIGURATION_BUILD_DIR}/${APPNAME}.app &

echo "Waiting for $APPNAME process"
while [ -z "$pid" ]; do
  sleep 1
  pid=$(ps auxww |grep ${APPNAME}.app/${APPNAME} | grep -v grep | awk '{ print $2 }')
done


exec cgdb -p $pid
