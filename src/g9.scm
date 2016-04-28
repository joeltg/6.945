
(define (clamp n lower upper)
  (min (max lower n) upper))

(define ((clamp-prop renderable) prop)
  (clamp (prop-ref renderable prop)
         (get-lower-prop-bound renderable prop)
         (get-upper-prop-bound renderable prop)))

(define (prop-ref renderable prop)
  )

(define (sticky? renderable)
  )

(define (get-lower-prop-bound renderable prop)
  )

(define (get-upper-prop-bound renderable prop)
  )

(define (get-renderable-by-id id)
  )

(define (get-keys dataObject)
  )

(define (get-val dataObject key)
  )

(define (set-val key val dataObject)
  )

(define (make-data-object keys vals initial)
  (fold set-val initial keys vals))

(define (delta-prop prop1 prop2)
  (- ))


(define (g9 initial-data populate-renderables on-change)

  (define (data->properties data)
    )

  (define (data->renderables data)
    )

  (define (make-renderer make-snapshot desire)
    )

  (define (render)
    ())

  (define (desire id . desired-props)
    (let* ((renderable (get-renderable-by-id id))
           (clamped-desired-props (map (clamp-prop renderable) desired-props))
           (keys (get-keys initial-data))
           (initial-vals (map get-val keys)))
      (let* ((optimized-vals
              (uncmin
                (lambda (current-values)
                  (let* ((current-data
                           (make-data-object keys current-values initial-data))
                         (current-props (data->properties current-data))
                         (deltas (map delta-prop
                                      clamped-desired-props
                                      current-props)))
                    (fold + 0 (map square deltas))))
                initial-vals))
              (optimized-data (make-data-object keys optimized-vals initial-data)))
        (render)
        (on-change optimized-data (data->renderables optimized-data))))))
