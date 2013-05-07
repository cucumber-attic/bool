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
  	: TOKEN_STEP TOKEN_NAME multiline_arg
        { $$ = new ast.Step(new ast.Token($1), new ast.Token($2), $3); }
  	;

multiline_arg
  	:
    | doc_string
    | table
        { $$ = new ast.DataTable($1); }
  	;

doc_string
	: TOKEN_TREBLE_QUOTE TOKEN_DOC_STRING TOKEN_TREBLE_QUOTE
		{ $$ = new ast.DocString($2.substr($2.indexOf('\n')+1)); }
	;

table
    : table cell_row
        { $1.push($2); }
    | cell_row
        { $$ = [$1]; }
    ;

cell_row
    : cells TOKEN_EOL
        { $$ = new ast.CellRow($1); }
    ;

cells
    : cells cell
        { $1.push($2); }
    | cell
        { $$ = [$1]; }
    ;

cell
    : TOKEN_CELL TOKEN_PIPE
        {
            var cell_value = new ast.Token($1.trim());
            $$ = new ast.Cell(cell_value);
        }
    | TOKEN_PIPE
        {
            var cell_value = new ast.Token('');
            $$ = new ast.Cell(cell_value);
        }
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
