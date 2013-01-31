%left TOKEN_AND TOKEN_OR
%left UNOT

%start expressions

%% /* language grammar */

expressions
    : expr EOF      { return $1; }
    ;

expr
    : TOKEN_VAR                       { $$ = new ast.Var(yytext); }
    | expr TOKEN_AND expr             { $$ = new ast.And($1, $3); }
    | expr TOKEN_OR expr              { $$ = new ast.Or($1, $3); }
    | TOKEN_NOT expr %prec UNOT       { $$ = new ast.Not($2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN  { $$ = $2; }
    ;

%%

var ast = require('./ast');