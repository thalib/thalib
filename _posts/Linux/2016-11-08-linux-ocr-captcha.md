---
layout: post
title:  "How To decode captcha using tesseract and convert"
date:   2016-11-08 07:05:21
categories: Linux
tags: ocr tesseract captcha decode
excerpt: How To decode captcha using tesseract and convert
---

With three simple  steps the captcha can be decoded, based on this simple command you can write scripts to automate the captcha and by pass the security of any websites.

Conver the captcha to a grayscale image, using grayscale image will improve accurancy when compared to color images.

```
$ convert Captcha.gif -colorspace Gray gray100.png
```

Feed the grayscale image to tesseract ocr, for converting the image to text.

```
$ tesseract gray100.png text
Tesseract Open Source OCR Engine v3.03 with Leptonica
```

On success, above command will create a file named text.txt with text content.

```
$ cat text.txt
87384e
```
