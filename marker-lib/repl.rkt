#lang racket
(require racket/gui)
(require marker/top-level)

(define (repl-generate-page format page)
  (let [(generated-page (generate-page format page))
        (save-location (put-file))]
    (when save-location
      (with-output-to-file save-location (thunk (display generated-page))))))

(provide repl-generate-page)
