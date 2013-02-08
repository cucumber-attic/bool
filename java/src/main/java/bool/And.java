package bool;

public class And extends Binary {
    public And(Expr left, Expr right) {
        super(left, right);
    }

    @Override
    public <R, A> R describeTo(Visitor<R, A> visitor, A arg) {
        return visitor.and(this, arg);
    }
}
