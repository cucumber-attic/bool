%{
package bool;

import bool.ast.*;
%}

%language "Java"
%name-prefix ""
%define public
%define stype "Union"
%error-verbose
%define lex_throws SyntaxError
%locations

%code {
    private Feature main;

    public Feature buildAst() throws SyntaxError {
        parse();
        return main;
    }

    private List list(Object o) {
        List list = new List();
        list.add(o);
        return list;
    }
}

%token <Token> TOKEN_TAG
%token <Token> TOKEN_FEATURE
%token <Token> TOKEN_BACKGROUND
%token <Token> TOKEN_SCENARIO
%token <Token> TOKEN_SCENARIO_OUTLINE
%token <Token> TOKEN_EXAMPLES
%token <Token> TOKEN_STEP
%token <Token> TOKEN_NAME
%token <Token> TOKEN_DESCRIPTION_LINE
%token <Token> TOKEN_DOC_STRING_LINE
%token <Token> TOKEN_PIPE
%token <Token> TOKEN_CELL
%token <Token> TOKEN_EOL

%type <Feature> main
%type <Feature> feature
%type <List> tags
%type <Tag> tag
%type <List> description_lines
%type <List> feature_elements
%type <FeatureElement> feature_element
%type <FeatureElement> background
%type <FeatureElement> scenario
%type <FeatureElement> scenario_outline
%type <List> steps
%type <Step> step
%type <List> examples_list
%type <Examples> examples
%type <MultilineArg> multiline_arg
%type <Union> table
%type <List> doc_string_lines
%type <DocString> doc_string_line
%type <List> cell_row
%type <List> cells
%type <List> cell

%%

main
    : feature
        { return $1; }
    ;

tags
    :
        { $$ = new List(); }
    | tags tag
        { $1.add($2); }
    ;

tag
    : TOKEN_TAG
        { $$ = new Tag(new Token($1, @1)); }
    ;

feature
    : tags TOKEN_FEATURE TOKEN_NAME description_lines feature_elements
        { $$ = new Feature($1, new Token($2, @2), new Token($3, @3), $4, $5); }
    ;

description_lines
    :
        { $$ = new List(); }
    | description_lines TOKEN_DESCRIPTION_LINE
        { $1.add(new Token($2, @2)); }
    ;

feature_elements
    :
        { $$ = new List(); }
    | feature_elements feature_element
        { $1.add($2); }
    ;

feature_element
    : background
    | scenario
    | scenario_outline
    ;

background
    : TOKEN_BACKGROUND TOKEN_NAME description_lines steps
        { $$ = new Background(new Token($1, @1), new Token($2, @2), $3, $4); }
    ;

scenario
    : tags TOKEN_SCENARIO TOKEN_NAME description_lines steps
        { $$ = new Scenario($1, new Token($2, @2), new Token($3, @3), $4, $5); }
    ;

scenario_outline
    : tags TOKEN_SCENARIO_OUTLINE TOKEN_NAME description_lines steps examples_list
        { $$ = new ScenarioOutline($1, new Token($2, @2), new Token($3, @3), $4, $5, $6); }
    ;

examples_list
    :
        { $$ = new List(); }
    | examples_list examples
        { $1.add($2); }
    ;

examples
    : TOKEN_EXAMPLES TOKEN_NAME description_lines table
        { $$ = new Examples(null, new Token($1, @1), new Token($2, @2), $3, new Table($4)); }
    ;

steps
    :
        { $$ = new List(); }
    | steps step
        { $1.add($2); }
    ;

step
    : TOKEN_STEP TOKEN_NAME multiline_arg
        { $$ = new Step(new Token($1, @1), new Token($2, @2), $3); }
    ;

multiline_arg
    :
        { $$ = null; }
    | doc_string_lines
        { $$ = new DocString($1); }
    | table
        { $$ = new Table($1); }
      ;

doc_string_lines
    : doc_string_lines doc_string_line
        { $1.add($2); }
    | doc_string_line
        { $$ = list($1); }
    ;

doc_string_line
    : TOKEN_DOC_STRING_LINE
        { $$ = new Token($1, @1); }
    ;

table
    : table cell_row
        { $1.add($2); }
    | cell_row
        { $$ = list($1); }
    ;

cell_row
    : cells TOKEN_PIPE TOKEN_EOL
        { $$ = $1; }
    ;

cells
    : cells cell
        { $1.add($2); }
    | cell
        { $$ = list($1); }
    ;

cell
    : TOKEN_PIPE TOKEN_CELL
        { $$ = new Token($2.getValue().trim(), @2); }
    | TOKEN_PIPE TOKEN_PIPE
        { $$ = new Token("", @2); }
    ;
%%
