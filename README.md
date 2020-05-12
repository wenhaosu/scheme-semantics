# scheme-semantics

## Introduction
This repo is for a dialect of Scheme implemented in K. Some features of our Scheme dialect are:

- Use `[]` instead of `()` for indicating functions
- Use `eof` as the mark of the end of a function
- Use `,` instead of `.` to describe pairs and lists
- Use `//`, `/*` and `*/` instead of `;`, `#|` and `|#` to comment

For examples, please refer to `./tests`.

## Contributor
Wenhao Su, Qihang Ren, Junkai Cheng, Patrick Meredith, Grigore Rosu

## Prerequisite
K Framework Tools 5.0

Check https://github.com/kframework/k for details

## How to Use
Compile:

```
kompile --backend java ./src/scheme.k -d 
```

Run: 

```
krun filename.scm
```
## Function
We implemented part of scheme functions. They are:

- Arithmetic expressions
- Boolean expressions
- Conditional expressions
- File I/O
- Local Binding: `let`, `let*`, and `letrec`
- Procedure Expressions: `lambda`
- Pair and List
- Continuation: `call/cc` 