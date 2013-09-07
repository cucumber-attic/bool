package bool;

import bool.ast.*;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class Renderer {

    private final static int INDENTATION = 2;

    private final static int FEATURE_INDENTATION = 0;
    private final static int SCENARIO_INDENTATION = INDENTATION;
    private final static int STEP_INDENTATION = SCENARIO_INDENTATION + INDENTATION;


    public String render(Feature feature) {
        StringBuilder out = new StringBuilder();
        renderTags(feature.tags, out, FEATURE_INDENTATION);
        out.append(feature.keyword.getValue()).append(" ").append(feature.name.getValue()).append("\n");
        renderDescription(feature.descriptionLines, FEATURE_INDENTATION+INDENTATION, out);
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
        renderTags(scenario.tags, out, SCENARIO_INDENTATION);
        renderFeatureElement(scenario.keyword, scenario.name, scenario.descriptionLines, scenario.steps, out, SCENARIO_INDENTATION);
        return out;
    }

    private StringBuilder renderScenarioOutline(ScenarioOutline scenarioOutline, StringBuilder out) {
        out.append("\n");
        renderTags(scenarioOutline.tags, out, SCENARIO_INDENTATION);
        renderFeatureElement(scenarioOutline.keyword, scenarioOutline.name, scenarioOutline.descriptionLines, scenarioOutline.steps, out, SCENARIO_INDENTATION);
        for (Examples examples : scenarioOutline.examplesList) {
            renderExamples(examples, out);
        }
        return out;
    }

    private void renderExamples(Examples examples, StringBuilder out) {
        out.append("\n");
        renderTags(examples.tags, out, STEP_INDENTATION);
        renderFeatureElement(examples.keyword, examples.name, examples.descriptionLines, Collections.EMPTY_LIST, out, STEP_INDENTATION);
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

    private void renderTable(Table table, StringBuilder out) {
        int[] colWidths = findColumnWidths(table);
        for (List<Token> row : table.rows) {
            writeIndent(STEP_INDENTATION + INDENTATION - 1, out);
            Iterator<Token> cellIterator = row.iterator();
            for (int i = 0; i < colWidths.length; ++i) {
                if (!cellIterator.hasNext())
                    break; // handle malformed tables
                Token cell = cellIterator.next();
                out.append(" | ");
                String cellValue = cell.getValue();
                int padding = colWidths[i] - cellValue.length();
                if (isNumber(cellValue)) {
                    out.append(cellValue);
                    writeIndent(padding, out);
                } else {
                    writeIndent(padding, out);
                    out.append(cellValue);
                }
            }
            out.append(" |\n");
        }
    }

    private boolean isNumber(String value) {
        // Could use StringUtils.isNumber(value) if we introduce a dependency
        for (char ch : value.toCharArray()) {
            if (!Character.isDigit(ch))
                return false;
        }
        return true;
    }

    private int[] findColumnWidths(Table table) {
        if (table.rows.isEmpty())
            return new int[0];
        int numCols = table.rows.get(0).size();
        int[] colWidths = new int[numCols];
        for (List<Token> row : table.rows) {
            Iterator<Token> cellIterator = row.iterator();
            for (int i = 0; i < numCols; ++i) {
                if (!cellIterator.hasNext())
                    break; // handle malformed tables
                Token cell = cellIterator.next();
                int cellWidth = cell.getValue().length();
                if (colWidths[i] < cellWidth)
                    colWidths[i] = cellWidth;
            }
        }
        return colWidths;
    }

    private void renderDocString(DocString docString, StringBuilder out) {
        writeIndent(STEP_INDENTATION, out).append("\"\"\"\n");
        for (Token line : docString.lines) {
            writeIndent(STEP_INDENTATION, out).append(line.getValue()).append("\n");
        }
        writeIndent(STEP_INDENTATION, out).append("\"\"\"\n");
    }

    private StringBuilder writeIndent(int i, StringBuilder out) {
        while (--i >= 0) {
            out.append(" ");
        }
        return out;
    }
}
