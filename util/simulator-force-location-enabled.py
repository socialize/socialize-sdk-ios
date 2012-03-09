#!/usr/bin/env python

import sys
from plutil import *
import os
import subprocess

LOCATIOND_FILENAME="%(HOME)s/Library/Application Support/iPhone Simulator/5.1/Library/Caches/locationd/clients.plist" % os.environ

if __name__ == '__main__':
  if len(sys.argv) < 2:
    print >>sys.stderr, 'usage: %s [bundleid]' % sys.argv[0]
    sys.exit(1)

  bundleid = sys.argv[1]

  update = {
    'Authorized': True,
    'BundleId': bundleid,
    'Executable': '',
    'Registered': '',
  }

  subprocess.call('killall "iPhone Simulator"', stderr=subprocess.PIPE, shell=True)

  try:
    subprocess.check_call('plutil -convert xml1 "%s"' % LOCATIOND_FILENAME, shell=True)
  except subprocess.CalledProcessError:
    print >>sys.stderr, 'Failed to convert %s to text' % LOCATIOND_FILENAME

  try:
    d = read_plist(LOCATIOND_FILENAME)
  except IOError, e:
    print >>sys.stderr, 'Write failed for %s -- %s' % (LOCATIOND_FILENAME, e)
  d[bundleid] = update
  try:
    write_plist(LOCATIOND_FILENAME, d)
  except IOError, e:
    print >>sys.stderr, 'Write failed for %s -- %s' % (LOCATIOND_FILENAME, e)

  try:
    subprocess.check_call('plutil -convert binary1 "%s"' % LOCATIOND_FILENAME, shell=True)
  except subprocess.CalledProcessError:
    print >>sys.stderr, 'Failed to convert %s to binary' % LOCATIOND_FILENAME

  print 'Successfully updated %s' % LOCATIOND_FILENAME
