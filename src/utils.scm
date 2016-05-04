
(define *at-least-zero* '(0 . #f))
(define *exactly-zero* '(0 . 0))
(define *at-least-one* '(1 . #f))
(define *exactly-one* '(1 . 1))

(define generate-list make-initialized-list)

(define (butlast l)
	(if (null? (cdr l))
	  '()
	  (cons (car l) (butlast (cdr l)))))

(define (compose . fs)
  (compose-n fs))

(define (compose-n fs)
  (define (lp fs)
    (cond ((null? (cdr fs)) (car fs))
	  (else (compose-2 (car fs) (lp (cdr fs))))))
  (cond ((null? fs) identity)
	((null? (cdr fs)) (car fs))
	(else				;compose-bin preserves arity
	 (compose-bin (lp (butlast fs))
		      (car (last-pair fs))))))

(define (identity x) x)

(define (compose-2 f g)
  (cond ((pair? g)
	 (lambda x
	   (apply f
		  (map (lambda (gi)
			 (apply gi x))
		       g))))
	(else
	 (lambda x
	   (f (apply g x))))))

(define (compose-bin f g)
  (cond ((pair? g)
	 (let ((a
		(a-reduce joint-arity
			  (map procedure-arity g))))
	   (cond ((equal? a *at-least-zero*)
		  (lambda x
		    (apply f
			   (map
			    (lambda (gi)
			      (apply gi x))
			    g))))
		 ((equal? a *exactly-zero*)
		  (lambda ()
		    (apply f
			   (map (lambda (gi)
				  (gi))
				g))))
		 ((equal? a *at-least-one*)
		  (lambda (x . y)
		    (apply f
			   (map (lambda (gi)
				  (apply gi x y))
				g))))
		 ((equal? a *exactly-one*)
		  (lambda (x)
		    (apply f
			   (map (lambda (gi)
				  (gi x))
				g))))

		 ((equal? a *at-least-two*)
		  (lambda (x y . z)
		    (apply f
			   (map (lambda (gi)
				  (apply gi x y z))
				g))))
		 ((equal? a *exactly-two*)
		  (lambda (x y)
		    (apply f
			   (map (lambda (gi)
				  (gi x y))
				g))))

		 ((equal? a *at-least-three*)
		  (lambda (u x y . z)
		    (apply f
			   (map (lambda (gi)
				  (apply gi u x y z))
				g))))
		 ((equal? a *exactly-three*)
		  (lambda (x y z)
		    (apply f
			   (map (lambda (gi)
				  (gi x y z))
				g))))
		 ((equal? a *one-or-two*)
		  (lambda (x . y)
		    (if (null? y)
			(apply f
			       (map (lambda (gi)
				      (gi x))
				    g))
			(apply f
			       (map (lambda (gi)
				      (gi x (car y)))
				    g)))))
		 (else
		  (lambda x
		    (apply f
			   (map
			    (lambda (gi)
			      (apply gi x))
			    g)))))))
	(else
	 (let ((a (procedure-arity g)))
	   (cond ((equal? a *at-least-zero*)
		  (lambda x
		    (f (apply g x))))
		 ((equal? a *exactly-zero*)
		  (lambda ()
		    (f (g))))
		 ((equal? a *at-least-one*)
		  (lambda (x . y)
		    (f (apply g x y))))
		 ((equal? a *exactly-one*)
		  (lambda (x)
		    (f (g x))))
		 ((equal? a *at-least-two*)
		  (lambda (x y . z)
		    (f (apply g x y z))))
		 ((equal? a *exactly-two*)
		  (lambda (x y)
		    (f (g x y))))
		 ((equal? a *at-least-three*)
		  (lambda (u x y . z)
		    (f (apply g u x y z))))
		 ((equal? a *exactly-three*)
		  (lambda (x y z)
		    (f (g x y z))))
		 ((equal? a *one-or-two*)
		  (lambda (x . y)
		    (if (null? y)
			(f (g x))
			(f (g x (car y))))))
		 (else
		  (lambda x
		    (f (apply g x)))))))))
