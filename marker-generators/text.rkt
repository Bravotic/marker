#lang racket

;;; This is a collection of functions which enables you to generate a plain text output from a marker document. This is
;;; the default mode used if no generator is given to marker. 

(require marker/base)
(require marker/generator)

(define (indent-string-with first-indent rest-indent string)
  (let [(parts (string-split string "\n"))]
    (string-join (cons (string-append first-indent (car parts))
          (map (lambda (x) (string-append rest-indent x)) (cdr parts))) "\n")))

(define (do-indent-to-contents contents)
  (match contents
    [(cons last '())
     (cons (indent-string-with "└ " "  " last) '())]
    [(cons first rest)
     (cons (indent-string-with "├ " "│ " first) (do-indent-to-contents rest))]
    ['()
     ""]))

(define marker->text
  (marker-generator
   [folder
    (format "~a:\n~a" name contents)]
   [bookmark
    (if (non-empty-string? description)
        (format "~a - ~a: ~a" name description url)
        (format "~a: ~a" name url))]
   [join
    (string-join (do-indent-to-contents contents) "\n")]))

(module+ main
  (require raco/command-name)
  (match (current-command-line-arguments)
    [(or (vector "--help") (vector))
     (printf "Usage: raco ~a [Marker file]\n"
             (current-command-name))]
    [(vector file)
     (displayln "Bookmarks")
     (displayln (marker->text (dynamic-require file 'page)))]))

(provide marker->text)
