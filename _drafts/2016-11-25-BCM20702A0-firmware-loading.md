---
layout: post
title:  "[Solved] BCM20702A0 Direct firmware load failed with error -2"
date:   2016-11-25 18:22:19
categories: Linux
tags: bluez bluetooth firmware solved
excerpt: [Solved] BCM20702A0 Direct firmware load failed with error -2
---

I was using BCM20702A0 bt dongle, It didn't work as expected, then from the demg I found the dognle is looking for firmeare and it failed to find one.

```
[26415.166236] usb 3-2.3: new full-speed USB device number 12 using xhci_hcd
[26415.185442] usb 3-2.3: New USB device found, idVendor=0a5c, idProduct=21e8
[26415.185445] usb 3-2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[26415.185447] usb 3-2.3: Product: BCM20702A0
[26415.185449] usb 3-2.3: Manufacturer: Broadcom Corp
[26415.185450] usb 3-2.3: SerialNumber: 5CF370669D06
[26415.220864] usb 3-2.3: Direct firmware load failed with error -2
[26415.220868] usb 3-2.3: Falling back to user helper
[26415.221601] Bluetooth: can't load firmware, may not work correctly
```

When I searched for solution in net, I came accross these web links [plugable.com](http://plugable.com/2014/06/23/plugable-usb-bluetooth-adapter-solving-hfphsp-profile-issues-on-linux#comment-41932) and [here](http://askubuntu.com/questions/617513/bluetooth-not-connecting-to-devices-even-though-it-recognizes-them/617518#617518) and [here](http://askubuntu.com/questions/180437/bluetooth-headset-a2dp-works-hsp-hfp-not-no-sound-no-mic)


Older Kernel Versions (before 3.16)

Run the following command to download the firmware file:

```wget https://s3.amazonaws.com/plugable/bin/fw-0a5c_21e8.hcd```

Copy the firmware file to the /lib/firmware folder:

```sudo cp fw-0a5c_21e8.hcd /lib/firmware```

Now **Reboot**

**[or]**

Re insert the btusb module

```sudo modprobe -r btusb && sudo modprobe btusb ```
