;;; This example illustrates how quasiquote evaluates its unquote
;;; expressions non-deterministically
;;; Note: this example takes a while
(display `( #(,(begin (display 0) 0)) (,(begin (display 1) 1) ,(begin (display 2) 2))))
  (newline)
