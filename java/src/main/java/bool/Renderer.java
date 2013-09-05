package bool;

import bool.ast.*;

import java.util.Collections;
import java.util.List;

public class Renderer {

    private final static int NO_INDENTATION = 0;
    private final static int INDENTATION = 2;


    public String render(Feature feature) {
        StringBuilder out = new StringBuilder();
        renderTags(feature.tags, out, NO_INDENTATION);
        out.append(feature.keyword.getValue()).append(" ").append(feature.name.getValue()).append("\n");
        renderDescription(feature.descriptionLines, INDENTATION, out);
        for (FeatureElement fe : feature.featureElement) {
            renderFeatureElement(fe, out);
        }
        return out.toString();
    }

    private void renderFeatureElement(FeatureElement featureElement, StringBuilder out) {
        featureElement.accept(new FeatureElement.Visitor<Void, StringBuilder>() {

            @Override
            public Void visit(Background background, StringBuilder out) {
                renderBackground(background, out);
                return null;
            }

            @Override
            public Void visit(Scenario scenario, StringBuilder out) {
                renderScenario(scenario, out);
                return null;
            }

            @Override
            public Void visit(ScenarioOutline scenarioOutline, StringBuilder out) {
                renderScenarioOutline(scenarioOutline, out);
                return null;
            }

        }, out);
    }

    private StringBuilder renderBackground(Background background, StringBuilder out) {
        out.append("\n");
        renderFeatureElement(background.keyword, background.name, background.descriptionLines, background.steps, out, INDENTATION);
        return out;
    }

    private StringBuilder renderScenario(Scenario scenario, StringBuilder out) {
        out.append("\n");
        renderTags(scenario.tags, out, INDENTATION);
        renderFeatureElement(scenario.keyword, scenario.name, scenario.descriptionLines, scenario.steps, out, INDENTATION);
        return out;
    }

    private StringBuilder renderScenarioOutline(ScenarioOutline scenarioOutline, StringBuilder out) {
        out.append("\n");
        renderTags(scenarioOutline.tags, out, INDENTATION);
        renderFeatureElement(scenarioOutline.keyword, scenarioOutline.name, scenarioOutline.descriptionLines, scenarioOutline.steps, out, INDENTATION);
        for (Examples examples : scenarioOutline.examplesList) {
            renderExamples(examples, out);
        }
        return out;
    }

    private void renderExamples(Examples examples, StringBuilder out) {
        out.append("\n");
        renderTags(examples.tags, out, 2 * INDENTATION);
        renderFeatureElement(examples.keyword, examples.name, examples.descriptionLines, Collections.EMPTY_LIST, out, 2*INDENTATION);
        renderTable(examples.table, out);
    }

    private void renderFeatureElement(Token keyword, Token name, List<Token> descriptionLines, List<Step> steps, StringBuilder out, int indent) {
        writeIndent(indent, out)
                .append(keyword.getValue())
                .append(" ")
                .append(name.getValue())
                .append("\n");
        renderDescription(descriptionLines, indent+INDENTATION, out);
        renderSteps(steps, indent+INDENTATION, out);
    }

    private void renderTags(List<Tag> tags, StringBuilder out, int indent) {
        boolean tagsWritten = false;
        for (Tag tag : tags) {
            if (tagsWritten) {
                out.append(" ");
            } else {
                writeIndent(indent, out);
            }
            out.append(tag.name.getValue());
            tagsWritten = true;
        }
        if (tagsWritten) {
            out.append("\n");
        }
    }

    private void renderDescription(List<Token> descriptionLines, int indent, StringBuilder out) {
        for (Token dl : descriptionLines) {
            writeIndent(indent, out)
                    .append(dl.getValue())
                    .append("\n");
        }
        if (!descriptionLines.isEmpty()) {
            out.append("\n");
        }
    }

    private void renderSteps(List<Step> steps, int indent, StringBuilder out) {
        for (Step s : steps) {
            writeIndent(indent, out)
                    .append(s.keyword.getValue())
                    .append(s.name.getValue())
                    .append("\n");
            if (s.multilineArg != null) {
                renderMultilineArg(s.multilineArg, out);
            }
        }
    }

    private void renderMultilineArg(MultilineArg multilineArg, StringBuilder out) {
        multilineArg.accept(new MultilineArg.Visitor<Void, StringBuilder>() {

                @Override
                public Void visit(Table table, StringBuilder out) {
                    renderTable(table, out);
                    return null;
                }

                @Override
                public Void visit(DocString docString, StringBuilder out) {
                    renderDocString(docString, out);
                    return null;
                }

            }, out);
    }

    private void renderTable(Table table, StringBuilder out) { // TODO int indent
        // TODO
    }

    private void renderDocString(DocString docString, StringBuilder out) {
        // TODO
    }

    private StringBuilder writeIndent(int i, StringBuilder out) {
        while (--i >= 0) {
            out.append(" ");
        }
        return out;
    }
}
