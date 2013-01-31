package bool;

import java.io.IOException;

public class RagelLexer implements Lexer {
    %%{
        machine lexer;
        alphtype char;

        main := |*
            [ \t\n];
            [a-z]+  => {state = Parser.TOKEN_VAR;    fbreak;};
            '&&'    => {state = Parser.TOKEN_AND;    fbreak;};
            '||'    => {state = Parser.TOKEN_OR;     fbreak;};
            '!'     => {state = Parser.TOKEN_NOT;    fbreak;};
            '('     => {state = Parser.TOKEN_LPAREN; fbreak;};
            ')'     => {state = Parser.TOKEN_RPAREN; fbreak;};
        *|;
    }%%

    %%write data noerror;

    private int cs, ts, te, p, act;
    private final int pe, eof;
    private final char[] data;

    public RagelLexer(char[] data)  {
        this.data = data;

        pe = data.length;
        eof = pe;

        %% write init;
    }

    public RagelLexer(String data) {
        this(data.toCharArray());
    }

    @Override
    public final int lex() throws IOException {
        int state = -1;
        %% write exec;
        return state;
    }

    @Override
    public String text() {
        return new String(data, ts, te-ts);
    }
}
