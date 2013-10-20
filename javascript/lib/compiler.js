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
    node.rows.slice(1).forEach(function(arg_values) {
      var steps = scenario_outline.steps.map(function(outline_step) {
        var step_name = replace_string(arg_names, arg_values, outline_step.name.value);
        var keyword_locations = outline_step.keyword.locations.concat(arg_values[0].locations);
        var keyword_token = new ast.Token(outline_step.keyword.value, keyword_locations);
        var name_token = new ast.Token(step_name, keyword_locations);
        var multiline_arg = replace_multiline_arg(arg_names, arg_values, outline_step.multiline_arg);
        return new ast.Step(keyword_token, name_token, multiline_arg);
      });
      var scenario = new ast.Scenario(scenario_outline.tags, scenario_outline.keyword, scenario_outline.name, scenario_outline.description_lines, background_steps.concat(steps));
      scenarios.push(scenario);
    });
  };

  function replace_multiline_arg(arg_names, arg_values, multiline_arg) {
    if (multiline_arg) {
      var replace_visitor = {
        visit_doc_string: function(doc_string, args) {
          var replaced_lines = doc_string.lines.map(function(t) {
            return replace_token(arg_names, arg_values, t);
          });
          return new ast.DocString(replaced_lines);
        },
        visit_table: function(table, args) {
          var replaced_rows = table.rows.map(function(r) {
            return r.map(function(c) {
              return replace_token(arg_names, arg_values, c);
              });
          });
          return new ast.Table(replaced_rows);
        }
      };
      return multiline_arg.accept(replace_visitor);
    } else {
      return null;
    }
  }

  function replace_token(arg_names, arg_values, t) {
    var replaced_value = replace_string(arg_names, arg_values, t.value);
    return new ast.Token(replaced_value, t.locations);
  }

  function replace_string(arg_names, arg_values, s) {
    arg_names.forEach(function(arg_name, arg_index) {
      s = s.replace(new RegExp('<' + arg_name.value + '>', 'g'), arg_values[arg_index].value);
    });
    return s;
  }
};
