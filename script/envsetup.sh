#!/bin/bash

POST_PATH=/home/mohamed/project/vagrant/thalib.github.io/_drafts
POST_DATE=`date +%Y-%m-%d`
POST_TIME=`date +%H:%M:%S`
POST_TITLE="---
layout: post
title:  \"Wonderfull article (CHANGE ME)\"
date:   $POST_DATE $POST_TIME
categories: General
tags:
excerpt: This post is all about XYZ (CHANGE ME)
---


"

function post-create() {
	POST_NAME=$POST_PATH/$POST_DATE-NEW-POST-CHANGE-MY-NAME-$RANDOM.md
	echo "$POST_TITLE" > $POST_NAME
	echo "Created $POST_NAME"
}

function post-cd() {
	cd $POST_PATH
}

function post-clean() {
	rm `find . | grep '~'`
}
