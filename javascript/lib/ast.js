module.exports = {
  // TODO: Store line and columns as well so we can indent descriptions

  Token: function Token(value) {
    this.value = value;
  },

  Feature: function Feature(keyword, name, description_lines, feature_elements) {
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.feature_elements  = feature_elements;

    this.accept = function(visitor, args) {
      return visitor.visit_feature(this, args);
    };
  },

  Scenario: function Scenario(keyword, name, description_lines, steps) {
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.steps             = steps;

    this.accept = function(visitor, args) {
      return visitor.visit_scenario(this, args);
    };
  },

  Step: function Step(keyword, name) {
    this.keyword           = keyword;
    this.name              = name;

    this.accept = function(visitor, args) {
      return visitor.visit_step(this, args);
    };
  }
};
