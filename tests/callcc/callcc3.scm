[define r false]
[+ 1 [call/cc
       [lambda [k]
         [set! r k]
         [+ 2 [k 3]]]]]
eof