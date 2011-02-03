#!/bin/sh
#Then forces joining  the workstation to open directory with the
#parmeters specified.

# Determine hostname of the computer
HOSTNAME=`hostname -s`

#Bind to LDAP
dsconfigldap -v -a <node> -n <node> -c $HOSTNAME -l <localadmin> -q <localadminpw>

#Set Authentication Serach Path
dscl /Search -append / CSPSearchPath /LDAPv3/<node>
