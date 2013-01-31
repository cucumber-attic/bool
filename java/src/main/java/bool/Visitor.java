package bool;

public interface Visitor<R, A> {
    R visitVar(Var var, A arg);

    R visitAnd(And and, A arg);

    R visitOr(Or or, A arg);

    R visitNot(Not not, A arg);
}
