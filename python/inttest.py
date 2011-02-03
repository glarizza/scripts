#!/usr/bin/python2.5

#
# Grab BSD interface names for the first Airport and Ethernet interfaces on your computer.
#
import subprocess
import sys
sys.path.append('/Library/HuronHS/Python2.5')
import pymacds
from time import sleep


nodes = pymacds.ConfiguredNodesLDAPv3()
nodeToFind = pymacds.ConfiguredNodesLDAPv3()[0]
currentnodes = pymacds.GetLDAPv3SearchNodes()
ethTest = "networksetup -listnetworkserviceorder | awk -F': ' '/Ethernet,/ || /Ethernet .,/ {gsub(/\)/,\"\");print $3}'"
apTest = "networksetup -listnetworkserviceorder | awk -F': ' '/AirPort,/ {gsub(/\)/,\"\");print $3}'"
newdict = {}
listOfNodes = ['/LDAPv3/boedocs.huronhs.com', '/LDAPv3/hsreplica.huronhs.com']


def searchContactNodes(nodeToFind):
	for node in pymacds.GetLDAPv3ContactsNodes():
		if node == nodeToFind:
			return 'Found It!'
	return ""

def searchSearchNodes(nodeToFind):
	for node in pymacds.GetLDAPv3SearchNodes():
		if node == nodeToFind:
			return 'Found It!'
	return ""

def ensureLDAPNodes(nodes):
	for node in nodes:
		if not searchSearchNodes(node):
				pymacds.EnsureSearchNodePresent(node)
				print "Added " + node + " to the Search path."
		if not searchContactNodes(node):
				pymacds.EnsureContactsNodePresent(node)
				print "Added " + node + " to the Contacts path."

command = subprocess.Popen(ethTest, shell=True, stdout=subprocess.PIPE,)
ethlist = command.communicate()[0]
newdict['Ethernet'] = ethlist.rstrip().split("\n")[0]

command = subprocess.Popen(apTest, shell=True, stdout=subprocess.PIPE,)
aplist = command.communicate()[0]
newdict['AirPort'] = aplist.rstrip().split("\n")[0]

print 'Ethernet interface is: ' + newdict['Ethernet']
print 'AirPort interface is: ' + newdict['AirPort']

print newdict

print "The Way it is:"
pymacds.EnsureSearchNodeAbsent('/LDAPv3/boedocs.huronhs.com')
print pymacds.GetLDAPv3SearchNodes()
print pymacds.GetLDAPv3ContactsNodes()

print " "

ensureLDAPNodes(listOfNodes)
sleep(3)

print pymacds.GetLDAPv3SearchNodes()
print pymacds.GetLDAPv3ContactsNodes()

pymacds.EnsureSearchNodeAbsent('/LDAPv3/hsreplica.huronhs.com')
pymacds.EnsureContactsNodeAbsent('/LDAPv3/hsreplica.huronhs.com')

print "After the Storm:"

print pymacds.GetLDAPv3SearchNodes()
print pymacds.GetLDAPv3ContactsNodes()

# print "Nodes Before:"
# print currentnodes
# if searchContactNodes(nodeToFind):
# 	print "Found it"
# else:
# 	print "Didn't find it"
# 
# for node in nodes:
# 	pymacds.EnsureSearchNodeAbsent(node)
# print "Nodes after Absent Ensure:"
# if searchContactNodes(nodeToFind):
# 	print "Found it"
# else:
# 	print "Didn't find it"
# 
# for node in nodes:
# 	pymacds.EnsureSearchNodePresent(node)
# print "Nodes after Present Ensure:"
# if searchContactNodes(nodeToFind):
# 	print "Found it"
# else:
# 	print "Didn't find it"