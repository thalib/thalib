---
layout: post
title:  "How to Extract Android boot.img"
date:   2016-10-27 19:31:50
categories: Embedded
tags: android linux embedded reverse
excerpt: Notes on How to Extract and recreate Android boot.img
---

Unlike system.img boot.img is not a filesystem image. 
It is read by the bootloader, and contains a kernel image and a tiny ramdisk image.

boot.img is created using **mkbootimg** tool, and unpacked using **unmkbootimg**, these tools are part of Android source, but you can download these tools from this git [https://github.com/pbatard/bootimg-tools](https://github.com/pbatard/bootimg-tools)

Download the source and execute the make file to compile the tools 

### Extracting/Unpacking boot.img:

unmkbootimg command usage

```
$ ./unmkbootimg -i ../boot.img -o out/
usage: unmkbootimg
       [ --kernel <filename> ]
       [ --ramdisk <filename> ]
       [ --second <2ndbootloader-filename> ]
       -i|--input <filename>

```

If kernel/ramdisk arguments are not passed the extracted files are placed in current working directory

Here is the example usage

```
$ ../bootimg-tools-master/mkbootimg/unmkbootimg -i ../boot.img 
kernel written to 'kernel' (1680996 bytes)
ramdisk written to 'ramdisk.cpio.gz' (29345113 bytes)

To rebuild this boot image, you can use the command:
  mkbootimg --base 0 --pagesize 2048 --kernel_offset 0x80008000 --ramdisk_offset 0x81000000 --second_offset 0x80f00000 --tags_offset 0x80000100 --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk' --kernel kernel --ramdisk ramdisk.cpio.gz -o ../boot.img

```

Above creates these file in the PWD. Also note the printed **mkbootimg** command and argument, you will need this when re-creating the boot.img

```
$ ls -lh
total 30M
-rw-rw-r-- 1 mohamed mohamed 1.7M Oct 26 19:03 kernel
-rw-rw-r-- 1 mohamed mohamed  28M Oct 26 19:03 ramdisk.cpio.gz

```

### Creating boot.img

Creating is very simple, Use the the command printed by **unmkbootimg** to create the boot.img.

```
mkbootimg --base 0 --pagesize 2048 --kernel_offset 0x80008000 --ramdisk_offset 0x81000000 --second_offset 0x80f00000 --tags_offset 0x80000100 --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk' --kernel kernel --ramdisk ramdisk.cpio.gz -o ../boot.img
```

For readability above command is written as below, all parameters are self explanatory.

```
mkbootimg --base 0 --pagesize 2048 \
--kernel_offset 0x80008000 \
--ramdisk_offset 0x81000000 \
--second_offset 0x80f00000 \
--tags_offset 0x80000100 \
--cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk' \
--kernel kernel \
--ramdisk ramdisk.cpio.gz \
-o ../boot.img
```

### Refrence

* [http://android-dls.com/wiki](http://android-dls.com/wiki/index.php?title=HOWTO%3a_Unpack%2C_Edit%2C_and_Re-Pack_Boot_Images)
* [imajeenyus.com](http://www.imajeenyus.com/computer/20130301_android_tablet/android/unpack_repack_recovery_image.html)

