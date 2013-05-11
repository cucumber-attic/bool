%token TOKEN_FEATURE
%token TOKEN_SCENARIO
%token TOKEN_NAME

%start main

%%

main
    : feature EOF      { return $1; }
    ;

tags
    :
        { $$ = []; }
    | tags tag
        { $1.push($2); }
    ;

tag
    : TOKEN_TAG
        { $$ = new ast.Tag(new ast.Token($1, [@1])); }
    ;

feature
    : tags TOKEN_FEATURE TOKEN_NAME description_lines feature_elements
        { $$ = new ast.Feature($1, new ast.Token($2, [@2]), new ast.Token($3, [@3]), $4, $5); }
    ;

description_lines
    :
        { $$ = []; }
    | description_lines TOKEN_DESCRIPTION_LINE
        { $1.push(new ast.Token($2, [@2])); }
    ;

feature_elements
    :
        { $$ = []; }
    | feature_elements feature_element
        { $1.push($2); }
    ;

feature_element
    : background
    | scenario
    | scenario_outline
    ;

background
    : TOKEN_BACKGROUND TOKEN_NAME description_lines steps
        { $$ = new ast.Background(new ast.Token($1, [@1]), new ast.Token($2, [@2]), $3, $4); }
    ;

scenario
    : tags TOKEN_SCENARIO TOKEN_NAME description_lines steps
        { $$ = new ast.Scenario($1, new ast.Token($2, [@2]), new ast.Token($3, [@3]), $4, $5); }
    ;

scenario_outline
    : tags TOKEN_SCENARIO_OUTLINE TOKEN_NAME description_lines steps examples_list
        { $$ = new ast.ScenarioOutline($1, new ast.Token($2, [@2]), new ast.Token($3, [@3]), $4, $5, $6); }
    ;

examples_list
    :
        { $$ = []; }
    | examples_list examples
        { $1.push($2); }
    ;

examples
    : TOKEN_EXAMPLES TOKEN_NAME description_lines table
        { $$ = new ast.Examples([], new ast.Token($1, [@1]), new ast.Token($2, [@2]), $3, new ast.Table($4)); }
    ;

steps
    :
        { $$ = []; }
    | steps step
        { $1.push($2); }
    ;

step
    : TOKEN_STEP TOKEN_NAME multiline_arg
        { $$ = new ast.Step(new ast.Token($1, [@1]), new ast.Token($2, [@2]), $3); }
    ;

multiline_arg
    :
    | doc_string_lines
        { $$ = new ast.DocString($1); }
    | table
        { $$ = new ast.Table($1); }
      ;

doc_string_lines
    : doc_string_lines doc_string_line
        { $1.push($2); }
    | doc_string_line
        { $$ = [$1]; }
    ;

doc_string_line
    : TOKEN_DOC_STRING_LINE
        { $$ = new ast.Token($1, [@1]); }
    ;

table
    : table cell_row
        { $1.push($2); }
    | cell_row
        { $$ = [$1]; }
    ;

cell_row
    : cells TOKEN_PIPE TOKEN_EOL
        { $$ = $1; }
    ;

cells
    : cells cell
        { $1.push($2); }
    | cell
        { $$ = [$1]; }
    ;

cell
    : TOKEN_PIPE TOKEN_CELL
        {
            $$ = new ast.Token($2.trim(), [@2]);
        }
    | TOKEN_PIPE TOKEN_PIPE
        {
            $$ = new ast.Token('', [@2]);
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
