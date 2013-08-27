package bool;

public abstract class AbstractEvaluator<T> implements Visitor<Boolean, T> {
    @Override
    public abstract Boolean visit(Var node, T args);

    @Override
    public Boolean visit(And node, T args) {
        return evaluate(node.left, args) && evaluate(node.right, args);
    }

    @Override
    public Boolean visit(Or node, T args) {
        return evaluate(node.left, args) || evaluate(node.right, args);
    }

    @Override
    public Boolean visit(Not node, T args) {
        return !evaluate(node.operand, args);
    }

    public Boolean evaluate(Node node, T args) {
        return node.accept(this, args);
    }
}
