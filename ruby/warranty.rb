#!/usr/bin/env ruby
require 'open-uri'

def get_warranty_end(serial)
  open('https://selfsolve.apple.com/warrantyChecker.do?sn=' + serial.upcase + '&country=USA') {|item|
       item.each_line {|item|}
       warranty_array = item.strip.split('"')
       coverage = warranty_array.index('COV_END_DATE')
       purchase = warranty_array.index('PURCHASE_DATE')
       puts "\nMachine serial:\t#{serial}"
       puts "Purchase date:\t#{warranty_array[purchase+2]}"
       puts "Coverage end:\t#{warranty_array[coverage+2]}\n"
     }
end

if ARGV.size > 0 then
  serial = ARGV.each do |serial|
    get_warranty_end(serial.upcase)
  end
  else
    puts "Without your input, we'll use this machine's serial number."
    #facts = Facter.to_hash
    #serial = "#{facts["sp_serial_number"]}" if facts.include?("sp_serial_number")
    #gets.chomp.upcase
    serial = %x(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}').upcase.chomp
    get_warranty_end(serial)
end