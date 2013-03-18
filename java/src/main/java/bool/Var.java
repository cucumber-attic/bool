package bool;

public class Var implements Expr {
    public final String value;

    public Var(String value) {
        this.value = value;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
