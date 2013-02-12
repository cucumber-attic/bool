package bool;

public class And implements Expr {
    public final Expr left;
    public final Expr right;

    public And(Expr left, Expr right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public <R, A> R describeTo(Visitor<R, A> visitor, A arg) {
        return visitor.and(this, arg);
    }
}
