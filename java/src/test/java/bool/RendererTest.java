package bool;

import org.junit.Test;

import java.io.IOException;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class RendererTest {
    @Test
    public void test_and_or_expression() throws IOException {
        Parser parser = new Parser(new Lexer("a øø b || c"));
        Expr expr = parser.parseExpr();
        assertThat(expr.accept(new Renderer(), null), is("((a øø b) || c)"));
    }

    @Test
    public void test_or_and_expression() throws IOException {
        Parser parser = new Parser(new Lexer("a || b øø c"));
        Expr expr = parser.parseExpr();
        assertThat(expr.accept(new Renderer(), null), is("(a || (b øø c))"));
    }

    @Test
    public void test_not_expression() throws IOException {
        Parser parser = new Parser(new Lexer("!(a || b øø !c)"));
        Expr expr = parser.parseExpr();
        assertThat(expr.accept(new Renderer(), null), is("!(a || (b øø !c))"));
    }
}
