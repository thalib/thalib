---
layout: post
title:  "Building GCC toolchain for PowerPC"
date:   2016-10-29 12:16:00
categories: Linux
tags: linux embedded gcc toolchain
excerpt: Building GCC toolchain for PowerPC
---

Building GCC toolchain for PowerPC

Download the latest sources from ftp://ftp.gnu.org .

I tested the build with binutils-2.14, gcc-3.3.2, glibc-2.3.2, glibc-linuxthreads-2.3.2 and (optionally gdb-6.0).

### Binutils

As most of the sites suggest, start by building the toolchain in separate directories from where you downloaded and unzipped the sources. So, I do build-binutils, build-gcc and so on... Also, you can specify the PATH you want the cross-compiled binaries to go with --prefix option. The most convenient way is to do configure --help to know the oft needed arguments for configuration. The next step is to configure the binutils for powerpc as target.

```
mkdir build-binutils & cd build-binutils
../binutils-2.14/configure --target=powerpc-linux --prefix=/opt/buckeye/powerpc-linux
make all install
```

### Minimal Gcc

After binutils is done, add the cross-compiled binaries to your PATH by

```
export PATH=$PATH:/opt/buckeye/powerpc-linux
mkdir build-gcc & cd build-gcc
../gcc-3.3.2/configure --target=powerpc-linux --prefix=/opt/buckeye/powerpc-linux --disable-shared --disable-threads \
--enable-languages=c --with-newlib
make all-gcc install-gcc
```

You can very well cross-compile Linux kernel with this minimal gcc, though may not be able to compile other applications.

### Glibc

After the minimal gcc is done; the next major step is to cross-compile glibc. I have had troubles compiling glibc in the past what with some of the patches not being applied to the glibc tree. But after some help from googling, I was able to put the right combination of arguments in place. Be sure to download glibc-linuxthreads and unzip it in the glibc source directory. I found out that glibc needs linuxthreads to compile correctly. It might not be this way but I could not compile it otherwise. So, here is what to do

```
mkdir build-glibc & cd build-glibc
tar xv{zj}f ../glibc-linuxthreads-2.3.2.tar.{gb}z{2} ../glibc-2.3.2/
../glibc-2.3.2/configure --prefix=/opt/buckeye/powerpc-linux --target=powerpc-linux --host=powerpc-linux  \
--enable-add-ons=linuxthreads --with-headers=${Path_to_your_powerpc_linux_kernel_tree}/linuxppc_2_4_devel/include  \
--with-binutils=/opt/buckeye/powerpc-linux/powerpc-linux/bin
make all install
```

glibc would give a compile error for glibc-2.3.2/stdio-common/sscanf.c ... you have to change the parameter declaration for sscaf function in sscanf.c to

```
int
sscanf (const char *s, const char *format, ...)
```

It should be a breeze after that.
It was worth noting that --target option does not work with glibc, you have to use --host={target-platform}-linux for glibc to work. At my machine, glibc libraries were installed in /opt/buckeye/powerpc-linux/lib, but gcc would expect them to be at /opt/buckeye/powerpc-linux/powerpc-linux/lib ... so you might either make a symlink to the correct path or change the glibc configure option --libdir to point to the right place.


### Complete Gcc

After glibc is compiled, you can reconfigure gcc as

```
../gcc-3.3.2/configure --target=powerpc-linux --prefix=/opt/buckeye/powerpc-linux --enable-shared --enable-threads \
--enable-languages=c
make all install
```

Now you should have a complete working version of gcc.

### Gdb and other graphical debuggers like insight

```
mkdir build-gdb & cd build-gdb
../gdb-6.0/configure --target=powerpc-linux --enable-sim-powerpc --prefix=/opt/buckeye/gdb (any dir of your choice)
make all install

```

--enable-sim-powerpc builds gdb with inbuilt powerpc instruction set simulator.
