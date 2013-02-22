module.exports = {
  And: function And(left, right) {
    this.left = left;
    this.right = right;

    this.walk_with = function(walker, args) {
      return walker.walk_and(this, args);
    }
  },

  Or: function Or(left, right) {
    this.left = left;
    this.right = right;

    this.walk_with = function(walker, args) {
      return walker.walk_or(this, args);
    }
  },

  Not: function Not(refnode) {
    this.refnode = refnode;

    this.walk_with = function(walker, args) {
      return walker.walk_not(this, args);
    }
  },

  Var: function Var(name) {
    this.name = name;

    this.walk_with = function(walker, args) {
      return walker.walk_var(this, args);
    }
  }
};
