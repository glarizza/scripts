#!/usr/bin/python2.5
#
# Class:
#				CrankTools.py
#		
# Description:
#				This class file is used with crankd to respond to network state changes. The
#				airportStateChange and ethernetStateChange methods are called directly from
#				your crankd plist. All other methods are called from these two. Each method should
#				be documented and inline comments will explain further.
#
# Author:
#				Gary Larizza
#
# Created:
#				10/12/2010
#
# Last Revised:
#				1/10/2011

__author__ = 'Gary Larizza (gary@huronhs.com)'
__version__ = '0.2'

import sys
sys.path.append('/Library/HuronHS/Python2.5')
import pymacds
import syslog
import subprocess
import os
import socket
from time import sleep
from SystemConfiguration import *

syslog.openlog("CrankD")
_PUPPETD = '/usr/bin/puppetd.rb'
_AIRPORT = '/usr/sbin/networksetup'
_SCUTIL = '/usr/sbin/scutil -r odm.huronhs.com'
ethTest = "/usr/sbin/networksetup -listnetworkserviceorder | awk -F': ' '/Ethernet,/ || /Ethernet .,/ {gsub(/\)/,\"\");print $3}'"
apTest = "/usr/sbin/networksetup -listnetworkserviceorder | awk -F': ' '/AirPort,/ {gsub(/\)/,\"\");print $3}'"
interfaces = {}

