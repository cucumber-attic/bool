RAGEL = ../ragel
BISON = ../bison
UNAME := $(shell uname)
LDSHARED?=$(CC) -shared
OBJECTS = lexer.o parser.o ast.o
TEST_OBJECTS = test/test.o
CFLAGS = -fPIC -O2 -Werror -Wall -Wextra -DYYDEBUG

all: libparse.o libparse.a run_tests

libparse.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)

libparse.o: $(OBJECTS)
	$(CC) --version
	$(CC) -shared -o $@ $(OBJECTS)

lexer.o: parser.o

run_tests: test/test
	test/test

test/test: $(TEST_OBJECTS) libparse.a
	$(CC) -o $@ test/*.o libparse.a

lexer.c: lexer.rl
	$(RAGEL) lexer.rl

parser.h parser.c: parser.y
	$(BISON) parser.y

clean:
	rm -f lexer.c parser.h parser.c *.o *.a test/test test/*.o

