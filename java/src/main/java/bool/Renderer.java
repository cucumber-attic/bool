package bool;

import java.util.List;

public class Renderer implements Visitor<String, List<String>> {

    @Override
    public String visit(Var var, List<String> notused) {
        return var.token.value;
    }

    @Override
    public String visit(And and, List<String> notused) {
        return "(" + explicit(and.left) + " " + and.token.value + " " + explicit(and.right) + ")";
    }

    @Override
    public String visit(Or or, List<String> notused) {
        return "(" + explicit(or.left) + " " + or.token.value + " " + explicit(or.right) + ")";
    }

    @Override
    public String visit(Not not, List<String> notused) {
        return not.token.value + explicit(not.operand);
    }

    private String explicit(Node node) {
        return node.accept(this, null);
    }

}
