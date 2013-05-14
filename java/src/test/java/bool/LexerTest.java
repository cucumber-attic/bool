package bool;

import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class LexerTest {
    @Test
    public void test_simple_lex() throws IOException {
        Lexer lexer = new Lexer("foo && bar");
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("foo", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("bar", lexer.getLVal().getValue());
    }

    @Test
    public void test_less_simple_lex() throws IOException {
        Lexer lexer = new Lexer("a && b && (!c || !d)");
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("a", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("b", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_LPAREN, lexer.yylex());
        assertEquals("(", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
        assertEquals("!", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("c", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_OR, lexer.yylex());
        assertEquals("||", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
        assertEquals("!", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("d", lexer.getLVal().getValue());

        assertEquals(Parser.TOKEN_RPAREN, lexer.yylex());
        assertEquals(")", lexer.getLVal().getValue());
    }

    @Test
    public void test_lex_error() throws IOException {
        Lexer lexer = new Lexer("" +
                "          \n" +
                "          \n" +
                "  a       \n" +
                "    ?     \n"
        );
        lexer.yylex();
        try {
            lexer.yylex();
            fail();
        } catch (SyntaxError expected) {
            assertEquals("syntax error: ?     \n", expected.getMessage());
            assertEquals(4, expected.startPos.line);
            assertEquals(5, expected.startPos.column);
            assertEquals(5, expected.endPos.column);
        }
    }
}
