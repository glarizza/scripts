#! /usr/bin/env ruby
#  This script captures the Applecare Coverage End Date of an Apple Computer
#
#
require 'json'
require 'open-uri'

sn            = %x{system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'}.chomp
data          = open('https://selfsolve.apple.com/warrantyChecker.do?sn=' \
                  + sn.upcase + '&country=USA')
warranty_info = JSON.parse(data.string[5..-2])

puts warranty_info['COV_END_DATE']
