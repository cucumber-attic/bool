package bool;

import java.io.IOException;

class LexerAdapter implements Parser.Lexer {
    private final Lexer lexer;

    public LexerAdapter(Lexer lexer) {
        this.lexer = lexer;
    }

    @Override
    public Expr getLVal() {
        return new Var(lexer.text());
    }

    @Override
    public int yylex() throws IOException {
        return lexer.lex();
    }

    @Override
    public void yyerror(String s) {
        throw new ParseException(s);
    }
}
