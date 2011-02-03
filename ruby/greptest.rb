#!/usr/bin/env ruby

# $printer = %x(lpstat -p | grep -q "Edileen" && echo "true" || echo "nil").chomp
# 
# if $printer == "true"
#   puts "do something here"
# else
#   puts "do something else"
# end
# 
# if system 'lpstat -p | grep -q "Eileen"'
#   puts "do something here"
# else
#   puts "do something else"
# end

if %x(lpstat -p) =~ /Lyle_ss_HP/
  puts "Printer Found"
else
  puts "Not Found"
end