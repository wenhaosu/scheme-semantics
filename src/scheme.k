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
  syntax Name ::= "+" | "-" | "*" | "/"
                | ">" | "<" | ">=" | "<=" | "not"
                | "display" | "newline" | "read"
                | "eqv?" | "boolean?" | "integer?" | "string?"

  syntax Names ::= List{Name," "}                  [klabel(exps)]

// Basic Scheme expressions, using [] now to aviod K's parsing issue
  syntax Exp ::= Int | Bool | String | Name
               | "[" Name Exps "]"                 [strict(2)]
               | "[" "if" Exp Exp "]"              [strict(1)]
               | "[" "if" Exp Exp Exp "]"          [strict(1)]
               | "[" "let" "[" Assigns "]" Exp "]"

  syntax Exps  ::= List{Exp," "}                   [strict, klabel(exps)]
  syntax Val
  syntax Vals ::= List{Val," "}                    [klabel(exps)]
  syntax Bottom
  syntax Bottoms ::= List{Bottom," "}              [klabel(exps)]
  syntax Assign ::= "[" Name Exp "]"               [strict(2)]
  syntax Assigns ::= List{Assign," "}              [klabel(exps)]

// Define program to be a sequence of expressions followed by eof
  syntax Pgm ::= Exp Pgm            [strict(1)] 
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

  syntax Val ::= Int | Bool | String | Null
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

  //@ \subsection{Conditional}
  
  rule [if C E:Exp] => [if C E null()]                      [macro]
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

  rule <k> [let [As:Assigns] E] => bindTo(As) ~> E ~> setEnv(Rho) ...</k>
       <env> Rho </env>

  syntax KItem ::= bindTo(Assigns)
                 | setEnv(Map)

  rule <k> bindTo([X:Name V:Val] As:Assigns) => bindTo(As) ...</k>
       <env> Rho => Rho[X <- !L:Int] </env>
       <store>... .Map => !L |-> V ...</store>              [assignment]
  rule bindTo(.Assigns) => .

  rule <k> V:Val ~> setEnv(Rho) => V ...</k>
       <env> _ => Rho </env>

  rule <k> X:Name => V ...</k>
       <env>... X |-> L ...</env>
       <store>... L |-> V:Val ...</store>                   [lookup]

endmodule
