package bool;

public class Var implements Expr {
    public final String name;

    public Var(String name) {
        this.name = name;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
