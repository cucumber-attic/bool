package bool;

import java.util.Collection;

public class Evaluator implements Visitor<Boolean, Collection<String>> {
    @Override
    public Boolean visit(Var node, Collection<String> vars) {
        return vars.contains(node.token.getValue());
    }

    @Override
    public Boolean visit(And node, Collection<String> vars) {
        return evaluate(node.left, vars) && evaluate(node.right, vars);
    }

    @Override
    public Boolean visit(Or node, Collection<String> vars) {
        return evaluate(node.left, vars) || evaluate(node.right, vars);
    }

    @Override
    public Boolean visit(Not node, Collection<String> vars) {
        return !evaluate(node.operand, vars);
    }

    private Boolean evaluate(Node node, Collection<String> vars) {
        return node.accept(this, vars);
    }
}
