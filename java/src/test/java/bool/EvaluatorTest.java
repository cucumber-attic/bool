package bool;

import org.junit.Test;

import java.io.IOException;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertTrue;

public class EvaluatorTest {
    @Test
    public void test_and_or_expression() throws IOException {
        Parser parser = new Parser(new Lexer("a && b || c"));
        Expr expr = parser.parseExpr();
        assertTrue(expr.accept(new Evaluator(), asList("a", "b")));
        assertTrue(expr.accept(new Evaluator(), asList("a", "c")));
    }

    @Test
    public void test_or_and_expression() throws IOException {
        Parser parser = new Parser(new Lexer("a || b && c"));
        Expr expr = parser.parseExpr();
        assertTrue(expr.accept(new Evaluator(), asList("a", "b")));
        assertTrue(expr.accept(new Evaluator(), asList("a", "c")));
    }

}
