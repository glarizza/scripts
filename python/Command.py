#!/usr/bin/python

import subprocess
import plistlib

command = ['system_profiler', '-xml', 'SPPrintersDataType']
task = subprocess.Popen(command,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE)

(stdout, stderr) = task.communicate()
printers = plistlib.readPlistFromString(stdout)
printers = printers[0]['_items']

for printer in printers:
  print '\nName: ' + printer['_name']
  print 'PPD: ' + printer['ppd']
  print 'URL: ' + printer['uri']
  print 'Default? ' + printer['default']