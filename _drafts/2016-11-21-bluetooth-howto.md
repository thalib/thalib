---
layout: post
title:  "How to use Bluetooth in Linux using Bluez"
date:   2016-11-22 07:48:44
categories: Linux
tags: bluez bluetooth howto
excerpt: How to use Bluetooth in Linux using Bluez
---

**This notes is under progress**


### Quick testing

not working
aplay -D bhnokia:HCI=hci0,DEV=00:1E:DE:21:D0:85,PROFILE=a2dp test.wav



### Avaliable bt commands

```
bluetoothd
bluetooth-agent
bluez-simple-agent
bluez-simple-service
bluez-test-adapter
bluez-test-network
bluez-test-audio
bluez-test-serial
bluez-test-device
bluez-test-service
bluez-test-discovery
bluez-test-telephony
bluez-test-input
bluez-test-manager
```

## BT Audio

The most common use of bluetooth audio is to make a wireless connection to a cellphone. This is typically done using a small headset that fits over one ear. These headsets don't deliver outstanding audio quality.

### SCO

A headset used for a phone call should not introduce much delay. A special transport, **Synchronous Connection-Oriented or SCO**, was invented to provide this low-delay monophonic audio with voice-quality fidelity.

SCO headsets have one or both of two profiles for 2-way voice communication.

- **HSP** : The simpler profile is the **Headset Profile, or HSP**. It provides for a way to tap a button to start or end a call and buttons for controlling audio levels.
- **HFP** : The more advanced Hands-free Profile, HFP, adds a host of optional functions like call rejection, last-number redial, caller id display, and dialing specific phone numbers.

### High-fidelity audio

The advanced audio distribution profile, A2DP, provides the basis for high-fidelity audio. The bandwidth of bluetooth cannot accommodate uncompressed high-quality stereo audio, so the audio stream must be digitally compressed.
Pausing, playing, advancing the track are features of the AVRCP profile, most commonly combined with A2DP.

### Commands

```
modprobe snd_bt_sco
hciconfig hci0 voice 0x0060
```

turn on the headset (you may need to prepare the headset to be paired the computer, usually by turning on the headset and holding the on button until it beeps; make sure the headset has not connected to your cell--this would block the computer's connection.)

run the handler (let it keep running if you run in the foreground)
```
btsco bdaddress
```

You probably need to enter the passkey if it's the first time 'round
send and receive audio from the headset (usually using /dev/dsp1) or via the alsa device with something like

```
aplay -B 1000000 -D plughw:Headset sound.wav
```

```
sudo /etc/init.d/bluetooth start
sleep 3
sudo passkey-agent --default /usr/bin/bluez-pin &
sleep 3
sudo modprobe snd_bt_sco
sleep 3
sudo hciconfig hci0 voice 0x0060
sleep 3
sudo hcitool scan
sleep 3
sudo hcitool inq
sleep 3
sudo hcitool con
sleep 3
sudo hcitool cc 00:13:17:84:96:34
sleep 3
sudo hcitool con
sleep 3
sudo hcitool auth 00:13:17:84:96:34
sleep 3
sudo sdptool browse
sleep 3
sudo btsco -v -f -r -s 00:13:17:84:96:34
sleep 3
aplay -B 1000000 -D plughw:Headset /usr/share/sounds/generic.wav
```


### Referecnes
* [https://github.com/atwilc3000/driver/wiki/bluetooth](https://github.com/atwilc3000/driver/wiki/bluetooth)
* [http://trac.gateworks.com/wiki/wireless/bluetooth](http://trac.gateworks.com/wiki/wireless/bluetooth)
* [https://wiki.gumstix.com/index.php?title=Category:How_to_-_bluetooth](https://wiki.gumstix.com/index.php?title=Category:How_to_-_bluetooth)
* [http://bluetooth-alsa.sourceforge.net](http://bluetooth-alsa.sourceforge.net)
* [http://bluetooth-alsa.sourceforge.net/embed.html](http://bluetooth-alsa.sourceforge.net/embed.html)
* [https://help.ubuntu.com/community/BluetoothHeadset](https://help.ubuntu.com/community/BluetoothHeadset)
* [https://help.ubuntu.com/community/BluetoothAudio](https://help.ubuntu.com/community/BluetoothAudio)
* [https://help.ubuntu.com/community/BluetoothSetup](https://help.ubuntu.com/community/BluetoothSetup)
* [http://www.gargan.org/linux/snd-bt-sco/](http://www.gargan.org/linux/snd-bt-sco/)
* [http://www.thinkwiki.org/wiki/How_to_setup_Bluetooth](http://www.thinkwiki.org/wiki/How_to_setup_Bluetooth)
* [https://wiki.archlinux.org/index.php/Bluetooth_headset](https://wiki.archlinux.org/index.php/Bluetooth_headset)
* [https://community.nxp.com/thread/355201](https://community.nxp.com/thread/355201)
* [https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/351693](https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/351693)
* [https://ubuntuforums.org/archive/index.php/t-213731.html](https://ubuntuforums.org/archive/index.php/t-213731.html)
* [http://www.fromdev.com/2014/03/python-tutorials-resources.html](http://www.fromdev.com/2014/03/python-tutorials-resources.html)
* http://www.bluez.org/the-management-interface/
* http://www.linuxquestions.org/questions/linux-wireless-networking-41/setting-up-bluez-with-a-passkey-pin-to-be-used-as-headset-for-iphone-816003/
* https://wiki.debian.org/BluetoothUser
* http://wiki.e-consystems.net/index.php/Bluetooth_wireless_mouse_and_key_board
* http://alsa.opensrc.org/Asoundrc
* http://www.alsa-project.org/main/index.php/Asoundrc
* https://wiki.gentoo.org/wiki/Bluetooth
* https://wiki.archlinux.org/index.php/Bluetooth_headset
* http://elinux.org/RPi_Bluetooth_LE
* https://bbs.archlinux.org/viewtopic.php?id=141760
* https://wiki.gentoo.org/wiki/Bluetooth_Headset

TI Links
* https://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/t/272288
* http://processors.wiki.ti.com/index.php/CC256x_Advanced_Voice_and_Audio_Features
* http://e2e.ti.com/support/wireless_connectivity/wilink_wifi_bluetooth/f/307/p/401199/1420546#1420546
* http://processors.wiki.ti.com/index.php/CC256x
