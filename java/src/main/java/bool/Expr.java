package bool;

public interface Expr {
    <R, A> R walkWith(Walker<R, A> walker, A arg);
}
