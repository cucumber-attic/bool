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
        var locations = outline_step.keyword.locations.concat(row[0].locations);

        var step_name = replace(arg_names, row, outline_step.name.value);
        var multiline_arg = null;
        if(outline_step.multiline_arg) {
          var replace_visitor = {
            visit_doc_string: function(doc_string, args) {
              var doc_string_value = replace(arg_names, row, doc_string.string());
              return new ast.DocString([new ast.Token(doc_string_value, locations)]);
            }
          }
          multiline_arg = outline_step.multiline_arg.accept(replace_visitor);
        }

        var keyword_token = new ast.Token(outline_step.keyword.value, locations);
        var name_token = new ast.Token(step_name, locations);
        return new ast.Step(keyword_token, name_token, multiline_arg);
      });
      var scenario = new ast.Scenario(scenario_outline.tags, scenario_outline.keyword, scenario_outline.name, scenario_outline.description_lines, background_steps.concat(steps));
      scenarios.push(scenario);
    });
  };

  function replace(arg_names, arg_values, s) {
    arg_names.forEach(function(arg_name, arg_index) {
      s = s.replace(new RegExp('<' + arg_name.value + '>', 'g'), arg_values[arg_index].value);
    });
    return s;
  }
};
