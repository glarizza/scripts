#!/usr/bin/env ruby

# This command will execute successfully
system ("which /usr/local/bin/macruby > /dev/null 2>&1")
puts "Macruby Exists!" if (($? >> 8) == 0)

# This command will not
system("which /usr/local/bin/macrubys > /dev/null 2>&1")
puts "Failed" if (($? >> 8) == 1)

