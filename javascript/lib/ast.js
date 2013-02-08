module.exports = {
  And: function And(left, right) {
    this.left = left;
    this.right = right;

    this.describeTo = function(visitor, args) {
      return visitor.and(this, args);
    }
  },

  Or: function Or(left, right) {
    this.left = left;
    this.right = right;

    this.describeTo = function(visitor, args) {
      return visitor.or(this, args);
    }
  },

  Not: function Not(refnode) {
    this.refnode = refnode;

    this.describeTo = function(visitor, args) {
      return visitor.not(this, args);
    }
  },

  Var: function Var(name) {
    this.name = name;

    this.describeTo = function(visitor, args) {
      return visitor.var(this, args);
    }
  }
};
