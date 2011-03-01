#!/usr/bin/env ruby
#
#  This file will read a CSV line by line and spit out the output
#   formatted for a Firstclass Batch Admin command to redirect
#   all sent mail to an outside email address.

newfile = File.open("/users/glarizza/desktop/script.txt", "w")
infile = File.open("/users/glarizza/desktop/staff.csv", "r")
  infile.each_line("\r") do |line|
    col = line.split(",")
    puts "col[0] = #{col[0]}"
    puts "Line[1] = #{col[1].downcase}"
    puts "Line[2] = #{col[2].downcase}"
    puts "Username = #{col[1][0,1].downcase}#{col[2].downcase}"
    
    newfile.write("PUT USER \"#{col[0]}\" 1605 6 0\n")
    newfile.write("New DESKTOP \"#{col[0]}\" Mailbox \"Google Send Rule\" \"\" FormDoc 23047 0 0 27 27 -U+X\n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Send Rule\" 8120 7 1252 8140 0 8141 0 9 \"\"\n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Send Rule\" 13810.0 7 33 13830.0 7 7 13832.0 0 \"#{col[1][0,1].downcase.chomp}#{col[2].downcase.chomp}@huron-city.k12.oh.us.test-google-a.com\"\n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Send Rule\" 13800 6 1\n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Send Rule\" 13801 7 1\n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Send Rule\" 13830 7 7\n")
    newfile.write("\n")
end
