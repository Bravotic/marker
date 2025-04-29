#lang racket

;;; This is a collection of functions which enables you to generate a plain text output from a marker document. This is
;;; the default mode used if no generator is given to marker. 

(require marker/base)

;; Indents a given entry to a certain level to reflect the current link's hierarchy in folders.
;; (do-indent : (Number -> String))
(define (do-indent indent-level)
  (string-join (make-list indent-level "| ") ""))

;; Compiles a bookmark entry to its corresponding text representation.
;; (bookmark->text : (MarkerEntry Number -> String))
(define (bookmark->text entry indent-level)
  (format "~a~a: ~a\n"
          (do-indent indent-level)
          (bookmark-name entry)
          (bookmark-url entry)))

;; Compiles a folder entry to its corresponding text representation.
;; (folder->text : (MarkerEntry Number -> String))
(define (folder->text entry indent-level)
  (format "~a~a:\n~a"
          (do-indent indent-level)
          (folder-name entry)
          (entry->text (folder-contents entry) (add1 indent-level))))

;; Compiles a marker entry to its corresponding text representation.
;; (entry->text : (MarkerEntry Number -> String))
(define (entry->text entry indent-level)
  (cond
    [(cons? entry)
     (string-append (entry->text (first entry) indent-level) (entry->text (rest entry) indent-level))]
    [(bookmark? entry)
     (bookmark->text entry indent-level)]
    [(folder? entry)
     (folder->text entry indent-level)]
    [else
     ""]))

;; Compiles a marker document to text. This is the main entrypoint that should be used.
;; (marker->text : (MarkerEntry -> String))
(define (marker->text entry)
          (entry->text entry 0))

(module+ main
  (require raco/command-name)
  (match (current-command-line-arguments)
    [(or (vector "--help") (vector))
     (printf "Usage: raco ~a [Marker file]\n"
             (current-command-name))]
    [(vector file)
     (display (marker->text (dynamic-require file 'page)))]))

(provide marker->text)
