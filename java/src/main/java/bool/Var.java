package bool;

public class Var extends Node {
    public Var(Token token) {
        super(token);
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
