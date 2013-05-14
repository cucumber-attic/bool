package bool.ast;

import java.util.List;

public class Scenario implements Union,FeatureElement {
    public final List<Tag> tags;
    public final Token keyword;
    public final Token name;
    public final List<Token> descriptionLines;
    public final List<Step> steps;

    public Scenario(List<Tag> tags, Token keyword, Token name, List<Token> descriptionLines, List<Step> steps) {
        this.tags = tags;
        this.keyword = keyword;
        this.name = name;
        this.descriptionLines = descriptionLines;
        this.steps = steps;
    }

    @Override
    public <R, A> R accept(FeatureElement.Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
