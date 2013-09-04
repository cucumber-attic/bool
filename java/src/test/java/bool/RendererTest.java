package bool;

import bool.ast.*;
import org.junit.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class RendererTest {

    @Test
    public void renders_empty_feature() {
        Feature feature = new Feature(
                tags("@foo"),
                token("Feature:"), token("a"),
                    descriptionLines(),
                    elements()
            );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "@foo\n"+
                "Feature: a\n",
                rendered);
    }

    @Test
    public void renders_empty_feature_with_description() {
        Feature feature = new Feature(
                tags(),
                token("Feature:"), token("a"),
                    descriptionLines(
                        "description 1",
                        "description 2"
                    ),
                    elements()
            );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "Feature: a\n" +
                "  description 1\n" +
                "  description 2\n" +
                "\n",
                rendered);
    }


    @Test
    public void renders_feature_with_background() {
        Feature feature = new Feature(
                tags("@foo"),
                token("Feature:"), token("a"),
                descriptionLines(
                ),
                elements(
                    background("b",
                            descriptionLines(
                                    "description 1",
                                    "description 2"
                            ),
                            given("c")
                    )
                )
        );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "@foo\n"+
                        "Feature: a\n" +
                        "\n"+
                        "  Background: b\n" +
                        "    description 1\n" +
                        "    description 2\n" +
                        "\n"+
                        "    Given c\n",
                rendered);
    }

    private List<Tag> tags(String ... tags) {
        List<Tag> ret = new ArrayList<Tag>(tags.length);
        for (String t : tags) {
            ret.add(tag(t));
        }
        return ret;
    }

    private Tag tag(String value) {
        return new Tag(token(value));
    }

    private List<Token> descriptionLines(String ... lines) {
        return tokens(lines);
    }

    private List<Token> tokens(String ... values) {
        List<Token> ret = new ArrayList<Token>(values.length);
        for (String v : values) {
            ret.add(token(v));
        }
        return ret;
    }

    private Token token(String value) {
        return new Token(value, 0, 0, 0, 0);
    }

    private List<FeatureElement> elements(FeatureElement ... elements) {
        return Arrays.asList(elements);
    }

    private Background background(String name, List<Token> descriptionLines, Step ... steps) {
        return new Background(token("Background:"), token(name), descriptionLines, Arrays.asList(steps));
    }

    private Step given(String name) {
        return new Step(token("Given "), token(name), null);
    }
}
