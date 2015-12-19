# bool

[![Build Status](https://travis-ci.org/cucumber/bool.svg)](https://travis-ci.org/cucumber/bool)

This is a cross-platform library for parsing boolean arithmetic expressions like `a && b && (!c || !d)` and evaluating them by assigning values to the variables.

Boolean expressions are parsed into an [abstract syntax tree](http://en.wikipedia.org/wiki/Abstract_syntax_tree) (AST).

This is done with a generated lexer and parser. The generators used are:

* Java: [Ragel](http://www.complang.org/ragel/) and [Bison](http://www.gnu.org/software/bison/)
* Ruby: (C extension): [Ragel](http://www.complang.org/ragel/) and [Bison](http://www.gnu.org/software/bison/)
* JRuby: [Ragel](http://www.complang.org/ragel/) and [Bison](http://www.gnu.org/software/bison/)
* JavaScript: [jison-lex](https://github.com/zaach/jison-lex) and [Jison](http://zaach.github.io/jison/)

This choice of generators makes it easy to port the implementation to other languages since they are ported to most programming languages. 

Evaluation of the boolean expressions is done by traversing the AST with a visitor. (This is obviously overkill for something as 
simple as boolean expressions, keep reading to understand why).

Supported platforms are Ruby, JRuby, Java and JavaScript. More platforms like Python, PHP and .NET may be added later.

The Ruby gem uses a C extension (for speed) and the JRuby gem uses a Java extension (also for speed). Support for e.g. Python could be added 
easily by using the same C code as the Ruby gem. Java programs (or any other JVM-based program such as Scala or Clojure) can also use the Java library as-is.

## Why?

The purpose of this library is twofold.

First, it serves as a simple example of how to build a custom interpreted language with a fast lexer/parser that builds a 
visitor-traversable AST, and that runs on many different platforms. People who want to build a bigger cross-platform language could 
leverage the structure and build files in this project. For example, the [Gherkin](https://github.com/cucumber/gherkin3) 3.0 project will use this 
project as a template.

Second, this project will be used by Cucumber to evaluate _tag expressions_ in a more elegant way.

## Building

See `CONTRIBUTING.md`

