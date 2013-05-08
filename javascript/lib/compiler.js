var ast = require('./ast');

function Unit(steps) {
  this.steps = steps;
}

module.exports = function Compiler() {
  var self = this;
  var background_steps;
  var scenario_outline_steps;
  var example_args;

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
    var unit = new Unit(background_steps.concat(node.steps));
    units.push(unit);
  };

  this.visit_scenario_outline = function(node, units) {
    scenario_outline_steps = node.steps;
    node.examples_list.forEach(function(examples) {
      examples.accept(self, units);
    });
  };

  this.visit_examples = function(node, units) {
    node.table.accept(self, units);
  };

  this.visit_table = function(node, units) {
    example_args = node.cell_rows[0].cells;
    node.cell_rows.slice(1).forEach(function(cell_row) {
      return cell_row.accept(self, units);
    });
  };

  this.visit_cell_row = function(node, units) {
    var steps = scenario_outline_steps.map(function(outline_step) {
      step_name = outline_step.name.value;
      example_args.forEach(function(arg, n) {
        step_name = step_name.replace(new RegExp('<' + arg.cell_value.value + '>', 'g'), node.cells[n].cell_value.value);
      });
      return new ast.Step(new ast.Token(outline_step.keyword), new ast.Token(step_name));
    });
    var unit = new Unit(background_steps.concat(steps));
    units.push(unit);
  };

  this.compile = function(node) {
    return node.accept(self);
  };
};
