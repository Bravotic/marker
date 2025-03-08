#lang racket

;;; A MarkerEntry is defined as one of the following:
;;;
;;; MarkerEntry ::= (list [entries : MarkerEntry] ...)
;;;               | (bookmark [name : string] [url : string])
;;;               | (folder [name : string] [contents : MarkerEntry])

(struct bookmark [name url] #:transparent)
(struct folder [name contents] #:transparent)

(provide (struct-out bookmark) (struct-out folder))
