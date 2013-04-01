module.exports = function Renderer() {
  this.visit_var = function(node, vars) {
    return node.token;
  };

  this.visit_and = function(node, vars) {
    return "(" + node.left.accept(this, vars) + " " + node.token + " " + node.right.accept(this, vars) + ")";
  };

  this.visit_or = function(node, vars) {
    return "(" + node.left.accept(this, vars) + " " + node.token + " " + node.right.accept(this, vars) + ")";
  };

  this.visit_not = function(node, vars) {
    return node.token + node.operand.accept(this, vars);
  };
};
