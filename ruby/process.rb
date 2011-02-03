#!/usr/bin/env ruby

# puts $$
# puts Process.pid
# puts Process.getpgid(42)
# puts Process.euid

# pid = ARGV[0].to_i
# 
# begin
#     Process.kill(0, pid)
#     puts "#{pid} is running"
# rescue Errno::EPERM                     # changed uid
#     puts "No permission to query #{pid}!";
# rescue Errno::ESRCH
#     puts "#{pid} is NOT running.";      # or zombied
# rescue
#     puts "Unable to determine status for #{pid} : #{$!}"
# end
# 
# puts Process.getpgid(pid)

users = %x(ps aux 2> /dev/null | grep loginwindow | cut -d " " -f1 | head -n1)
userlist = {}

# for user in users
#   if not user == 'root'
#     userlist['process'] = user
#   end
# end

#puts "The user is #{userlist['process']}"

puts users