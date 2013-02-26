package bool;

public interface Expr {
    <R, A> R accept(Visitor<R, A> visitor, A arg);
}
