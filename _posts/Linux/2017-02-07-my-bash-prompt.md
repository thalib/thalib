---
layout: post
title:  "My bash prompt"
date:   2017-02-07 12:32:38
categories: Linux
tags: tip bash prompt linux commandline
---

I used below entry in ~/.bashrc file 

```
PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u @ \h\[\033[0;36m\]\[\e[1;91m\]$(__git_ps1)\[\033[0;32m\] \[\033[0;36m\][\w]\n\[\033[0;32m\] └─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '
```

The output is simiplar to below, inside the bracket is the branch name and followed by the current path.
```
mohamed @ turnip (master) [~/project/vagrant]
 └─ $ ▶
```
