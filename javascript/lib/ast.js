module.exports = {
  Var: function Var(value) {
    this.value = value;

    this.accept = function(visitor, args) {
      return visitor.visit_var(this, args);
    }
  },

  And: function And(left, right) {
    this.left = left;
    this.right = right;

    this.accept = function(visitor, args) {
      return visitor.visit_and(this, args);
    }
  },

  Or: function Or(left, right) {
    this.left = left;
    this.right = right;

    this.accept = function(visitor, args) {
      return visitor.visit_or(this, args);
    }
  },

  Not: function Not(operand) {
    this.operand = operand;

    this.accept = function(visitor, args) {
      return visitor.visit_not(this, args);
    }
  }
};
