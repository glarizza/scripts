#!/bin/sh
#Then forces joining  the workstation to open directory with the
#parmeters specified.

# Determine hostname of the computer
HOSTNAME=`hostname -s`

#Bind to LDAP
dsconfigldap -fv -r <node address here> -c $HOSTNAME -u <diradmin> -p <diradminpw> -l admin -q <diradminpw>

