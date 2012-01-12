#!/usr/bin/env ruby
#
# File:  Warranty.rb
#
# Decription:     Contact's Apple's selfserve servers to capture warranty
#                 information about your product. Accepts arguments of
#                 machine serial numbers.
#
# Author:         Gary Larizza
# Last Modified:  1/11/2012
# Why:            It was ugly
#
require 'open-uri'
require 'openssl'
require 'json'

def get_warranty(serial)
  warranty_data = {}
  raw_data = open('https://selfsolve.apple.com/warrantyChecker.do?sn=' + serial.upcase + '&country=USA')
  warranty_data = JSON.parse(raw_data.string[5..-2])

  puts "\nSerial Number:\t\t#{warranty_data['SERIAL_ID']}\n"
  puts "Product Decription:\t#{warranty_data['PROD_DESCR']}\n"
  puts "Purchase date:\t\t#{warranty_data['PURCHASE_DATE'].gsub("-",".")}"

  unless warranty_data['COV_END_DATE'].empty?
    puts "Coverage end:\t\t#{warranty_data['COV_END_DATE'].gsub("-",".")}\n"
  else
    puts "Coverage end:\t\tEXPIRED\n"
  end
end

if ARGV.size > 0 then
  serial = ARGV.each do |serial|
    get_warranty(serial.upcase)
  end
else
  puts "Without your input, we'll use this machine's serial number."
  serial = %x(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}').upcase.chomp
  get_warranty(serial)
end
