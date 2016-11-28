---
layout: post
title:  "Working with Bluetooth in Linux (Part 4)"
date:   2016-11-24 14:50:06
categories: Linux
tags: bluetooth bluez
excerpt: Working with Bluetooth in Linux (Part 4)
---

I am working with [TI WL1271-TIWI-BLE](http://www.ti.com/product/wl1271-tiwi-ble) which is module. It is connected processor.

To initalize the bluetooth toggle the gpio (this step depends on the board/connnection to the bluetooth module)

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

### Working with BTS

TI provides [BTS](http://processors.wiki.ti.com/index.php/Bluetooth_BTS_files_overview) or Bluetooth Init Script which contains init commands/sequnce for initializing the BT SoC. The BTS files for CC256x can be [downloaded](http://processors.wiki.ti.com/index.php/CC256x_Downloads).

We are using [CC2564xB Init Script](http://www.ti.com/tool/cc256xb-bt-sp). The BTS files can be modified to enable/disable SoC features.

As per [TI Wiki](http://processors.wiki.ti.com/index.php/CC256x_Bluetooth_Hardware_Evaluation_Tool#A_Quick_Tour_of_the_CC256x_Bluetooth_Hardware_Evaluation_Tool) When using add-ons on a Linux Host with the CC256x device, you must combine the Main init script with Add-on init script.

Here is how to combile

1. Download the [http://www.ti.com/tool/wilink-bt_wifi-wireless_tools HCI tester tool in order to edit the init scripts(.bts) files.
* Download the device specific init scripts from here.
* Copy all of the commands from the add-on script
* Paste the commands from the add-on script, into the main script immediately after Enable fast clock XTAL support and before the Enable eHILL commands.
* Save the new script and copy it onto the Linux SD card in the /lib/firmware/

### WBS Features in CC256x devices

Provide mSBC encoding and decoding in the CC256xB device instead of the host(to offload the host processor)
Support legacy headsets (non-mSBC-compliant, 8 Ksamples per second) as well as WB speech headsets, all managed transparently to the phone system. This capability allows the phone to have a standard interface for all headsets.
Provide support for packet loss concealment (PLC) for WBS
The internal mSBC codec can be applied only through the PCM interface. Assisted WBS over HCI (UART) is not supported.
NoteNote: Only one WB speech extended synchronous connection oriented (eSCO) is supported at a time.

[Software Setup for Assisted WBS](http://processors.wiki.ti.com/index.php/CC256x_Advanced_Voice_and_Audio_Features)

More infocan be found on

* [TI Wiki - CC256x_VS_HCI_Commands](http://processors.wiki.ti.com/index.php/CC256x_VS_HCI_Commands)
* [BLE in WL127xL](http://processors.wiki.ti.com/index.php/BTS_with_BLE_enabled_for_WL127xL)
* [TI BluetoothLE](http://processors.wiki.ti.com/index.php/Category:BluetoothLE?DCMP=blestack&HQS=ble-wiki)
*
