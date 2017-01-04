---
layout: post
title:  "Check list to secure the cloud server"
date:   2016-12-26 12:14:44
categories: Linux
tags: security cloud server admin checklist
excerpt: Check list to secure the cloud server
---

Here are the important steps to secure the cloud server, a.k.a server hardening

Note: This aricle is under active development.

# Update OS

On fist time, upgrade the distro.
```
sudo apt-get update
sudo apt-get -y dist-upgrade
```

Regularly update the packages
```
sudo apt-get update
sudo apt-get -y upgrade
```

### configure the timezone of the server

https://www.digitalocean.com/community/tutorials/additional-recommended-steps-for-new-ubuntu-14-04-servers
https://www.linode.com/docs/security/
https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04

```
$ sudo dpkg-reconfigure tzdata

Current default time zone: 'Asia/Kolkata'
Local time is now:      Sun Jan  1 13:08:32 IST 2017.
Universal Time is now:  Sun Jan  1 07:38:32 UTC 2017.
```

### Add non root user

Create a non-root user

```
adduser $NON_ROOT_USER
```

Add non-root user to sudo list

```
usermod -aG sudo $NON_ROOT_USER
```

https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-ubuntu-quickstart
https://www.digitalocean.com/community/tutorials/additional-recommended-steps-for-new-ubuntu-14-04-servers

### Disable Root User

**Disable root user login**

Edit ```/etc/passwd``` file and change the shell of root from ```/bin/bash``` to ```/sbin/nologin```.

```root:x:0:0:root:/root:/bin/bash```

```
sudo usermod -s /sbin/nologin root
```

**Disabling root SSH logins**

Edit the ```/etc/ssh/sshd_config``` file and set the ```PermitRootLogin``` parameter to ```no```.

```
PermitRootLogin yes - > PermitRootLogin no
ChallengeResponseAuthentication yes -> ChallengeResponseAuthentication no
sudo service ssh restart
```

### Disable SSH using password

Setup SSH Key Authentication

Disable password login

```
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
```

Restart the ssh server for above changes to take effect.

```
sudo service ssh restart
```

* http://www.thegeekstuff.com/2011/05/openssh-options/
* http://askubuntu.com/questions/627017/how-do-i-recover-the-default-version-of-some-configuration-file
* https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
* https://www.cyberciti.biz/tips/checking-openssh-sshd-configuration-syntax-errors.html
* https://stribika.github.io/2015/01/04/secure-secure-shell.html
* https://www.digitalocean.com/community/tutorials/how-to-connect-to-your-droplet-with-ssh
*

# Install Firewall (ufw)

Block all ports except ssh and http/s

```
sudo ufw default deny
sudo ufw allow 2222
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

```
sudo ufw status
```
https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-14-04
https://wiki.archlinux.org/index.php/Uncomplicated_Firewall

###
* Disable SSH pasword login
* Change SSH port
* Prepare the list of packages installed
* Remove unwanted software/packages
* Disable Unwanted users

* Use SELinux if you are expert in SELinux
* Close unused ports
* Setup VPN if possible, for communication between your dev PC and server
* Set proper file permissions
* Run audits and verfiy preiodicaly (port, service and files)
* Sandbox services (using docker, chroot, etc.)
* Harden PHP (if used)

### Tools and Software

There are the some of the tools and software to automate the security

* [fail2ban](http://www.fail2ban.org)
* [lynis](https://cisofy.com/lynis/)
* [heatsheild](https://heatshield.io)

https://www.linode.com/docs/security/using-fail2ban-for-security
https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04
### Use Secure Password

A good password should have

* At Least 8 Characters Long — (longer is better).
* Upper Case Letters
* Lower Case Letters
* Numbers
* Special characters

> The best password in the world does little good if you cannot remember it

use acronyms or other mnemonic devices to aid in memorizing passwords.

Also enforce Password Aging (using ```chage -M 90 <username>```)



### Securing Ports

Make sure there is no service runs without your knowledge. It is a must to audit the network ports which are open/used, and ensure it’s listening on the correct network port.

You can use ```netstat``` command to list down the services and its associated ports used

```
$ sudo netstat -plnt
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      16772/nginx -g daem
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1400/sshd
tcp6       0      0 :::80                   :::*                    LISTEN      16772/nginx -g daem
tcp6       0      0 :::22                   :::*                    LISTEN      1400/sshd
```

Another command to use is ```lsof```, this command will list previliage of a port

```
$ sudo lsof -i TCP| fgrep LISTEN
sshd     1400     root    3u  IPv4  13851      0t0  TCP *:ssh (LISTEN)
sshd     1400     root    4u  IPv6  13941      0t0  TCP *:ssh (LISTEN)
nginx   16772     root    6u  IPv4 262165      0t0  TCP *:http (LISTEN)
nginx   16772     root    7u  IPv6 262166      0t0  TCP *:http (LISTEN)
nginx   16773 www-data    6u  IPv4 262165      0t0  TCP *:http (LISTEN)
nginx   16773 www-data    7u  IPv6 262166      0t0  TCP *:http (LISTEN)
```

### Application securing

* Password cracking
* URL manipulation through HTTP GET methods
* SQL Injection
* Cross Site Scripting (XSS)

### nginx
http://askubuntu.com/questions/443775/nginx-failing-to-reload-how-to-track-down-why
http://stackoverflow.com/questions/18587638/how-do-i-restart-nginx-only-after-the-config-test-was-successful-on-ubuntu
https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-14-04-lts
https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-14-04
https://www.digitalocean.com/community/tutorials/how-to-add-the-gzip-module-to-nginx-on-ubuntu-14-04
http://blog.ansals.me/2015/12/22/setting-expires-header-in-nginx/
https://www.digitalocean.com/community/tutorials/how-to-implement-browser-caching-with-nginx-s-header-module-on-ubuntu-16-04
http://kbeezie.com/nginx-configuration-examples/
### Reference

* https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/3/html/Security_Guide/index.html
* https://support.rackspace.com/how-to/basic-cloud-server-security/
* http://serverfault.com/questions/214242/can-i-hide-all-server-os-info
* https://suhosin.org/stories/index.html
* https://en.wikipedia.org/wiki/Penetration_test
* https://rudd-o.com/linux-and-free-software/a-better-way-to-block-brute-force-attacks-on-your-ssh-server
* https://www.rackaid.com/blog/how-to-block-ssh-brute-force-attacks/
* https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-12-04
* https://www.rackaid.com/blog/how-to-harden-or-secure-ssh-for-improved-security/
* https://www.digitalocean.com/help/getting-started/setting-up-your-server/
* https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-16-04
* https://www.digitalocean.com/community/tutorial_series/new-ubuntu-14-04-server-checklist
* https://www.ubuntu.com/server
* http://www.fail2ban.org/wiki/index.php/MANUAL_0_8
