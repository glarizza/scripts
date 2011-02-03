#!/usr/bin/env ruby
##
#	Log Monitoring Script
#
#	This script will monitor the /var/log/system.log for a specific line of text, and then respond accordingly
##
require 'pathname'
require 'facter'

##
#   watch_for Method: Accepts a logfile and pattern argument
#
#   This method will look for the "Could Not Resolve" error in puppet, and then will capture the IP
#    address of the offending client, search the YAML store for the certname, and clean the cert from
#    the puppetmaster server.  This script is ENTIRELY hacky.  Sorry.
##
def watch_for(file, pattern)

  ## Variable Definitions
  ip = Facter.value(:ipaddress).split('.')[2]
  server = case ip
    when 0 then 'testing.huronhs.com'
    when 1, 5 then 'helpdesk.huronhs.com'
    when 2 then 'msreplica.huronhs.com'
    when 3 then 'wesreplica.huronhs.com'
    else 'testing.huronhs.com'
  end
  command = "http://#{server}/cgi-bin/pclean.rb?certname="
  yaml_filename = ""
  
  ## Open the logfile first and search for the passed pattern argument
  f = File.open(file,"r")
  f.seek(0,IO::SEEK_END)
  while true do
    select([f])
    line = f.gets.to_s
    matches = line.scan(/10\.13\.[12]?[0-9]?[0-9]\.[12]?[0-9]?[0-9]/)

    ## If we find this log error set the found variable to "yes"
    found = "yes" if line =~ pattern
    if found == "yes"
      
      ## If found, search through the /var/puppet/yaml/facts directory for the correct certname
      Dir.glob("/var/puppet/yaml/facts/*") {|file|
        path = Pathname.new(file)
        tempfile = File.open(file)
        tempfile.each_line do |line|
          ip_in_yaml = line.scan(matches[0])
          
          ## If you find the IP address in the YAML file, set the yaml_filename variable to the 
          ##   certificate filename
          if ip_in_yaml[0] == matches[0]
            yaml_filename = path.basename
          end
        end
        
        ## If the yaml_filename is anything but empty, call the certificate cleaning CGI script and
        ##  pass the appropriate certificate name (strip the .yaml off the end).
        if yaml_filename != ""
          yaml_filename = yaml_filename.to_s.gsub!(/[.]yaml/,"")
          puts "curl #{command}#{yaml_filename}"
          yaml_filename = ""
        end
      }
      end
      
      ## Reset the found variable to be "no"
      found = "no"
  end
end

watch_for("/var/log/system.log", /Could not resolve 10.13./)