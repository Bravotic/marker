#lang info
(define collection "marker-generators")
(define deps '("base" "marker-lib"))
(define raco-commands
  '(("marker-html" (submod marker-generators/html main) "Compile Marker to HTML" #f)
    ("marker-netscape" (submod marker-generators/netscape main) "Compile Marker to Netscape Bookmarks Format" #f)
    ("marker-text" (submod marker-generators/text main) "Compile Marker to plain text" #f)))
(define verison "1.0")
(define license 'MIT)
