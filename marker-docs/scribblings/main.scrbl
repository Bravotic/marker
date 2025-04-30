#lang scribble/manual

@(require scribble/example
          (for-syntax racket/base)
          (for-label racket))

@title{Marker: A language for links}
@author["Collin McKinley"]

@defmodulelang[marker
               #:packages ("marker")]

Marker is a programming language designed to make representing collections of
links easier than ever. Think something like a bookmarks bar in your browser or
a linktree link. Marker allows this collection of links to be read and
interpreted as Racket data, thus enabling all sorts of interesting operations on
them. The main use of Marker is to provide a common format to which other
formats can be easily compiled. This document will walk you through the basics
of writing Marker documents and compiling them to a few common formats.

@section{Marker Quick Reference}

Marker is a very small programming language. That being said, it features pretty
much all the functionality you'd need in its rather small domain. The following
is a comprehensive list of all the functionality present in Marker:

@subsection{Defining a bookmark}

@defform[#:id _
         #:literals [<String>]
         (name url)
         #:grammar
         [(name <String>)
          (url <String>)]
         ]{Defines a bookmark with a given name which points to a given URL.}

The following are examples of bookmarks being defined in Marker:

@codeblock|{
            #lang marker
            ("Google" "https://google.com")
            ("Racket" "https://racket-lang.org")
            ("Blank Page" "about:blank")
            }|

@subsection{Defining a folder}

@defform[#:id _
         #:literals [<String> <Marker-Entry>]
         [name
          entries ...]
         #:grammar
         [(name <String>)
          (entries <Marker-Entry>)]
         ]{Defines a folder with the given name containing the given entries.}

The following are examples of folders being defined in Marker:

@codeblock|{
            #lang marker
            ["Search"
             ("Google" "https://google.com")
             ("Bing" "https://bing.com")]
            
            ["Read"
             ("Wikipedia" "https://wikipedia.org")
             ("Project Gutenberg" "https://gutenberg.org")]
            
            ["Folder"
             ["In a Folder"
              ["In Another Folder"
               ("Hello" "about:blank")]]]
            }|

@subsection{Requiring other files}

@defform[#:id _
         #:literals [require <String>]
         (require path-to-other-file)
         #:grammar
         [(path-to-other-file <String>)]
         ]{Requires in the file at the given path string and places its contents
                    in the current entry.}

This works almost exactly as it does in base Racket or any other programming
language where you can import external libraries. The following illustrates how
require works:

@codeblock|{
            #lang marker
            ;; In file: require.mrkr
            ("Required Bookmark" "about:blank")
            }|

@codeblock|{
            #lang marker
            ;; In file: main.mrkr
            (require "require.mrkr")

            ["Folder"
             (require "require.mrkr")]
            }|

Becomes after requiring:

@codeblock|{
            #lang marker

            ("Required Bookmark" "about:blank")

            ["Folder"
             ("Required Bookmark" "about:blank")]
            }|

@subsection{Comments}

Like in Racket, the following comments are valid in Marker:

@codeblock|{
            #lang marker
            ; Single line comment

            #|
            multi
            line
            comment
            |#

            #;(comment
             the
             whole
             s-expression)

            }|

@section{Compiling Marker to Other Formats}

The power of Marker comes from its ability to easily compile into many other
formats. There are three generators currently provided with the base install of
Marker:

@itemlist[
           @item{Plain text - Folders and Links are represented with plain text.}

           @item{HTML - Folders and Links are represented as hyperlinks on a webpage.}

           @item{Netscape - Folders and Links are represented as bookmarks, suitable for
                          import into Firefox or Chrome}]

Marker generators are typically installed as raco commands. This means to run
any generator, you usually use a command like "raco marker-format [file]" which
will take the given Marker file and convert it into the format.

If you are interested in writing a custom generator, please see the
documentation for marker-lib, which discusses more if the inner workings of
Marker.

@subsection{Compiling Marker to Plain Text}

To compile Marker to plain text, simply use the "marker-text" raco command. The
following is an example of converting a Marker document into plain text.

@codeblock|{
            #lang marker
            ;; In file: example.mrkr

            ("Marker" "https://github.com/bravotic/marker")
            ("Google" "https://google.com")
            ["Racket"
             ("Website" "https://racket-lang.org")
             ("Docs" "https://docs.racket-lang.org")]
            }|

After running the following command...

@codeblock|{
            $ raco marker-text example.mrkr
            }|

the Marker document is compiled to:

@codeblock|{
Marker: https://github.com/bravotic/marker
Google: https://google.com
Racket:
| Website: https://racket-lang.org
| Docs: https://docs.racket-lang.org
            }|

@subsection{Compiling Marker to HTML}

Like plain text, the command "marker-html" can be used to compile Marker to
a basic HTML webpage. The following is an example of a Marker document being
compiled to HTML:

@codeblock|{
            #lang marker
            ;; In file: example.mrkr

            ("Marker" "https://github.com/bravotic/marker")
            ("Google" "https://google.com")
            ["Racket"
             ("Website" "https://racket-lang.org")
             ("Docs" "https://docs.racket-lang.org")]
            }|

After running the following command...

@codeblock|{
            $ raco marker-html example.mrkr
            }|

the Marker document is compiled to:

@codeblock|{
<html>
<body>
<h1>Bookmarks</h1>
<li><a href="https://github.com/bravotic/marker"><img height=16 width=16 src="https://github.com/favicon.ico">Marker</a></li>
<li><a href="https://google.com"><img height=16 width=16 src="https://google.com/favicon.ico">Google</a></li>
<h2>Racket</h2>
<ul style="border-left: 2px dashed black;"><li><a href="https://racket-lang.org"><img height=16 width=16 src="https://racket-lang.org/favicon.ico">Website</a></li>
<li><a href="https://docs.racket-lang.org"><img height=16 width=16 src="https://docs.racket-lang.org/favicon.ico">Docs</a></li>
</ul>
</body>
</html>
            }|


@subsection{Compiling Marker to Netscape Bookmarks}

The Netscape bookmark format is the HTML based format both Firefox and Chrome
use to store and export bookmarks. Marker can export to this format which makes
it easy to import into any modern browser. To compile to this format, we follow
the same steps as both plain text or HTML, except this time using the command
"marker-netscape" as follows:

@codeblock|{
            #lang marker
            ;; In file: example.mrkr

            ("Marker" "https://github.com/bravotic/marker")
            ("Google" "https://google.com")
            ["Racket"
             ("Website" "https://racket-lang.org")
             ("Docs" "https://docs.racket-lang.org")]
            }|

After running the following command...

@codeblock|{
            $ raco marker-html example.mrkr
            }|

the Marker document is compiled to:

@codeblock|{
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
    <DT><A HREF="https://github.com/bravotic/marker" ADD_DATE="0" LAST_MODIFIED="0">Marker</A>
    <DT><A HREF="https://google.com" ADD_DATE="0" LAST_MODIFIED="0">Google</A>
    <DT><H3 ADD_DATE="0" LAST_MODIFIED="0">Racket</H3>
    <DL><p>
        <DT><A HREF="https://racket-lang.org" ADD_DATE="0" LAST_MODIFIED="0">Website</A>
        <DT><A HREF="https://docs.racket-lang.org" ADD_DATE="0" LAST_MODIFIED="0">Docs</A>
    </DL><p>
</DL><p>
            }|
