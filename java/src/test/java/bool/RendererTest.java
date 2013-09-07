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
    public void renders_empty_feature_with_description() {
        Feature feature = new Feature(
            tags("@foo"),
            token("Feature:"), token("a"),
                descriptionLines(
                    "description 1",
                    "description 2"
                ),
                elements()
            );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "@foo\n" +
                "Feature: a\n" +
                "  description 1\n" +
                "  description 2\n" +
                "\n",
            rendered);
    }

    @Test
    public void renders_feature_with_background() {
        Feature feature = new Feature(
            tags(),
            token("Feature:"), token("a"),
            descriptionLines(
            ),
            elements(
                background("b",
                    descriptionLines(
                        "description 1",
                        "description 2"
                    ), new Step[] {
                        given("c"),
                        when("d")
                    }
                )
            )
        );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "Feature: a\n" +
                "\n" +
                "  Background: b\n" +
                "    description 1\n" +
                "    description 2\n" +
                "\n" +
                "    Given c\n" +
                "    When d\n",
            rendered);
    }

    @Test
    public void renders_feature_with_scenario() {
        Feature feature = new Feature(
            tags(),
            token("Feature:"), token("a"),
            descriptionLines(
            ),
            elements(
                scenario(tags("@bar"), "b",
                        descriptionLines(
                                "description 1",
                                "description 2"
                        ), new Step[]{
                        given("c"),
                        when("d")
                }
                )
            )
        );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "Feature: a\n" +
                "\n" +
                "  @bar\n" +
                "  Scenario: b\n" +
                "    description 1\n" +
                "    description 2\n" +
                "\n" +
                "    Given c\n" +
                "    When d\n",
            rendered);
    }

    @Test
    public void renders_feature_with_scenario_and_docstring() {
        Feature feature = new Feature(
            tags(),
            token("Feature:"), token("a"),
            descriptionLines(
            ),
            elements(
                scenario(tags(), "b",
                    descriptionLines(
                    ), new Step[] {
                        given("c",
                            "doc string 1",
                            "doc string 2"
                        ),
                        when("d")
                    }
                )
            )
        );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "Feature: a\n" +
                "\n" +
                "  Scenario: b\n" +
                "    Given c\n" +
                "    \"\"\"\n" +
                "    doc string 1\n" +
                "    doc string 2\n" +
                "    \"\"\"\n" +
                "    When d\n",
            rendered);
    }

    @Test
    public void renders_feature_with_scenario_outline() {
        Feature feature = new Feature(
            tags(),
            token("Feature:"), token("a"),
            descriptionLines(
            ),
            elements(
                scenarioOutline(tags("@foo"), "b",
                    descriptionLines(
                        "description 1",
                        "description 2"
                    ), new Step[] {
                        given("c"),
                        when("d")
                    }, new Examples[] {
                        example(tags("@bar"), "e",
                            descriptionLines(
                                "description 3",
                                "description 4"
                            ),
                            new String[][] {
                                {"aaa","bb","c"},
                                {"11","222","3"}
                            }
                        )
                    }
                )
            )
        );

        String rendered = new Renderer().render(feature);

        assertEquals(
                "Feature: a\n" +
                "\n" +
                "  @foo\n" +
                "  Scenario Outline: b\n" +
                "    description 1\n" +
                "    description 2\n" +
                "\n" +
                "    Given c\n" +
                "    When d\n" +
                "\n" +
                "    @bar\n" +
                "    Examples: e\n"  +
                "      description 3\n" +
                "      description 4\n" +
                "\n"+
                "      | aaa |  bb | c |\n"+
                "      | 11  | 222 | 3 |\n",
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

    private Background background(String name, List<Token> descriptionLines, Step[] steps) {
        return new Background(token("Background:"), token(name), descriptionLines, Arrays.asList(steps));
    }

    private Scenario scenario(List<Tag> tags, String name, List<Token> descriptionLines, Step[] steps) {
        return new Scenario(tags, token("Scenario:"), token(name), descriptionLines, Arrays.asList(steps));
    }

    private ScenarioOutline scenarioOutline(List<Tag> tags, String name, List<Token> descriptionLines, Step[] steps, Examples[] examples) {
        return new ScenarioOutline(tags, token("Scenario Outline:"), token(name), descriptionLines, Arrays.asList(steps), Arrays.asList(examples));
    }

    private Step given(String name, String ... docString) {
        return new Step(token("Given "), token(name), new DocString(tokens(docString)));
    }

    private Step given(String name) {
        return new Step(token("Given "), token(name), null);
    }

    private Step when(String name) {
        return new Step(token("When "), token(name), null);
    }

    private Examples example(List<Tag> tags, String name, List<Token> descriptionLines, String[][] table) {
        return new Examples(tags, token("Examples:"), token(name), descriptionLines, table(table));
    }

    private Table table(String[][] stringMatrix) {
        List<List<Token>> table = new ArrayList<List<Token>>();
        for (String[] line : stringMatrix) {
            List<Token> tableLine = new ArrayList<Token>();
            for (String cell : line) {
                tableLine.add(token(cell));
            }
            table.add(tableLine);
        }
        return new Table(table);
    }
}
