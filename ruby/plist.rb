#!/usr/bin/env ruby
require "osx/cocoa"
require 'pp'

myfile = 'com.huronhs.example.plist'
my_dict = OSX::NSMutableDictionary.dictionary
my_dict['CFBundleVersion'] = '2.0.1'
my_dict['count'] = '15'
my_dict.writeToFile_atomically(myfile, true)

pp my_dict
