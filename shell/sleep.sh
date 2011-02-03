#!/bin/sh
# seconds=$(( (RANDOM%60+1)*60 ))
# sleep $seconds
# echo "I'm done!"

RANDOM=`date '+%s'`
sleep $[($RANDOM % 60) + 1]
echo "I'm done!"