%namespace Bool
%output=BoolParser.generated.cs 
%partial 
//%sharetokens
//%start list
%parsertype BoolParser
%visibility public

%YYSTYPE Expression

%token TOKEN_VAR
%token TOKEN_AND
%token TOKEN_OR
%token TOKEN_NOT
%token TOKEN_LPAREN
%token TOKEN_RPAREN

%left TOKEN_OR
%left TOKEN_AND 
%left UNOT

%%

input
    : expr  { expr = $1; }
    ;

expr
    : TOKEN_VAR                       // $$ is automatically lexer.yylval java was: { $$ = yylexer.getLVal(); }
    | expr TOKEN_AND expr             { $$ = new And($1, $3); }
    | expr TOKEN_OR expr              { $$ = new Or($1, $3); }
    | TOKEN_NOT expr %prec UNOT       { $$ = new Not($2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN  { $$ = $2; }
    ;

%%
