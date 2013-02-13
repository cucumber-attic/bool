UNAME := $(shell uname)
LDSHARED?=$(CC) -shared
OBJECTS = lexer.o parser.o ast.o
TEST_OBJECTS = test/test.o
CFLAGS = -fPIC -O2 -Werror -Wall -Wextra
# Keep in sync with ../Makefile
PATH := $(shell pwd)/../bison-2.7/tests:/usr/local/Cellar/flex/2.5.37/bin:$(PATH)

# http://stackoverflow.com/questions/5694228/sed-in-place-flag-that-works-both-on-mac-and-linux
ifeq ($(UNAME), Darwin)
SEDI = sed -i ''
else
SEDI = sed -i''
endif

all: libparse.o libparse.a run_tests

libparse.a: $(OBJECTS)
	$(AR) rcs $@ $(OBJECTS)

libparse.o: $(OBJECTS)
	$(CC) -shared -o $@ $(OBJECTS)

lexer.o: parser.o

run_tests: test/test
	test/test

test/test: $(TEST_OBJECTS) libparse.a
	$(CC) -o $@ test/*.o libparse.a

lexer.h lexer.c: lexer.l
	flex --version
	flex lexer.l
	# Remove warnings from lexer.c by injecting a few UNUSED macros with surgical precision.
	$(SEDI) -e 's/exit( YY_EXIT_FAILURE );/UNUSED(yyscanner);exit( YY_EXIT_FAILURE );/g' lexer.c
	$(SEDI) -e 's/return (void \*) malloc( size );/UNUSED(yyscanner);return (void *) malloc( size );/g' lexer.c
	$(SEDI) -e 's/return (void \*) realloc( (char \*) ptr, size );/UNUSED(yyscanner);return (void *) realloc( (char *) ptr, size );/g' lexer.c
	$(SEDI) -e 's/free( (char \*) ptr );/UNUSED(yyscanner);free( (char *) ptr );/g' lexer.c
	# Inject missing initializations into lexer.c with surgical precision.
	$(SEDI) -e 's/b->yy_fill_buffer = 0;/b->yy_fill_buffer = 0; b->yy_bs_lineno = 1; b->yy_bs_column = 1;/g' lexer.c
	# resolve a warning in lexer.c by casting appropriately
	$(SEDI) -e 's/for ( yyl = 0; yyl < yyleng; ++yyl )/for ( yyl = 0; yyl < (int)yyleng; ++yyl )/g' lexer.c
	$(SEDI) -e 's/for ( i = 0; i < _yybytes_len; ++i )/for ( i = 0; i < (int)_yybytes_len; ++i )/g' lexer.c

parser.h parser.c: parser.y
	bison --version
	bison parser.y

clean:
	rm -f lexer.h lexer.c parser.h parser.c *.o *.a test/test test/*.o
