---
layout: post
title:  "Programming Linux from Uboot"
date:   2016-10-26 18:10:22
categories: Linux
tags:  linux embedded uboot
excerpt: Configuring U-Boot for various Linux deployments
---

Short guide, from my very old notes on how to Configuring U-Boot for various Linux deployments

### Flashing U-Boot from U-Boot

The flash range is from 0xE8000000 to 0xEFFFFFFF: 128MB. already a workable U-Boot programmed in the Flash:

```
=>tftp 1000000 u-boot.bin
=>protect off all
=>erase eff80000 efffffff
=>cp.b 1000000 eff80000 $filesize
```

Then reset the board to boot it up.

### Configuring U-Boot for RAM boot deployment

```
=>setenv ipaddr <board_ipaddress>
=>setenv serverip <tftp_serverip>
=>setenv gatewayip <your_gatewayip>
=>setenv bootargs root=/dev/ram rw console=ttyS0,115200
=>saveenv
=>tftp 1000000 uImage
=>tftp 2000000 rootfs.ext2.gz.uboot
=>tftp c00000 mpc8572ds.dtb
=>bootm 1000000 2000000 c00000
```

### Configuring U-Boot for NAND boot deployment

Below are the command prepares for nand boot.


```
=>setenv ipaddr <board_ipaddress>
=>setenv serverip <tftp_serverip>
=>setenv gatewayip <your_gatewayip>
=>setenv ramargs ‘setenv bootargs root=/dev/ram rw console=ttyS0,115200’
=>setenv bootcmd ‘run ramargs; bootm ec000000 e8000000 eff00000’
=>saveenv
=>tftp 1000000 uImage
=>erase ec000000 ec3fffff
=>cp.b 1000000 ec000000 $filesize

=>tftp 2000000 rootfs.ext2.gz.uboot
=>erase e8000000 eaffffff
=>cp.b 2000000 e8000000 $filesize

=>tftp c00000 mpc8572ds.dtb
=>erase eff00000 eff1ffff
=>cp.b c00000 eff00000 3000
```

### Configuring U-Boot for NFS deployment

```
=>setenv ipaddr <board_ipaddress>
=>setenv serverip <tftp_serverip>
=>setenv gatewayip <your_gatewayip>
=>setenv bootargs root=/dev/nfs rw nfsroot=<tftp_serverip>:<nfs_root_path>ip=<board_ipaddress>:<tftp_serverip>:<your_gatewayip>:<your_netmask>:MPC8572DS:eth0:off console=ttyS0,115200
=>saveenv
```

### Configuring U-Boot for JFFS Flash deployment

```
=>setenv ipaddr <board_ipaddress>
=>setenv serverip <tftp_serverip>
=>setenv gatewayip <your_gatewayip>
=>setenv bootargs root=/dev/mtdblock4 rw rootfstype=jffs2 console=ttyS0,115200
=>setenv bootcmd ‘run ramargs; bootm ec000000 e8000000 eff00000’
=>saveenv
```

### Configuring U-Boot for Harddisk deployment

```
=>setenv bootargs root=/dev/sda3 rw console=ttyS0,115200
=>setenv bootcmd 'ext2load scsi 0:3 0x1000000 /boot/uImage; ext2load scsi 0:3 0xc00000 /boot/mpc8572ds.dtb;bootm 0x1000000 - c00000'
=>saveenv
```
