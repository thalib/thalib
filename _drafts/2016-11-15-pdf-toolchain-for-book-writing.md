---
layout: post
title:  "Wonderfull article (CHANGE ME)"
date:   2016-11-15 13:26:47
categories: General
tags:
excerpt: This post is all about XYZ (CHANGE ME)
---


### Markdown to PDF

```
for filename in *.md; do
  echo $filename
  pandoc --from=markdown+yaml_metadata_block -o pod/pdf/cards/"$(basename "$filename" .md)".pdf --latex-engine=xelatex $filename
done
```

### Create a pdf file

```
pdfjam *.pdf --outfile out.pdf
```

### Create a single file from PDFS

```
pdfjam *.pdf --no-landscape --frame true --nup 3x3 --suffix complete --outfile out.pdf
```

## Reference
https://github.com/GregariousMammal/Chip-Shop/
https://www.sitepoint.com/creating-pdfs-from-markdown-with-pandoc-and-latex/
https://en.wikibooks.org/wiki/LaTeX/Package_Reference
https://www.sharelatex.com/learn
http://www.latex-project.org/help/books/
http://yihui.name/knitr/demo/pandoc/
http://jonmifsud.com/blog/writing-in-markdown-and-converting-markdown-to-pdf/
https://www.maketecheasier.com/use-pandoc-convert-text-to-ebook/
https://toolchain.gitbook.com/setup.html

http://www.methods.co.nz/asciidoc/userguide.html
http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/#images

### Source highlighting

https://github.com/gpoore/minted
http://pygments.org
http://www.ctan.org/tex-archive/macros/latex/contrib/minted/
