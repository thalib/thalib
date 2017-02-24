---
layout: post
title:  "How To Change the OS in Vagrant VM"
date:   2016-11-01 17:03:56
categories: Programming
tags: programming language go
excerpt: How To Change the OS in Vagrant VM
---

Many times we may need to change the Vagrant OS for some reason, there a are many methods. I am documenting here how I did it.

I wanted to change the Ubuntu OS version from 12.04(hashicorp/precise64) to 14.04(ubuntu/trusty64), but

### Step 1:

Renamed .vagrant to some thing else, eg old.vagrant

## Step 2:

In Vagrantfile set the config.vm.box to **"ubuntu/trusty64"**

```
config.vm.box = "ubuntu/trusty64"
```
### Step 3:

```
vagrant up
```

That's it, vagrant will now load the new OS.

**Note** : if you change the OS image, all your OS setups will lost, you need to reinstall/configure the OS.

### Refrence

* [How to switch Vagrant virtual machine](http://stackoverflow.com/questions/19104830/how-to-switch-vagrant-virtual-machine)
