%{
#define YY_NO_INPUT
#include "parser.h"
%}

%option outfile="lexer.c" header-file="lexer.h"
%option warn
%option reentrant noyywrap never-interactive nounistd
%option nounput
%option bison-bridge

%%

[ \r\n\t]*             { /* Skip blanks. */ }
[A-Za-z0-9_\-@]+       { yylval->value = strdup(yytext); return TOKEN_VAR; }
"&&"                   { return TOKEN_AND; }
"||"                   { return TOKEN_OR; }
"!"                    { return TOKEN_NOT; }
"("                    { return TOKEN_LPAREN; }
")"                    { return TOKEN_RPAREN; }

%%
