---
layout: post
title:  "How to install vagrant in Debian 8"
date:   2017-03-29 13:01:24
categories: Notes
tags: vagrant, virtualbox, debian
---

The first step is to download the [vagrant](https://www.vagrantup.com/downloads.html) and [virtualbox](https://www.virtualbox.org/wiki/Downloads) from its website.


Update the apt

```
sudo apt-get update
```

And install the kernel headers, kernel headers are needed by virutal box to comile some modules

```
sudo apt-get install linux-headers-amd64
```

Install virtualbox and vagrant deb package

```
sudo dpkg -i virtualbox-5.1_5.1.18-114002-Debian-jessie_amd64.deb
sudo dpkg -i vagrant_1.9.3_x86_64.deb
```

Run below command to install any missing dependacy of above deb packages.

```
sudo apt-get -f install
```

Now vagrant and virtual box are ready for use

Running Debian 8 on vagrant

```
vagrant init debian/jessie64
vagrant up
```
