package bool;

import java.util.List;

public class Renderer implements Visitor< String, List<String>> {

	@Override
	public String var(Var var, List<String> notused) {
		return var.name;
	}

	@Override
	public String and(And and, List<String> notused) {
		return "(" + explicit(and.left) + " && " + explicit(and.right) + ")";
	}

	@Override
	public String or(Or or, List<String> notused) {
		return "(" + explicit(or.left) + " || " + explicit(or.right) + ")";
	}

	@Override
	public String not(Not not, List<String> notused) {
		return "!" + explicit(not.operand); 
	}
	
	private String explicit (Expr expr) {
	    return expr.describeTo(this, null);
	}

}
