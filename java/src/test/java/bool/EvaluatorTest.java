package bool;

import org.junit.Test;

import java.io.IOException;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertTrue;

public class EvaluatorTest {
    @Test
    public void test_and_or_expression() throws IOException {
        Node node = Bool.parse("a && b || c");
        assertTrue(node.accept(new Evaluator(), asList("a", "b")));
        assertTrue(node.accept(new Evaluator(), asList("a", "c")));
    }

    @Test
    public void test_or_and_expression() throws IOException {
        Node node = Bool.parse("a || b && c");
        assertTrue(node.accept(new Evaluator(), asList("a", "b")));
        assertTrue(node.accept(new Evaluator(), asList("a", "c")));
    }

}
