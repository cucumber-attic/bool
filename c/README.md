## C

You need:

* `make`
* A C compiler such as `gcc` or `clang`
* `flex` 2.5.35 or newer
* `bison` 2.5 or newer

To compile, just run

```
make
```

This should create a shared library, but no executable. The C library only contains a lexer, parser and a simple AST.
It does not implement the visitor that traverses the AST that evaluates the parsed expression. This is done in the ruby extension,
and a future extensions for Node.js, Python, Lua etc. could do the same.

