package bool;

public abstract class Expr {
    public abstract <R, A> R describeTo(Visitor<R, A> visitor, A arg);
}
