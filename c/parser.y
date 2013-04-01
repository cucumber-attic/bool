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
    Token* token;
    Node* node;
}
 
%token <token> TOKEN_VAR
%token <token> TOKEN_AND
%token <token> TOKEN_OR
%token <token> TOKEN_NOT
%token <token> TOKEN_LPAREN
%token <token> TOKEN_RPAREN

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
    | expr TOKEN_AND expr             { $$ = create_and($2, $1, $3); }
    | expr TOKEN_OR expr              { $$ = create_or($2, $1, $3); }
    | TOKEN_NOT expr %prec UNOT       { $$ = create_not($1, $2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN  { $$ = $2; }
    ;

%%

