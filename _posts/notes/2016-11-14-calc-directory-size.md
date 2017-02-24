---
layout: post
title:  "Calculate the size of directory in Linux"
date:   2016-11-14 13:27:58
categories: Linux
tags: bash linux howto
excerpt: This post is all about XYZ (CHANGE ME)
---

Here is simple bash script to find how much size a directory take in the hard drive. Here we combine simple bash for loop with **ls and du** command to compute the size.

```
for i in `ls`; do
  du -sh $i
done
```
