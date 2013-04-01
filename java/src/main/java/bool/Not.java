package bool;

public class Not extends Node {
    public final Node operand;

    public Not(Token token, Node operand) {
        super(token);
        this.operand = operand;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
