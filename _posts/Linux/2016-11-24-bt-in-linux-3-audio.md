---
layout: post
title:  "Bluez A2DP Audio Streaming in Linux"
date:   2016-11-24 14:50:06
categories: Linux
tags: bluetooth bluez
excerpt: Bluez A2DP Audio Streaming in Linux
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

In embedded targests ```bluetooth-agent``` is named as ```agent```

Next is to create connection to remove device

```
sudo hcitool cc --role=s 00:1E:DE:21:D0:85
```

**Note:** Opposite cc is dc ```sudo hcitool dc 00:1E:DE:21:D0:85``` to disconnect the bt device

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


Add below Alsa configuration to /etc/asound.conf or ~/.asoundrc for alsa recognize our bt as sink/source

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

To make a loop back

```
arecord -D  btnokia | aplay -D btnokia
```

More readings on

* [Ubuntu Wiki](https://help.ubuntu.com/community/BluetoothHeadset)
* [Gentoo Wiki](https://wiki.gentoo.org/wiki/Bluetooth_Headset)
* [ArchLinux Wiki](https://wiki.archlinux.org/index.php/Bluetooth_headset)
* [Article on A2DP and HSP/HFP](http://blog.cyphermox.net/2012/03/call-for-testing-bluez-a2dp-and-hsphfp.html)
* [Broadcom BCM20702A0 Bug](http://askubuntu.com/questions/180437/bluetooth-headset-a2dp-works-hsp-hfp-not-no-sound-no-mic)
* [HFP on Bluez and ofono](http://padovan.org/blog/2010/02/handsfree-profile-into-bluez-and-ofono/)
* [nohands - Linux Hands-Free Profile server](http://nohands.sourceforge.net)
