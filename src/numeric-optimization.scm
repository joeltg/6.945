#| -*-Scheme-*-

Copyright (C) 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994,
    1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005,
    2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014 Massachusetts
    Institute of Technology

This file is part of MIT/GNU Scheme.

MIT/GNU Scheme is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

MIT/GNU Scheme is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with MIT/GNU Scheme; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301,
USA.

|#

;;;; MULTIMIN.SCM -- n-dimensional minimization routines
;;; 9/22/89 (gjs) reduce->a-reduce

(declare (usual-integrations = + - * /
			     zero? 1+ -1+
			     ;; truncate round floor ceiling
			     sqrt exp log sin cos))

;;; Nelder-Mead downhill simplex algorithm.

;;; We have a function, f, defined on points in n-space.
;;; We are looking for a local minimum of f.

;;; The central idea -- We have a simplex of n+1 vertices where f is
;;; known.  We want to deform the simplex until it sits on the minimum.

;;; A simplex is represented as a list of entries, each of which is a
;;; pair consisting of a vertex and the value of f at that vertex.

(define simplex-size length)

(define simplex-vertex car)
(define simplex-value cdr)
(define simplex-entry cons)

;;; Simplices are stored in sorted order
(define simplex-highest car)
(define simplex-but-highest cdr)
(define simplex-next-highest cadr)
(define (simplex-lowest s) (car (last-pair s)))

(define (simplex-add-entry entry s)
  (let ((fv (simplex-value entry)))
    (let loop ((s s))
      (cond ((null? s) (list entry))
            ((> fv (simplex-value (car s))) (cons entry s))
            (else (cons (car s) (loop (cdr s))))))))

(define (simplex-adjoin v fv s)
  (simplex-add-entry (simplex-entry v fv) s))

(define (simplex-sort s)
  (let lp ((s s) (ans '()))
    (if (null? s)
        ans
        (lp (cdr s) (simplex-add-entry (car s) ans)))))

(define simplex-centroid
  (lambda (simplex)
    (scalar*vector (/ 1 (simplex-size simplex))
		   (a-reduce vector+vector
			     (map simplex-vertex simplex)))))

(define	extender
  (lambda (p1 p2)
    (let ((dp (vector-vector p2 p1)))
      (lambda (k)
        (vector+vector p1 (scalar*vector k dp))))))

(define (make-simplex point step f)
  (simplex-sort
    (map (lambda (vertex) (simplex-entry vertex (f vertex)))
         (cons point
	       (let ((n (vector-length point)))
		 (make-initialized-list n
		   (lambda (i)
		     (vector+vector point
		       (scalar*vector step
			 (v:make-basis-unit n i))))))))))

(define (stationary? simplex epsilon)
  (close-enuf? (simplex-value (simplex-highest simplex))
               (simplex-value (simplex-lowest simplex))
               epsilon))

(define nelder-wallp? false)

(define (nelder-mead f start-pt start-step epsilon maxiter)
  (define shrink-coef 0.5)
  (define reflection-coef 2.0)
  (define expansion-coef 3.0)
  (define contraction-coef-1 1.5)
  (define contraction-coef-2 (- 2 contraction-coef-1))
  (define (simplex-shrink point simplex)
    (let ((pv (simplex-vertex point)))
      (simplex-sort
       (map (lambda (sp)
	      (if (eq? point sp)
		  sp
		  (let ((vertex ((extender pv (simplex-vertex sp))
				 shrink-coef)))
		    (simplex-entry vertex (f vertex)))))
	    simplex))))
  (define (nm-step simplex)
    (let ((g (simplex-highest simplex))
          (h (simplex-next-highest simplex))
          (s (simplex-lowest simplex))
          (s-h (simplex-but-highest simplex)))
      (let* ((vg (simplex-vertex g)) (fg (simplex-value g))
             (fh (simplex-value h)) (fs (simplex-value s))
             (extend (extender vg (simplex-centroid s-h))))
        (let* ((vr (extend reflection-coef))
               (fr (f vr)))                 ;try reflection
          (if (< fr fh)                     ;reflection successful
              (if (< fr fs)                 ;new minimum
                  (let* ((ve (extend expansion-coef))
                         (fe (f ve)))       ;try expansion
                    (if (< fe fs)           ;expansion successful
                        (simplex-adjoin ve fe s-h)
                        (simplex-adjoin vr fr s-h)))
                  (simplex-adjoin vr fr s-h))
              (let* ((vc (extend (if (< fr fg)
                                     contraction-coef-1
                                     contraction-coef-2)))
                     (fc (f vc)))           ;try contraction
                (if (< fc fg)               ;contraction successful
                    (simplex-adjoin vc fc s-h)
                    (simplex-shrink s simplex))))))))
  (define (limit simplex count)
    (if nelder-wallp? (write-line (simplex-lowest simplex)))
    (if (stationary? simplex epsilon)
        (list 'ok (simplex-lowest simplex) count)
        (if (fix:= count maxiter)
            (list 'maxcount (simplex-lowest simplex) count)
            (limit (nm-step simplex) (fix:+ count 1)))))
  (limit (make-simplex start-pt start-step f) 0))
