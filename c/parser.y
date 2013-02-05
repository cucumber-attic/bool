%{

#include "parser.h"
#include "lexer.h"
 
void yyerror(yyscan_t scanner, Node** node, const char* msg);
 
%}

%code requires {

#include "ast.h"
#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif

}
 
%output  "parser.c"
%defines "parser.h"
 
%define api.pure
%lex-param   { yyscan_t scanner }
%parse-param { Node** node }
%parse-param { yyscan_t scanner }

%error-verbose
/* %locations */
 
%union {
    char* value;
    Node* node;
}
 
%left TOKEN_OR
%left TOKEN_AND
%left UNOT
 
%token <value> TOKEN_VAR
%token TOKEN_AND
%token TOKEN_OR
%token TOKEN_NOT
%token TOKEN_LPAREN
%token TOKEN_RPAREN
%token TOKEN_ERROR

%type <node> expr
 
%%
 
input
    : expr  { *node = $1; }
    ;
 
expr
    : TOKEN_VAR                       { $$ = create_var($1); }
    | expr TOKEN_AND expr             { $$ = create_and($1, $3); }
    | expr TOKEN_OR expr              { $$ = create_or($1, $3); }
    | TOKEN_NOT expr %prec UNOT       { $$ = create_not($2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN  { $$ = $2; }
    ;
 
%%
