package bool;

import bool.ast.*;

public class Lexer implements Parser.Lexer {
    %%{
        machine lexer;
        alphtype char;

        crlf              = '\n';

        feature           = 'Feature:';
        background        = 'Background:';
        scenario          = 'Scenario:';
        scenario_outline  = 'Scenario Outline:';
        examples          = 'Examples:';
        step              = 'Given ' | 'When '| 'Then ' | 'And ' | 'But ';
        tag               = '@'alpha+;
        doc_string_delim  = '"""';

        main := |*
            [ \t\r]                            ;
            crlf                               ;
            tag                             => { fnext tags; ret = TOKEN_TAG; fbreak; };
            feature                         => { fnext after_keyword; ret = TOKEN_FEATURE; fbreak; };
            background                      => { fnext after_keyword; ret = TOKEN_BACKGROUND; fbreak; };
            scenario                        => { fnext after_keyword; ret = TOKEN_SCENARIO; fbreak; };
            scenario_outline                => { fnext after_keyword; ret = TOKEN_SCENARIO_OUTLINE; fbreak; };
            examples                        => { fnext after_keyword; ret = TOKEN_EXAMPLES; fbreak; };
            step                            => { fnext after_keyword; ret = TOKEN_STEP; fbreak; };
            doc_string_delim . [ ]* . crlf  => { fnext doc_string; };
            '|'                             => { fnext cell; ret = TOKEN_PIPE; fbreak; };
            any                             => { fhold; fnext description_line; };
        *|;

        tags := |*
            [ ]                                ;
            crlf                            => { fnext main; };
            tag                             => { ret = TOKEN_TAG; fbreak; };
        *|;

        after_keyword := |*
            [ ]                                ;
            (any -- [ ])                    => { fhold; fnext name; };
        *|;

        name := |*
            (any -- crlf)*                  => { fnext main; ret = TOKEN_NAME; fbreak; };
        *|;

        doc_string := |*
            [ ]* . doc_string_delim         => { fnext main; };
            any                             => { fhold; fnext doc_string_line; };
        *|;

        doc_string_line := |*
            (any -- crlf)* . crlf           => { fnext doc_string; ret = TOKEN_DOC_STRING_LINE; fbreak; };
        *|;

        cell := |*
            crlf                            => { fnext main; ret = TOKEN_EOL; fbreak; };
            '|' . [ ]*                      => { ret = TOKEN_PIPE; fbreak; };
            [^\|\n]*                        => { ret = TOKEN_CELL; fbreak; };
        *|;

        description_line := |*
            (any -- crlf)*                  => { fnext main; ret = TOKEN_DESCRIPTION_LINE; fbreak; };
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
        int ret = -1;

        if (p == eof) {
            return EOF;
        }

        %% write exec;

        lastLine = firstLine;

        if (ret == -1) {
            if (p == eof) {
                return EOF; // reached EOF without generating any token
            }
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
