require 'open-uri'

sn = 'W87380R4X8A'

open('https://selfsolve.apple.com/Warranty.do?serialNumber=' + sn + '&country=USA&fullCountryName=United%20States')  {|f|
	f.each_line {|line|
		if line.include?("coverageEndDate") then
			puts line.split(" ").slice(2)
			end}
}

#	warranty_data = f.read.strip.split(/\",\:/,"\n")
#	warranty_data.split(/\",\"/,"\n")
#	puts warranty_data

#	warranty_data.strip
#.split(/\":\"/,":")
#	puts warranty_data



