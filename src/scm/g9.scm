(load "optimize.scm")

(define (g9 initial-data data->renderables renderer on-data-update)
  (define current-data initial-data)
  (define current-renderables (data->renderables current-data))

  (define (on-renderable-update desired-renderable)
    (let* ((id (car desired-renderable))
           (current-renderable (assq id current-renderables))
           (optimized-data (optimize data->renderables
                                     current-data
                                     current-renderable
                                     desired-renderable)))
      (set! current-data optimized-data)
      (set! current-renderables (data->renderables current-data))
      current-renderables))

  (renderer on-renderable-update current-renderables))
