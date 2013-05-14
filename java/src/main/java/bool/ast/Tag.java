package bool.ast;

public class Tag implements Union {
    public final Token name;

    public Tag(Token name) {
        this.name = name;
    }
}
