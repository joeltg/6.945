(load "numeric-optimization.scm")

(define (delta a b)
  (square (- a b)))

(define (renderable-diff r1 r2)
  (let iter ((r1 r1) (r2 r2) (sum 0))
    (if (null? r1)
      sum
      (let* ((key (car r1)) (val1 (cadar r1)) (val2 (assq r2)))
        (if val2
          (iter (cdr r1) r2 (+ sum (delta val1 val2)))
          (iter (cdr r1) r2 sum))))))

(define (optimize data->renderables
                  current-data
                  current-renderable
                  desired-renderable)
  (let* ((data-keys (map car current-data))
         (data-vals (map cdr current-data))
         (f (lambda (vals)
              (renderable-diff
                current-renderables
                (data->renderables (map list data-keys vals))))))
    (multidimensional-minimize f data-vals)))

(define (multidimensional-minimize f parameters)
  (let ((f (lambda (x) (f (vector->list x)))))
    (let ((result
	   (nelder-mead f
			(list->vector parameters)
			nelder-start-step
			nelder-epsilon
			nelder-maxiter)))
      (if (eq? 'ok (car result))
	  (vector->list (caadr result))
	  (error "Minimizer did not converge")))))

(define nelder-start-step .01)
(define nelder-epsilon 1.0e-10)
(define nelder-maxiter 1000)
