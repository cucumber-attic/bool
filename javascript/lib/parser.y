%token TOKEN_FEATURE
%token TOKEN_NAME

%start main

%%

main
  : feature EOF      { return $1; }
  ;

feature
  : TOKEN_FEATURE TOKEN_NAME description_lines
    { $$ = new ast.Feature(new ast.Token($1), new ast.Token($2), $3); }
  ;

description_lines
    : description_lines TOKEN_DESCRIPTION_LINE
      { $1.push(new ast.Token($2)); }
    | TOKEN_DESCRIPTION_LINE
      { $$ = [new ast.Token($1)]; }
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
