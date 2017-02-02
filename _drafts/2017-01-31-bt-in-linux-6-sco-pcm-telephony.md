---
layout: post
title:  "Wonderfull article (CHANGE ME)"
date:   2017-01-31 12:07:01
categories: General
tags:
excerpt: This post is all about XYZ (CHANGE ME)
---

### Stop X

service lightdm stop

### Bluez Setup

```
sudo su
insmod snd-soc-tegra-btlsr.ko

service bluetooth stop && \
sleep 2 && \
killall -9 hciattach
killall -9 bluetoothd

echo 221 > /sys/class/gpio/export && \
echo out > /sys/class/gpio/gpio221/direction

echo 0 > /sys/class/gpio/gpio221/value && \
sleep 1 && \
echo 1 > /sys/class/gpio/gpio221/value

hciattach -t 10 -s 115200 /dev/ttyTHS1 texas 3000000 flow  && \
sleep 2

hciconfig hci0 up

service bluetooth start
[or]
bluetoothd -n -d &

```

```
hcitool scan --refresh
Scanning ...
44:1C:A8:25:9B:30       n/a
00:1E:DE:21:D0:85       Nokia BH-505
```

```
bluez-simple-agent hci0 00:1E:DE:21:D0:85
RequestPinCode (/org/bluez/396/hci0/dev_00_1F_20_39_69_8B)
Enter PIN Code: 0000
Release
New device (/org/bluez/396/hci0/dev_00_1F_20_39_69_8B)
```

[or]


bluez-simple-agent 0000 00:1E:DE:21:D0:85

bluez-test-device trusted 00:1E:DE:21:D0:85 yes

hcitool cc --role=s 00:1E:DE:21:D0:85

/usr/bin/bluez-test-telephony connect 00:1E:DE:21:D0:85
/usr/bin/bluez-test-telephony play 00:1E:DE:21:D0:85

/usr/bin/bluez-test-telephony disconnect 00:1E:DE:21:D0:85

scotest -n 00:1E:DE:21:D0:85

### Audo Testing

Install sox

```
sudo apt-get install sox
sox input.wav -r 8000 -c 1 output.wav
```

Run scotest application,
```
scotest -n <bt address of headset>
```

Play noise for testing
```
cat /dev/urandom | aplay -Dhw:1 -f S16_LE -r16000
```

Record and Play Audio
```
arecord -Dhw:1 -f S16_LE -r16000 test.wav

aplay -Dhw:1 -f S16_LE -r16000 test.wav
```

RAW Record and Play Audio
```
arecord -Dhw:1 -f S16_LE -r16000 -t raw test.raw

aplay -Dhw:1 -f S16_LE -r16000 -t raw test.raw
```

alex
```
arecord -Dhw:1 -f S16_LE test1.wav
aplay -Dhw:1 -f S16_LE test1.wav
```

Loop back testing
```
arecord -Dhw:1 -f S16_LE -r16000 | aplay -Dhw:1
```
