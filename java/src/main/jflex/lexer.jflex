package bool;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;

%%

%public
%class Lexer
%byaccj
%unicode
%line
%column

%{
    public Lexer(String expr) {
        this(new StringReader(expr));
    }

    public int getYyline() {
        return yyline;
    }

    public int getYycolumn() {
        return yycolumn;
    }
%}

%%

[ \r\n\t]*            { /* skip whitespace */ }
[A-Za-z0-9_\-@]+      { return Parser.TOKEN_VAR; }
"&&"                  { return Parser.TOKEN_AND; }
"||"                  { return Parser.TOKEN_OR; }
"!"                   { return Parser.TOKEN_NOT; }
"("                   { return Parser.TOKEN_LPAREN; }
")"                   { return Parser.TOKEN_RPAREN; }
.                     { // Both yyline and yycolumn start at 0 in JFlex. With Flex yylineno starts at 1 and yycolumn at 0.
                        // Here we define the flex equivalent of first_line and last_token. We add 1 to yyline to make it
                        // 1-indexed. We add 1 to yycolumn to make it point to the last column (we know . is just one character).
                        throw new SyntaxError("Unexpected character: " + yytext(), yyline + 1, yycolumn); }