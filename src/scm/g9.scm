(load "optimize.scm")

(define optimize optimize:numeric)

(define (g9 initial-data data->renderables renderer on-data-update)
  (define current-data initial-data)
  (define current-renderables (data->renderables current-data))
  (define (desire desired-renderable)
    (let* ((id (car desired-renderable))
           (optimized-data (optimize data->renderables
                                     current-data
                                     desired-renderable)))
      (set! current-data optimized-data)
      (set! current-renderables (data->renderables current-data))
      current-renderables))

  (renderer desire current-renderables))
