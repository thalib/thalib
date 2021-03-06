---
layout: post
title:  "Simple script create a uboot compatible ramdisk file"
date:   2016-10-29 12:16:00
categories: Linux
tags: linux embedded script ramdisk
excerpt: A simple script create a uboot compatible ramdisk file
---

A simple script create a uboot compatible ramdisk file


```
#!/bin/sh

##############################################################
# This is a utility used to create ramdisk Image for uboot   #
# 							     #
# Author : Mohamed Thalib .H  #
# Date   : Thursday, June 25 2009			     #
##############################################################

usage()
{
cat << EOF
usage: $0 options

example: $0 -d <rootfs directory>

This commmand generates ramdisk.ext2.gz.uboot

OPTIONS:
   -h      Show this message
   -d      Source directory
EOF
}

SRC_DIR=
OUT_FILE=

while getopts “hd:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         d)
             SRC_DIR=$OPTARG
             ;;
         ?)
             usage
             exit 1
             ;;
	 *)
	     usage
	     exit 1
	     ;;
     esac
done

if [ -z $SRC_DIR ]
then
    usage
    exit 1
fi


if [ -d $SRC_DIR ]
then
    echo
else
    echo "$SRC_DIR not found"
    exit 1
fi

fs_size=`du -slk $SRC_DIR | awk -F" " {'print $1'}`

if [ $fs_size -ge 20000 ]
then
    blocks=$((fs_size+16384))
else
    blocks=$((fs_size+2400))
fi

fcount=`find $SRC_DIR -print | wc -l`
inodes=$(($fcount+400))
echo "-----------------------------------"
echo "No of block size  : $blocks"
echo "No of inodes 	: $inodes"
echo
echo -n "Generating rootfs.ext2"

genext2fs -U -b $blocks -i $inodes -d $SRC_DIR rootfs.ext2

#genext2fs -U -b $blocks -i $inodes -D device_genromfs.txt -d $SRC_DIR rootfs.ext2

if [ `echo $?` != 0 ]
then
    echo "genext2fs failed - Try running as root user"
    exit 1
fi

echo ".......done"
echo
echo -n "Generating rootfs.ext2.gz"

gzip rootfs.ext2

if [ `echo $?` != 0 ]
then
    echo "gzip failed"
    exit 1
fi

echo ".......done"
echo
echo -n "Generating rootfs.ext2.gz.uboot"

mkimage -n 'uboot ext2 ramdisk rootfs' -A ppc -O linux -T ramdisk -C gzip -d rootfs.ext2.gz rootfs.ext2.gz.uboot

if [ `echo $?` != 0 ]
then
    echo "mkimage failed"
    exit 1
fi

echo ".......done"
echo
echo "Image generation succeded"
echo
echo
```
