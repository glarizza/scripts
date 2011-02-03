#!/bin/bash

mcollective_root='/Users/management/Desktop/mcollective'
pkgroot='/Users/management/Desktop/test'

#for file in $mcollective_root/etc/* ; do cp -R $file $(echo $pkgroot$file | sed 's/.dist//g') ; done
for file in $mcollective_root/etc/* ; do cp -R $file $(echo $pkgroot"/"`basename $file` | sed 's/.dist//g') ; done