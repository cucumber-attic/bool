package bool.ast;

public class Step implements Union {
    public final Token keyword;
    public final Token name;

    public Step(Token keyword, Token name) {
        this.keyword = keyword;
        this.name = name;
    }
}
