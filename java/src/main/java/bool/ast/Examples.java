package bool.ast;

import java.util.List;

public class Examples implements Union {
    public final List<Tag> tags;
    public final Token keyword;
    public final Token name;
    public final List<Token> descriptionLines;
    public Table table;

    public Examples(List<Tag> tags, Token keyword, Token name, List<Token> descriptionLines, Table table) {
        this.tags = tags;
        this.keyword = keyword;
        this.name = name;
        this.descriptionLines = descriptionLines;
        this.table = table;
    }
}
