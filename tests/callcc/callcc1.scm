[define k false]
[display [+ 1 1 1 [call/cc [lambda[c] [begin [set! k c] 0]]]]]
[k 3]
eof
