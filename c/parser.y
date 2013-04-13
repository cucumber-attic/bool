%{

#include <stdio.h>
#include "parser.h"
#include "lexer.h"
 
%}

%code requires {
#include "ast.h"
}

%output  "parser.c"
%defines "parser.h"

%parse-param { Node** node }

%error-verbose
%locations

%union {
    char* value;
    Node* node;
}
 
%token <value> TOKEN_VAR
%token TOKEN_AND
%token TOKEN_OR
%token TOKEN_NOT
%token TOKEN_LPAREN
%token TOKEN_RPAREN

%left TOKEN_OR
%left TOKEN_AND
%left UNOT

%type <node> expr

%%

input
    : expr { *node = $1; }
    ;

expr
    : TOKEN_VAR                       { $$ = create_var($1); }
    | expr TOKEN_AND expr             { $$ = create_and($1, $3); }
    | expr TOKEN_OR expr              { $$ = create_or($1, $3); }
    | TOKEN_NOT expr %prec UNOT       { $$ = create_not($2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN  { $$ = $2; }
    ;

%%

