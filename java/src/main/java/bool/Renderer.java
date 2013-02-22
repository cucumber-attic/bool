package bool;

import java.util.List;

public class Renderer implements Walker< String, List<String>> {

	@Override
	public String walk(Var var, List<String> notused) {
		return var.name;
	}

	@Override
	public String walk(And and, List<String> notused) {
		return "(" + render(and.left) + " && " + render(and.right) + ")";
	}

	@Override
	public String walk(Or or, List<String> notused) {
		return "(" + render(or.left) + " || " + render(or.right) + ")";
	}

	@Override
	public String walk(Not not, List<String> notused) {
		return "!" + render(not.operand); 
	}
	
	private String render (Expr expr) {
	    return expr.walkWith(this, null);
	}

}
