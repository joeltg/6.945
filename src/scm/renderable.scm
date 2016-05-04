; a renderable is a collection of properties and constraints
; that are consumed by a functional renderer to produce graphics objects

; TODO: make constraints (lower/upper bounds) generic

; a prop is a cons of a prop-name and a prop-val
; a renderable has an assoc list of props and a list of constraints
; a constraint is a lambda that takes a renderable and returns
; a minimally modified (hopefully unmodified) prop list that satisfies
; its constraint

(define (make-renderable id props constraints)
  (list 'renderable id props constraints))

(define (renderable:id renderable)
  (cadr renderable))
(define (renderable:props renderable)
  (caddr renderable))
(define (renderable:constraints renderable)
  (cadddr renderable))

; returns a new renderable with the modification
(define (set-prop renderable prop-key prop-val)
  #f
  )

(define (prop-ref renderable prop-key)
  #f
  )

(define (prop-key prop)
  (car prop))

(define (prop-val prop)
  (cdr prop))

(define (get-renderable-by-id id renderables)
  (assq id renderables))

(define (constrain-props props constraints)
  (fold-right props (lambda (constraint props) (constraint props)) constraints))

; example constraint
(define (clamp n lower upper)
  (min (max lower n) upper))
(define ((clamp-prop renderable) prop-key lower upper)
  (set-prop renderable prop-key
    (clamp (prop-ref renderable prop-key) lower upper)))
