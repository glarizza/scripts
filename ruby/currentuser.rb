#
#  File:  currentuser.rb
#
#  Description: A facter fact determining the currently-logged-in user
#   based on the owner of the /dev/console file.
#

require 'etc' 
require 'facter'

Facter.add("currentuser") do
  confine :kernel => "Darwin"
  setcode.do
    uid = File.stat('/dev/console').uid 
  end
end
