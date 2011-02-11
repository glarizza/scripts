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
path = File.expand_path("/Users/glarizza/Desktop/com.huronhs.example.plist")
second = load_plist(File.read(path))
pp second['count']

