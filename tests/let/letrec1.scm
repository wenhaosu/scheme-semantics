[let [[even [lambda [n]
        [if [= n 0]
            true
            [odd [- n 1]]]]]
      [odd [lambda [n]
        [if [= n 0]
            false
            [even [- n 1]]]]]]
    [list [even 23] [odd 23]]]
eof