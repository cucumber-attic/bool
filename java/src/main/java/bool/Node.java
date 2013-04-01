package bool;

public abstract class Node implements Union {
    public final Token token;

    protected Node(Token token) {
        this.token = token;
    }

    public abstract <R, A> R accept(Visitor<R, A> visitor, A arg);
}
