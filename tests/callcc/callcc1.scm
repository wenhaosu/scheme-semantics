[define k false]
[display [+ 1 1 1 [call/cc [lambda[c] [set! k c] 0]]]]
[k 3]
eof