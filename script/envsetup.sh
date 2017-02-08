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
---


"

function post-new() {
	POST_NAME=$POST_PATH/$POST_DATE-NEW-POST-$RANDOM.md
	echo "$POST_TITLE" > $POST_NAME
	echo "Created $POST_NAME"
}

function post-cd() {
	cd $POST_PATH
}

function post-clean() {
	find . -iname "*~" -print | xargs rm -vf
}

function post-update() {
	git commit -a -s -m "Updated"
	git push origin master
}

function post-sync() {
	git pull origin master
}
