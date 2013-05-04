module.exports = {
  // TODO: Store line and columns as well so we can indent descriptions

  Token: function Token(value) {
    this.value = value;
  },

  Feature: function Feature(keyword, name, description_lines) {
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    console.log('oo',description_lines);

    this.accept = function(visitor, args) {
      return visitor.visit_feature(this, args);
    };
  }
};
