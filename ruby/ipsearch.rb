#!/usr/bin/env ruby

ip = "10.13.1.190"
#myfile = File.open("/Users/management/Desktop/file.txt", "r")

Dir.glob("/Users/management/Desktop/search/*") {|file|
  tempfile = File.open(file)
  tempfile.each_line do |line|
    junk = line.scan(ip)
    puts file if junk[0] == ip
  end

}

# myfile.each_line do |line|
#   junk = line.scan(ip)
#   puts junk
# end

#myfile.close