---
layout: post
title:  "Working with Bluetooth Audio in Linux (Part 3)"
date:   2016-11-24 14:50:06
categories: Linux
tags: bluetooth bluez
excerpt: Working with Bluetooth Audio in Linux (Part 3)
---

Get the bluetooth address of Headset using hcitool command

```
hcitool scan
Scanning ...
	00:1E:DE:21:D0:85	Nokia BH-505
	00:1E:DE:21:D0:85	S10
```

Here I have two bluetooth devices

### Paring and Connecting Device

Now lets pair the device

```
$ bluetooth-agent 0000 00:1E:DE:21:D0:85
Agent has been released
```

Next is to create connection to remove device

```
sudo hcitool cc --role=s 00:1E:DE:21:D0:85
```

Note: Opposite cc is, dc - disconnect a device

```
sudo hcitool dc 00:1E:DE:21:D0:85
```

Then we have to add the device as thrusted

```
bluez-test-device trusted 00:1E:DE:21:D0:85 yes
```

Now connect devices using audio profile

```
bluez-test-audio connect 00:1E:DE:21:D0:85
```


You can use **hcitool con** command to check if connection has succeded or not
```
$ hcitool con
Connections:
	< ACL 00:1E:DE:21:D0:85 handle 11 state 1 lm MASTER
```

### BT and Alsa config

Add below config to /etc/bluetooth/audio.conf to enable audio in bluetoothd

```
Enable=Source,Sink,Headset,Gateway,Control,Socket,Media
```


Add below Alsa configuration to ~/.asoundrc to recognize our bt as sink/source

```
pcm.btnokia {
   type plug
   slave {
       pcm {
           type bluetooth
           device 00:1E:DE:21:D0:85
           profile "auto"
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

Once you have made above file modification you need to restart bluetoothd daemon (refer Part 1 on how to reset the bluetoothd).


### Audio playback/recording

Play audio file

```
aplay -D btnokia test.wav
```

Record audio file

```
arecord -D  btnokia -d 10 out.wav
```

### Refrence

* [Ubuntu BluetoothHeadset](https://help.ubuntu.com/community/BluetoothHeadset)
