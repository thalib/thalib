---
layout: post
title:  "Git best practices"
date:   2016-12-26 12:14:44
categories: Linux
tags: git
excerpt: Git best practices
---

### DON'T: Avoid tracking large files in your repo

Avoid putting large files into your repository: binaries, media files, archived artifacts, etc.

This is because once you add a file, it will always be there in the repo’s history, which means every time the repo is cloned, that huge heavy file will be cloned along with it.

### DO: Use shallow clones

By default Git clones the repos entire history, this takes longer and longer. If you don't need all history then use shallow clone ```--depth 1``` .

```
git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
```

If you know anything new, let me know it in the comment. 
