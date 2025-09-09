#lang racket

;;; This is a set of functions allowing for Marker programs to be exported to the Netscape bookmark format. This is the
;;; bookmark format used by browsers like Firefox, Chrome, and Edge. While the resulting file type is HTML, it isn't
;;; very nice to read. If you want a pretty HTML output, use the 'html' or 'pretty-html' generators.
;;;
;;; Information about the Netscape bookmark spec can be found here:
;;; https://learn.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa753582(v=vs.85)?redirectedfrom=MSDN

(require marker/base)

;; Creates a string containing whitespace to simulate different indention levels. I'm not positive if this is required
;; as part of the Netscape bookmark spec (its very ambiguous, and no formal spec exists).
;; (do-indent : (Number -> String))
(define (do-indent indent-level)
  (string-join (make-list indent-level "    ") ""))

;; Compiles a bookmark entry into its corresponding Netscape bookmark entry.
;; (bookmark->netscape : (MarkerEntry Number -> String))
(define (bookmark->netscape entry indent-level)
  (match entry
    [(bookmark title description url)
     #:when (non-empty-string? description)
     (format "~a<DT><A HREF=\"~a\" ADD_DATE=\"0\" LAST_MODIFIED=\"0\">~a</A>\n~a<DD>~a\n"
             (do-indent indent-level)
             url
             title
             (do-indent indent-level)
             description)]
    [(bookmark title _ url)
     (format "~a<DT><A HREF=\"~a\" ADD_DATE=\"0\" LAST_MODIFIED=\"0\">~a</A>\n"
             (do-indent indent-level)
             url
             title)]))

;; Compiles a folder entry into its corresponding Netscape bookmark folder. For all entries within the folder, the
;; current indentation level is increased by 1.
;; (folder->netscape : (MarkerEntry Number -> String))
(define (folder->netscape entry indent-level)
  (format "~a<DT><H3 ADD_DATE=\"0\" LAST_MODIFIED=\"0\">~a</H3>\n~a<DL><p>\n~a~a</DL><p>\n"
          (do-indent indent-level)
          (folder-name entry)
          (do-indent indent-level)
          (entry->netscape (folder-contents entry) (add1 indent-level))
          (do-indent indent-level)))

;;; Compiles a Marker entry into its corresponding Netscape bookmark representation.
;;; (entry->netscape : (MarkerEntry Number -> String))
(define (entry->netscape entry indent-level)
  (cond
    [(cons? entry)
     (string-append (entry->netscape (first entry) indent-level) (entry->netscape (rest entry) indent-level))]
    [(bookmark? entry)
     (bookmark->netscape entry indent-level)]
    [(folder? entry)
     (folder->netscape entry indent-level)]
    [else
     ""]))

;;; Compiles a whole marker document into a Netscape bookmark document. This is the main entry point into this generator
;;; which will later delegate to the other helper functions above.
;;; (marker->netscape : MarkerEntry -> String)
(define (marker->netscape entry)
  (format "<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
~a</DL><p>"
          (entry->netscape entry 1)))

(module+ main
  (require raco/command-name)
  (match (current-command-line-arguments)
    [(or (vector "--help") (vector))
     (printf "Usage: raco ~a [Marker file]\n"
             (current-command-name))]
    [(vector file)
     (display (marker->netscape (dynamic-require file 'page)))]))

(provide marker->netscape)
