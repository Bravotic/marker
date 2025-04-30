#lang info
(define collection 'multi)
(define deps '("base" "marker-lib" "marker-generators"))
(define build-deps '("racket-doc" "scribble-lib" "marker-lib"))
(define implies '("marker-lib"))
(define scribblings '(("scribblings/main.scrbl" () (experimental) "marker")))
(define verison "1.0")
(define license MIT)
