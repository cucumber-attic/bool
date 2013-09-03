package bool;

import bool.ast.Feature;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class ParserTest {

    @Test
    public void parses_simple_feature() throws IOException {
        Parser parser = new Parser(new Lexer("Feature: foo"));
        Feature feature = parser.buildAst();
        assertEquals("foo", feature.name.getValue());
        assertEquals(10, feature.name.getFirstColumn());
    }
}
