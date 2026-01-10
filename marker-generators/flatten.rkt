#lang racket

;;; This is a Marker generator which is not designed to give a finished product,
;;; but is designed to help create marker generators for platforms which do not
;;; have a concept of a folder. This turns a list of bookmarks and folders into
;;; simply a list of bookmarks. In order to disambiguate bookmarks with the same
;;; name which reside in different folders, the name of the folder is prepended
;;; to the front of the bookmark name.

(require marker/base)
(require marker/generator)

; Creates a procedure which prepends the given folder-name to a bookmark's name.
(define (prepend-folder-name folder-name)
  (λ (bookmark-data)
    (match bookmark-data
      [(bookmark name description url)
       (bookmark (format "~a/~a" folder-name name) description url)]
      ['()
       '()])))

(define marker-flatten
  (marker-generator
   [folder
    (map (prepend-folder-name name) contents)]
   [bookmark
    (bookmark name description url)]
   [join
    (flatten contents)]))

(provide marker-flatten)
