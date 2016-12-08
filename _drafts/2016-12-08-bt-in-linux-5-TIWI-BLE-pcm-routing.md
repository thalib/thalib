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

### Reference

* https://github.com/geomatsi/e-notes/blob/master/bluez-howto.txt
* https://github.com/geomatsi/e-notes/blob/master/hfp.txt
* http://plugable.com/2016/06/22/understanding-bluetooth-wireless-audio/
* https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/85657
* https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/272288
* http://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/85657/310250
