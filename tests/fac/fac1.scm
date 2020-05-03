;;;factorial with do loop
[define fac
    [lambda [n]
        [do [[i n [- i 1]] [a 1 [* a i]]]
            [[= 0 i] a]]]]
[display [fac 3]]
  [newline]
[display [fac 10]]
  [newline]
[display [fac 100]]
  [newline]
eof
