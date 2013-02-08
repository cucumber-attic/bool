package bool;

import java.io.IOException;

class LexerAdapter implements Parser.Lexer {
    private final Lexer lexer;

    public LexerAdapter(Lexer lexer) {
        this.lexer = lexer;
    }

    @Override
    public Expr getLVal() {
        return new Var(lexer.yytext());
    }

    @Override
    public int yylex() throws IOException {
        return lexer.yylex();
    }

    @Override
    public void yyerror(String s) {
        throw new SyntaxError(s, lexer.getYyline() + 1, lexer.getYycolumn() + 1);
    }
}
