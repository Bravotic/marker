#lang racket

(require (for-syntax syntax/parse))
(require "./base.rkt" racket/stxparam)

(define-syntax-parameter name
  (lambda (stx)
    (raise-syntax-error #f "Only allowed inside marker-generator block" stx)))

(define-syntax-parameter contents
  (lambda (stx)
    (raise-syntax-error #f "Only allowed inside marker-generator block" stx)))

(define-syntax-parameter description
  (lambda (stx)
    (raise-syntax-error #f "Only allowed inside marker-generator block" stx)))

(define-syntax-parameter url
  (lambda (stx)
    (raise-syntax-error #f "Only allowed inside marker-generator block" stx)))

(define-syntax-parameter indent-level
  (lambda (stx)
    (raise-syntax-error #f "Only allowed inside marker-generator block" stx)))

(define-syntax-parameter path
  (lambda (stx)
    (raise-syntax-error #f "Only allowed inside marker-generator block" stx)))

(begin-for-syntax
  (define (make-data-transformer ref)
      (lambda (stx)
        (syntax-parse stx
          [_:id ref]))))

(define-syntax (marker-generator stx)
  (syntax-parse stx
    [(_ (~alt (~once ((~datum folder) . folder-body))
              (~once ((~datum join) . join-body))
              (~once ((~datum bookmark) . bookmark-body))) ...)
     #'(letrec [(generator
                  (lambda (indent-level-ref path-ref input)
                    (match input
                      [(folder name-ref contents-ref)
                       (syntax-parameterize ([name (make-data-transformer #'name-ref)]
                                             [contents (make-data-transformer #'(generator (+ indent-level-ref 1) (string-append path-ref name-ref "/") contents-ref))]
                                             [indent-level (make-data-transformer #'indent-level-ref)]
                                             [path (make-data-transformer #'path-ref)])
                         (begin . folder-body))]
                      [(bookmark name-ref description-ref url-ref)
                       (syntax-parameterize ([name (make-data-transformer #'name-ref)]
                                             [description (make-data-transformer #'description-ref)]
                                             [url (make-data-transformer #'url-ref)]
                                             [indent-level (make-data-transformer #'indent-level-ref)]
                                             [path (make-data-transformer #'path-ref)])
                         (begin . bookmark-body))]
                      [(? list? list-ref)
                       (syntax-parameterize ([contents (make-data-transformer #'(map (curry generator indent-level-ref path-ref) list-ref))])
                         (begin . join-body))]
                      )))]
                         
                (lambda (input)
                  (generator 0 "/" input)))]))

(provide marker-generator name description url contents indent-level path)