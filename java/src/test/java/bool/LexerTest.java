package bool;

import bool.ast.Token;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class LexerTest {
    @Test
    public void test_simple_lex() throws IOException {
        Lexer lexer = new Lexer("foo && bar");
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("foo", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("bar", getToken(lexer).getValue());
    }

    private Token getToken(Lexer lexer) {
        return ((Token)lexer.getLVal());
    }

    @Test
    public void test_less_simple_lex() throws IOException {
        Lexer lexer = new Lexer("a && b && (!c || !d)");
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("a", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("b", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_LPAREN, lexer.yylex());
        assertEquals("(", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
        assertEquals("!", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("c", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_OR, lexer.yylex());
        assertEquals("||", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
        assertEquals("!", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("d", getToken(lexer).getValue());

        assertEquals(Parser.TOKEN_RPAREN, lexer.yylex());
        assertEquals(")", getToken(lexer).getValue());
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
            assertEquals(4, expected.getToken().getFirstLine());
            assertEquals(5, expected.getToken().getFirstColumn());
            assertEquals(5, expected.getToken().getLastColumn());
        }
    }
}
