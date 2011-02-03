
#!/bin/bash


# This simply displays an AppleScript dialog showing the IP addresses of the
# default Ethernet and Airport interfaces for Macs with only one of each.

# Ryan Manly - ryan.manly@gmail.com - 021910

en0=`ipconfig getifaddr en0 2>&1`

en1=`ipconfig getifaddr en1 2>&1`


if [ "$en0" = "get if addr en0 failed, (os/kern) failure" ]; then

en0="unavailable"

fi


if  [ "$en1" = "get if addr en1 failed, (os/kern) failure" ]; then

en1="unavailable"

fi


/usr/bin/osascript << EOF

tell application "Finder"

       activate

display dialog "Wired IP Address: $en0" & return & "Wireless IP Address:
$en1" buttons {"OK"} with icon caution

end tell

EOF


exit 0
