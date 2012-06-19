#!/usr/bin/env python

from plutil import *
import sys

if __name__ == '__main__':
  if len(sys.argv) != 7:
    print 'usage: %s [socialize_config] [api_config] [url] [secureurl] [key] [secret]' % sys.argv[0]
    sys.exit(1)

  socialize_config, api_config, url, securl, key, secret = sys.argv[1:]

  socialize_update = {
    'URLs': {
      'RestserverBaseURL': url,
      'SecureRestserverBaseURL': securl,
    }
  }

  try:
    update_plist(socialize_config, socialize_update)
  except IOError, e:
    print 'Update failed for %s -- %s' % (socialize_config, e)

  apiupdate = {
    'Socialize API info': {
      'key': key,
      'secret': secret,
    }
  }

  try:
    update_plist(api_config, apiupdate)
  except IOError, e:
    print 'Update failed for %s -- %s' % (socialize_config, e)

  print 'Successfully updated %s and %s' % (socialize_config, api_config)
