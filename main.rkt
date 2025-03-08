#lang racket

(require (for-syntax syntax/parse))
(require marker/base marker/compiler)

;; Generates a simple runner stub, allowing generators to be called by just running the Marker program. This will NOT
;; run if required from another file or program.
(define-for-syntax (make-generator-runtime page)
  #'(module+ main
      (require marker/generators/text)
      (require marker/generators/html)
      (require marker/generators/netscape)
      (display
       (match (current-command-line-arguments)
         [(vector "html") (marker->html page)]
         [(vector "netscape") (marker->netscape page)]
         [else (marker->text page)]))))

;; Entry point for a marker program when run or required in. Effectively compiles the entries to a variable named 'page'
;; which is exported.
(define-syntax (marker:#%module-begin stx)
  (syntax-parse stx
    [(_ entries ...)
       #`(#%module-begin
          (define page (compile-entry entries ...))
          (provide page)
          #,(make-generator-runtime #'page))]))

(provide (rename-out
          [marker:#%module-begin #%module-begin])
         #%datum)
