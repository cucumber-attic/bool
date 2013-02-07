%{
#include "unused.h"
#define YY_NO_INPUT
#include "parser.h"

#define YY_USER_ACTION yylloc->first_line = yylloc->last_line = yylineno; \
    yylloc->first_column = yycolumn; yylloc->last_column = yycolumn + (int)yyleng - 1; \
    yycolumn += (int)yyleng;

%}

%option yylineno
%option outfile="lexer.c" header-file="lexer.h"
%option warn
%option reentrant noyywrap never-interactive nounistd
%option nounput
%option bison-bridge
%option bison-locations

%%

[ \n\r\t]*             { /* Skip blanks. */ }
[A-Za-z0-9_\-@]+       { yylval->value = strdup(yytext); return TOKEN_VAR; }
"&&"                   { return TOKEN_AND; }
"||"                   { return TOKEN_OR; }
"!"                    { return TOKEN_NOT; }
"("                    { return TOKEN_LPAREN; }
")"                    { return TOKEN_RPAREN; }

%%
