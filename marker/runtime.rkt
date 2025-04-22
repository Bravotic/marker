#lang racket

(require marker-generators-common/text)
(require marker-generators-common/html)
(require marker-generators-common/netscape)

;; Generate a document in the given format using the given Marker page as its content. This is placeholder for now until
;; I come up with a better solution which is more extensible.
(define (generate-page format page)
  (match format
    ["html" (marker->html page)]
    ["netscape" (marker->netscape page)]
    ["text" (marker->text page)]
    [else (raise-user-error 'generate-page "Generator ~s not supported" format)]))

;; Given the desired format, gets the expected file extension which that format should save in. Likewise this is
;; placeholder while I reconsider how this section should ideally work.
(define (get-format-extension format)
  (match format
    [(or "html" "netscape") "html"]
    ["text" "txt"]))

(provide generate-page)
