package bool.ast;

public class Step implements Union {
    public final Token keyword;
    public final Token name;
    public final MultilineArg multilineArg;

    public Step(Token keyword, Token name, MultilineArg multilineArg) {
        this.keyword = keyword;
        this.name = name;
        this.multilineArg = multilineArg;
    }
}
