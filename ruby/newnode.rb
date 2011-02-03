#!/usr/bin/env ruby
#
#
#  This External Node classifier script will return appropriate classes for Puppet depending
#   on the machine's huron_class fact.  The script will dip into the Server's YAML depository,
#   search for the passed certname, extract the fact information, and return a YAML block to
#   puppet.
#
#  Created by Gary Larizza - 6.10.2010
#  Last Modified - 11.30.2010
#
#

require 'yaml'
require 'puppet'

# Intitialize Variables
vardir = "/var/puppet/yaml/facts"
default = {'classes' => []}
yaml_output = {}

# Check to see if the Node YAML file exists, based on certname
begin
  yamlfile = YAML::load_file(vardir_path + ARGV[0] + '.yaml').values
  huron_class = yamlfile["huron_class"]
  fqdn = yamlfile["fqdn"]
rescue Exception => error
  puts "Node YAML file was not found!  Error: " + error
  exit(1)
end

if huron_class + "xxx" == "xxx"
  print default.to_yaml
  exit(0)
end

puts {'classes' => huron_class.split(,)}.to_yaml
