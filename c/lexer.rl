#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "lexer.h"
#include "parser.h"

%%{
    machine lexer;
    alphtype char;

    main := |*
        [ \t\r]*;
        '\n'              => { ++yylloc.first_line; };
        [A-Za-z0-9_\-@]+  => { ret = TOKEN_VAR;    fbreak; };
        '&&'              => { ret = TOKEN_AND;    fbreak; };
        '||'              => { ret = TOKEN_OR;     fbreak; };
        '!'               => { ret = TOKEN_NOT;    fbreak; };
        '('               => { ret = TOKEN_LPAREN; fbreak; };
        ')'               => { ret = TOKEN_RPAREN; fbreak; };
    *|;
}%%

%%write data noerror;

char *p;
char *ts;
char *te;
const char *pe;
const char *eof;
int cs;
int act;
int data_len;

int at_eof;

void scan_init(char* data) {
    p = data;
    eof = pe = data + strlen(data);
    at_eof = 0;

    yylloc.first_line = 1;
    %% write init;
}

char* yytext(void) {
    return strndup(ts, te-ts);
}

int yylex(void) {
    int ret = 0;

    if (at_eof) {
        return ret;
    }

    %% write exec;

    if (p == eof) {
        at_eof = 1;
    }

    if(ret == 0) {
        char* prefix = "Unexpected: ";
        char* unexp = strndup(p, pe-p);
        
        char* message = malloc(sizeof(char) * (strlen(prefix) + strlen(unexp) + 1));
        sprintf(message, "%s%s", prefix, unexp);
        yyerror(NULL, message);
        yylval.value = NULL;
    } else {
        yylval.value = yytext();
    }

    return ret;
}
