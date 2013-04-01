package bool;

import org.junit.Test;

import java.io.IOException;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

public class ParserTest {

    @Test
    public void test_parse() throws IOException {
        Parser parser = new Parser(new Lexer("foo && bar"));
        Expr expr = parser.parseExpr();
        assertTrue(expr.accept(new Evaluator(), asList("foo", "bar")));
        assertFalse(expr.accept(new Evaluator(), asList("foo")));
    }

    @Test
    public void test_parse_error() throws IOException {
        Parser parser = new Parser(new Lexer("" +
                "          \n" +
                "          \n" +
                "  a       \n" +
                "    ||    \n" +
                "      c   \n" +
                "        &&"
        ));
        try {
            parser.parseExpr();
            fail();
        } catch (SyntaxError expected) {
            assertEquals("syntax error, unexpected end of input, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN", expected.getMessage());
            assertEquals(6, expected.getLine());
            assertEquals(11, expected.getColumn());
        }
    }
}
