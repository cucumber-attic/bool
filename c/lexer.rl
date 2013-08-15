#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "lexer.h"
#include "parser.h"

%%{
    machine lexer;
    alphtype char;

    main := |*
        [ \t\r];
        '\n'              => { ++yylloc.first_line; line_start = p + 1; };
        [A-Za-z0-9_\-@]+  => { ret = TOKEN_VAR;    fbreak; };
        '&&'              => { ret = TOKEN_AND;    fbreak; };
        '||'              => { ret = TOKEN_OR;     fbreak; };
        '!'               => { ret = TOKEN_NOT;    fbreak; };
        '('               => { ret = TOKEN_LPAREN; fbreak; };
        ')'               => { ret = TOKEN_RPAREN; fbreak; };
    *|;
}%%

%%write data noerror;

const char *p, *ts, *te, *pe, *eof, *line_start;
int cs, act, at_eof;

void scan_init(const char* data) {
    p = line_start = data;
    eof = pe = data + strlen(data);
    at_eof = 0;

    yylloc.first_line = 1;
    yylloc.first_column = 1;
    yylloc.last_line = 1;
    yylloc.last_column = 1;
    %% write init;
}

int yylex(void) {
    int ret = 0; // EOF

    if (at_eof) {
        return ret;
    }

    %% write exec;

    if (p == eof) {
        at_eof = 1;
    }

    yylloc.last_line = yylloc.first_line;

    if(ret == 0) {
        const char* prefix = "syntax error: ";
        char* message = malloc(sizeof(char) * (strlen(prefix) + pe - p + 1));
        strcpy(message, prefix);
        strcpy(message + strlen(prefix), p);

        yylloc.first_column = yylloc.last_column = (int)(p - line_start) + 1;
        yyerror(NULL, message);
    } else {
        yylloc.first_column = (int)(ts - line_start) + 1;
        yylloc.last_column  = (int)(te - line_start) + 1;

        yylval.token = create_token();
        yylval.token->value = malloc(sizeof(char) * (te - ts + 1));
        strncpy(yylval.token->value, ts, te - ts);
        yylval.token->value[te - ts] = '\0';
    }

    return ret;
}
