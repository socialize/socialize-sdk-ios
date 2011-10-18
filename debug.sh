#!/bin/bash

APPNAME=SampleSdkApp
thisdir=$(dirname $0)
APPENV=${thisdir}/build/${APPNAME}-env
[ -e "${APPENV}" ] || { echo "can't find ${APPENV}"; exit 1; }
. ${APPENV}

getsimpid() {
  ps auxww |grep ${APPNAME}.app/${APPNAME} | grep -v grep | awk '{ print $2 }'
}

curpid=$(getsimpid)

while [ -n "$curpid" ]; do
  echo "Killing existing process"
  kill $curpid
  sleep 1
  curpid=$(getsimpid)
done

waxsim ${CONFIGURATION_BUILD_DIR}/${APPNAME}.app &

echo "Waiting for $APPNAME process"
while [ -z "$pid" ]; do
  sleep 1
  pid=$(getsimpid)
done


exec cgdb -p $pid
