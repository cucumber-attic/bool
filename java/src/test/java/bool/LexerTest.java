package bool;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.util.Collection;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class LexerTest {
    private final Lexer lexer;

    @Parameterized.Parameters
    public static Collection<Object[]> data() {
        return asList(new Object[][]{
                {new JFlexLexer("foo && bar")},
                {new RagelLexer("foo && bar")},
        });
    }

    public LexerTest(Lexer lexer) {
        this.lexer = lexer;
    }

    @Test
    public void test_lex() throws IOException {
        assertEquals(Parser.TOKEN_VAR, lexer.lex());
        assertEquals("foo", lexer.text());

        assertEquals(Parser.TOKEN_AND, lexer.lex());
        assertEquals("&&", lexer.text());

        assertEquals(Parser.TOKEN_VAR, lexer.lex());
        assertEquals("bar", lexer.text());
    }
}
