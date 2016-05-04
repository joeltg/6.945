(let ((path (working-directory-pathname)))
    (cd "/usr/local/scmutils/src/")
        (load "load.scm")
        (cd path))

(load "g9")

(define (js-write renderables)
    (write-string "::begin-renderables::")
    (write renderables)
    (write-string "::end-renderables::"))

(define global-desire)

(define (js-render desire renderables)
    (set! global-desire (lambda (renderable)
                                (js-write (desire renderable))))
    (js-write renderables))