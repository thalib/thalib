---
layout: post
title:  "Secure Server 0"
date:   2017-01-12 11:15:07
categories: General
tags:
excerpt: Secure Server 0
---


```
$ nmap -A craftjewels.in

Starting Nmap 6.40 ( http://nmap.org ) at 2017-01-12 11:15 IST
Nmap scan report for craftjewels.in (139.59.41.69)
Host is up (0.011s latency).
Not shown: 992 filtered ports
PORT     STATE  SERVICE     VERSION
80/tcp   open   http        nginx 1.10.0 (Ubuntu)
|_http-generator: Hugo 0.18.1
|_http-methods: No Allow or Public header in OPTIONS response (status code 405)
|_http-title:  CraftJewels.in
113/tcp  closed ident
443/tcp  open   tcpwrapped
2000/tcp open   cisco-sccp?
2222/tcp open   ssh         (protocol 2.0)
|_ssh-hostkey: ERROR: Script execution failed (use -d to debug)
5060/tcp open   sip?
8008/tcp open   http?
|_http-methods: No Allow or Public header in OPTIONS response (status code 302)
|_http-title: Did not follow redirect to https://craftjewels.in:8010/
8010/tcp open   xmpp?
2 services unrecognized despite returning data. If you know the service/version, please submit the following fingerprints at http://www.insecure.org/cgi-bin/servicefp-submit.cgi :
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port2222-TCP:V=6.40%I=7%D=1/12%Time=587717F4%P=x86_64-pc-linux-gnu%r(NU
SF:LL,29,"SSH-2\.0-OpenSSH_7\.2p2\x20Ubuntu-4ubuntu2\.1\r\n");
==============NEXT SERVICE FINGERPRINT (SUBMIT INDIVIDUALLY)==============
SF-Port8008-TCP:V=6.40%I=7%D=1/12%Time=587717F4%P=x86_64-pc-linux-gnu%r(Ge
SF:tRequest,43,"HTTP/1\.1\x20302\x20Found\r\nLocation:\x20https://:8010/\r
SF:\nConnection:\x20close\r\n\r\n")%r(FourOhFourRequest,66,"HTTP/1\.1\x203
SF:02\x20Found\r\nLocation:\x20https://:8010/nice%20ports%2C/Tri%6Eity\.tx
SF:t%2ebak\r\nConnection:\x20close\r\n\r\n")%r(GenericLines,42,"HTTP/1\.1\
SF:x20302\x20Found\r\nLocation:\x20https://:8010\r\nConnection:\x20close\r
SF:\n\r\n")%r(HTTPOptions,42,"HTTP/1\.1\x20302\x20Found\r\nLocation:\x20ht
SF:tps://:8010\r\nConnection:\x20close\r\n\r\n")%r(SIPOptions,42,"HTTP/1\.
SF:1\x20302\x20Found\r\nLocation:\x20https://:8010\r\nConnection:\x20close
SF:\r\n\r\n");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at http://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 172.73 seconds
```
### ssh d
https://support.microsoft.com/en-us/kb/298805
https://www.linode.com/docs/security/securing-your-server
https://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html
https://www.cyberciti.biz/faq/howto-ssh-server-hide-version-number-sshd_config/
https://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html
http://askubuntu.com/questions/2271/how-to-harden-an-ssh-server
https://debian-administration.org/article/87/Keeping_SSH_access_secure
https://wiki.archlinux.org/index.php/Port_knocking
https://github.com/pan0pt1c0n/knock-knock
https://www.digitalocean.com/community/tutorials/how-to-use-port-knocking-to-hide-your-ssh-daemon-from-attackers-on-ubuntu

### Nginx
https://geekflare.com/nginx-webserver-security-hardening-guide/
https://geekflare.com/remove-server-header-banner-nginx/
https://geekflare.com/add-x-frame-options-nginx/
https://geekflare.com/remove-server-header-banner-nginx/
https://geekflare.com/online-scan-website-security-vulnerabilities/
https://www.cyberciti.biz/tips/linux-unix-bsd-nginx-webserver-security.html
https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-on-ubuntu-14-04
### Apache

http://www.thegeekstuff.com/2011/03/apache-hardening

https://donjajo.com/modify-apache-servertokens-custom-value-using-mod_security-module/#.WHcXJbjGyCg
https://ubuntuforums.org/showthread.php?t=1278953
https://www.petefreitag.com/item/419.cfm
https://www.howtoforge.com/changing-apache-server-name-to-whatever-you-want-with-mod_security-on-debian-6
http://www.modsecurity.org
https://www.if-not-true-then-false.com/2009/howto-hide-and-modify-apache-server-information-serversignature-and-servertokens-and-hide-php-version-x-powered-by/

###

https://www.kali.org
https://linux-audit.com/linux-systems-guide-to-achieve-pci-dss-compliance-and-certification/
https://linux-audit.com/linux-systems-guide-to-achieve-pci-dss-compliance-and-certification/
