---
layout: post
title:  "Convert audio to and from SBC codec format in Linux"
date:   2016-12-08 07:35:09
categories: Linux
tags: bluez bluetooth audio
excerpt: Convert audio to and from SBC codec format in Linux
---

Bluetooth Spec defines [SBC](https://en.wikipedia.org/wiki/SBC_(codec)) (Low Complexity Subband Coding) an audio subband codec specified for the Audio transmission between Bluetooth devices and Host.

SBC is a digital audio encoder and decoder used to transfer data to Bluetooth audio output devices like headphones or loudspeakers.

In Linux here is the command to encode/decode a audio and send it to Bluetooth headset. For conversion a commandline tool named sox (SoX - Sound eXchange, the Swiss Army knife of audio manipulation) will be used.

### Convert to/from SBC format

#### Encode to SBC format

```
mpg123 -q -s test.mp3 | sox -t raw -r 44100 -c 2 -s -w - -t raw -r 8000 -c 1 -s -w out.sbc
```

Using with bluez hstest test application

```
mpg123 -q -s test.mp3 | sox -t raw -r 44100 -c 2 -s -w - -t raw -r 8000 -c 1 -s -w - | ./hstest play - $BDADDR $CHANNEL
```

#### Decode SBC format

```
sox -t raw -r 8000 -c 1 -s -w inputfile.sbc -b 16 -r 44100 -c 2 -s outfile.wav
```

Using with bluez hstest test application

```
./hstest record - $BDADDR $CHANNEL | sox -t raw -r 8000 -c 1 -s -w - -b 16 -r 44100 -c 2 -s outfile.wav
```
