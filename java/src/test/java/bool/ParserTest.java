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
    public void test_parse() {
        Node node = Bool.parse("foo && bar");
        assertTrue(node.accept(new Evaluator(), asList("foo", "bar")));
        assertFalse(node.accept(new Evaluator(), asList("foo")));
    }

    @Test
    public void test_parse_error() throws IOException {
        try {
            Bool.parse("" +
                    "          \n" +
                    "          \n" +
                    "  a       \n" +
                    "    ||    \n" +
                    "      c   \n" +
                    "        &&"
                    //1234567890
            );
            fail();
        } catch (SyntaxError expected) {
            assertEquals("syntax error, unexpected end of input, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN", expected.getMessage());
            assertEquals(6, expected.getFirstLine());
            assertEquals(9, expected.getFirstColumn());
            assertEquals(11, expected.getLastColumn());
        }
    }
}
