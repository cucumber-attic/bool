package bool;

public class Not extends Expr {
    public final Expr node;

    public Not(Expr node) {
        this.node = node;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visitNot(this, arg);
    }
}
