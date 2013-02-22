package bool;

public interface Walker<R, A> {
    R walk(Var var, A arg);

    R walk(And and, A arg);

    R walk(Or or, A arg);

    R walk(Not not, A arg);
}
