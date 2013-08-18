package bool;

import org.junit.Test;

import java.io.IOException;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

public class RendererTest {
    @Test
    public void test_and_or_expression() throws IOException {
        Node node = Bool.parse("a && b || c");
        assertThat(node.accept(new Renderer(), null), is("((a && b) || c)"));
    }

    @Test
    public void test_or_and_expression() throws IOException {
        Node node = Bool.parse("a || b && c");
        assertThat(node.accept(new Renderer(), null), is("(a || (b && c))"));
    }

    @Test
    public void test_not_expression() throws IOException {
        Node node = Bool.parse("!(a || b && !c)");
        assertThat(node.accept(new Renderer(), null), is("!(a || (b && !c))"));
    }
}
