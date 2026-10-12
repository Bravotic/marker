#lang info
(define collection "marker")
(define deps '("base" "marker-lib"))
(define build-deps '("base" "racket-doc" "scribble-lib" "marker-lib"))
(define scribblings '(("scribblings/main.scrbl" () (experimental) "marker")))
(define version "1.0")
(define license 'MIT)
