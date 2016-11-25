---
layout: post
title:  "Working with Bluetooth in Linux (Part 4)"
date:   2016-11-24 14:50:06
categories: Linux
tags: bluetooth bluez
excerpt: Working with Bluetooth in Linux (Part 4)
---

I am working with [TI WL1271-TIWI-BLE](http://www.ti.com/product/wl1271-tiwi-ble) which is module. It is connected processor.

To initalize the bluetooth toggle the gpio

```
echo 101 > /sys/class/gpio/export
echo low > /sys/class/gpio/gpio101/direction
echo high > /sys/class/gpio/gpio101/direction
```

Attach the bt UART interface to bluez stack

```
# hciattach -t 30 -s 115200 /dev/ttymxc2 texas 3000000 flow
Found a Texas Instruments' chip!
Firmware file : /lib/firmware/TIInit_7.6.15.bts
Loaded BTS script version 1
texas: changing baud rate to 3000000, flow control to 1
Device setup complete
```

Bring the bt interface up and give it a name

```
hciconfig hci0 up piscan name thalib-bt
```

More infocan be found on

* [CC256x Downloads](http://processors.wiki.ti.com/index.php/CC256x_Downloads)
* [TI Wiki - CC256x_VS_HCI_Commands](http://processors.wiki.ti.com/index.php/CC256x_VS_HCI_Commands)
* [CC2564xB Init Script Download](http://www.ti.com/tool/cc256xb-bt-sp)
* [BLE in WL127xL](http://processors.wiki.ti.com/index.php/BTS_with_BLE_enabled_for_WL127xL)
* [BTS file overview ](http://processors.wiki.ti.com/index.php/Bluetooth_BTS_files_overview)
* [TI BluetoothLE](http://processors.wiki.ti.com/index.php/Category:BluetoothLE?DCMP=blestack&HQS=ble-wiki)
