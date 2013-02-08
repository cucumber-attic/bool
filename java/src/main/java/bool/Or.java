package bool;

public class Or extends Binary {
    public Or(Expr left, Expr right) {
        super(left, right);
    }

    @Override
    public <R, A> R describeTo(Visitor<R, A> visitor, A arg) {
        return visitor.or(this, arg);
    }
}
