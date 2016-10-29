---
layout: post
title:  "Enabling IPv4 Forwarding"
date:   2016-10-29 12:16:00
categories: Embedded
tags: linux embedded
excerpt: Commands for Enabling IPv4 Forwarding
---

Enable IP forwarding, using /proc entry

```
echo 1 > /proc/sys/net/ipv4/ip_forward
```

Set the IP address

```
ifconfig lo 127.0.0.1 netmask 255.0.0.0
ifconfig eth0 10.1.1.1 netmask 255.255.255.0 up
ifconfig eth1 10.1.2.1 netmask 255.255.255.0 up
```
