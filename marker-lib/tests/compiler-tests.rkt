#lang racket

(require "../compiler.rkt")
(require "../base.rkt")

(require rackunit)

; Base cases
; ==========

; Test compile nothing gives empty list
(check-equal? (compile-entry)
              (list))

; Test compile single bookmark
(check-equal? (compile-entry ("Name" "about:blank"))
              (list (bookmark "Name" "about:blank")))

; Test compile multiple bookmarks
(check-equal? (compile-entry
               ("Name" "about:blank")
               ("Other" "about:blank"))
              (list
               (bookmark "Name" "about:blank")
               (bookmark "Other" "about:blank")))

; Test compile single folder
(check-equal? (compile-entry
               ["Folder"
                ])
              (list
               (folder "Folder" (list))))

; Test compile multiple folders
(check-equal? (compile-entry
               ["Folder1"
                ]
               ["Folder2"
                ])
              (list
               (folder "Folder1" (list))
               (folder "Folder2" (list))))

; Inductive step
; ==============

; Test compiling folder recurs into compile-entry for children
(check-equal? (compile-entry
               ["Folder"
                ("Child" "about:blank")
                ("OtherChild" "about:blank")])
              (list
               (folder "Folder" (compile-entry
                                 ("Child" "about:blank")
                                 ("OtherChild" "about:blank")))))
