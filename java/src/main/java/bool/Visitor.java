package bool;

public interface Visitor<R, A> {
    R visit(Var var, A arg);

    R visit(And and, A arg);

    R visit(Or or, A arg);

    R visit(Not not, A arg);
}
