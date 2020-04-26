(define-syntax test
  (syntax-rules ()
    ((_ (X) ...) (list (list X) ...))))

(display (test (1) (2) (3) (4)))
  (newline)
(display (test (#(1 2 3))))
  (newline)
