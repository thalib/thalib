
---
layout: post
title:  "How To create a image from commandline in Linux"
date:   2016-10-31 12:45:32
tags: linux commandline
---

Linux provides an **convert** command to add any text on an image. In order to use this command you need to install ImageMagick package on your system.

To create a image with a white background:

```
convert -size 640x480 xc:white empty.jpg
```
Here the size of the imge is specified using **-size**

To create a 32x32 image with a transparent background:

```
convert -size 32x32 xc:transparent empty.jpg
```
### Add Text to image

```
convert -pointsize 20 -fill blue -draw 'text 200,460 "Here is the TEXT"' empty.jpg image-with-text.jpg
```

In this command

* **text 200,460** is used to spefiy the exact location of text in the image
* **-fill blue** tell the text color

### Generate a dummy Image with Text

The command parameters are changed to generate a image with text itself

```
convert -size 640x480 xc:white -pointsize 20 -fill black -draw 'text 200,460 "Here is the TEXT"' image-with-text.jpg
```

* **-size 640x480** tells the image size to be generated
* **xc:white** or **-background white** can be used to tell the image background color


Alternate method to create a dummy image 

```
convert -size 640x480 xc:White \
  -gravity Center \
  -weight 100 -pointsize 80 \
  -annotate 0 "This\nIs\na Image" \
  out.png
```

* **-font helvetica** can be used to tell the font type

### Refernce

* [imagemagick.org](http://www.imagemagick.org/Usage/canvas/#solid)
