module.exports = function Evaluator() {
  var self = this;

  this.visit_var = function(node, vars) {
    return vars.indexOf(node.token) != -1;
  };

  this.visit_and = function(node, vars) {
    return evaluate(node.left, vars) && evaluate(node.right, vars);
  };

  this.visit_or = function(node, vars) {
    return evaluate(node.left, vars) || evaluate(node.right, vars);
  };

  this.visit_not = function(node, vars) {
    return !evaluate(node.operand, vars);
  };

  function evaluate(node, vars) {
    return node.accept(self, vars)
  }
};
