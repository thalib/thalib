---
layout: post
title:  "How to convert an MP3 to WAV Format from Linux command line"
date:   2016-11-23 19:06:55
categories: Linux
tags: howto mp3 linux command
excerpt: How to convert an MP3 to WAV Format from Linux command line
---

It easy to convert an MP3 to WAV from Linux command line,

```
mpg123 -w output.wav input.mp3
```


### 8-bit wav format

Buy default the ouput 16bit wav format, Here is how you convert to 8bit wav file

```
mpg123 --wav out.wav --8bit --rate 8000 --mono input.mp3
```
