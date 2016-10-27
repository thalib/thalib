#!/bin/bash

POST_PATH=/home/mohamed/project/diy/thalib.io/thalib.github.io/_posts
POST_DATE=`date +%Y-%m-%d`
POST_TIME=`date +%H:%M:%S`
POST_TITLE="
---
layout: post
title:  \"Wonderfull article\"
date:   $POST_DATE $POST_TIME
categories: General
tags: 
excerpt: This post is all about XYZ
---


"
POST_NAME=$POST_PATH/$POST_DATE-article-$RANDOM.md

function post-create() {
	echo "$POST_TITLE" > $POST_NAME
	echo "Created $POST_NAME"
}

function post-cd() {
	cd $POST_PATH
}
