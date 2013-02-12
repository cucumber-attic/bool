package bool;

public class Not implements Expr {
    public final Expr operand;

    public Not(Expr operand) {
        this.operand = operand;
    }

    @Override
    public <R, A> R describeTo(Visitor<R, A> visitor, A arg) {
        return visitor.not(this, arg);
    }
}
