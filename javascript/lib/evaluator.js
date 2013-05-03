module.exports = function Evaluator() {
  var self = this;

  this.visit_var = function(node, vars) {
    return vars.indexOf(node.token.value) != -1;
  };

  this.visit_and = function(node, vars) {
    return self.evaluate(node.left, vars) && self.evaluate(node.right, vars);
  };

  this.visit_or = function(node, vars) {
    return self.evaluate(node.left, vars) || self.evaluate(node.right, vars);
  };

  this.visit_not = function(node, vars) {
    return !self.evaluate(node.operand, vars);
  };

  this.evaluate = function(node, vars) {
    return node.accept(self, vars)
  }
};
