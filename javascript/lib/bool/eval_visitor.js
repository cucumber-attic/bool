module.exports = function EvalVisitor() {
  this.visitVar = function visitVar(var_node, vars) {
    return vars.indexOf(var_node.name) != -1;
  };

  this.visitAnd = function visitAnd(and_node, vars) {
    return and_node.left.accept(this, vars) && and_node.right.accept(this, vars);
  };

  this.visitOr = function visitAnd(or_node, vars) {
    return or_node.left.accept(this, vars) || or_node.right.accept(this, vars);
  };

  this.visitNot = function visitNot(not_node, vars) {
    return !not_node.refnode.accept(this, vars);
  };
};