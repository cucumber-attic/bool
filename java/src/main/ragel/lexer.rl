package bool;

import java.io.IOException;

public class Lexer implements Parser.Lexer {
    %%{
        machine lexer;
        alphtype char;

        main := |*
            [ \r\n\t]*;
            [A-Za-z0-9_\-@]+  => {state = Parser.TOKEN_VAR;    fbreak;};
            '&&'              => {state = Parser.TOKEN_AND;    fbreak;};
            '||'              => {state = Parser.TOKEN_OR;     fbreak;};
            '!'               => {state = Parser.TOKEN_NOT;    fbreak;};
            '('               => {state = Parser.TOKEN_LPAREN; fbreak;};
            ')'               => {state = Parser.TOKEN_RPAREN; fbreak;};
        *|;
    }%%

    %%write data noerror;

    private int cs, ts, te, p, act;
    private final int pe, eof;
    private final char[] data;

    public Lexer(char[] data)  {
        this.data = data;

        pe = data.length;
        eof = pe;

        %% write init;
    }

    public Lexer(String data) {
        this(data.toCharArray());
    }

    public String yytext() {
        return new String(data, ts, te-ts);
    }

    @Override
    public Expr getLVal() {
        return new Var(yytext());
    }

    @Override
    public final int yylex() throws IOException {
        int state = -1;
        %% write exec;
        return state;
    }

    @Override
    public void yyerror(String s) {
//        throw new SyntaxError(s, lexer.getYyline() + 1, lexer.getYycolumn() + 1);
        throw new SyntaxError(s, 1000, 10000);
    }


}

