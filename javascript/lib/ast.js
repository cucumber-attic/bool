module.exports = {
  // TODO: Store line and columns as well so we can indent descriptions

  Token: function Token(value, locations) {
    this.value = value;

    // Paranoia. This can go away later.
    if(locations == undefined) throw new Error('Missing locations');
    if(!Array.isArray(locations)) locations = [locations];
    if(typeof(locations[0].first_line) != 'number') throw new Error('locations[0] is not Map of int');
    this.locations   = locations;
  },

  Tag: function Tag(name) {
    this.name = name;
  },

  Feature: function Feature(tags, keyword, name, description_lines, feature_elements) {
    this.tags              = tags;
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.feature_elements  = feature_elements;
  },

  Background: function Background(keyword, name, description_lines, steps) {
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.steps             = steps;

    this.accept = function(visitor, args) {
      return visitor.visit_background(this, args);
    };
  },

  Scenario: function Scenario(tags, keyword, name, description_lines, steps) {
    this.tags              = tags;
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.steps             = steps;

    this.accept = function(visitor, args) {
      return visitor.visit_scenario(this, args);
    };
  },

  ScenarioOutline: function ScenarioOutline(tags, keyword, name, description_lines, steps, examples_list) {
    this.tags              = tags;
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.steps             = steps;
    this.examples_list     = examples_list;

    this.accept = function(visitor, args) {
      return visitor.visit_scenario_outline(this, args);
    };
  },

  Examples: function Examples(tags, keyword, name, description_lines, table) {
    this.tags              = tags;
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.table             = table;
  },

  Step: function Step(keyword, name, multiline_arg) {
    this.keyword       = keyword;
    this.name          = name;
    this.multiline_arg = multiline_arg;
  },

  DocString: function DocString(lines) {
    this.lines = lines;

    this.string = function() {
      return lines.map(function(line) {
        return line.value;
      }).join('');
    };

    this.accept = function(visitor, args) {
      return visitor.visit_doc_string(this, args);
    };
  },

  Table: function Table(rows) {
    this.rows = rows;

    this.accept = function(visitor, args) {
      return visitor.visit_table(this, args);
    };
  }
};
