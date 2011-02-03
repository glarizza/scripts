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
  print 'Name: ' + printer['ppd']
  print 'PPD: ' + printer['_name']