#!/usr/bin/env ruby

# MC Agent for facts.txt
#
# This is my test at pushing/popping/querying data from facts.txt
#
# Initial file contains:
#
# huron_class=staff,shel
# environment=production
require 'pp'

hash = {}
p_fact = ARGV[1]
p_value = ARGV[2]

def open_file()
  h = {}
  
  # Open /etc/facts.txt if it exists, fail if it does not.
  if File.exists?("/etc/facts.txt")
    File.open("/etc/facts.txt") do |fp|
      fp.each do |line|
        key, value = line.chomp.split("=")
        h[key] = value
      end
    end
    return h
  else
    puts "File does not exist"
    exit(1)
  end
end # End of open_file def

def write_to_file(hash)
  etc_facts_file = File.open("/etc/facts.txt", 'w+') 
  hash.each{|key, value| etc_facts_file.puts "#{key}=#{value}"}
end # End of write_to_file def

def append_to_file(key, value)
  etc_facts_file = File.open("/etc/facts.txt", 'a+') 
  etc_facts_file.puts "#{key}=#{value}"
end # End of append_to_file def

if ARGV[0] == "-r"
  hash = open_file()

  if hash.size == 0
    puts "/etc/facts.txt contains no key/value pairs"
    exit(0)
  end
  
  puts "Before Removing Variable:\n"
  hash.each {|key, value| puts "#{key} is #{value}"}

  # Attempt at removing a searched class from the list of classes
  # This is only proof-of-concept, no file writes yet
  if hash[p_fact] =~ /,#{p_value},/ or hash[p_fact] =~ /,#{p_value}/
    hash[p_fact][",#{p_value}"]= ""
  elsif hash[p_fact] =~ /#{p_value},/
    hash[p_fact]["#{p_value},"]= ""
  elsif hash[p_fact] == "#{p_value}"
    hash[p_fact] = ""
  else
    puts "\nSearch Variable does not exist."
  end

  puts "\nAfter Removing Variable:\n"
  hash.each {|key, value| puts "#{key} is #{value}"}
  
  write_to_file(hash)
  puts "\nFile is written.\n"
end

if ARGV[0] == "-a"
  hash = open_file()

  if hash.size == 0
    puts "/etc/facts.txt contains no key/value pairs"
    exit(0)
  end

  if hash.has_key?(p_fact) 
    # Attempt at Adding a passed variable onto the list of classes
    # This is only proof-of-concept, no file writes yet
    puts "\nBefore Adding Variable to List:\n"
    hash.each {|key, value| puts "#{key} is #{value}"}

    hash[p_fact] += ",#{p_value}"

    puts "\nAfter Adding Variable:\n"
    hash.each {|key, value| puts "#{key} is #{value}"}
  
    write_to_file(hash)
    puts "\nFile is written.\n"
  else
    puts "Fact not found"
  end
end

if ARGV[0] == "-s"
  hash = open_file()

  if hash.size == 0
    puts "/etc/facts.txt contains no key/value pairs"
    exit(0)
  end

  if hash.has_key?(p_fact)
    puts "Found. Values are: #{hash[p_fact]}" if hash[p_fact].split(",").grep(p_value).any?
    puts "Not found." if hash[p_fact].split(",").grep(p_value).empty?
  else
    puts "Fact not found"
  end
end

if ARGV[0] == "-n"
  append_to_file(append_key, append_value)
end #end ARGV if

if ARGV[0] == "-d"
  hash = open_file()
  
  if hash.size == 0
    puts "/etc/facts.txt contains no key/value pairs"
    exit(0)
  end
  
  puts "Contents of /etc/facts.txt file:\n"
  hash.each {|key, value| puts "Fact: #{key} Contains: #{value}"}
end


