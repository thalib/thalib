---
layout: post
title:  "Creating target images (ramdsik, ext2 image, cramfs, dtb)"
date:   2016-10-29 12:16:00
categories: Linux
tags: linux embedded
excerpt: Commands for creating target images (ramdsik, ext2 image, cramfs, dtb)
---


## Working with Uncompressed image

Mounting via ramdisk:

```
mkdir mnt
cat init-ramdisk-2-35 > /dev/ram1
mount /dev/ram1 mnt
```

Or via loopback:

```
mount -o loop init-ramdisk-2-35 mnt
```

## Working with ext2 Image

### Creating a new ext2 filesystem image

```
# dd if=/dev/zero of=init-ramdisk.img bs=1k count=8k
# mke2fs -i 1024 -b 1024 -m 3 -F -v init-ramdisk.img
# mkdir temp
# mount -o loop init-ramdisk.img temp
# cd temp
# (Do what you need to do.)
# cd ..
# umount temp
# gzip -9 init-ramdisk.img
```

### Modifying an existing ext2 filesystem image

```
# gunzip ramdisk-file.gz
# mkdir temp
# mount -o loop ramdisk-file temp
# cd temp
# (Do what you need to do.)
# cd ..
# umount temp
# gzip -9 ramdisk-file
```

### Creating an ext2 filesystem file

```
mkfs -t ext2 /specialfile
```

where specialfile is something like /dev/ram1 (for a ramdisk), /dev/flash3 (for a flash device), /dev/fd0 (for a floppy), or init-ramdisk.img (for an image of a filesystem stored in a pre-existing file).

The example above makes a filesystem onto an 8MByte file. This is the equivalent of formatting the drive. Instead of ext2, we could use another filesystem type, such as reiserfs, fat, etc.

### Going from a device to a file

```
dd if=specialfile of=imagefile
```

will read the entire special file into a plain file, e.g.:

```
dd if=/dev/ram1 of=init-ramdisk-2-35
```

But remember to unmount it before you extract it, or it can be out-of-sync (i.e.: the kernel hasn't flushed all data to disk yet). And of course the "mounted" bit is set if it is still mounted, so the next time you mount it you'll get a warning about dirty filesystems.

## Working With Cramfs

```
# mkdir mntpoint
# mkdir temp
# mount -t cramfs init-2-40.cramfs mntpoint -o loop
# cp -a mntpoint temp
# (do what you need to do)
# cd ..
# mkcramfs temp init-2-41.cramfs
# Get into the boot loader and load the file where it belongs.
```

## Working With Ramfs

Ramfs is new to 2.4.x. It is a filesystem which keeps all files in RAM.
It allows read and write access. Ramfs grows and shrinks to accomodate the
files it contains, in contrast to a 'ext2 ramdisk', which gets allocated a
fixed amount of RAM.

To use ramfs, type:

```
mkdir /mnt/mntpoint
mount -t ramfs ramfs /mnt/mntpoint
```

## Working with DTB

### dtb file creation

```
dtc -f -b 0 -I dts -O dtb -R 8 -S 0x3000 -o <output filename.dtb>  <dts file name.dts>
```

### dtu file creation

```
mkimage -A ppc -O Linux -T flat_dt -C none -a 0x300000 -e 0 -d <dtbfile name.dtb> <output filename.dtu>
```
