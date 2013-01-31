package bool;

import java.util.List;

public class EvalVisitor implements Visitor<Boolean, List<String>> {
    @Override
    public Boolean visitVar(Var var, List<String> vars) {
        return vars.contains(var.name);
    }

    @Override
    public Boolean visitAnd(And and, List<String> vars) {
        return and.left.accept(this, vars) && and.right.accept(this, vars);
    }

    @Override
    public Boolean visitOr(Or or, List<String> vars) {
        return or.left.accept(this, vars) || or.right.accept(this, vars);
    }

    @Override
    public Boolean visitNot(Not not, List<String> vars) {
        return !not.node.accept(this, vars);
    }
}
