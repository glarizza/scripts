#!/usr/bin/env ruby

users = []

users += %x(ps aux 2> /dev/null | grep loginwindow | cut -d " " -f1).split()
puts (users - ['root']).join(",")
  


