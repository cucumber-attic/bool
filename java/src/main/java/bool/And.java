package bool;

public class And implements Expr {
    public final String value;
    public final Expr left;
    public final Expr right;

    public And(String value, Expr left, Expr right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
