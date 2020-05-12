# scheme-semantics

## Introduction
This repo is for a dialect of Scheme implemented in K.

## Functionalities & Features
Some features of our Scheme dialect are:

- Use `[]` instead of `()` for indicating functions
- Use `eof` as the mark of the end of a function
- Use `,` instead of `.` to describe pairs and lists
- `let` completes the job of both `let` and `letrec` in original Scheme

Below is a list of the functionalities implemented so far:
- Arithmetic operations including `+`, `-`, `x`, `÷`
- `let`, `let*`
- `define`
- `lambda`
- `if`
- `list`, `cons`, `car`, `cdr`
- `read`, `display`
- `eqv?`, `boolean?`, `integer?`, `string?`, `list?`, `null?`

For more details, please refer to the test cases provided in `tests/`.

## Contributor
Wenhao Su, Qihang Ren, Junkai Cheng, Patrick Meredith, Grigore Rosu
