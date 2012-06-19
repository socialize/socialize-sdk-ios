import plistlib
import collections

def nested_update(d, u):
    for k, v in u.iteritems():
        if isinstance(v, collections.Mapping):
            r = nested_update(d.get(k, {}), v)
            d[k] = r
        else:
            d[k] = u[k]
    return d

def update_plist(config_filepath , u):
    f = open(config_filepath, 'r')
    plist = plistlib.readPlist(f)
    nested_update(plist, u)
    f.close()
    f = open(config_filepath, 'w')
    plistlib.writePlist(plist, f)

def read_plist(filepath):
    f = open(filepath, 'r')
    obj = plistlib.readPlist(f)
    f.close()
    return obj

def write_plist(filepath, obj):
    f = open(filepath, 'w')
    plistlib.writePlist(obj, f)
