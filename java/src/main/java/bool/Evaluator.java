package bool;

import java.util.List;

public class Evaluator implements Walker<Boolean, List<String>> {
    @Override
    public Boolean walk(Var var, List<String> vars) {
        return vars.contains(var.name);
    }

    @Override
    public Boolean walk(And and, List<String> vars) {
        return evaluate(and.left, vars) && evaluate(and.right, vars);
    }

    @Override
    public Boolean walk(Or or, List<String> vars) {
        return evaluate(or.left, vars) || evaluate(or.right, vars);
    }

    @Override
    public Boolean walk(Not not, List<String> vars) {
        return !evaluate(not.operand, vars);
    }

    private Boolean evaluate(Expr expr, List<String> vars) {
        return expr.walkWith(this, vars);
    }
}
