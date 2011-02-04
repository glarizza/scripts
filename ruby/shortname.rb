#!/usr/bin/ruby
#  File: shortname.rb
# 
#  Use:  A ruby cgi script to verify a user's shortname.
#        Place this script in your /cgi-bin/ and call it with the below syntax:
#        http://server/cgi-bin/shortname.rb?shortname=<username>

class Huronhs
	def self.shortname shortname, addr
		command = "/usr/bin/dscl /LDAPv3/127.0.0.1 -read /Users/#{shortname} RealName | awk -F \" \" '{print $2 \" \" $3}'"
		logger = "/usr/bin/logger -t ShortnameChecker #{addr} checked the short name of #{shortname}"
		output = %x{#{command}}
		%x{#{logger}}
		return output
	end
end
=begin
CGI starts here
=end
require 'cgi'
cgi = CGI.new
shortname = cgi["shortname"]
information = Huronhs.shortname(shortname, ENV['REMOTE_ADDR'])
cgi.out("status" => "OK", "connection" => "close") {"This user is:  #{information} (if the space is blank, the username is invalid)"}


