package bool;

import java.io.IOException;

public class Lexer implements Parser.Lexer {
    %%{
        machine lexer;
        alphtype char;

        main := |*
            [ \t\r];
            '\n'              => { ++firstLine; lineStart = p + 1; };
            [A-Za-z0-9_\-@]+  => { ret = Parser.TOKEN_VAR;    fbreak; };
            '&&'              => { ret = Parser.TOKEN_AND;    fbreak; };
            '||'              => { ret = Parser.TOKEN_OR;     fbreak; };
            '!'               => { ret = Parser.TOKEN_NOT;    fbreak; };
            '('               => { ret = Parser.TOKEN_LPAREN; fbreak; };
            ')'               => { ret = Parser.TOKEN_RPAREN; fbreak; };
        *|;
    }%%

    %%write data noerror;

    private int firstLine = 1, lastLine = 1, firstColumn = 1, lastColumn = 1;
    private int lineStart = 0;

    private int cs, ts, te, p, act;
    private final int pe, eof;
    private final char[] data;
    private boolean atEof = false;

    public Lexer(char[] data)  {
        this.data = data;
        eof = pe = data.length;

        %% write init;
    }

    public Lexer(String data) {
        this(data.toCharArray());
    }

    String yytext() {
        return new String(data, ts, te-ts);
    }

    private int firstColumn() {
        return p - lineStart + 1;
    }

    @Override
    public Expr getLVal() {
        return new Var(yytext());
    }

    @Override
    public final int yylex() throws IOException {
        int ret = Parser.EOF;

        if (atEof) {
            return ret;
        }

        %% write exec;

        if (p == eof) {
            atEof = true;
        }

        lastLine = firstLine;

        if(ret == Parser.EOF) {
            firstColumn = lastColumn = p - lineStart + 1;
            yyerror("syntax error: " + new String(data, p, pe - p));
        } else {
            firstColumn = ts - lineStart + 1;
            lastColumn  = te - lineStart + 1;
        }

        return ret;
    }

    @Override
    public void yyerror(String message) {
        throw new SyntaxError(message, firstLine, lastLine, firstColumn, lastColumn);
    }
}

