[let [[x 5]]
  [begin
    [define foo [lambda [y] [bar x y]]]
    [define bar [lambda [a b] [+ [* a b] a]]]
    [foo [+ x 3]]]]
eof
