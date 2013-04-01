module.exports = {
  Var: function Var(token) {
    this.token = token;

    this.accept = function(visitor, args) {
      return visitor.visit_var(this, args);
    }
  },

  And: function And(token, left, right) {
    this.token = token;
    this.left = left;
    this.right = right;

    this.accept = function(visitor, args) {
      return visitor.visit_and(this, args);
    }
  },

  Or: function Or(token, left, right) {
    this.token = token;
    this.left = left;
    this.right = right;

    this.accept = function(visitor, args) {
      return visitor.visit_or(this, args);
    }
  },

  Not: function Not(token, operand) {
    this.token = token;
    this.operand = operand;

    this.accept = function(visitor, args) {
      return visitor.visit_not(this, args);
    }
  }
};
