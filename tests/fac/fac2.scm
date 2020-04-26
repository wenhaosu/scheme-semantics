;;;factorial with recursion
(define (fac n)
   (if (= n 1)
        1
       (* n (fac (- n 1)))))
(display (fac 3))
  (newline)
(display (fac 10))
  (newline)
(display (fac 100))
  (newline)
