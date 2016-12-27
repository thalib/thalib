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

Refrences from

https://cisofy.com/lynis/

* [Basic Ubuntu Setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-14-04)
* [Enable SSH](https://www.digitalocean.com/community/tutorials/7-security-measures-to-protect-your-servers)
* [UFW](https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server)
* [UFW Rules](https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands)
* [Install nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-14-04-lts)
* [Host name](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-host-name-with-digitalocean)
* Git deploy from [github](https://www.sitepoint.com/deploying-from-github-to-a-server/), [bitbucket](https://support.deployhq.com/articles/deployments/how-do-i-start-an-automatic-deployment-from-bitbucket)
* [php setup](https://www.digitalocean.com/community/tutorials/how-to-host-multiple-websites-securely-with-nginx-and-php-fpm-on-ubuntu-14-04)
* [lemp setup](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04)

https://bitbucket.org/atlassianlabs/webhook-listener/src
https://bitbucket.org/lilliputten/automatic-bitbucket-deploy/
http://www.bluehost.in/devcloud?chan=ga_se_devcloud_do&ad=ga_se_devcloud_do&cmp=Comp_DevCloud_DO(S)&kw=Digitalocean&mt=e&adg=Digital_Ocean_-Gen&adid=165279959252&coupon=&a_aid=8a10h1801b&gclid=COWA2c6kkdECFdWKaAodss8K5g

https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
https://www.atlassian.com/continuous-delivery/git-hooks-continuous-integration
http://brandonsummers.name/blog/2012/02/10/using-bitbucket-for-automated-deployments/
https://www.sitepoint.com/deploying-from-github-to-a-server/
