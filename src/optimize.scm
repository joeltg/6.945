(load "generic-operators")


(define delta (make-generic-operator 2 'delta delta:symbolic))

(defhandler delta delta:numeric number? number?)

(define delta:numeric -)

(define (delta:symbolic a b)
  (if (eq? a b) 0 1))

(define (map-assq f alist . alists)
  (let iter ((alist alist) (alists alists) (result '()))
    (if (null? alist)
      result
      (let* ((key (caar alist))
             (collect (map (lambda (l) (assq key l))) alists))
          (if (any not collect)
            (iter (cdr alist) alists result)
            (let* ((values (map cadar collect))
                   (new-result (cons (list key (apply f values)) result)))
              (iter (cdr alist) alists new-result)))))))

(define (sse r1 r2)
  (let iter ((r1 r1) (r2 r2) (sum 0))
    (if (null? r1)
      sum
      (let ((key (car r1)) (val1 (cadar r1)) (val2 (assq r2)))
        (if val2
          (iter (cdr r1) r2 (+ sum (delta val1 val2)))
          (iter (cdr r1) r2 sum))))))


(define (optimize:numeric data->renderables
                          current-data
                          current-renderable
                          desired-renderable)
  (let* ((data-keys (map car current-data))
         (data-vals (map cdr current-data))
         (f (lambda (vals)
              (sse
                current-renderables
                (data->renderables (map list data-keys vals))))))
    (multidimensional-minimize f data-vals)))
