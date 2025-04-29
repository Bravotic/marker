#lang racket

(require (for-syntax syntax/parse))
(require marker/base marker/compiler)

;; Entry point for a marker program when run or required in. Effectively compiles the entries to a variable named 'page'
;; which is exported.
(define-syntax (marker:#%module-begin stx)
  (syntax-parse stx
    [(_ entries ...)
     #`(#%module-begin
        (define page (compile-entry entries ...))
        (provide page))]))
 
(module reader syntax/module-reader
  marker)

(provide (rename-out
          [marker:#%module-begin #%module-begin])
         #%datum
         #%top)
