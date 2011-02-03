#!/bin/sh
#
# Generated using Passenger
# http://macinmind.com/Passenger
# This shell script should be run as super-user to be effective
#
for i in /volumes/datahd/home/2017/*
do
 u=`echo $i | cut -d/ -f6`
 case $u in
  Shared)
   ;;
  Temporary)
   ;;
  *)
   /usr/sbin/chown -R $u:staff $i
   /bin/chmod -R 700 $i
  ;;
 esac
done
for i in /volumes/datahd/home/2017/*
do
 u=`echo $i | cut -d/ -f6`
 case $u in
  Shared)
   ;;
  Temporary)
   ;;
  *)
   /usr/sbin/chown $u:staff $i
   /bin/chmod 755 $i
  ;;
 esac
done
/usr/sbin/chown -R 'root':wheel '/volumes/datahd/home/2017/Shared'
/bin/chmod -R 777 '/volumes/datahd/home/2017/Shared'
for i in /volumes/datahd/home/2017/*
do
 u=`echo $i | cut -d/ -f6`
 case $u in
  Shared)
   ;;
  Temporary)
   ;;
  *)
   /usr/sbin/chown -R $u:staff $i/Public
   /bin/chmod -R 755 $i/Public
  ;;
 esac
done
for i in /volumes/datahd/home/2017/*
do
 u=`echo $i | cut -d/ -f6`
 case $u in
  Shared)
   ;;
  Temporary)
   ;;
  *)
   /usr/sbin/chown -R $u:staff $i/Public/Drop\ Box
   /bin/chmod -R 733 $i/Public/Drop\ Box
  ;;
 esac
done
for i in /volumes/datahd/home/2017/*
do
 u=`echo $i | cut -d/ -f6`
 case $u in
  Shared)
   ;;
  Temporary)
   ;;
  *)
   /usr/sbin/chown -R $u:staff $i/Sites
   /bin/chmod -R 755 $i/Sites
  ;;
 esac
done
exit 0
