(with-working-directory-pathname "/usr/local/scmutils/src/" (lambda () (load "load.scm")))
(load "g9")

(define global-desire)

(define (js-render desire renderables)
	;(set! global-desire desire)
	(write-string "::begin-renderables::")
	(write renderables)
	(write-string "::end-renderables::"))