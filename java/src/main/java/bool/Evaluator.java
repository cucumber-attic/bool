package bool;

import java.util.Collection;

public class Evaluator extends AbstractEvaluator<Collection<String>> {
    @Override
    public Boolean visit(Var node, Collection<String> vars) {
        return vars.contains(node.token.getValue());
    }
}
