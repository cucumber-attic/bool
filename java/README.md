## Java

You need `mvn`, `ragel` and `bison` on your `PATH`. Cd into `java` and run

```
mvn package
```

The Java build actually builds a lexer with both Ragel and JFlex. The only reason there are two at the moment is that I haven't decided which one to use yet, so I'm experimenting with both.