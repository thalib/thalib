---
layout: post
title:  "Go language Notes"
date:   2016-11-01 17:03:56
categories: Programming
tags: programming language go
excerpt: Notes on Go language
---

* [Go Spec](https://golang.org/ref/spec)
* [Go by examples](https://gobyexample.com)
* [Effective Go](https://golang.org/doc/effective_go.html)
*
## Installation and setup

GOPATH evnrioment variable tells the go tool suite, the location of source code and pkg, this can be changed as per need by user to point diffrent location.

In Linux OS, export command is used to setup GOPATH

Set current directory as GOPATH

```export GOPATH=$PWD```

**[or]**

Set specific direcotry

```export GOPATH=~/project/src```

For instruction on how to in Windows OS [link](http://www.wadewegner.com/2014/12/easy-go-programming-setup-for-windows/) to setup GOPATH

## go command

go is a complete toolsuite, it can be invoked using **go** command, for example to check the version of go use below command

```go version
go version go1.7 windows/amd64
```

there are plenty of more other sub-commands offered by go tool suite, to get list of all subcommands

```go help
```

## Start
Go language is a

Here is a classical Hello World program

```
package main

import "fmt"

func	main()	{
				fmt.Printf("Hello,	World!\n")
}
```

### Data

Go provides two type of data storage, const and var. As its name implies
* **const** are constants, thier values	are	determined	during	compile	time and	you	cannot	change	them	during	runtime.
* **var** are variables, whichs value can be changed in runtime.

The general syntax of defining a declaring a data in go is below

*For variables*

```
var	variableName	type
```

*For constants*

```
const	variableName	type
```

Define	multiple	variables.

```
var	vname1,	vname2,	vname3	type
```

Define	a	variable	with	initial	value.

```
var	variableName	type	=	value
```

Define	multiple	variables	with	initial	values.

```
var	vname1,	vname2,	vname3	type	=	v1,	v2,	v3
```
Use := to replace var and type, this is called a brief statement

```
vname1,	vname2,	vname3	:=	v1,	v2,	v3
```

**Note** brief statement can only be used inside of functions

Group defining

```
var i int
var pi float32
var prefix string
```

above can be deined as below

```
var(
  i int
  pi float32
  prefix string
)
```


Here

1. **varialbeName** - name of the variable defined by
* **type** - can be one from the below table

The date types are primarily classified as Boolean, Numeric (integer, float), String and Derived (types such as Pointer, Array, Structure, Union, Function, Slice, Function, Interface, Map, Channel)

* Boolean - bool
* Numeric integer - rune, int8, int16, int32, int64, byte, uint8, uint16, uint32, uint64. (rune is alias of int32 and byte is alias of uint8)
* Numeric float - float32 and float64
* Numeric complex - complex128 and complex64 (Its form is RE+IMi)
* string
* error
*

### _ special variable name

**_** (blank) is a special variable name. Any value that is given to it will be ignored.

```
_, b := 34, 35
```
Value 34 will be discared, and b will be assigned 35.
