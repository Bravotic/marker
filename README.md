# Marker

Marker is a domain specific language designed to make managing collections of
links easier. It is designed to be easy to read and write, but also provide a
rich Racket interface, which in turn allows for other link collection formats to
be generated.

An exmple of marker can be seen below:

```racket
#lang s-exp marker
("Marker Github" "https://github.com/bravotic/marker")
("Marker project page" "https://bravotic.com/marker")
["Racket"
  ("Homepage" "https://racket-lang.org")
  ("Docs" "https://docs.racket-lang.org")]
```

From this, Marker can export to...

Plain text:

```
Marker Github: https://github.com/bravotic/marker
Marker project page: https://bravotic.com/marker
Racket:
| Homepage: https://racket-lang.org
| Docs: https://docs.racket-lang.org
```

HTML:

```html
<html>
<body>
<h1>Bookmarks</h1>
<li><a href="https://github.com/bravotic/marker"><img height=16 width=16 src="https://github.com/favicon.ico">Marker Github</a></li>
<li><a href="https://bravotic.com/marker"><img height=16 width=16 src="https://bravotic.com/favicon.ico">Marker project page</a></li>
<h2>Racket</h2>
<ul style="border-left: 2px dashed black;"><li><a href="https://racket-lang.org"><img height=16 width=16 src="https://racket-lang.org/favicon.ico">Homepage</a></li>
<li><a href="https://docs.racket-lang.org"><img height=16 width=16 src="https://docs.racket-lang.org/favicon.ico">Docs</a></li>
</ul>
</body>
</html>
```

Netscape Bookmarks Format:

```html
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
    <DT><A HREF="https://github.com/bravotic/marker" ADD_DATE="0" LAST_MODIFIED="0">Marker Github</A>
    <DT><A HREF="https://bravotic.com/marker" ADD_DATE="0" LAST_MODIFIED="0">Marker project page</A>
    <DT><H3 ADD_DATE="0" LAST_MODIFIED="0">Racket</H3>
    <DL><p>
        <DT><A HREF="https://racket-lang.org" ADD_DATE="0" LAST_MODIFIED="0">Homepage</A>
        <DT><A HREF="https://docs.racket-lang.org" ADD_DATE="0" LAST_MODIFIED="0">Docs</A>
    </DL><p>
</DL><p>
```

And many more to come!

---

## Installing Marker

Marker can be installed in two easy steps. First download
[Racket](https://racket-lang.org) for whatever system you are running, then run
the following command:

```shell
$ raco pkg install git://github.com/bravotic/marker
```

---

## Files and Directories

* `base.rkt` - Contains the definitions for the basic data structures Marker
  documents are compiled into. If you are writing a program which requires or
  otherwise uses Marker documents, requiring in `marker/base` should be all that
  is needed.

* `compiler.rkt` - Contains the main compiler implementation.

* `generators/` - Contains various generators for turning Marker abstract syntax
  into usable formats.

* `info.rkt` - Racket module info

* `main.rkt` - Contains the main runtime implementation. When a Marker document
  is run or required, this is the file that is executed.
