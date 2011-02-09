#!/usr/bin/env ruby
#
# File:  Warranty.rb
#
# Decription: Contact's Apple's selfserve servers to capture warranty information
#              about your product. Accepts arguments of machine serial numbers.

require 'open-uri'
require 'openssl'

# This is a complete hack to disregard SSL Cert validity for the Apple
#  Selfserve site.  We had SSL errors as we're behind a proxy.  I'm
#  open suggestions for doing it 'Less-Hacky.' You can delete this 
#  code if your network does not have SSL issues with open-uri.
module OpenSSL
  module SSL
    remove_const:VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def get_warranty(serial)
  hash = {}
  open('https://selfsolve.apple.com/warrantyChecker.do?sn=' + serial.upcase + '&country=USA') {|item|
    item.each_line {|item|}
    warranty_array = item.strip.split('"')
    warranty_array.each {|array_item|
      hash[array_item] = warranty_array[warranty_array.index(array_item) + 2] if array_item =~ /[A-Z][A-Z\d]+/
    }
    
    puts "\nSerial Number:\t\t#{hash['SERIAL_ID']}\n"
    puts "Product Decription:\t#{hash['PROD_DESCR']}\n"
    puts "Purchase date:\t\t#{hash['PURCHASE_DATE'].gsub("-",".")}"
    puts (!hash['COV_END_DATE'].empty?) ? "Coverage end:\t\t#{hash['COV_END_DATE'].gsub("-",".")}\n" : "Coverage end:\t\tEXPIRED\n"
  }
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