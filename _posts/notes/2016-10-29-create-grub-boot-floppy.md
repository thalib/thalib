---
layout: post
title:  "How to Creating a GRUB boot floppy"
date:   2016-10-29 12:16:00
categories: Linux
tags: linux embedded floppy
excerpt: GRUB boot floppy creating instruction
---

To create a GRUB boot floppy, you need to take the files stage1 and stage2 from the image directory, and write them to the first and the second block of the floppy disk, respectively.

Caution: This procedure will destroy any data currently stored on the floppy.

On a UNIX-like operating system, that is done with the following commands:

```
# cd /usr/lib/grub/i386-pc
# dd if=stage1 of=/dev/fd0 bs=512 count=1
1+0 records in
1+0 records out
# dd if=stage2 of=/dev/fd0 bs=512 seek=1
153+1 records in
153+1 records out
```
