(define (make-renderer attach! render)
  (lambda (callback inital)
    (attach! callback)
    (render initial)))
