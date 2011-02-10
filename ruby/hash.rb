#!/usr/bin/env ruby

hash = {}

if File.exist?("/users/glarizza/Desktop/testhash.txt")
    File.readlines("/users/glarizza/Desktop/testhash.txt").each do |line|
        newarray = line.split(",")
        hash[newarray[0]] = newarray[1]
        puts "hash[#{newarray[0]}] is #{hash[newarray[0]]}"
    end
end

puts hash['this']
puts hash['test']

#  The contents of /users/glarizza/Desktop/testhash.txt is:
#
# test,1
# this,2
# is,3
# a,4
# test,5
#