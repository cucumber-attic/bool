package bool;

import java.io.IOException;

public class Lexer implements Parser.Lexer {
    %%{
        machine lexer;
        alphtype char;

        main := |*
            [ \t]*;
            ('\n' | '\r\n')   => {lineNumber++; lastNewline = p + 1;};
            [A-Za-z0-9_\-@]+  => {state = Parser.TOKEN_VAR;    fbreak;};
            '&&'              => {state = Parser.TOKEN_AND;    fbreak;};
            '||'              => {state = Parser.TOKEN_OR;     fbreak;};
            '!'               => {state = Parser.TOKEN_NOT;    fbreak;};
            '('               => {state = Parser.TOKEN_LPAREN; fbreak;};
            ')'               => {state = Parser.TOKEN_RPAREN; fbreak;};
        *|;
    }%%

    %%write data noerror;

    private int lineNumber = 1;
    private int lastNewline = 0;

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

    public int getLineNumber() {
        return lineNumber;
    }

    public int getColumnNumber() {
        return p - lastNewline;
    }

    public String remaining() {
        return new String(data, p, data.length-p);
    }

    @Override
    public Expr getLVal() {
        return new Var(yytext());
    }

    @Override
    public final int yylex() throws IOException {
        int state = -1;
        %% write exec;

        if(cs < lexer_first_final) {
            yyerror("syntax error: " + remaining());
        }

        return state;
    }

    @Override
    public void yyerror(String message) {
        throw new SyntaxError(message, getLineNumber(), getColumnNumber());
    }


}

