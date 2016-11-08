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

### Refernce

* http://stackoverflow.com/questions/32473095/image-to-text-recognition-using-tesseract-ocr-is-better-when-image-is-preprocess
* https://www.win.tue.nl/~aeb/linux/ocr/tesseract.html
* https://williamjturkel.net/2013/07/06/doing-ocr-using-command-line-tools-in-linux/
* https://misteroleg.wordpress.com/2012/12/19/ocr-using-tesseract-and-imagemagick-as-pre-processing-task/
* https://webscraping.com/blog/Solving-CAPTCHA/
* https://gist.github.com/chroman/5679049
* https://www.sitepoint.com/ocr-in-php-read-text-from-images-with-tesseract/
* http://resources.infosecinstitute.com/case-study-cracking-online-banking-captcha-login-using-python/
