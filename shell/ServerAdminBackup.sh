#!/bin/bash
#
# Backup Server Admin Settings
#
date=`date "+%Y%m%d"`
archive_path=/Volumes/BackupHD/OpenDirectory

for s in $(serveradmin list); do mkdir -p $archive_path/backup-$date;  serveradmin settings $s > $archive_path/backup-$date/$s-backup-$date; done
