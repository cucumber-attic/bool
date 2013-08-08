package bool;

import bool.ast.*;

public class Lexer implements Parser.Lexer {
    %%{
        machine lexer;
        alphtype char;

        crlf     = '\n';
        feature  = 'Feature:';
        step     = 'Given ' | 'When '| 'Then ' | 'And ' | 'But ';
        tag      = '@'[a-z]+;
        description_line = 'xxxx';

        name := |*
            (any -- crlf)*     => { fnext main; ret = Parser.TOKEN_NAME; fbreak; };
        *|;

        after_keyword := |*
            [ ]+              => { fnext name; };
            empty             => { fnext name; };
        *|;

        main := |*
            [ \t\r];
            '\n'              => { ++firstLine; lineStart = p + 1; };
            tag               => { ret = Parser.TOKEN_TAG; fbreak; };
            feature           => { fnext after_keyword; ret = Parser.TOKEN_FEATURE; fbreak; };
            step              => { fnext name; ret = Parser.TOKEN_STEP; fbreak; };
            description_line  => { ret = Parser.TOKEN_DESCRIPTION_LINE; fbreak; };
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
            yytext = new String(data, p, pe - p);
            String message = "syntax error: " + yytext;
            firstColumn = lastColumn = p - lineStart + 1;
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
