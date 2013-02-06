UNAME := $(shell uname)
LDSHARED?=$(CC) -shared
OBJECTS = lexer.o parser.o ast.o
CFLAGS = -fPIC -O2 -Werror -Wall -Wunused-parameter
# Keep in sync with ../Makefile
PATH := $(shell pwd)/../bison-2.7/tests:$(PATH)

# http://stackoverflow.com/questions/5694228/sed-in-place-flag-that-works-both-on-mac-and-linux
ifeq ($(UNAME), Darwin)
ISED = sed -i ''
else
ISED = sed -i''
endif

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
	# Remove warnings from lexer.c by injecting a few UNUSED macros with surgical precision.
	$(ISED) -e 's/exit( YY_EXIT_FAILURE );/UNUSED(yyscanner);exit( YY_EXIT_FAILURE );/g' lexer.c
	$(ISED) -e 's/return (void \*) malloc( size );/UNUSED(yyscanner);return (void *) malloc( size );/g' lexer.c
	$(ISED) -e 's/return (void \*) realloc( (char \*) ptr, size );/UNUSED(yyscanner);return (void *) realloc( (char *) ptr, size );/g' lexer.c
	$(ISED) -e 's/free( (char \*) ptr );/UNUSED(yyscanner);free( (char *) ptr );/g' lexer.c

parser.h parser.c: parser.y
	bison --version
	bison parser.y

clean:
	rm -f lexer.h lexer.c parser.h parser.c *.o *.a
