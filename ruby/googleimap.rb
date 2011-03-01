#!/usr/bin/env ruby
#
# File:         googleimap.rb
#
# Description:  Create IMAP Folders on the specified Server to prepare them for Google's
# =>              IMAP Migration Tool. 
#

require 'net/imap'
require 'logger'
require 'getoptlong'

if not ARGV[0]
  puts "You must have an argument.  Use --help for more information"
  exit(1)
end

# Parse the arguments here and print the help prompt if any incorrect arguments
#  are being used.
opts = GetoptLong.new(
    [ '--username', '-u', GetoptLong::REQUIRED_ARGUMENT],
    [ '--password', '-p', GetoptLong::REQUIRED_ARGUMENT],
    [ '--folders', '-f', GetoptLong::REQUIRED_ARGUMENT],
    [ '--help', '-h', GetoptLong::NO_ARGUMENT]
)

begin
  opts.each do |opt, arg|
    case opt
      when '--username'
        $username = arg
      when '--password'
        $password = arg
      when '--folders'
        $allfolders = arg.split(',')
      when '--help'
        puts <<-EOF   
        googleimap.rb --username value --password value

        -u, --username:
          This is the IMAP server username

        -p, --password:
          This is the IMAP server password
        
        -f, --folders
          The list of folders to be created. Must be comma-separated.
          
        -h, --help:
          Display this help text
              
        EOF
      end
    end
rescue GetoptLong::InvalidOption, GetoptLong::AmbigousOption
  puts <<-EOF   
  googleimap.rb --username value --password value

  -u, --username:
    This is the IMAP server username

  -p, --password:
    This is the IMAP server password
  
  -f, --folders
    The list of folders to be created. Must be comma-separated.
    
  -h, --help:
    Display this help text
        
  EOF
end

log = Logger.new("IMAPlog.txt")
server = "10.13.1.2"

#Login to the imap server
imap = Net::IMAP.new(server)
log.info("Logging In...")
imap.login($username, $password)

$allfolders.each do |folder|
  log.info("Creating folder #{folder} for user #{$username}")
  puts "Creating Folder #{folder} for user #{$username}"
  imap.create(folder)
end
