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
char *pe;
char *ts;
char *te;
char *eof;
int cs;
int act;

void scan_init(char* data) {
    p = data;

    yylloc.first_line = 1;
    %% write init;
}

char* yytext(void) {
    return strndup(ts, te-ts);
}

int yylex(void) {
    int ret = -1;
    %% write exec;

    yylval.value = yytext();

    if(cs < lexer_first_final) {
        last_error.token = yytext();
        yyerror(NULL, yytext());
    }

    return ret;
}
