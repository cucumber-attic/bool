%{
package bool;

import java.io.IOException;
%}

%language "Java"
%name-prefix ""
%define public
//%define stype "Expr"
%error-verbose

%code {
    private Expr expr;

    public Parser (bool.Lexer lexer) {
        this(new LexerAdapter(lexer));
    }

    public Expr parseExpr() throws SyntaxError, IOException {
        parse();
        return expr;
    }
}

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
    : expr  { expr = (Expr)$1; }
    ;

expr
    : TOKEN_VAR                       { $$ = yylexer.getLVal(); }
    | expr TOKEN_AND expr             { $$ = new And((String)$2, (Expr)$1, (Expr)$3); }
    | expr TOKEN_OR expr              { $$ = new Or((String)$2, (Expr)$1, (Expr)$3); }
    | TOKEN_NOT expr %prec UNOT       { $$ = new Not((String)$1, (Expr)$2); }
    | TOKEN_LPAREN expr TOKEN_RPAREN  { $$ = $2; }
    ;

%%
