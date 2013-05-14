package bool.ast;

import java.util.List;

public class Feature implements Union {
    public final List<Tag> tags;
    public final Token keyword;
    public final Token name;
    public final List<Token> descriptionLines;
    public final List<FeatureElement> featureElement;

    public Feature(List<Tag> tags, Token keyword, Token name, List<Token> descriptionLines, List<FeatureElement> featureElement) {
        this.tags = tags;
        this.keyword = keyword;
        this.name = name;
        this.descriptionLines = descriptionLines;
        this.featureElement = featureElement;
    }
}
