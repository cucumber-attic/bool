package bool;

public class And extends Node {
    public final Node left;
    public final Node right;

    public And(Token token, Node left, Node right) {
        super(token);
        this.left = left;
        this.right = right;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
