module.exports = {
  And: function And(left, right) {
    this.left = left;
    this.right = right;

    this.accept = function(visitor, args) {
      return visitor.visitAnd(this, args);
    }
  },

  Or: function Or(left, right) {
    this.left = left;
    this.right = right;

    this.accept = function(visitor, args) {
      return visitor.visitOr(this, args);
    }
  },

  Not: function Not(refnode) {
    this.refnode = refnode;

    this.accept = function(visitor, args) {
      return visitor.visitNot(this, args);
    }
  },

  Var: function Var(name) {
    this.name = name;

    this.accept = function(visitor, args) {
      return visitor.visitVar(this, args);
    }
  }
};