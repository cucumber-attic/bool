LDSHARED?=$(CC) -shared
OBJECTS = lexer.o parser.o bool_ast.o
CFLAGS = -O2 -fPIC

all: libbool.o libbool.a

libbool.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)

libbool.o: $(OBJECTS)
	$(CC) -shared -o $@ $(OBJECTS)

lexer.o: parser.o
nodes.o: nodes.h

lexer.h lexer.c: lexer.l
	flex lexer.l

parser.h parser.c: parser.y
	bison parser.y

clean:
	rm -f lexer.h lexer.c parser.h parser.c *.o *.a

