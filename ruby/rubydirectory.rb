#!/usr/bin/env ruby
require 'fileutils'

$testdir = '/Users/glarizza/Desktop/makeme/now'

puts "Nope!" if not File.directory?($testdir)

puts "It's a match" if $0 == __FILE__

puts "And a match" if __FILE__ == $PROGRAM_NAME


# if not File.directory?($testdir)
#   FileUtils.mkdir_p($testdir)
#   puts "Created #{$testdir}"
# else
#   puts "It Exists."
# end

# if not File.directory?('/etc/puppet')
#   puts "No /etc/puppet"
# else
#   puts "/etc/puppet Exists"
# end
