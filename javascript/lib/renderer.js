module.exports = function Renderer() {
  this.visit_var = function(node, vars) {
    return node.value;
  };

  this.visit_and = function(node, vars) {
    return "(" + node.left.accept(this, vars) + " && " + node.right.accept(this, vars) + ")";
  };

  this.visit_or = function(node, vars) {
    return "(" + node.left.accept(this, vars) + " || " + node.right.accept(this, vars) + ")";
  };

  this.visit_not = function(node, vars) {
    return "!" + node.operand.accept(this, vars);
  };
};
