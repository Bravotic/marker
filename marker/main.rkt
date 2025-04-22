#lang racket

(require (for-syntax syntax/parse))
(require marker/base marker/compiler)

;; Generates a simple runner stub, allowing generators to be called by just running the Marker program. This will NOT
;; run if required from another file or program.
(define-for-syntax (make-generator-runtime page)
  #'(module+ main
      (require marker/runtime)
      (display
       (match (current-command-line-arguments)
         [(vector format) (generate-page format page)]
         [else (generate-page "text" page)]))))
      

;; Entry point for a marker program when run or required in. Effectively compiles the entries to a variable named 'page'
;; which is exported.
(define-syntax (marker:#%module-begin stx)
  (syntax-parse stx
    [(_ entries ...)
     #`(#%module-begin
        (define page (compile-entry entries ...))
        (provide page)
        #,(make-generator-runtime #'page))]))

;; Each time a query is given to the REPL, this is called. Since Marker doesn't really have a REPL to speak of, we use
;; this as a chance to ask the user for what format they want to export their page in. This is a workaround for now and
;; I eventually hope to change it.
(define-syntax (marker:#%top-interaction stx)
  (syntax-parse stx
    [(_ . format)
     (let [(format-string (symbol->string (syntax->datum #'format)))]
       #`(begin
           (require (submod "."))
           (require marker/repl)
           (repl-generate-page #,format-string page)))]))

(provide (rename-out
          [marker:#%module-begin #%module-begin]
          [marker:#%top-interaction #%top-interaction])
         #%datum
         #%top)
