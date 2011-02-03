#!/usr/bin/env ruby

searchvar = "This is the Certificate request does not match existing certificate search variable"
condition = searchvar.grep(/search/)

if /Retrieved certificate does not match private key/ =~ searchvar || /Certificate request does not match existing certificate/ =~ searchvar
  condition = "yes"
else
  condition = "no"
end

puts condition
puts ENV['USER']