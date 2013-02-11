package bool;

public abstract class Binary extends Expr {
    public final Expr left;
    public final Expr right;

    public Binary(Expr left, Expr right) {
        this.left = left;
        this.right = right;
    }
}
