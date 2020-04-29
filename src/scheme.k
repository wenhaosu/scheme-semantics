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
  syntax Names ::= List{Name,","}

// Basic Scheme expressions, using [] now to aviod K's parsing issue
  syntax Exp ::= Int | Bool | String | Name
               | "[" Name Exps "]"                 [strict(2)]

  syntax Exps  ::= List{Exp," "}                   [strict]
  syntax Val
  syntax Vals ::= List{Val," "}
  syntax Bottom
  syntax Bottoms ::= List{Bottom," "}

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
                  <k color="green"> $PGM:Exps </k>
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
  syntax KResult ::= Val

/*@ To make sure that the program executes sequentially and KResult
displays the result of last function executed. */

  rule _:Val E:Exps => E
    requires notBool(E ==K .Exps)
  rule V:Val .Exps => V

//@ \subsection{Arithmetic expressions}

  rule [+ I1 I2 Vals] => [+ (I1 +Int I2) Vals]              [arith]
  rule [+ I .Vals] => I                                     [arith]
  rule [- I1 I2 Vals] => [- (I1 -Int I2) Vals]              [arith]
  rule [- I .Vals] => I                                     [arith]
  rule [* I1 I2 Vals] => [* (I1 *Int I2) Vals]              [arith]
  rule [* I .Vals] => I                                     [arith]
  rule [/ I1 I2 Vals] => [/ (I1 /Int I2) Vals]              [arith]
    when I2 =/=K 0
  rule [/ I .Vals] => I                                     [arith]

endmodule
