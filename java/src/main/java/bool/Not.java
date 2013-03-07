package bool;

public class Not implements Expr {
    public final String value;
    public final Expr operand;

    public Not(String value, Expr operand) {
        this.value = value;
        this.operand = operand;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
