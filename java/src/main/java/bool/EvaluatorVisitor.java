package bool;

import java.util.List;

public class EvaluatorVisitor implements Visitor<Boolean, List<String>> {
    @Override
    public Boolean var(Var var, List<String> vars) {
        return vars.contains(var.name);
    }

    @Override
    public Boolean and(And and, List<String> vars) {
        return evaluate(and.left, vars) && evaluate(and.right, vars);
    }

    @Override
    public Boolean or(Or or, List<String> vars) {
        return evaluate(or.left, vars) || evaluate(or.right, vars);
    }

    @Override
    public Boolean not(Not not, List<String> vars) {
        return !evaluate(not.operand, vars);
    }

    private Boolean evaluate(Expr expr, List<String> vars) {
        return expr.describeTo(this, vars);
    }
}
