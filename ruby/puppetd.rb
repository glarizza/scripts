#!/usr/bin/env ruby
#
# puppetd.rb
#
# Usage:  This script determines which puppet master server to contact and will call puppet.
#          The script will accept arguments of -c (which will clean the puppet SSL Certificate)
# =>       and -v (which is a verbose mode).  If an /etc/puppet/puppet.conf or /etc/facts.txt
# =>       file doesn't exist, this script will create an initial version of those files.
# =>       Finally, the script will delete the /var/lib/puppet/state/puppetdlock file if its
# =>       modification date is older than 24 hours.  
#
# Author:  Gary Larizza
#
# Created: 10/15/2009
#
# Last Modified: 1/18/2011
#

require 'facter'
require 'puppet'
require 'fileutils'
require 'tempfile'


## Set Environment Variables
ENV['TERM_PROGRAM'] = 'Apple_Terminal'
ENV['TERM'] = 'xterm-color'
ENV['PATH'] = '/usr/sbin:/usr/bin:/bin'
$stdout.sync=(true) if not $stdout.sync

## Determine whether we're using Puppet 2.6 or legacy
$_PUPPETD = 'puppet agent'
if Facter.value(:puppetversion) < "0.26"
	$_PUPPETD = 'puppetd'
else
  $_PUPPETD = 'puppet agent'
end

## Parse the /etc/puppet/puppet.conf settings (if the file exists).
Puppet.settings.parse

## Declare Global Variables
$script_version = '1.6.0'
$arg_file = Tempfile.new('puppetd') if ARGV[0] == "-v"
$mac_uid = %x(/usr/sbin/nvram MAC_UID 2>/dev/null | awk '{print $2}').chomp
$suffix = 'huronhs.com'
$ip = Facter.value(:ipaddress).split('.')[2]
$vardir = Puppet[:vardir]
$certname = Puppet[:certname]
$puppet_command = "#{$_PUPPETD} --onetime --no-daemonize --verbose --debug"
$puppet_verbose = "#{$puppet_command} 2>&1 | /usr/bin/tee #{$arg_file.path}" if ARGV[0] == "-v"

## Check for required Puppet Directories
if not File.directory?($vardir)
  FileUtils.mkdir_p($vardir)
  puts "Created #{$vardir} because it did not exist."
end

if not File.directory?('/etc/puppet')
  FileUtils.mkdir_p('/etc/puppet')
  puts "Created /etc/puppet because it did not exist."
end

