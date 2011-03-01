#!/usr/bin/env ruby

newfile = File.open("/users/glarizza/desktop/outfile.txt", "w")
File.open("/users/glarizza/desktop/staff.txt", "r") do |infile|
  while (line = infile.gets)
    line = line.chomp
    newfile.write("PUT USER \"#{line}\" 1605 6 0\n")
    newfile.write("New DESKTOP \"#{line}\" Mailbox \"Conservo Receive Rule\" \"\" FormDoc 23047 112 15 21 21 -U+X\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Receive Rule\" 8120 7 1252 8140 0 8141 0 9 \"\"\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Receive Rule\" 13810.0 7 33 13830.0 7 7 13832.0 0 \"#{line},Archive\"\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Receive Rule\" 13800 6 1\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Receive Rule\" 13830 7 7\n")
    newfile.write("New DESKTOP \"#{line}\" Mailbox \"Conservo Send Rule\" \"\" FormDoc 23047 0 0 27 27 -U+X\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Send Rule\" 8120 7 1252 8140 0 8141 0 9 \"\"\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Send Rule\" 13810.0 7 33 13830.0 7 7 13832.0 0 \"#{line},Archive\"\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Send Rule\" 13800 6 1\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Send Rule\" 13801 7 1\n")
    newfile.write("Put RULES DESKTOP \"#{line}\" Mailbox \"Conservo Send Rule\" 13830 7 7\n")
    newfile.write("\n")
  end
end