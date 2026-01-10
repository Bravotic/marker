#lang racket

;;; This allows you to compile a Marker file into a JSON file with effectively
;;; the same notation. It is as follows:
;;;
;;; stm ::= bookmark | folder
;;; bookmark ::= { "name" : String, "description" : String, "url" : String }
;;; folder ::= { "name" : String, "contents" : Array of stm }

(require marker/base)
(require marker/generator)

(define marker->json
  (marker-generator
   [folder
    (format "{\"name\":\"~a\",\"contents\":[~a]}" name contents)]
   [bookmark
    (format "{\"name\":\"~a\",\"description\":\"~a\",\"url\":\"~a\"}"
            name description url)]
   [join
    (string-join contents ",")]))

(module+ main
  (require raco/command-name)
  (match (current-command-line-arguments)
    [(or (vector "--help") (vector))
     (printf "Usage: raco ~a [Marker file]\n"
             (current-command-name))]
    [(vector file)
     (printf "[~a]\n" (marker->json (dynamic-require file 'page)))]))

(provide marker->json)
