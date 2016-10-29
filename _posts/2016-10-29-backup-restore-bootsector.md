---
layout: post
title:  "How to backup and restore HDD boot sector"
date:   2016-10-29 12:16:00
categories: Embedded
tags: linux embedded backup 
excerpt: How to backup and restore HDD boot sector
---


Here I will explain how we will be backup and restore the boot sector of a running pc. In  this example I will consider my hardisk is /dev/sda.

Backing up existing boot sector in /dev/sda hardrive

 dd if=/dev/sda of=bootsec.bin bs=512 count=1

Now to restore the boot sector to the hardisk use the following command.

 dd if=bootsec.bin of=/dev/sda bs=512 count=1
