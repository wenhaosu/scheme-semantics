[define r false]
[+ 1 [call/cc
       [lambda [k]
          [begin [set! r k]
                 [+ 2 [k 3]]]]]]
eof