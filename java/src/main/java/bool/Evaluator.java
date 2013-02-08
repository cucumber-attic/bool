package bool;

import java.util.List;

public class Evaluator implements Visitor<Boolean, List<String>> {
    @Override
    public Boolean var(Var var, List<String> vars) {
        return vars.contains(var.name);
    }

    @Override
    public Boolean and(And and, List<String> vars) {
        return and.left.describeTo(this, vars) && and.right.describeTo(this, vars);
    }

    @Override
    public Boolean or(Or or, List<String> vars) {
        return or.left.describeTo(this, vars) || or.right.describeTo(this, vars);
    }

    @Override
    public Boolean not(Not not, List<String> vars) {
        return !not.node.describeTo(this, vars);
    }
}
