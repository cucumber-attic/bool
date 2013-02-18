package bool;

import static org.hamcrest.MatcherAssert.*;
import static org.hamcrest.CoreMatchers.*;
import org.junit.Test;

import java.io.IOException;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertTrue;



public class EvaluatorTest {
	@Test
	public void test_and_or_expression() throws IOException {
		Parser parser = new Parser(new Lexer("a && b || c"));
		Expr expr = parser.parseExpr();
		assertTrue("a && b || c given a, b should be true",
				expr.describeTo(new EvaluatorVisitor(), asList("a", "b")));
		assertTrue("a && b || c given a, c should be true",
				expr.describeTo(new EvaluatorVisitor(), asList("a", "c")));
		
	}

	@Test
	public void test_or_and_expression() throws IOException {
		Parser parser = new Parser(new Lexer("a || b && c"));
		Expr expr = parser.parseExpr();
		assertTrue("a || b && c given a, b should be true",
				expr.describeTo(new EvaluatorVisitor(), asList("a","b")));
		assertTrue("a || b && c given a, c should be true",
				expr.describeTo(new EvaluatorVisitor(), asList("a","c")));
	}
	

}