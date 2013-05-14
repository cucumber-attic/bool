package bool;

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

    private String yytext = null;
    private boolean atEof = false;

    public Lexer(char[] data)  {
        this.data = data;
        eof = pe = data.length;

        %% write init;
    }

    public Lexer(String data) {
        this(data.toCharArray());
    }

    @Override
    public Position getStartPos() {
        return new Position(firstLine, firstColumn);
    }

    @Override
    public Position getEndPos() {
        return new Position(lastLine, lastColumn);
    }

    @Override
    public Token getLVal() {
        return new Token(yytext, firstLine, firstColumn, lastLine, lastColumn);
    }

    @Override
    public final int yylex() {
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
            yytext = new String(data, p, pe - p);
            String message = "syntax error: " + yytext;
            throw new SyntaxError(message, firstLine, firstColumn, lastLine, lastColumn);
        } else {
            firstColumn = ts - lineStart + 1;
            lastColumn  = te - lineStart + 1;
            yytext = new String(data, ts, te-ts);
        }

        return ret;
    }

    @Override
    public void yyerror(Parser.Location location, String message) {
        throw new SyntaxError(message, location.begin.getLine(), location.begin.getColumn(), location.end.getLine(), location.end.getColumn());
    }
}

