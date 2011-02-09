#!/usr/bin/env ruby
require 'open-uri'

def get_warranty_end(serial)
  hash = {}
  open('https://selfsolve.apple.com/warrantyChecker.do?sn=' + serial.upcase + '&country=USA') {|item|
    item.each_line {|item|}
    warranty_array = item.strip.split('"')
    warranty_array.each {|array_item|
      hash[array_item] = warranty_array[warranty_array.index(array_item) + 2] if array_item =~ /[A-Z][A-Z\d]+/
    }
    
    puts "\nMachine serial:\t#{serial}"
    puts "Purchase date:\t#{hash['PURCHASE_DATE']}"
    puts (!hash['COV_END_DATE'].empty?) ? "Coverage end:\t#{hash['COV_END_DATE']}\n" : "Coverage end:\tEXPIRED\n"
  }
end

if ARGV.size > 0 then
  serial = ARGV.each do |serial|
    get_warranty_end(serial.upcase)
  end
  else
    puts "Without your input, we'll use this machine's serial number."
    serial = %x(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}').upcase.chomp
    get_warranty_end(serial)
end