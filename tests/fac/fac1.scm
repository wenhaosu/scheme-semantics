//factorial with do loop
[define fac
    [lambda [x]
        [if [eqv? x 0] 
            1
            [* x [fac [- x 1]]]]]]
[define input 8]
[fac 8]
eof
