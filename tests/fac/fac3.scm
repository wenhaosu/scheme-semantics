[let fac [[x 10]] 
      [if [eqv? x 0] 
          1
          [* x [fac [- x 1]]]]]
eof
