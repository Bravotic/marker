#lang racket

;;; This is a set of functions to create an HTML document reflecting your marker document. The generated page indents
;;; links based on folder hierarchy and includes favicon images next to links.

(require marker/base)
(require net/url-string)

;; Gets the favicon URL for a given URL. This involves getting the base URL and adding /favicon.ico to the end.
;; (get-favicon-url : (String -> String))
(define (get-favicon-url url-string)
  (url->string (combine-url/relative (string->url url-string) "/favicon.ico")))

;; Compiles a bookmark entry to its corresponding HTML representation.
;; (bookmark->html : (MarkerEntry -> String))
(define (bookmark->html entry)
  (format "<li><a href=\"~a\"><img height=16 width=16 src=\"~a\">~a</a></li>\n"
          (bookmark-url entry)
          (get-favicon-url (bookmark-url entry))
          (bookmark-name entry)))

;; Compiles a folder entry to its corresponding HTML representation.
;; (folder->html : (MarkerEntry -> String))
(define (folder->html entry)
  (format "<h2>~a</h2>\n<ul style=\"border-left: 2px dashed black;\">~a</ul>\n"
          (folder-name entry)
          (entry->html (folder-contents entry))))

;; Compiles a marker entry to its corresponding HTML representation.
;; (entry->html : (MarkerEntry -> String))
(define (entry->html entry)
  (cond
    [(cons? entry)
     (string-append (entry->html (first entry)) (entry->html (rest entry)))]
    [(bookmark? entry)
     (bookmark->html entry)]
    [(folder? entry)
     (folder->html entry)]
    [else
     ""]))

;; Compiles a marker document into HTML. This is the entry point which should be used.
;; (marker->html : (MarkerEntry -> String))
(define (marker->html entry)
  (format "<html>\n<body>\n<h1>Bookmarks</h1>\n~a</body>\n</html>\n"
          (entry->html entry)))

(provide marker->html)
