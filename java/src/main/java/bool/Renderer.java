package bool;

import java.util.List;

public class Renderer implements Visitor<String, List<String>> {

    @Override
    public String visit(Var var, List<String> notused) {
        return var.name;
    }

    @Override
    public String visit(And and, List<String> notused) {
        return "(" + explicit(and.left) + " && " + explicit(and.right) + ")";
    }

    @Override
    public String visit(Or or, List<String> notused) {
        return "(" + explicit(or.left) + " || " + explicit(or.right) + ")";
    }

    @Override
    public String visit(Not not, List<String> notused) {
        return "!" + explicit(not.operand);
    }

    private String explicit(Expr expr) {
        return expr.accept(this, null);
    }

}
