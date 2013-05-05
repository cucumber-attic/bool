%token TOKEN_FEATURE
%token TOKEN_SCENARIO
%token TOKEN_NAME

%start main

%%

main
  : feature EOF      { return $1; }
  ;

feature
  : TOKEN_FEATURE TOKEN_NAME description_lines feature_elements
    { $$ = new ast.Feature(new ast.Token($1), new ast.Token($2), $3, $4); }
  ;

description_lines
    :
      { $$ = []; }
    | description_lines TOKEN_DESCRIPTION_LINE
      { $1.push(new ast.Token($2)); }
    ;

feature_elements
    :
      { $$ = []; }
    | feature_elements feature_element
      { $1.push($2); }
    ;

feature_element
    : scenario
    ;

scenario
  : TOKEN_SCENARIO TOKEN_NAME description_lines steps
    { $$ = new ast.Scenario(new ast.Token($1), new ast.Token($2), $3, $4); }
  ;

steps
	:
      { $$ = []; }
    | steps step
      { $1.push($2); }
    ;

step
  : TOKEN_STEP TOKEN_NAME
    { $$ = new ast.Step(new ast.Token($1), new ast.Token($2)); }
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
