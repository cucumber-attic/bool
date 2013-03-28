#include <string.h>
#include <stdio.h>
#include "parser.h"

%%{
    machine lexer;
    alphtype char;

    main := |*
        [ \t]*;
        ('\n' | '\r\n')   => {};
        [A-Za-z0-9_\-@]+  => { state = TOKEN_VAR;    fbreak; };
        '&&'              => { state = TOKEN_AND;    fbreak; };
        '||'              => { state = TOKEN_OR;     fbreak; };
        '!'               => { state = TOKEN_NOT;    fbreak; };
        '('               => { state = TOKEN_LPAREN; fbreak; };
        ')'               => { state = TOKEN_RPAREN; fbreak; };
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

void scan_init(char* data)  {
    p = data;

    %% write init;
}

char* yytext(void) {
    return strndup(ts, te-ts);
}

int yylex(void) {
    int state = -1;
    %% write exec;

    if(cs < lexer_first_final) {
        //yyerror("syntax error: " + remaining());
    }

    yylval.value = yytext();

    return state;
}
