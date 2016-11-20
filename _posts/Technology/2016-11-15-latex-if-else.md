---
layout: post
title:  "How to use if else in latex"
date:   2016-11-15 20:26:47
categories: Latex
tags: tex latex miktex
excerpt: How to use if else in latex
---

[Latex](https://en.wikibooks.org/wiki/LaTeX/Basics) does not offer if/else, but Tex offer the ability to have conditional if/else statements, Here is a small snippet how to use it.

```
\documentclass[a4paper,11pt]{article}

\def \UserName {Mohamed Thalib H}

\begin{document}

\ifx\UserName\undefined
	\textcolor{red}{UNKNOWN LAND OWNER}
\else
	\UserName
\fi

\end{document}
```


#### Reference

* https://en.wikibooks.org/wiki/TeX/def
* http://tex.stackexchange.com/questions/655/what-is-the-difference-between-def-and-newcommand
