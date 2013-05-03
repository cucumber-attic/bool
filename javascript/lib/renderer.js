module.exports = function Renderer() {
  var self = this;

  this.visit_var = function(node, vars) {
    return node.token.value;
  };

  this.visit_and = function(node, _) {
    return "(" + self.render(node.left) + " " + node.token.value + " " + self.render(node.right) + ")";
  };

  this.visit_or = function(node, _) {
    return "(" + self.render(node.left) + " " + node.token.value + " " + self.render(node.right) + ")";
  };

  this.visit_not = function(node, _) {
    return node.token.value + self.render(node.operand);
  };

  this.render = function(node) {
    return node.accept(self, null);
  };
};
