package bool;

import java.util.List;

public class Renderer implements Visitor<String, List<String>> {

    @Override
    public String visit(Var var, List<String> _) {
        return var.token.getValue();
    }

    @Override
    public String visit(And and, List<String> _) {
        return "(" + render(and.left) + " " + and.token.getValue() + " " + render(and.right) + ")";
    }

    @Override
    public String visit(Or or, List<String> _) {
        return "(" + render(or.left) + " " + or.token.getValue() + " " + render(or.right) + ")";
    }

    @Override
    public String visit(Not not, List<String> _) {
        return not.token.getValue() + render(not.operand);
    }

    public String render(Node node) {
        return node.accept(this, null);
    }

}
