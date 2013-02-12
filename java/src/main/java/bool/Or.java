package bool;

public class Or implements Expr {
    public final Expr left;
    public final Expr right;

    public Or(Expr left, Expr right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public <R, A> R describeTo(Visitor<R, A> visitor, A arg) {
        return visitor.or(this, arg);
    }
}
