/*!
\title{Scheme}
\author{Wenhao Su, Qihang Ren, Junkai Cheng and Grigore Ro\c{s}u and 
        (\texttt{\{wenhaos3, qihangr2, junkaic2, grosu\}@illinois.edu})}
\organization{University of Illinois at Urbana-Champaign}
*/

//@ \section{Syntax}

module SCHEME-COMMON
  imports DOMAINS-SYNTAX

// Builtin function names, maybe consider replacing with arith later

  syntax Name ::= "+" | "-" | "*" | "/" | "="
                | ">" | "<" | ">=" | "<=" | "not"
                | "newline" | "read"
                | "eqv?" | "boolean?" | "integer?" | "string?" | "list?" | "null?"
  syntax Names ::= List{Name," "}                  [klabel(exps)]

// Basic Scheme expressions, using [] now to aviod K's parsing issue
  syntax Exp ::= Int | Bool | String | Name | Pair
               | "[" Exp Exps "]"                  [strict]
               | "[" "if" Exp Exp "]"              [strict(1)]
               | "[" "if" Exp Exp Exp "]"          [strict(1)]
               | "[" "let" "[" Exps "]" Exp "]"
               | "[" "let" Name "[" Exps "]" Exp "]"
               | "[" "begin" Exp Exps "]"          [strict(1)]
               | "[" "lambda" "[" Names "]"  Exp "]"
               | "[" "list" Exps "]"               [seqstrict]
               | "[" "cons" Exp Exp "]"            [strict]
               | "[" "car" Exp "]"                 [strict]
               | "[" "cdr" Exp "]"                 [strict]
               | "[" "display" Exp "]"             [strict]

  // "define" can only appear at the top level of a program
  syntax Top ::= "[" "define" Name Exp "]"         [strict(2)]
               | "[" "define" "[" Name Names "]" Exp "]"
               | Exp

  syntax Exps  ::= List{Exp," "}                   [strict, klabel(exps)]
  syntax Val
  syntax Vals ::= List{Val," "}                    [klabel(exps)]
  syntax Bottom
  syntax Bottoms ::= List{Bottom," "}              [klabel(exps)]
  syntax Pair ::= "{" Exp "," Exp "}"              [strict]
                | "{" "}"

// Call-with-current-continuation
  syntax Exp ::= "call/cc"

// Define program to be a sequence of expressions followed by eof
  syntax Pgm ::= Top Pgm                           [strict(1)]
               | "eof"

endmodule

//@ \subsection{Naming policy}

module SCHEME-SYNTAX
  imports SCHEME-COMMON
  imports BUILTIN-ID-TOKENS

// For now we only allow following user-defined symbols
  syntax Name ::= r"[a-z][_a-zA-Z0-9]*"           [token, prec(2)]
                | #LowerId                        [token]
endmodule

//@ \subsection{Desugaring macros}

module SCHEME-MACROS
  imports SCHEME-COMMON

  rule [define [N:Name Ns] E:Exp] => [define N [lambda [Ns] E]]    [macro]

endmodule


/*@ \section{Semantics}

The semantics below is environment-based. */

module SCHEME
  imports SCHEME-COMMON
  imports SCHEME-MACROS
  imports DOMAINS

//*@ \subsection{Configuration} */

  configuration <T color="yellow">
                  <k color="green"> $PGM:Pgm </k>
                  <env color="violet"> .Map </env>
                  <genv color="pink"> .Map </genv>
                  <store color="white"> .Map </store>
                  <input color="magenta" stream="stdin"> .List </input>
                  <output color="brown" stream="stdout"> .List </output>
                </T>


//*@ \subsection{Values and results} */  

  syntax Val ::= Int | Bool | String | Pair | Null
  syntax Exp ::= Val
  syntax Exps ::= Vals
  syntax Vals ::= Bottoms
  syntax Exps ::= Names
  syntax Names ::= Bottoms
  syntax KResult ::= Vals | Val

  syntax Null ::= null()

/*@ To make sure that the program executes sequentially and KResult
displays the result of last function executed. */

  rule _:Val P:Pgm => P
    when notBool(P ==K eof)
  rule V:Val eof => V
    when notBool(V ==K null())
  rule N:Null eof => .
  // rule V:Val .Vals => V


//@ \subsection{Arithmetic expressions}

  rule [+ I1 I2 Vals] => [+ (I1 +Int I2) Vals]              [arith]
  rule [+ I .Vals] => I                                     [arith]
  rule [- I1 I2 Vals] => [- (I1 -Int I2) Vals]              [arith]
  rule [- I .Vals] => I                                     [arith]
  rule [* I1 I2 Vals] => [* (I1 *Int I2) Vals]              [arith]
  rule [* I .Vals] => I                                     [arith]
  rule [/ I1 I2 Vals] => [/ (I1 /Int I2) Vals]
    when I2 =/=K 0                                          [arith]
  rule [/ I .Vals] => I                                     [arith]
  rule [= V1:Val V2:Val Vals] => false
    when notBool(V1 ==K V2)                                 [arith]
  rule [= V1:Val V2:Val Vals] => [= V2:Val Vals]
    when V1 ==K V2                                          [arith]
  rule [= V .Vals] => true                                  [arith]


