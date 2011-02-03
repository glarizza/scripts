#!/usr/bin/env python

import sys
#sys.path.append('/Library/HuronHS/Python2.5/')
#import dsutils
from subprocess import Popen, PIPE, STDOUT

launchdlabel = 'com.huronhs.pupppetconfig'
launchdaemon = '/Library/LaunchDaemons/com.huronhs.puppetconfig.plist'

launch = ['/usr/bin/env', 'launchctl', 'load', '-w', launchdaemon]
args = ['launchctl', 'load', '-w', '/Library/LaunchDaemons/com.huronhs.puppetconfig.plist']
check = ['/usr/bin/env', 'launchctl', 'list', '|', 'grep', launchdlabel]
filecheck = Popen(check, stdout=PIPE, stderr=PIPE)
output, errors = filecheck.communicate()

if output:
	print('Item was already loaded')
else:
	Popen(launch)
	
# Popen(args)
# Popen(launch)
#Popen(args, shell=True)
print('Ran the commands')