## Check for an empty $mac_uid variable.
if $mac_uid.empty?
  $mac_uid = %x(system_profiler SPHardwareDataType | awk '/Serial Number/ {print $NF}').chomp.downcase + "." + $suffix
  $mac_uid = %x(hostname).chomp if $mac_uid.empty?
  
  ## Set the mac_uid variable in NVRAM.
  %x(/usr/sbin/nvram MAC_UID=#{$mac_uid})
end

## Determine which server to contact
$server = case $ip
  when '0' then 'testing.huronhs.com'
  when '1', '5' then 'helpdesk.huronhs.com'
  when '2' then 'msreplica.huronhs.com'
  when '3' then 'wesreplica.huronhs.com'
  else 'testing.huronhs.com'
end
$command = "http://#{$server}/cgi-bin/pclean.rb?certname=#{$mac_uid}"

########
# The setPuppetConf Method: Creates a puppet.conf file if one doesn't exist
#
# Arguments:  None
########
def setPuppetConf()
  confHash = {} # Our hash of puppet.conf keys and values
  
  # Set the confHash equal to all your puppet.conf settings
  confHash = {"server" => $server, "certname" => $mac_uid, "pluginsync" => "true", "factpath" => "$vardir/lib/facter", "report" => "true"}
  
  # Output values to the puppet.conf file
  File.open("/etc/puppet/puppet.conf", 'w') {|f| 
    f.write("[main]\n")
    confHash.each{|key,value| f.write(key + " = " + value + "\n")}
  }
end

########
#  The setEtcFacts Method:  Creates an /etc/facts.txt file if one doesn't exist
#
#  Arguments:  None
########
def setEtcFacts
  etcHash = {}

  # The huron_class fact is a list of classes that should be applied to our machines.
  # Set the initial value equal to the building/function sections of each machine's hostname.
  # If the hostname does not conform, set huron_class equal to our general_image class.
  huron_class = %x{hostname | awk -F '-' '{print $2 "," $3}'}.chomp.gsub!(/[.].*/,"")
  
  # If our hostname does not match the district format, set huron_class to nodes.pp - this
  # way our External Node Classifier script will recognize this and default to the nodes.pp
  # file class declarations.
  huron_class = "nodes.pp" if huron_class == "," or huron_class == nil
  
  # Output values to /etc/facts.txt file
  etcHash = {"huron_class" => huron_class, "environment" => "production"}
  File.open("/etc/facts.txt", 'w') {|g| etcHash.each{|key, value| g.write(key + "=" + value + "\n")}}  
end

########
# Our cleaning method - it will remove the SSL and vardir, call the cleaning CGI to remove
#   the cert on the server, and then run puppet twice to ensure a good run
# 
# Arguments: None
########
def clean_certs ()
  puts "Removing /etc/puppet/ssl and #{$vardir}"
  FileUtils.rm_rf '/etc/puppet/ssl'
  FileUtils.rm_rf $vardir
  puts "Removing Certificate from #{$server}"
  system "curl #{$command}"

  5.times do
    putc('.')
    sleep(1)
  end

  system "#{$puppet_command} 2>&1"
  exit(0)
end

########
# The puppetrun method - it will call puppet and clean the certs if an error is found
# 
# Arguments: None
########
def puppetrun()
  puppet_results = %x(#{$puppet_command} 2>&1)
  if /Retrieved certificate does not match private key/ =~ puppet_results || /Certificate request does not match existing certificate/ =~ puppet_results
    cert_error = true
  end
  
  ## If a certificate error was found, then call the clean_certs method
  if cert_error
    puts "A certificate error has been found - cleaning SSL and Vardir, then cleaning cert from server."
    clean_certs()
  end
  exit(0)
end

# If there's no puppet.conf file, set a default one.
setPuppetConf() if !File.exists?("/etc/puppet/puppet.conf")

# If there's not an /etc/facts.txt file, set a default one.
setEtcFacts() if !File.exists?("/etc/facts.txt")

# If the Puppetd lock exists, check to see if it's older than a day.  If so, delete it.
# We don't use the puppetdlock to disable puppet - we're using a Big Red Button ©
if File.exists?("#{$vardir}/state/puppetdlock")
  difference = Time.now - File.mtime("#{$vardir}/state/puppetdlock")
  days = difference.divmod(60)[0].divmod(60)[0].divmod(24)[0]
  FileUtils.rm("#{$vardir}/state/puppetdlock") if days > 1
end

########
# The -c argument will clean the SSL directory, the vardir, and the cert off the server. This is to prep
#  for imaging or to correct a certificate error.
########
clean_certs() if ARGV[0] == "-c"

#########
# The -d argument will display the version of this script
#########
if ARGV[0] == "-d"
  puts "The Current version of this Puppet Wrapper Script is #{$script_version}"
  exit(0)
end

########
# If the -v argument is set, return everything from the puppet run and log commands into a 
#  temporary file.  Next, check for certain certificate errors in the output and clean the certs if need be.
#
# If the -v argument is NOT set, run puppet silently, log all output to the puppet_results variable,
#  and check for our certificate errors (cleaning certs as warranted)
########
if ARGV[0] == "-v"
  puts "#{$puppet_verbose}"
  system "#{$puppet_verbose}"
  cert_error = system "cat #{$arg_file.path} | grep -q \"/Certificate request does not match existing certificate\" "
  cert_error = system "cat #{$arg_file.path} | grep -q \"Retrieved certificate does not match private key\" "
  
  ## If a certificate error was found, then call the clean_certs method
  if cert_error
    puts "A certificate error has been found - cleaning SSL and Vardir, then cleaning cert from server."
    clean_certs()
  end
  exit(0)
else
  puppetrun()
end
