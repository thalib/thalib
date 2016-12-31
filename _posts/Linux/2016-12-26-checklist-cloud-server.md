---
layout: post
title:  "Check list to secure the cloud server"
date:   2016-12-26 12:14:44
categories: Linux
tags: security cloud server admin checklist
excerpt: Check list to secure the cloud server
---

Here are the important steps to secure the cloud server, a.k.a server hardening

* Update OS (```apt-get update && apt-get dist-upgrade```)
* Enable SSH Key Authentication
* Disable Root SSH login
* Disable SSH pasword login
* Change SSH port
* Prepare the list of packages installed
* Remove unwanted software/packages
* Disable Unwanted users
* Install Firewall (ufw)
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

### Secure Root User

* **Disable root user login**: edit ```/etc/passwd``` file and change the shell of root from ```/bin/bash``` to ```/sbin/nologin```.

* **Disabling root SSH logins**: edit the ```/etc/ssh/sshd_config``` file and set the ```PermitRootLogin``` parameter to ```no```.

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
