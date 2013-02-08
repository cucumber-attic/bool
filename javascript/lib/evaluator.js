module.exports = function Evaluator() {
  this.var = function(var_node, vars) {
    return vars.indexOf(var_node.name) != -1;
  };

  this.and = function(and_node, vars) {
    return and_node.left.describeTo(this, vars) && and_node.right.describeTo(this, vars);
  };

  this.or = function(or_node, vars) {
    return or_node.left.describeTo(this, vars) || or_node.right.describeTo(this, vars);
  };

  this.not = function(not_node, vars) {
    return !not_node.refnode.describeTo(this, vars);
  };
};
