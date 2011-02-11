#!/usr/local/bin/macruby
#
# File: macruby_plist.rb
#
# Description: Plist manipulation using MacRuby.
#
require 'pp'

# This block will create a plist, set values, and write the
#  file to my Desktop.  Finally, I output it with pp.
myfile = '/Users/glarizza/Desktop/com.huronhs.macruby.plist'
plist = NSMutableDictionary.dictionary
plist['The_Color'] = 'blue'
plist['count'] = 15
plist.writeToFile(myfile, :atomically => true)
pp plist


# This block reads in an existing plist file and outputs data
#  from the plist file.
path = "/Users/glarizza/Desktop/com.huronhs.example.plist"
second = load_plist(File.read(path))
pp second['count']


# Contents of com.huronhs.example.plist:
#
# <?xml version="1.0" encoding="UTF-8"?>
# <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
# <plist version="1.0">
# <dict>
#   <key>The_Color</key>
#   <string>blue</string>
#   <key>count</key>
#   <integer>15</integer>
# </dict>
# </plist>

