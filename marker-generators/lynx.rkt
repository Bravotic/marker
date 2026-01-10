#lang racket

;;; This is designed to output a lynx_bookmark.html file for use with the Lynx
;;; browser. While this techinically could have been done by the existing
;;; marker-html generator, this will create a much more native Lynx bookmark
;;; file.

(require marker/base)
(require marker/generator)
(require marker-generators/flatten)

(define marker->lynx
  (marker-generator
   [folder
    (error 'marker->lynx "Lynx bookmarks expect a flattened Marker document")]
   [bookmark
    (if (non-empty-string? description)
        (format "<li><a href=\"~a\">~a - ~a</a></li>" url name description)
        (format "<li><a href=\"~a\">~a</a></li>" url name))]
   [join
    (string-join contents "\n")]))

(define header
  "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">

<html>
<head>
<META http-equiv=\"content-type\" content=\"text/html;charset=iso-8859-1\">
<title>Bookmark file</title>
</head>
<body>
<p>     You can delete links using the remove bookmark command.  It is usually
     the 'R' key but may have been remapped by you or your system
     administrator.<br>
     This file also may be edited with a standard text editor to delete
     outdated or invalid links, or to change their order.

<!--
Note: if you edit this file manually
      you should not change the format within the lines
      or add other HTML markup.
      Make sure any bookmark link is saved as a single line.
--></p>

<ol>
")

(module+ main
  (require raco/command-name)
  (match (current-command-line-arguments)
    [(or (vector "--help") (vector))
     (printf "Usage: raco ~a [Marker file]\n"
             (current-command-name))]
    [(vector file)
     (printf "~a\n~a"
             header
             (marker->lynx (marker-flatten (dynamic-require file 'page))))]))

(provide marker->lynx)
