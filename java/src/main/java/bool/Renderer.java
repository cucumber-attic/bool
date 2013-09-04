package bool;

import bool.ast.*;

import java.util.List;

public class Renderer {

    private final static int NO_INDENTATION = 0;
    private final static int INDENTATION = 2;

    private class FeatureElementVisitor implements FeatureElement.Visitor<StringBuilder, StringBuilder> {

        @Override
        public StringBuilder visit(Background background, StringBuilder out) {
            out.append("\n");
            writeIndent(INDENTATION, out)
                    .append(background.keyword.getValue())
                    .append(" ")
                    .append(background.name.getValue())
                    .append("\n");
            renderDescription(background.descriptionLines, 2*INDENTATION, out);
            renderSteps(background.steps, 2*INDENTATION, out);
            return out;
        }

        @Override
        public StringBuilder visit(Scenario scenario, StringBuilder out) {
            // TODO
            return out;
        }

        @Override
        public StringBuilder visit(ScenarioOutline scenarioOutline, StringBuilder out) {
            // TODO
            return out;
        }
    }

    private class MultilineArgVisitor implements MultilineArg.Visitor<StringBuilder, StringBuilder> {

        @Override
        public StringBuilder visit(Table table, StringBuilder out) {
            // TODO
            return out;
        }

        @Override
        public StringBuilder visit(DocString docString, StringBuilder out) {
            // TODO
            return out;
        }
    }

    public String render(Feature feature) {
        StringBuilder out = new StringBuilder();
        renderTags(feature.tags, out, NO_INDENTATION);
        out.append(feature.keyword.getValue()).append(" ").append(feature.name.getValue()).append("\n");
        renderDescription(feature.descriptionLines, INDENTATION, out);
        for (FeatureElement fe : feature.featureElement) {
            fe.accept(new FeatureElementVisitor(), out);
        }
        return out.toString();
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
                s.multilineArg.accept(new MultilineArgVisitor(), out);
            }
        }
    }

    private StringBuilder writeIndent(int i, StringBuilder out) {
        while (--i >= 0) {
            out.append(" ");
        }
        return out;
    }
}
