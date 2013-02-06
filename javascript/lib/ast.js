module.exports = {
  And: function(left, right) {
    this.left = left;
    this.right = right;

    this.describeTo = function(visitor, args) {
      return visitor.and(this, args);
    }
  },

  Or: function(left, right) {
    this.left = left;
    this.right = right;

    this.describeTo = function(visitor, args) {
      return visitor.or(this, args);
    }
  },

  Not: function(refnode) {
    this.refnode = refnode;

    this.describeTo = function(visitor, args) {
      return visitor.not(this, args);
    }
  },

  Var: function(name) {
    this.name = name;

    this.describeTo = function(visitor, args) {
      return visitor.var(this, args);
    }
  }
};
