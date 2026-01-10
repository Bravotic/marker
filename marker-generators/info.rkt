#lang info
(define collection "marker-generators")
(define deps '("base" "marker-lib"))
(define raco-commands
  '(("marker-html" (submod marker-generators/html main) "Compile Marker to HTML" #f)
    ("marker-netscape" (submod marker-generators/netscape main) "Compile Marker to Netscape Bookmarks Format" #f)
    ("marker-text" (submod marker-generators/text main) "Compile Marker to plain text" #f)
    ("marker-json" (submod marker-generators/json main) "Compile Marker to JSON" #f)
    ("marker-lynx" (submod marker-generators/lynx main) "Compile Marker to the Lynx bookmark format" #f)))
(define verison "1.2")
(define license 'MIT)
