UNAME := $(shell uname)
LDSHARED?=$(CC) -shared
OBJECTS = lexer.o parser.o ast.o
TEST_OBJECTS = test/test.o
CFLAGS = -fPIC -O2 -Werror -Wall -Wextra

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
	$(CC) --version
	$(CC) -shared -o $@ $(OBJECTS)

lexer.o: parser.o

run_tests: test/test
	test/test

test/test: $(TEST_OBJECTS) libparse.a
	$(CC) -o $@ test/*.o libparse.a

lexer.h lexer.c: lexer.l
	../flex lexer.l
	
	# Modify flex-generated lexer.c with surgical precision.

	# Remove warnings
	$(SEDI) -e 's/exit( YY_EXIT_FAILURE );/UNUSED(yyscanner);exit( YY_EXIT_FAILURE );/g' lexer.c
	$(SEDI) -e 's/return (void \*) malloc( size );/UNUSED(yyscanner);return (void *) malloc( size );/g' lexer.c
	$(SEDI) -e 's/return (void \*) realloc( (char \*) ptr, size );/UNUSED(yyscanner);return (void *) realloc( (char *) ptr, size );/g' lexer.c
	$(SEDI) -e 's/free( (char \*) ptr );/UNUSED(yyscanner);free( (char *) ptr );/g' lexer.c
	# Inject missing initializations
	$(SEDI) -e 's/b->yy_fill_buffer = 0;/b->yy_fill_buffer = 0; b->yy_bs_lineno = 1; b->yy_bs_column = 1;/g' lexer.c

	# Resolve a warning by casting appropriately
	$(SEDI) -e 's/for ( yyl = 0; yyl < yyleng; ++yyl )/for ( yyl = 0; yyl < (int)yyleng; ++yyl )/g' lexer.c
	$(SEDI) -e 's/for ( i = 0; i < _yybytes_len; ++i )/for ( i = 0; i < (int)_yybytes_len; ++i )/g' lexer.c

parser.h parser.c: parser.y
	../bison parser.y

clean:
	rm -f lexer.h lexer.c parser.h parser.c *.o *.a test/test test/*.o

