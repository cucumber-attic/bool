package bool.ast;

import java.util.List;

public class Background implements Union, FeatureElement {
    public final Token keyword;
    public final Token name;
    public final List<Token> descriptionLines;
    public final List<Step> steps;

    public Background(Token keyword, Token name, List<Token> descriptionLines, List<Step> steps) {
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
