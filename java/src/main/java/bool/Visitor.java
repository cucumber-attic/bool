package bool;

public interface Visitor<R, A> {
    R var(Var var, A arg);

    R and(And and, A arg);

    R or(Or or, A arg);

    R not(Not not, A arg);
}
