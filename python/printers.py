#!/usr/bin/env python
import plistlib
import subprocess

command = ['system_profiler', '-xml', 'SPPrintersDataType']
task = subprocess.Popen(command,
                        stdout=subprocess.PIPE,
                        stderr=subprocess.PIPE)

(stdout, stderr) = task.communicate()
printers = plistlib.readPlistFromString(stdout)
printers = printers[0]['_items']
for printer in printers:
	print 'Name: ' + printer['_name']
	print 'PPD: ' + printer['ppd']