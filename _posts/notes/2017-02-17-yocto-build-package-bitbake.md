---
layout: post
title:  "Yocto - building a package with bitbake"
date:   2017-02-17 14:46:19
categories: Linux
tags: bitbake yocto
---

To build a package in yacto that command is simple

```
bitbake foo
```

* **foo** - name of the package without any extension or version number.

To clean a package from tmp dir,

```
bitbake -c clean foo
```

It is very useful if you work on a new .bb recipe. Without it your changes to the recipe may not work.

During development there will be times when you need to execte only certain task in the package building steps. Using below command you can list tasks for building a package.

```
bitbake -c listtasks foo
```

Here is a sample output of ```bitbake -c listtasks bluez5``` for bluez5 package

```
$ bitbake -c listtasks bluez5
....
....
....
bluez5-5.37-r0 do_listtasks: do_clean                       Removes all output files for a target
bluez5-5.37-r0 do_listtasks: do_cleanall                    Removes all output files, shared state cache, and downloaded source files for a target
bluez5-5.37-r0 do_listtasks: do_cleansstate                 Removes all output files and shared state cache for a target
bluez5-5.37-r0 do_listtasks: do_compile                     Compiles the source in the compilation directory
bluez5-5.37-r0 do_listtasks: do_compile_ptest_base          Compiles the runtime test suite included in the software being built
bluez5-5.37-r0 do_listtasks: do_configure                   Configures the source by enabling and disabling any build-time and configuration options for the software being built
bluez5-5.37-r0 do_listtasks: do_configure_ptest_base        Configures the runtime test suite included in the software being built
bluez5-5.37-r0 do_listtasks: do_devpyshell                  Starts an interactive Python shell for development/debugging
bluez5-5.37-r0 do_listtasks: do_devshell                    Starts a shell with the environment set up for development/debugging
bluez5-5.37-r0 do_listtasks: do_fetch                       Fetches the source code
....
....
....
```

Above lists all task for given package, you can run any one of the task as needed.

For example state do_compile can be executed to compile the source

```
bluez5-5.37-r0 do_listtasks: do_compile                     Compiles the source in the compilation directory

```

remove **do_** from do_compile and use it in command

```
bitbake -f -c compile foo
```

like wise you can run do_fetch to download the source code of a package

```
bitbake -f -c fetch foo
```

[or] execute do_devshell for starting a shell with the environment set up for development/debugging

```
bitbake -f -c devshell foo
```

there are many more options, try playing with.