class CrankTools():	
	def interfaceSetter(self, en0Status, en1Status, en0IP, en1IP):
		"""Triggered when a "State:/Network/Interface/en0/IPv4" change occurs.  This method will disable
			the Airport if the Ethernet port becomes active and on-network.  If the Ethernet connection is
			disabled, it will simply log this occurrence. If the Ethernet connection is enabled and on-
			network, it will enable the Search and Contact nodes. Finally, if the Ethernet connection is
			enabled and off-network, it will remove these nodes.
		"""
		# Set nodes to the configured LDAP node using the pymacds library
		nodes = pymacds.ConfiguredNodesLDAPv3()
		
		# This large set of nested if-statements will check to see if each interface is
		#	active and on the Huron Network. It will also disable the Airport interface
		#	if the Ethernet interface is active and on-network. If any interface is off-
		#	network, it will remove our LDAP bindings.
		if en0Status == "false":
			if en1Status == "true":
				if self.onHuronNetwork(en1IP):
					syslog.syslog(syslog.LOG_ALERT, "The Ethernet interface is down, but the Airport is active and on-network.")
					self.ensureLDAPNodes(nodes)
					syslog.syslog(syslog.LOG_ALERT, "Performing a Puppet Run.")
					self.callPuppet()
				else:
					syslog.syslog(syslog.LOG_ALERT, "The Ethernet interface is down, but the Airport is active and off-network.")
					self.removeLDAPNodes(nodes)
			else:
				syslog.syslog(syslog.LOG_ALERT, "The Ethernet interface is down, and the Airport is inactive.")
				self.removeLDAPNodes(nodes)
		else:
			if en1Status == "true":
				if self.onHuronNetwork(en1IP) == "true":
					if self.onHuronNetwork(en0IP) == "true":
						syslog.syslog(syslog.LOG_ALERT, "Because both the Airport and Ethernet are enabled and on-network, we're disabling the Airport Interface.")
						self.toggleAirport('en1','off')
						self.ensureLDAPNodes(nodes)
						syslog.syslog(syslog.LOG_ALERT, "Performing a Puppet Run.")
						self.callPuppet()
					else:
						syslog.syslog(syslog.LOG_ALERT, "The Airport and Ethernet are enabled, but the Airport is on-network and the Ethernet connection is not.")
				else:
					if self.onHuronNetwork(en0IP) == "true":
						syslog.syslog(syslog.LOG_ALERT, "The Ethernet connection is enabled and on-network, but the Airport connection is also enabled and off-network.")
						self.ensureLDAPNodes(nodes)
						syslog.syslog(syslog.LOG_ALERT, "Performing a Puppet Run.")
						self.callPuppet()
					else:
						syslog.syslog(syslog.LOG_ALERT, "Both the Airport and Ethernet connection are enabled and off-network.")
						self.removeLDAPNodes(nodes)
			else:
				if self.onHuronNetwork(en0IP) == "true":
					syslog.syslog(syslog.LOG_ALERT, "The Ethernet connection is enabled and on-network.")
					self.ensureLDAPNodes(nodes)
					syslog.syslog(syslog.LOG_ALERT, "Performing a Puppet Run.")
					self.callPuppet()
				else:
					syslog.syslog(syslog.LOG_ALERT, "The Ethernet connection is enabled and off-network.")
					self.removeLDAPNodes(nodes)

	def callPuppet(self):
		"""Simple utility function that calls puppet via subprocess. The _PUPPETD variable is set globally
			and corresponds to the unified puppet binary (as of 2.6.0).
		---
		Arguments: None
		Returns: Nothing
		"""
		command = [_PUPPETD]
		syslog.syslog(syslog.LOG_ALERT, "Puppet was called")
		# task = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		# 		task.communicate()
		
	def checkIP(self, interface):
		"""This function accepts a BSD interface name and returns the state of that interface as
			well as the system IP Address for that interface using the SystemConfiguration Framework.
		---
		Arguments:
			interface - Either en0 or en1, the BSD interface name of a Network Adapter.
		Returns:
			bool - True or False depending on if the interface is both active and is on the Huron Network.
			IP - The IP Address of the interface or 0.0.0.0 if the interface is disabled.
		"""
		store = SCDynamicStoreCreate(None, "global-network", None , None)
		ifKey = "State:/Network/Interface/" + interface + "/IPv4"
		keyStore = SCDynamicStoreCopyValue(store, ifKey)

		try:
			print "The IP Address for interface: " + interface + " is: " + keyStore['Addresses'][0]
		except TypeError:
			syslog.syslog(syslog.LOG_ALERT, "Interface " + interface + " not active.")
			return ("false", "0.0.0.0")

		return ("true", str(keyStore['Addresses'][0]))
		
	def onHuronNetwork(self, ipAddress):
		"""This function will check to see if the passed IP Address is on the Huron Network.
			It does this by checking the passed IP Address to make sure it matches the Huron
			scheme, and also uses scutil -r to attempt to reach an internal-only server.
		---
		Arguments:
			ipAddress - A dotted IPv4 Address with four octets
		Returns:
			bool - Either True or False depending on if the IP Address is on the network
		"""
		# Encode and split the passed IP Address
		ipAddress = ipAddress.encode('iso-8859-5')
		octet = ipAddress.split('.')
		
		# This code will use scutil -r to check for reachability against a known-
		# 	good server that is only accessible inside our network.
		reachable = 'false'
		command = subprocess.Popen(_SCUTIL, shell=True, stdout=subprocess.PIPE,)
		netcheck = command.communicate()[0].rstrip().split(',')
		for status in netcheck:
			if status == 'Reachable':
				reachable = 'true'

		
		# If the IP address matches the Huron scheme, and our scutil -r reachibility
		#	passes, then return true.
		if octet[0] == '10':
			if octet[1] == '13' and reachable == 'true':
				syslog.syslog(syslog.LOG_ALERT, "On Huron Network")
				return 'true'
			else:
				syslog.syslog(syslog.LOG_ALERT, "2nd octet doesn\'t match.")
				return 'false'
		else:
			syslog.syslog(syslog.LOG_ALERT, "1st octet doesn\'t match.")
			return 'false'
			
	def toggleAirport(self, interface, state):
		"""A utility function that toggles the Airport off or on. The _AIRPORT variable is
			set globally to the networksetup binary.
		---
		Arguments: 
			interface - BSD Interface; either "en0" or "en1"
			state - Either "off" or "on"
		Returns: Nothing
		"""
		command = [_AIRPORT, '-setairportpower', interface, state]
		syslog.syslog(syslog.LOG_ALERT, "Toggling " + interface + " " + state + ".")
		task = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		task.communicate()
		
	def ensureLDAPNodes(self, nodes):
		"""A utility function to ensure our LDAP Search and Contact Nodes. 
			Pymacds will already check to ensure the nodes don't exist.
		---
		Arguments: 
			nodes - a list of nodes to ensure.
		Returns: Nothing
		"""
		for node in nodes:			
			pymacds.EnsureSearchNodePresent(node)
			syslog.syslog(syslog.LOG_ALERT, "Added " + node + " to the Search path."
			pymacds.EnsureContactsNodePresent(node)
			syslog.syslog(syslog.LOG_ALERT, "Added " + node + " to the Contacts path."
			
	def removeLDAPNodes(self, nodes):
		"""A utility function to remove specific LDAP Search and Contact Nodes. 
			Pymacds will already check to ensure the nodes exist.
		---
		Arguments: 
			nodes - a list of nodes to remove.
		Returns: Nothing
		"""
		for node in nodes:
			pymacds.EnsureSearchNodeAbsent(node)
			syslog.syslog(syslog.LOG_ALERT, "Removed " + node + " from the Search path."
			pymacds.EnsureContactsNodeAbsent(node)
			syslog.syslog(syslog.LOG_ALERT, "Removed " + node + " from the Contacts path."
					
	def onNetworkStateChange(self, *args, **kwargs):
		"""Triggered when a "State:/Network/Global/IPv4." change occurs.  After sleeping 
			10 seconds (to allow for an IP address to be acquired), this method will first 
			query /usr/sbin/networksetup and capture the BSD interface name for the first 
			Ethernetand AirPort interface on the machine. It will then check the status 
			of both interfaces and pass those to the interfaceSetter method.
		"""
		# Sleep for 10 seconds to allow IP Addresses to be registered.
		# NOTE: If you're having IP Errors, you may need to increase this value. 
		sleep(10)
		
		# Capture the first Ethernet BSD interface name into our interfaces dictionary.
		command = subprocess.Popen(ethTest, shell=True, stdout=subprocess.PIPE,)
		ethlist = command.communicate()[0]
		interfaces['Ethernet'] = ethlist.rstrip().split("\n")[0]

		# Capture the first Airport BSD interface name into our interfaces dictionary.
		command = subprocess.Popen(apTest, shell=True, stdout=subprocess.PIPE,)
		aplist = command.communicate()[0]
		interfaces['AirPort'] = aplist.rstrip().split("\n")[0]
	
		# Get each interface status and IP Address.
		(en0Status, en0IP) = self.checkIP(interfaces['Ethernet'])
		(en1Status, en1IP) = self.checkIP(interfaces['AirPort'])
	
		# Pass each interface status and IP Address to the interfaceSetter method.
		self.interfaceSetter(en0Status, en1Status, en0IP, en1IP)