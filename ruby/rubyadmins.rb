#!/usr/bin/env ruby
# 
# File: rubyadmins.rb
# Description:  Playing around with exporting all users greater than a certain value.
# =>             Here are a couple of methods (some good, some BAD).

require 'pp'
require 'etc'

hash = Hash.new
array = []

# On-liner method dropping all values into a users array
users = `dscl . -list /users UniqueID`.split("\n").collect! {|u| u.sub!(/\ +/, ",").split(",").to_a}.select {|u| u[1].to_i > 500}
pp users


# Or, a method using Hashes:
`dscl . -list /users UniqueID`.split("\n").each{|value| hash[value.squeeze(" ").split(" ")[1]] = value.squeeze(" ").split(" ")[0]}
hash.each_pair {|key,val| pp "hash[#{key}] = #{val}" if key.to_i >= 500}

# And, another method using the Etc lib.
Etc.passwd() { |u|
  pp u.name if u.uid >= 500
}

# Finally, a method of reading the /etc/passwd file. BAD, because it doesn't include local users.
File.open("/etc/passwd", "r") do |infile|
  while (line = infile.gets) 
    if not (line.split(":")[0][0,1] == '#')
      array = line.strip.split(":")
      pp array[0] if array[2].to_i >= 500
    end
  end
end


