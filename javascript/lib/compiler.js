var ast = require('./ast');

module.exports = function Compiler() {
  var self = this;
  var background_steps;
  var scenario_outline;
  var example_args;

  this.compile = function(node) {
    background_steps = [];

    var scenarios = [];
    node.feature_elements.forEach(function(feature_element) {
      feature_element.accept(self, scenarios);
    });
    return scenarios;
  };

  this.visit_background = function(node, scenarios) {
    background_steps = node.steps;
  };

  this.visit_scenario = function(node, scenarios) {
    var scenario = new ast.Scenario(node.tags, node.keyword, node.name, node.description_lines, background_steps.concat(node.steps));
    scenarios.push(scenario);
  };

  this.visit_scenario_outline = function(node, scenarios) {
    scenario_outline = node;
    node.examples_list.forEach(function(examples) {
      examples.table.accept(self, scenarios);
    });
  };

  this.visit_table = function(node, scenarios) {
    arg_names = node.rows[0];
    node.rows.slice(1).forEach(function(row) {
      var steps = scenario_outline.steps.map(function(outline_step) {
        var step_name = outline_step.name.value;

        // TODO: Make a function so it's easier to replace in multiline args as well.
        var cell_locations;
        arg_names.forEach(function(arg_name, n) {
          step_name = step_name.replace(new RegExp('<' + arg_name.value + '>', 'g'), row[n].value);
          cell_locations = row[n].locations;
        });
        var keyword_locations = outline_step.keyword.locations.concat(cell_locations);
        var name_locations    = outline_step.name.locations.concat(cell_locations);
        var keyword_token = new ast.Token(outline_step.keyword.value, keyword_locations);
        var name_token = new ast.Token(step_name, name_locations);
        return new ast.Step(keyword_token, name_token);
      });
      var scenario = new ast.Scenario(scenario_outline.tags, scenario_outline.keyword, scenario_outline.name, scenario_outline.description_lines, background_steps.concat(steps));
      scenarios.push(scenario);
    });
  };
};
