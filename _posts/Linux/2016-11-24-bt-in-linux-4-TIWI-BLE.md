---
layout: post
title:  "How To Bluez Headset Profile (HSP) on TI WL1271-TIWI-BLE"
date:   2016-12-05 14:50:06
categories: Linux
tags: bluetooth bluez
excerpt: How To Bluez Headset Profile (HSP) on TI WL1271-TIWI-BLE
---

I am working with [TI WL1271-TIWI-BLE](http://www.ti.com/product/wl1271-tiwi-ble) which is module. It is connected IMX6 processor via UART.

To initalize the bluetooth toggle the gpio (this step depends on the board/connnection to the bluetooth module)

```
echo 101 > /sys/class/gpio/export && \
echo low > /sys/class/gpio/gpio101/direction && sleep 1 && \
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

start the bt dameon in debug mode (for production deployment remove ```-n -d``` )

```
bluetoothd -n -d
```

Pair/Connect the device

```
agent 0000 00:1E:DE:21:D0:85
hcitool cc --role=s 00:1E:DE:21:D0:85
```


### Resest chip

Here is the simple instruction to reset the bluetoothd service and chip

```
killall -9 bluetoothd ; \
killall -9 hciattach

echo low > /sys/class/gpio/gpio101/direction && sleep 1 && \
echo high > /sys/class/gpio/gpio101/direction

hciattach -t 30 -s 115200 /dev/ttymxc2 texas 3000000 flow && \
hciconfig hci0 up && \
bluetoothd -d -n

agent 0000 00:1E:DE:21:D0:85
hcitool cc --role=s 00:1E:DE:21:D0:85
```

### Enable SCO over HCI

As per [TI forum](https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/439110/1578792#1578792) you need to write below SCO configuration

Send_HCI_VS_Write_SCO_Configuration 0xFE10, 0x01, 120, 511, 0xFF
Wait_HCI_Command_Complete_VS_Write_SCO_Configuration_Event 5000, any,
HCI_VS_Write_SCO_Configuration, 0x00, 100, 0x0

```
hcitool cmd 0x3f 0x210 0x01 120 511 0xF
```

It also metions about eabling flow control, for me wihout flow control it worked.

```
hcitool cmd 0x3 0x2f 0x01
```

### Record audio over HCI sco

Note: hstest was part of bluez source, it can be found in test/hstest.c
```
./hstest record in.rec 00:1E:DE:21:D0:85 1
Voice setting: 0x0060
RFCOMM channel connected
SCO audio channel connected (handle 257, mtu 180)
```

### Play audio over HCI SCO
```
./hstest play in.re 00:1E:DE:21:D0:85 1
Voice setting: 0x0060
RFCOMM channel connected
SCO audio channel connected (handle 257, mtu 180)

```

### Working with BTS

TI provides [BTS](http://processors.wiki.ti.com/index.php/Bluetooth_BTS_files_overview) or Bluetooth Init Script which contains init commands/sequnce for initializing the BT SoC. The BTS files for TiWi-BLE
can be [downloaded](https://www.lsr.com/embedded-wireless-modules/wifi-plus-bluetooth-module/tiwi-ble).

Here is how edit bts file

* Download the [http://www.ti.com/tool/wilink-bt_wifi-wireless_tools](HCI tester tool) in order to edit the init scripts(.bts) files.
* Load and mofify the bts script in HCI tester tool
* Save the new script and copy it onto the Linux SD card in the /lib/firmware/


### Set voice profile

If your hci0 is not set to voice mode, use below command to set it to voice mode.

```
hciconfig hci0 voice 0x0060 up
```

### Refrences


* [Software Setup for Assisted WBS](http://processors.wiki.ti.com/index.php/CC256x_Advanced_Voice_and_Audio_Features#WB_Speech)
* [hci commands reference 1](http://www.dziwior.org/Bluetooth/HCI_Commands_Host_Control.html)
* [hci commands reference 2](http://www.lisha.ufsc.br/teaching/shi/ine5346-2003-1/work/bluetooth/hci_commands.html)
* [TI Wiki - CC256x_VS_HCI_Commands](http://processors.wiki.ti.com/index.php/CC256x_VS_HCI_Commands)
* [BLE in WL127xL](http://processors.wiki.ti.com/index.php/BTS_with_BLE_enabled_for_WL127xL)
* [TI BluetoothLE](http://processors.wiki.ti.com/index.php/Category:BluetoothLE?DCMP=blestack&HQS=ble-wiki)
* http://www.funtoo.org/Bluetooth_made_easy
* https://github.com/pauloborges/bluez/tree/master/test
* http://nohands.sourceforge.net/config.html
* http://wiki.openmoko.org/wiki/Manually_using_Bluetooth
* http://www.drdobbs.com/mobile/using-bluetooth/232500828
* http://www.lightofdawn.org/blog/?viewDetailed=00031
* http://git.kernel.org/cgit/bluetooth/sbc.git/
* https://e2e.ti.com/search?q=hcitool%20sco
* https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/439110/1578792#1578792
* https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/514194
* https://e2e.ti.com/support/wireless_connectivity/bluetooth_cc256x/f/660/t/537782
* https://e2e.ti.com/support/wireless_connectivity/bluetooth_cc256x/f/660/t/537782
* http://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/401199/1420546#1420546
