#!/usr/bin/env ruby
require 'pp'
node = %x{dscl localhost -list /LDAPv3}.split('.')
puts node[1]
pp node


