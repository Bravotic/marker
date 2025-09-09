#lang racket

(require (for-syntax syntax/parse))
(require "./base.rkt")

;;; A Marker file consists of multiple entries. Marker entries are as follows:
;;;
;;; entry    ::= <bookmark>
;;;            | <folder>
;;;            | (require [file-name : string])
;;;
;;; bookmark ::= ([name : string] [url : string])
;;;            | ([name : string] [description : string] [url : string])
;;;
;;; folder   ::= [[name : string] <entry> ...]

;; Compiles a marker entry to its corresponding data structure. This also resolves all (require) statements. Results in
;; a MarkerEntry data structure.
(define-syntax (compile-entry stx)
  (syntax-parse stx
    
    ; Marker entry is empty
    [(_)
     #''()]

    ; Entry is a <bookmark> with no description
    [(_ (name:string url:string) rest ...)
     #'(cons (bookmark name "" url) (compile-entry rest ...))]

    ; Entry is a <bookmark> with a description
    [(_ (name:string description:string url:string) rest ...)
     #'(cons (bookmark name description url) (compile-entry rest ...))]

    ; Entry is a require. We resolve it here.
    [(_ ((~datum require) path:string) rest ...)
     #'(cons (parameterize ([current-directory (path-only path)])
               (dynamic-require (file-name-from-path path) 'page))
             (compile-entry rest ...))]
    
    [(_ (name:string contents ...) rest ...)
     #'(cons (folder name (compile-entry contents ...)) (compile-entry rest ...))]))

(provide compile-entry)
