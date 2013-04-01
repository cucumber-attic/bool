package bool;

import java.io.IOException;

public class Lexer implements Parser.Lexer {
    %%{
        machine lexer;
        alphtype char;

        main := |*
            [ \t\r];
            '\n'              => { lineNumber++; line_start = p + 1; };
            [A-Za-z0-9_\-@]+  => { ret = Parser.TOKEN_VAR;    fbreak; };
            '&&'              => { ret = Parser.TOKEN_AND;    fbreak; };
            '||'              => { ret = Parser.TOKEN_OR;     fbreak; };
            '!'               => { ret = Parser.TOKEN_NOT;    fbreak; };
            '('               => { ret = Parser.TOKEN_LPAREN; fbreak; };
            ')'               => { ret = Parser.TOKEN_RPAREN; fbreak; };
        *|;
    }%%

    %%write data noerror;

    private int lineNumber = 1;
    private int line_start = 0;

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

    String yytext() {
        return new String(data, ts, te-ts);
    }

    private int columnNumber() {
        return p - line_start + 1;
    }

    public String remaining() {
        return new String(data, p, pe-p);
    }

    @Override
    public Expr getLVal() {
        return new Var(yytext());
    }

    @Override
    public final int yylex() throws IOException {
        int ret = Parser.EOF;
        %% write exec;

        if(cs < lexer_first_final) {
            yyerror("syntax error: " + remaining());
        }

        return ret;
    }

    @Override
    public void yyerror(String message) {
        throw new SyntaxError(message, lineNumber, columnNumber());
    }
}

