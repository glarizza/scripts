#!/usr/bin/ruby
# shortname.rb
# cgi script to verify a user's shortname.
class Huronhs
	def self.shortname shortname, addr
		command = "/usr/bin/dscl /LDAPv3/127.0.0.1 -read /Users/#{shortname} RealName | awk -F \" \" '{print $2 \" \" $3}'"
		output = %x{#{command}}
		%x{"logger #{addr} checked for #{shortname}"}
		return output
	end
end
=begin
CGI starts here
=end
# get the value of the passed param in the URL Query_string
require 'cgi'
cgi=CGI.new
shortname = cgi["shortname"]
information = Huronhs.shortname(shortname, ENV['REMOTE_ADDR'])
cgi.out("status" => "OK", "connection" => "close") {"This user is:  #{information} (if the space is blank, the username is invalid)"}
