#
#  This script captures the Applecare Coverage End Date of an Apple Computer
#
#

require 'open-uri'

#  First grab the serial number with the system_profiler command (note that this runs on the boot volume).
sn = %x{system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'}.chomp

#  Next fetch warranty information from Apple.
open('https://selfsolve.apple.com/Warranty.do?serialNumber=' + sn + '&country=USA&fullCountryName=United%20States') {|item|
     item.each_line {|item|}
     
#  Remove the quotation marks from the information provided by Apple, along with whitespace,
#  and enter the remaining information into an array.
     warranty_array = item.strip.split('"')

#  Find the Coverage End Date field in the array and print the date (which is two positions away)
     position = warranty_array.index('COV_END_DATE')
     puts warranty_array[position+2]
   }