//@ \subsection{Boolean expressions}
  rule [> I1 I2] => I1 >Int I2                              [arith]
  rule [>= I1 I2] => I1 >=Int I2                            [arith]
  rule [< I1 I2] => I1 <Int I2                              [arith]
  rule [<= I1 I2] => I1 <=Int I2                            [arith]
  rule [not false] => true                                  [arith]
  rule [not _:Val] => false                                 [arith]
  rule [boolean? B:Bool] => true                            [arith]
  rule [boolean? _] => false                                [arith]
  rule [string? S:String] => true                           [arith]
  rule [string? _] => false                                 [arith]
  rule [integer? I:Int] => true                             [arith]
  rule [integer? _] => false                                [arith]
  rule [eqv? V1:Val V2:Val] => true
    when V1 ==K V2                                          [arith]
  rule [eqv? _:Val _:Val] => false                          [arith]
  rule [list? { V:Val , _ }] => true                        [arith]
  rule [list? _] => false                                   [arith]
//   rule [null? {  }] => true                                   [arith]
//   rule [null? _] => false                                   [arith]

  //@ \subsection{Conditional}
  
  rule [if C:Val E:Exp] => [if C E null()]
  rule [if true E:Exp _:Exp] => E
  rule [if false _:Exp E:Exp] => E


  //@ \subsection{I/O}

  rule <k> [newline .Exps] => null() ...</k>
       <output>... .List => ListItem("\n") </output>        [io]

  rule <k> [display V:Val] => null() ...</k>
       <output>... .List => ListItem(V) </output>           [io]

  rule <k> [read .Exps] => I ...</k>
       <input> ListItem(I:Int) => .List ... </input>        [io]


  //@ \subsection{Assignment}

  rule <k> [let [As:Exps] E] => bindTo(As) ~> E ~> setEnv(Rho) ...</k>
       <env> Rho </env>

  rule <k> [let N:Name [As:Exps] E] => bindFun(N, As, E, Rho, parags(.Names, .Vals)) ~> setEnv(Rho) ...</k>
       <env> Rho </env>

  rule <k> [define N:Name V:Val] => null() ...</k>
       <env> Rho => Rho[N <- !L:Int] </env>
       <store>... .Map => !L |-> V ...</store>
    [assignment]

  rule <k> X:Name => V ...</k>
       <env>... X |-> L ...</env>
       <store>... L |-> V:Val ...</store>                   [lookup]


  //@ \subsection{Begin}

  rule [begin V:Val .Exps] => V
  rule [begin V:Val E:Exp Es] => [begin E Es]
  

  //@ \subsection{Function}
  syntax Val ::= closure(Map,Names,Exp)

  rule <k> [lambda [ Ns:Names ] E:Exp] => closure(Rho, Ns, E) ...</k>
       <env> Rho </env>
    [structural]

  rule <k> [closure(Rho, Ns, E) Vs:Vals] => bindMap(Ns, Vs) ~> E ~> setEnv(Rho') ...</k>
       <env> Rho' </env>


  //@ \subsection{List}

  rule [list .Vals] => { }
  rule [list V:Val Vs] => [cons V [list Vs] ]
  rule [cons V1:Val V2:Val] => { V1 , V2 }
  rule [car {V:Val , _}] => V
  rule [car {V:Pair , _}] => V
  rule [cdr {_ , V:Pair}] => V

  //@ \subsection{call/cc}

  syntax Val ::= cc(Map,K)
  rule <k> ([call/cc V:Val] => [V cc(Rho,K)]) ~> K </k>  
       <env> Rho </env>
  rule <k> [cc(Rho,K) V:Val] ~> _ => V ~> K </k>  
       <env> _ => Rho </env>


  //@ \subsection{Extra KItems}

  syntax KItem ::= bindTo(Exps)
                 | bindMap(Names, Vals)
                 | bindFun(Name, Exps, Exp, Map, KItem)
                 | setEnv(Map)
                 | parags(Names, Vals)

  rule <k> bindTo([X:Name V:Val] As:Exps) => bindTo(As) ...</k>
       <env> Rho => Rho[X <- !L:Int] </env>
       <store>... .Map => !L |-> V ...</store>
    [assignment]
  rule bindTo(.Exps) => .

  rule bindMap(X:Name Ns, V:Val Vs) => bindTo([X V]) ~> bindMap(Ns, Vs)
  rule bindMap(.Names, .Vals) => .

  rule bindFun(N, [X:Name V:Val] As:Exps, E, Rho, parags(Ns, Vs))
        => bindFun(N, As, E, Rho, parags(X Ns, V Vs))
  
  rule <k> bindFun(N:Name, .Exps, E:Exp, Rho', parags(Ns, Vs)) => [N Vs] ...</k>
       <env> Rho => Rho[N <- !L:Int] </env>
       <store>... .Map => !L |-> closure(Rho', Ns, E) ...</store>
    [assignment]

  rule <k> V:Val ~> setEnv(Rho) => V ...</k>
       <env> _ => Rho </env>


endmodule
