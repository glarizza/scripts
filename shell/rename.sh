#!/bin/bash

for userhomedir in /Users/management/Desktop/doit/*
do
	countusername=`basename "$userhomedir"`
	chown -R $countusername:staff $userhomedir
	
done
