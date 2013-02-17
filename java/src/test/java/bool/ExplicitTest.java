package bool;

import static org.hamcrest.MatcherAssert.*;
import static org.hamcrest.CoreMatchers.*;
import org.junit.Test;

import java.io.IOException;

import static java.util.Arrays.asList;
import static org.junit.Assert.assertTrue;



public class ExplicitTest {
	@Test
	public void test_and_or_expression() throws IOException {
		Parser parser = new Parser(new Lexer("a && b || c"));
		Expr expr = parser.parseExpr();
		assertThat("a && b || c should explicitly be ((a && b) || c)",
				expr.describeTo(new ExplicitVisitor(),null),
				is ("((a && b) || c)"));
		
	}
	
	@Test
	public void test_or_and_expression() throws IOException {
		Parser parser = new Parser(new Lexer("a || b && c"));
		Expr expr = parser.parseExpr();
		assertThat("a || b && c should explicitly be (a || (b && c))",
				expr.describeTo(new ExplicitVisitor(),null),
				is ("(a || (b && c))"));
	}
}
