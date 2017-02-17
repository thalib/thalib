---
layout: post
title:  "[Solved] arm-linux-gnueabihf-gcc: No such file or directory"
date:   2017-02-17 14:46:19
categories: Linux
tags: toolchain, 32bit, 64bit
---

I installed Debian 8, just moved from Ubuntu 14.04 LTS. After which the ARM cross compiler failed to work

The error message was **No such file or directory**, which looks strange also misleading.

```
$ ./arm-linux-gnueabihf-gcc
bash: ./arm-linux-gnueabihf-gcc: No such file or directory
```
[or]

```
$ /opt/arm-tools/gcc-linaro-arm-linux-gnueabihf-4.8-2014.03_linux/bin/arm-linux-gnueabihf-gcc
bash: /opt/arm-tools/gcc-linaro-arm-linux-gnueabihf-4.8-2014.03_linux/bin/arm-linux-gnueabihf-gcc: No such file or directory
```

I tried lots of thing, permissions, path setup, and soon.

> Nothing worked

While troubleshooting I just found the binary was compiled for 32bit system, Wow that was the clue.

```
$ file /opt/arm-tools/gcc-linaro-arm-linux-gnueabihf-4.8-2014.03_linux/bin/arm-linux-gnueabihf-gcc-4.8.3 /opt/arm-tools/gcc-linaro-arm-linux-gnueabihf-4.8-2014.03_linux/bin/arm-linux-gnueabihf-gcc-4.8.3: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux.so.2, for GNU/Linux 2.6.15, stripped
```

But system OS was pure 64bit installation.

```
$ uname -a
Linux onion 3.16.0-4-amd64 #1 SMP Debian 3.16.39-1 (2016-12-30) x86_64 GNU/Linux
```

From my experince of toolchain building task earlier, I knew this was due to [Multilib](https://www.google.co.in/?q=multilib). I need to install Multilib package to support executing of 32bit binaries.

### Solution

Enable i386 package installation support

```
sudo dpkg --add-architecture i386
sudo apt-get update
```

Install packages need to build source code on the system

```
sudo apt-get install git build-essential fakeroot
```

gcc-multilib is the package which will enable running 32bit (x86) binaries on 64bit (amd64/x86_64) system.

```
sudo apt-get install gcc-multilib
sudo apt-get install zlib1g:i386
```

Now lets try it again

```
$ /opt/arm-tools/gcc-linaro-arm-linux-gnueabihf-4.8-2014.03_linux/bin/arm-linux-gnueabihf-gcc
arm-linux-gnueabihf-gcc-4.8.3: fatal error: no input files
compilation terminated.
```

### Additional steps

Since I am compiling Linux kernel for ARM MCU, I was in need of these additional packages installed.

* u-boot-tools - for mkimage tool
* lzop for comperssion

```
sudo apt-get install u-boot-tools lzop
```
