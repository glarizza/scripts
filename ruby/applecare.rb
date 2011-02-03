require 'open-uri'
sn = %x{system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'}.chomp
open('https://selfsolve.apple.com/Warranty.do?serialNumber=' + sn + '&country=USA&fullCountryName=United%20States') {|item|
     item.each_line {|item|}
     warranty = item.split('"')
     puts warranty[95]
   }