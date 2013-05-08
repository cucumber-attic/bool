function Unit(steps) {
  this.steps = steps;
}

module.exports = function Compiler() {
  var self = this;
  var background_steps;

  this.visit_feature = function(node) {
    background_steps = [];

    var units = [];
    node.feature_elements.forEach(function(feature_element) {
      feature_element.accept(self, units);
    });
    return units;
  };

  this.visit_background = function(node, units) {
    background_steps = node.steps;
  };

  this.visit_scenario = function(node, units) {
    var steps = background_steps.concat(node.steps);
    var unit = new Unit(steps);
    units.push(unit);
  };

  this.compile = function(node) {
    return node.accept(self);
  };
};
