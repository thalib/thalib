---
layout: post
title:  "How To Change the OS in Vagrant VM"
date:   2016-11-01 17:03:56
categories: Programming
tags: vagrant ssh putty windows devoops vm
excerpt: How To Change the OS in Vagrant VM
---

PuTTY will not recognize the insecure_private_key (which is in OpenSSH format) provided by Vagrant as a valid, private key. But you can convert the OpenSSH for private key to PuTTY ppk file using  PuTTYgen

Vagrant will store info about the boxes in the same dir where Vagrantfile is present.

Example

```
.vagrant\machines\default\virtualbox
```

In this dir, the OpenSSH format insecure_private_key will be created by vagrant. We need to convert this key to PuTTY ppk format

1. Start PuTTYgen
* From menu select **File > Open private key** and navigate to the above path
* Select the file insecure_private_key file (if no file is visible, change the file types to All File) select file **insecure_private_key** and open
* Click on the Save private key button.

Then, launch PuTTY and enter the following connection information:

* Host Name:	127.0.0.1
* Port:	2222
* Connection type:	SSH
* Connection	Data	Auto-login username:	vagrant
* Connection/SSH	Auth	Private key file for authentication:	Click on the Browse button and find the .ppk private key you just converted

Thats it, this is how you configure the PuTTY to connect to Vagrant VM.

### Refrence

* [Connect to Your Vagrant Virtual Machine with PuTTY](https://github.com/Varying-Vagrant-Vagrants/VVV/wiki/Connect-to-Your-Vagrant-Virtual-Machine-with-PuTTY)
