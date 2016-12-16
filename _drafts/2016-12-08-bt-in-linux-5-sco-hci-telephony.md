---
layout: post
title:  "Bluez Headset Profile Audio Routing via PCM on TI WL1271-TIWI-BLE"
date:   2016-12-08 11:35:09
categories: Linux
tags: bluetooth bluez
excerpt: Bluez Headset Profile Audio Routing via PCM on TI WL1271-TIWI-BLE
---

This articles expalines how to enable and use Headset Profile with bluez-4.101, the audio is routed via PCM (SSI) Interface. I am working with [TI WL1271-TIWI-BLE](http://www.ti.com/product/wl1271-tiwi-ble) bluetooth module. It is connected IMX6 processor via UART.

To initialize the bluetooth toggle the gpio (this step depends on the board/connection to the bluetooth module)

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

Edit the config file /etc/bluetooth/audio.conf and change the setting as below

```
[General]
Enable=Control,Source,Sink,Headset,Gateway,Socket,Media

# SCO routing. Either PCM or HCI (in which case audio is routed to/from ALSA)
# Defaults to HCI
SCORouting=PCM
```

Append below configuration to ```~/.asoundrc``` file
```

pcm.btnokia {
   type plug
   slave {
       pcm {
           type bluetooth
           device 00:1E:DE:21:D0:85
           profile "hfp"
       }
   }
   hint {
       show on
       description "Nokia HS"
   }
}
ctl.btnokia {
  type bluetooth
}
```

Start the bt daemon in debug mode (Note: for production deployment remove ```-n -d``` )

```
bluetoothd -n -d
```

Pair/Connect the device

```
agent 0000 00:1E:DE:21:D0:85
hcitool cc --role=s 00:1E:DE:21:D0:85
```


### Reset chip

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

### Important Note

* By default the audio from bluetooth module is routed via PCM (SSI) interface, so no need of special hci command.
* You will need to write a small driver inorder to connect the IMX6 SSI interface to ALSA, so the PCM data from bluetooth module can be used from userspace (I won't be explaining this, refer sample driver (linux-src/sound/) on how to)

### Testing Headset profile

Bluez comes with test script named ```test-telephony```. copy this target

```
# ./test-telephony
Usage: ./test-telephony <command>

	connect <bdaddr>
	disconnect <bdaddr>
	outgoing <number>
	incoming <number>
	cancel
	signal <level>
	battery <level>
	roaming <yes|no>
	registration <status>
	subscriber <number>
	speakergain <bdaddr> [level]
	microphonegain <bdaddr> [level]
	play <bdaddr>
	stop <bdaddr>
```

To establish connection with headset

```
./test-telephony connect 00:1E:DE:21:D0:85
```

On successfull connect from bluetoothd dameon console

```
bluetoothd[886]: audio/headset.c:headset_set_state() State changed /org/bluez/886/hci0/dev_00
_1E_DE_21_D0_85: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECTING
bluetoothd[886]: plugins/mgmtops.c:mgmt_event() cond 1
bluetoothd[886]: plugins/mgmtops.c:mgmt_event() Received 33 bytes from management socket
bluetoothd[886]: plugins/mgmtops.c:mgmt_device_connected() hci0 device 00:1E:DE:21:D0:85 conn
ected eir_len 14
bluetoothd[886]: src/adapter.c:adapter_get_device() 00:1E:DE:21:D0:85
bluetoothd[886]: audio/headset.c:headset_set_channel() Discovered Handsfree service on channe l 1
bluetoothd[886]: audio/headset.c:rfcomm_connect() /org/bluez/886/hci0/dev_00_1E_DE_21_D0_85:
Connecting to 00:1E:DE:21:D0:85 channel 1
bluetoothd[886]: audio/headset.c:headset_connect_cb() /org/bluez/886/hci0/dev_00_1E_DE_21_D0_
85: Connected to 00:1E:DE:21:D0:85
bluetoothd[886]: audio/headset.c:handle_event() Received AT+BRSF=25
bluetoothd[886]: audio/headset.c:print_hf_features() HFP HF features: "EC and/or NR function"
 "Voice recognition activation" "Remote volume control"
bluetoothd[886]: audio/headset.c:handle_event() Received AT+CIND=?
bluetoothd[886]: audio/headset.c:handle_event() Received AT+CIND?
bluetoothd[886]: audio/headset.c:handle_event() Received AT+CMER=3, 0, 0, 1
bluetoothd[886]: audio/headset.c:event_reporting() Event reporting (CMER): mode=3, ind=1
bluetoothd[886]: audio/headset.c:hfp_slc_complete() HFP Service Level Connection established
bluetoothd[886]: audio/telephony.c:telephony_device_connected() telephony-dummy: device 0x377
2e0 connected
bluetoothd[886]: audio/headset.c:headset_set_state() State changed /org/bluez/886/hci0/dev_00
_1E_DE_21_D0_85: HEADSET_STATE_CONNECTING -> HEADSET_STATE_CONNECTED
bluetoothd[886]: audio/headset.c:handle_event() Received AT+VGS=08
bluetoothd[886]: audio/headset.c:handle_event() Received AT+VGM=10
bluetoothd[886]: audio/headset.c:handle_event() Received AT+CSRSF=0,0,0,0,0,7
bluetoothd[886]: Badly formated or unrecognized command: AT+CSRSF=0,0,0,0,0,7
```

To disconnect Headset
```
./test-telephony disconnect 00:1E:DE:21:D0:85
```
### Play/Record Audio on Headset

Put headset in play mode

```
./test-telephony play 00:1E:DE:21:D0:85
```
on successfull connection you need get below message from bluetoothd terminal

```
bluetoothd[880]: audio/headset.c:headset_set_state() State changed /org/bluez/880/hci0/dev_00_1E_DE_21_D0_85: HEADS
ET_STATE_CONNECTED -> HEADSET_STATE_PLAY_IN_PROGRESS
bluetoothd[880]: audio/headset.c:sco_connect_cb() SCO socket opened for headset /org/bluez/880/hci0/dev_00_1E_DE_21
_D0_85
bluetoothd[880]: audio/headset.c:sco_connect_cb() SCO fd=22
bluetoothd[880]: audio/headset.c:headset_set_state() State changed /org/bluez/880/hci0/dev_00_1E_DE_21_D0_85: HEADS
ET_STATE_PLAY_IN_PROGRESS -> HEADSET_STATE_PLAYING
```

to play audio to headset

```
aplay -D hw:2,0 test.sbc
```

[or]

record audio from headset mic

```
arecord -D hw:2,0 -d 10 test.sbc
```

[or]

loopback audio from headset mic to headset speaker

```
arecord -D hw:2,0 | aplay -D hw:2,0
```

Turn off headset play mode

```
./test-telephony stop 00:1E:DE:21:D0:85
```

on successfull stop you need get below message from bluetoothd terminal

```

bluetoothd[880]: audio/headset.c:headset_set_state() State changed /org/bluez/880/hci0/dev_00_1E_DE_21_D0_85: HEADS
ET_STATE_PLAYING -> HEADSET_STATE_CONNECTED
```
**Note:** Bluetooth spec uses SBC codec format for transmitting audio between host and device.

### More

get current speaker gain

```
./test-telephony speakergain 00:1E:DE:21:D0:85
15
```

```
./test-telephony speakergain 00:1E:DE:21:D0:85 15
```

./test-telephony microphonegain 00:1E:DE:21:D0:85
10

./test-telephony microphonegain 00:1E:DE:21:D0:85 15

Record/Play audio

arecord -D btnokia ~/hs.sbc
aplay -D btnokia ~/hs.sbc

### Reference

* https://github.com/geomatsi/e-notes/blob/master/bluez-howto.txt
* https://github.com/geomatsi/e-notes/blob/master/hfp.txt
* http://plugable.com/2016/06/22/understanding-bluetooth-wireless-audio/
* https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/85657
* https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/272288
* http://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/85657/310250
http://processors.wiki.ti.com/index.php/CC256x_Advanced_Voice_and_Audio_Features#WB_Speech
http://processors.wiki.ti.com/index.php/CC256x_Testing_Guide
https://e2e.ti.com/support/wireless_connectivity/bluetooth_cc256x/f/660/t/309348

## important
https://e2e.ti.com/support/wireless_connectivity/bluetooth_cc256x/f/660/t/503195
http://processors.wiki.ti.com/index.php/CC256x_VS_HCI_Commands#HCI_VS_Set_Pcm_Loopback_Enable_.280xFE28.29

configure pcm (Send_HCI_VS_Write_CODEC_Config 0xFD06, 3072, 0x00, 8000, 0x0001, 1, 0x00, 0x00, 16, 0x0001, 1, 16, 0x0001, 0, 0x00, 16, 17, 0x01, 16, 17, 0x00, 0x00)
hcitool cmd 0x3f 0x106 3072 0x00 8000 0x0001 1 0x00 0x00 16 0x0001 1 16 0x0001 0 0x00 16 17 0x01 16 17 0x00 0x00

enable loop back (0xFE28 0x01)
hcitool cmd 0x3f 0x228 0x01