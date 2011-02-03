#!/usr/bin/env ruby

node = %x{dscl localhost -list /LDAPv3}.split('.')
puts node[1]

#This is the difference in the patch
# Tada!

