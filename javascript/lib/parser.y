%token TOKEN_VAR
%token TOKEN_AND
%token TOKEN_OR
%token TOKEN_NOT
%token TOKEN_LPAREN
%token TOKEN_RPAREN

%left TOKEN_OR
%left TOKEN_AND
%left UNOT

%start expressions

%%

expressions
    : expr EOF      { return $1; }
    ;

expr
    : TOKEN_VAR                       { $$ = new ast.Var(new ast.Token($1)); }
    | expr TOKEN_AND expr             { $$ = new ast.And(new ast.Token($2), $1, $3); }
    | expr TOKEN_OR expr              { $$ = new ast.Or(new ast.Token($2), $1, $3); }
    | TOKEN_NOT expr %prec UNOT       { $$ = new ast.Not(new ast.Token($1), $2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN  { $$ = $2; }
    ;

%%

// Load our AST code
var ast = require('./ast');

// Install more detailed error reporting
var SyntaxError = require('./syntax_error');
parser.parseError = function parseError(message, hash) {
    throw new SyntaxError(message, hash);
};

// Hook up our lexer
var lexer = require('./lexer');
parser.lexer = lexer;
