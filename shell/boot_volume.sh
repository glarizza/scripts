#!/bin/bash
#
#  A quick one-liner that grabs the Boot Volume on a Mac.

diskutil info `bless --getBoot` |sed '/^ *Volume Name: */!d;s###'

# A challenger has appeared!

system_profiler SPSoftwareDataType | awk -F': ' '/Boot Volume/{print $2}'