---
layout: post
title:  "How to Create Live CD"
date:   2016-10-29 12:16:00
categories: Linux
tags: linux embedded
excerpt: This articles lists down the commands for creating Live CD/ISO image
---


Below is the steps to create live cd

```
$ mkisofs -o /tmp/bootcd.iso -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 8 -boot-info-table .
```

Test the image with emulator

```
 $ qemu -cdrom /tmp/bootcd.iso -serial stdio
```
