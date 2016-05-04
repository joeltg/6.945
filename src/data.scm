; a data object is a scheme object and a collection of keyed getter- and
; setter- functions

(define (get-keys dataObject)
  #f
  )
(define (get-val dataObject key)
  #f
  )
(define (set-val key val dataObject)
  #f
  )

(define (make-data-object keys vals initial)
  (fold-right set-val initial keys vals))

(define (data->properties data)
  #f
  )
(define (data->renderables data)
  #f
  )
