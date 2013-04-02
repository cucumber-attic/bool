package bool;

import java.util.List;

public class Evaluator implements Visitor<Boolean, List<String>> {
    @Override
    public Boolean visit(Var node, List<String> vars) {
        return vars.contains(node.token.getValue());
    }

    @Override
    public Boolean visit(And node, List<String> vars) {
        return evaluate(node.left, vars) && evaluate(node.right, vars);
    }

    @Override
    public Boolean visit(Or node, List<String> vars) {
        return evaluate(node.left, vars) || evaluate(node.right, vars);
    }

    @Override
    public Boolean visit(Not node, List<String> vars) {
        return !evaluate(node.operand, vars);
    }

    private Boolean evaluate(Node node, List<String> vars) {
        return node.accept(this, vars);
    }
}
