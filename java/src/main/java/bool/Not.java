package bool;

public class Not implements Expr {
    public final Expr operand;

    public Not(Expr operand) {
        this.operand = operand;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
