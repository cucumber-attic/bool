package bool;

public interface Expr {
    <R, A> R describeTo(Visitor<R, A> visitor, A arg);
}
