(load "generic-operators")

(define (delta:symbolic a b)
  (if (eq? a b) 0 1))

(define delta:numeric -)

(define (delta:list a b)
  (sum-square (map delta a b)))

(define delta (make-generic-operator 2 'delta delta:symbolic))

(defhandler delta delta:numeric number? number?)

(defhandler delta delta:list list? list?)

(define (sum-square l)
  (fold + 0 (map square l)))

(define (map-assq f alist . alists)
  (let iter ((alist alist) (result '()))
    (if (null? alist)
      result
      (let* ((key (caar alist))
             (collect (map (lambda (l) (assq key l)) alists)))
          (if (any not collect)
            (iter (cdr alist) result)
            (let* ((values (cons (cadar alist) (map cadr collect)))
                   (new-result (cons (list key (apply f values)) result)))
              (pp values)
              (iter (cdr alist) new-result)))))))


(define (sse r1 r2)
  (let iter ((r1 (cadr r1)) (r2 (cadr r2)) (sum 0))
    (if (null? r1)
      sum
      (let* ((key (caar r1)) (val1 (cadar r1)) (val2 (assq key r2)))
        (if val2
          (iter (cdr r1) r2 (+ sum (magnitude (square (delta val1 (cadr val2))))))
          (iter (cdr r1) r2 sum))))))

(define (simplex-min f vals)
  (multidimensional-minimize f vals))

(define bfgs-estimate 0.1)
(define bfgs-epsilon 0.1)
(define bfgs-maxiter 1000)

(define nelder-start-step .01)
(define nelder-epsilon 1.0e-10)
(define nelder-maxiter 1000)

(define (bfgs-min f vals)
  (let ((f (compose f vector->list)))
    (let ((result
            (bfgs f
              '()
              (list->vector vals)
              bfgs-estimate
              bfgs-epsilon
              bfgs-maxiter)))
      (if (eq? 'ok (car result))
    	  (vector->list (caadr result))
    	  (error "Minimizer did not converge")))))

(define (optimize:numeric data->renderables
                          current-data
                          desired-renderable)
  (let* ((data-keys (map car current-data))
         (data-vals (map cadr current-data))
         (key (car desired-renderable)))
    (let ((f (lambda (vals)
              (sse
                desired-renderable
                (assq key (data->renderables (map list data-keys vals)))))))
    (pp "about to compute result")
    (map list data-keys (bfgs-min f data-vals)))))


;(define (data->renderables data)
;  `((handle ((x-pos ,(square (cadr (assq 'x data))))))))
;
;(define current-data `((x 2)))
;(define desired-renderable '(handle  ((x-pos 5))))
;
;(define opt (optimize:numeric data->renderables current-data desired-renderable))
;(pp (data->renderables opt))
;opt
