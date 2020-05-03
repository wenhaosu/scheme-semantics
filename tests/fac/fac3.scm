//tail recursive factorial...note that currently the definition does
//not have "tail call optimization"
[define [fac n]
   [letrec [[aux 
      [lambda [n acc]
         [if [= n 1]
          acc
         [aux [- n 1] [* n acc]]]]]]
    [aux n 1]]]
[display [fac 3]]
  [newline]
[display [fac 10]]
  [newline]
[display [fac 100]]
  [newline]
eof
