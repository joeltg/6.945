(load "g9")

(define foo 4)

(define (renderer callback)
  (set! foo callback)
  (lambda (renderables)
    (pp "rendering")
    (pp renderables)))

(define initial-data '((x 0) (y 0)))

(define (data->renderables data)
  `(((type point)
     (position ((x ,(+ 10 (cadr (assq 'x data))))
                (y ,(+ 50 (cadr (assq 'y data)))))))))

(define (on-data-update data)
  (pp "updated data")
  (pp data))