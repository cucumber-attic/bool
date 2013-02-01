package bool;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;

%%

%public
%class Lexer
%byaccj
%unicode
%column

%{
    public Lexer(String expr) {
        this(new StringReader(expr));
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

