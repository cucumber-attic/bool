LDSHARED?=$(CC) -shared
OBJECTS = lexer.o parser.o ast.o
CFLAGS = -O2 -fPIC -Wall -Werror
# Keep in sync with ../Makefile
PATH := $(shell pwd)/../bison-2.7/tests:$(PATH)

all: libparse.o libparse.a

libparse.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)

libparse.o: $(OBJECTS)
	$(CC) -shared -o $@ $(OBJECTS)

lexer.o: parser.o
nodes.o: nodes.h

lexer.h lexer.c: lexer.l
	flex --version
	flex lexer.l

parser.h parser.c: parser.y
	bison --version
	bison parser.y

clean:
	rm -f lexer.h lexer.c parser.h parser.c *.o *.a
