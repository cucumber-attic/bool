package bool;

public class And extends Binary {
    public And(Expr left, Expr right) {
        super(left, right);
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visitAnd(this, arg);
    }
}
