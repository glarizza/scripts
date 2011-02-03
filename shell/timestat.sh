#!/bin/bash
#
#  File: timestat.sh
#
#  Use: Calculate the difference, in seconds, between the modification date of two files.
#

NOW=/private/tmp/now
THEN=/private/tmp/loggedin

echo `stat -r $NOW | awk -F " " '{print $9}'` - `stat -r $THEN | awk -F " " '{print $9}'` | bc

