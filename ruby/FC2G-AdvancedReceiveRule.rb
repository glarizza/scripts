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
    newfile.write("New DESKTOP \"#{col[0]}\" Mailbox \"Google Advanced Rule\" \"\" FormDoc 23047 0 0 23 23 -U+X\n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Advanced Rule\" 8120 7 10000 8140 0 8141 0 9 \"\"\n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Advanced Rule\" 13810.0 7 6 13806.0 7 22 13810.1 7 6 13806.1 7 41 13822.1 0 \"huron-city.k12.oh.us\" 13830.0 7 7 \n")
    newfile.write("Put RULES DESKTOP \"#{col[0]}\" Mailbox \"Google Advanced Rule\" 13832.0 0  \"#{col[1][0,1].downcase.chomp}#{col[2].downcase.chomp}@huron-city.k12.oh.us.test-google-a.com\"\n")
    newfile.write("\n")
end



# New Relative "" "Advanced Rule" "" FormDoc 23047 0 0 23 23 -U+X
# Put Previous 8120 7 10000 8140 0 8141 0 9 ""
# Put Previous 13810.0 7 6 13806.0 7 22 13810.1 7 6 13806.1 7 41 13822.1 0 "huron-city.k12.oh.us" 13830.0 7 7
# Put Previous 13832.0 0 "gl@huron-city.k12.oh.us.test-google-a.com"