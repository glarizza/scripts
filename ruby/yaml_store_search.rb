#!/usr/bin/env ruby
#
# File:			yaml_store_search.rb
#
# Description:	A script to search through your puppet master's YAML store
#				 for a specific node's data.

require 'getoptlong'
require 'puppet'

Puppet.settings.parse

if not ARGV[0]
  puts "You must have an argument.  Use --help for more information."
  exit(1)
end

# Parse the arguments here and print the help prompt if any incorrect arguments
#  are being used.
opts = GetoptLong.new(
    [ '--hostname', '-n', GetoptLong::REQUIRED_ARGUMENT],
    [ '--certname', '-c', GetoptLong::REQUIRED_ARGUMENT],
    [ '--help', '-h', GetoptLong::NO_ARGUMENT]
)

begin
  opts.each do |opt, arg|
      case opt
          when '--hostname'
              $hostname = arg
          when '--certname'
              $certname = arg
          when '--help'
              puts <<-EOF   
              yaml_store_search.rb [OPTION] value

              -n, --hostname:
                Search for a specific hostname in the YAML store. Requires a hostname argument

              -c, --certname:
                Search for a specific certname in the YAML store. Requires a certname argument

              -h, --help:
                Display this help text
              
                EOF
          end
        end
rescue GetoptLong::InvalidOption, GetoptLong::AmbigousOption
  puts <<-EOF   

  -n, --hostname:
    Search for a specific hostname in the YAML store. Requires a hostname argument

  -c, --certname:
    Search for a specific certname in the YAML store. Requires a certname argument

  -h, --help:
    Display this help text
  
    EOF
  exit(1)
end

# Determine whether we're doing a lookup via hostname or certname
searchfield = 'hostname' and arg = $hostname if $hostname
searchfield = 'certname' and arg = $certname if $certname

# Iterate through your puppet YAML store using the $vardir from
#  your puppet.conf settings. If we find the YAML file with a 
#  matching certname or hostname, break out of the loop.
Dir.glob("#{Puppet[:vardir]}/yaml/facts/*") {|file|
  $tempfile = YAML::load_file(file).values
  if $tempfile[searchfield] == arg
    $found_file = true
    break
  end
}

# Output the list of facts.
if $tempfile
  $tempfile.each_pair {|key, value|
    puts "#{key} = #{value}"
  }
end