package bool;

public class Not implements Expr {
    public final Expr operand;

    public Not(Expr operand) {
        this.operand = operand;
    }

    @Override
    public <R, A> R walkWith(Walker<R, A> walker, A arg) {
        return walker.walk(this, arg);
    }
}
