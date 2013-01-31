package bool;

public class Or extends Binary {
    public Or(Expr left, Expr right) {
        super(left, right);
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visitOr(this, arg);
    }
}
