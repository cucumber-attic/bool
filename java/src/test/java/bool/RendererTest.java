package bool;

import static org.hamcrest.MatcherAssert.*;
import static org.hamcrest.CoreMatchers.*;
import org.junit.Test;
import java.io.IOException;

public class RendererTest {
    @Test
    public void test_and_or_expression() throws IOException {
        Parser parser = new Parser(new Lexer("a && b || c"));
        Expr expr = parser.parseExpr();
        assertThat(expr.describeTo(new Renderer(), null), is("((a && b) || c)"));

    }

    @Test
    public void test_or_and_expression() throws IOException {
        Parser parser = new Parser(new Lexer("a || b && c"));
        Expr expr = parser.parseExpr();
        assertThat(expr.describeTo(new Renderer(), null), is("(a || (b && c))"));
    }

    @Test
    public void test_not_expression() throws IOException {
        Parser parser = new Parser(new Lexer("!(a || b && !c)"));
        Expr expr = parser.parseExpr();
        assertThat(expr.describeTo(new Renderer(), null), is("!(a || (b && !c))"));
    }
}
