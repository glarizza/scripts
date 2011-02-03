#!/usr/bin/env ruby

require 'puppet'

Puppet.settings.parse

$clientcert = Puppet[:clientcert]
$certname = Puppet[:certname]
$_PUPPETD = "puppet agent"
$puppet_command = "#{$_PUPPETD} --onetime --no-daemonize --verbose --debug"
$puppet_verbose = "#{$puppet_command} 2>&1 | /usr/bin/tee arg_file.path"


puts "Certname exists #{$certname}" if $certname
puts "Clientcert exists #{$clientcert}" if $clientcert
puts "#{$puppet_command}"
puts "#{$puppet_verbose}"