#!/usr/bin/env ruby
#
#
#  This External Node classifier script will return appropriate classes for Puppet depending
#   on the machine's hostname (i.e. testing-shawstaff-shel.huronhs.com will return "shawstaff"
#   and "shel" in YAML). If the machine's hostname doesn't match this format, it returns a blank
#   YAML block so that the nodes.pp file can be consulted
#
#  Created by Gary Larizza - 6.10.2010
#  Last Modified - 6.10.2010
#
#

require 'yaml'
require 'puppet'


# Initialize variables
function = nil
default = {'classes' => []}

# Check to see if either supported YAML Facts store exists.
begin
  if File.exists?("/var/db/puppet/yaml/facts/") && File.directory?("/var/db/puppet/yaml/facts/")
    vardir_path = "/var/db/puppet/yaml/facts/"
    puts "vardb"
  elsif File.exists?("/var/puppet/yaml/facts") && File.directory?("/var/puppet/yaml/facts")
    vardir_path = "/var/puppet/yaml/facts/"
    puts "varpuppet"
  else
    exit(1)
  end
rescue Exception => factdir
  puts "YAML Facts directory not found!"
  exit(1)
end

# Check to see if the Node YAML file exists, based on certname
begin
  yamlfile = YAML::load_file(vardir_path + ARGV[0] + '.yaml').values
  fqdn = yamlfile["fqdn"]
rescue Exception => error
  puts "Node YAML file was not found!  Error: " + error
  exit(1)
end

# Split out the appropriate classes from the machine's hostname
function = %x{echo #{fqdn} | awk -F '-' '{print $2}'}.chomp
building = %x{echo #{fqdn} | awk -F '-' '{print $3}'}.chomp.gsub!(/[.].*/,"")

# If the hostname doesn't contain classes, pass a blank YAML block so the
#  nodes.pp file can check for appropriate classes.
if function + "xxx" == "xxx"
  print default.to_yaml
  exit(0)
end

# Finally, pass a YAML block containing the appropriate classes
output = {'classes' => [ 'general_image', building , function ]}
print output.to_yaml
