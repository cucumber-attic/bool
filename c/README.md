## C

You need `make`, a C compiler, `flex` and `bison` on your `PATH`. Cd into `c` and run

```
make
```

This should create a shared library, but no executable. The C library only contains a lexer, parser and a simple AST.
It does not implement the visitor that traverses the AST that evaluates the parsed expression. This is done in the ruby extension,
and a future Python extension could do the same.
