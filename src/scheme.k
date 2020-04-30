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
                | "display" | "newline" | "read"

  syntax Names ::= List{Name," "}

// Basic Scheme expressions, using [] now to aviod K's parsing issue
  syntax Exp ::= Int | Bool | String | Name
               | "[" Name Exps "]"                 [strict(2)]

  syntax Exps  ::= List{Exp," "}                   [strict]
  syntax Val
  syntax Vals ::= List{Val," "}
  syntax Bottom
  syntax Bottoms ::= List{Bottom," "}

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
                  <store color="white"> .Map </store>
                  <input color="magenta" stream="stdin"> .List </input>
                  <output color="brown" stream="stdout"> .List </output>
                </T>

//*@ \subsection{Values and results} */  

  syntax Val ::= Int | Bool | String
  syntax Exp ::= Val
  syntax Exps ::= Vals
  syntax Vals ::= Bottoms
  syntax Exps ::= Names
  syntax Names ::= Bottoms
  syntax KResult ::= Vals | Val

/*@ To make sure that the program executes sequentially and KResult
displays the result of last function executed. */

  rule _:Val P:Pgm => P
    when notBool(P ==K eof)
  rule V:Val eof => V

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

  //@ \subsection{I/O}

// Currently having bug on display, seeking a way to complete the 
// procecss of V ~> K

  rule <k> [newline .Exps] => "\n" ...</k>
       <output>... .List => ListItem("\n") </output>        [io]

  rule <k> [display V:Val] => V ...</k>
       <output>... .List => ListItem(V) </output>           [io]

  rule <k> [read .Exps] => I ...</k>
       <input> ListItem(I:Int) => .List ... </input>        [io]

endmodule
