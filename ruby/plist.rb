#!/usr/bin/env ruby
require "osx/cocoa"
require 'pp'

# Create the plist and assign values
myfile = '/Users/glarizza/Desktop/com.huronhs.example.plist'
my_dict = OSX::NSMutableDictionary.dictionary
my_dict['The_Color'] = 'blue'
my_dict['count'] = 15

# Output to File and print
my_dict.writeToFile_atomically(myfile, true)
pp my_dict
