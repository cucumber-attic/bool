package bool;

public class Not extends Expr {
    public final Expr node;

    public Not(Expr node) {
        this.node = node;
    }

    @Override
    public <R, A> R describeTo(Visitor<R, A> visitor, A arg) {
        return visitor.not(this, arg);
    }
}
