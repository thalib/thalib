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
```
bluetoothd -n -d
```


### Resest chip
```
killall -9 bluetoothd ; \
killall -9 hciattach

echo low > /sys/class/gpio/gpio101/direction && sleep 1 && \
echo high > /sys/class/gpio/gpio101/direction



hciattach -t 30 -s 115200 /dev/ttymxc2 texas 3000000 flow && \
bluetoothd -d -n
```
After reset you need to follow all the above insturctions

### Working with BTS

TI provides [BTS](http://processors.wiki.ti.com/index.php/Bluetooth_BTS_files_overview) or Bluetooth Init Script which contains init commands/sequnce for initializing the BT SoC. The BTS files for CC256x can be [downloaded](http://processors.wiki.ti.com/index.php/CC256x_Downloads).

We are using [CC2564xB Init Script](http://www.ti.com/tool/cc256xb-bt-sp). The BTS files can be modified to enable/disable SoC features.

As per [TI Wiki](http://processors.wiki.ti.com/index.php/CC256x_Bluetooth_Hardware_Evaluation_Tool#A_Quick_Tour_of_the_CC256x_Bluetooth_Hardware_Evaluation_Tool) When using add-ons on a Linux Host with the CC256x device, you must combine the Main init script with Add-on init script.

Here is how to combile

* Download the [http://www.ti.com/tool/wilink-bt_wifi-wireless_tools HCI tester tool in order to edit the init scripts(.bts) files.
* Download the device specific init scripts from here.
* Copy all of the commands from the add-on script
* Paste the commands from the add-on script, into the main script immediately **after** Enable fast clock XTAL support and **before** the Enable eHILL commands.
* Save the new script and copy it onto the Linux SD card in the /lib/firmware/

### WBS Features in CC256x devices

Provide mSBC encoding and decoding in the CC256xB device instead of the host(to offload the host processor)
Support legacy headsets (non-mSBC-compliant, 8 Ksamples per second) as well as WB speech headsets, all managed transparently to the phone system. This capability allows the phone to have a standard interface for all headsets.
Provide support for packet loss concealment (PLC) for WBS
The internal mSBC codec can be applied only through the PCM interface. Assisted WBS over HCI (UART) is not supported.
NoteNote: Only one WB speech extended synchronous connection oriented (eSCO) is supported at a time.

### Software Setup for Assisted WBS
The AVPR functions cannot run concurrently with BLE or ANT.
You must first disable BLE/ANT with the corresponding command:

```
BLE: Send_HCI_VS_BLE_Enable 0xFD5B, 0, 0
ANT: Send_HCI_VS_ANT_Enable 0xFDD0, 0, 0, 0
```

```
hcitool cmd 0x3f 0x15b 0 0
hcitool cmd 0x3f 0x1d0 0 0 0
```

The HCI_VS_Write_CODEC_Config (0xFD06) command is required to set fSYNC to a 16-kHz sampling rate (and correspondingly double the clock speed), as well as set up the standard codec PCM parameters.
The following commands are required to activate WB speech in the CC256xB device:
//configure codec to 16 kHz 16 bit samples. will be SBC encoded and sent over 64 kbps. eSCO link.

```
HCI_VS_Write_CODEC_Config 0xFD06, 3072, 0x00, 16000, 0x0001, 1, 0x00, 0x00, 16, 1, 0x01, 16, 1, 0x00, 0x00, 16, 17, 0x01, 16, 17, 0x00, 0x00
```

```
hcitool cmd 0x3f 0x106 3072 0x00 16000 0x0001 1 0x00 0x00 16 1 0x01 16 1 0x00 0x00 16 17 0x01 16 17 0x00 0x00
```

//write air mode transparent.
```
HCI_Write_Voice_Setting 0x0063
HCI_Vs_Wbs_Associate 0xFD78, 0x1
```

```
hcitool cmd 0x63
hcitool cmd 0x3f 0x178 0x1
```

```
HCI_Setup_Synchronous_Connection 1, 0x1f40, 0x1f40, 0xE, 0x0063, 0x02, 0x03c8

To disable WB speech, use this script:

```
HCI_Disconnect (0x0406) 0x101, 0x13
HCI_Vs_Wbs_Disassociate 0xFD79
```
To re-enable BLE or ANT:
Disable AVPR:

```
Send_HCI_VS_AVPR_Enable 0xFD92, 0, 0, 0, 0
```

Re-load BLE or ANT add-on


[Software Setup for Assisted WBS](http://processors.wiki.ti.com/index.php/CC256x_Advanced_Voice_and_Audio_Features#WB_Speech)

http://www.dziwior.org/Bluetooth/HCI_Commands_Host_Control.html
http://www.lisha.ufsc.br/teaching/shi/ine5346-2003-1/work/bluetooth/hci_commands.html

More infocan be found on

* [TI Wiki - CC256x_VS_HCI_Commands](http://processors.wiki.ti.com/index.php/CC256x_VS_HCI_Commands)
* [BLE in WL127xL](http://processors.wiki.ti.com/index.php/BTS_with_BLE_enabled_for_WL127xL)
* [TI BluetoothLE](http://processors.wiki.ti.com/index.php/Category:BluetoothLE?DCMP=blestack&HQS=ble-wiki)


### HStest tool

http://stackoverflow.com/questions/30321192/bluez-on-i-mx25-cant-connect-rfcomm-socket-operation-now-in-progress

https://bbs.archlinux.org/viewtopic.php?id=60158

http://osdir.com/ml/linux.bluez.user/2003-07/msg00112.html
https://sourceforge.net/p/bluez/mailman/message/12729397/
https://padovan.org/blog/2010/02/handsfree-profile-into-bluez-and-ofono/

https://wiki.apertis.org/QA/Test_Cases/bluez-hfp
http://maemo.org/api_refs/5.0/5.0-final/bluez/audio-api.txt
http://www.funtoo.org/Bluetooth_made_easy
https://github.com/pauloborges/bluez/tree/master/test
http://nohands.sourceforge.net/config.html

http://wiki.openmoko.org/wiki/Manually_using_Bluetooth

http://www.drdobbs.com/mobile/using-bluetooth/232500828
http://stackoverflow.com/questions/15557933/receive-audio-via-bluetooth-in-android

http://people.csail.mit.edu/albert/bluez-intro/
https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/362198
Good
http://www.lightofdawn.org/blog/?viewDetailed=00031
http://git.kernel.org/cgit/bluetooth/sbc.git/

###

./hsplay ~/Music/test.wav 00:1E:DE:21:D0:85
Voice setting: 0x0060
/usr/bin/sox WARN sox: Option `-s' is deprecated, use `-e signed-integer' instead.
/usr/bin/sox WARN getopt: option `w' not recognized
/usr/bin/sox FAIL sox: invalid option

Can't connect RFCOMM channel: Host is down


## Set voice profile
hciconfig hci0 voice 0x0060 up

root@esomimx6s:/lib/firmware/bluez4-scripts# ./hstest record in.rec 00:1E:DE:21:D0:85 1
Voice setting: 0x0060
RFCOMM channel connected
SCO audio channel connected (handle 257, mtu 180)
AT+BRSF=25
