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
	# http://stackoverflow.com/questions/1251999/sed-how-can-i-replace-a-newline-n
	sed -e ':a' -e 'N' -e '$$!ba' -e 's/ yyscanner)\n{/ yyscanner) { UNUSED(yyscanner);/g' lexer.c > lexer.c.nowarn
	mv lexer.c.nowarn lexer.c

parser.h parser.c: parser.y
	bison --version
	bison parser.y

clean:
	rm -f lexer.h lexer.c parser.h parser.c *.o *.a
