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

  Background: function Background(keyword, name, description_lines, steps) {
    this.keyword           = keyword;
    this.name              = name;
    this.description_lines = description_lines;
    this.steps             = steps;

    this.accept = function(visitor, args) {
      return visitor.visit_background(this, args);
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

  Step: function Step(keyword, name, multiline_arg) {
    this.keyword       = keyword;
    this.name          = name;
    this.multiline_arg = multiline_arg;

    this.accept = function(visitor, args) {
      return visitor.visit_step(this, args);
    };
  },

  DocString: function DocString(string) {
    this.string = string;

    this.accept = function(visitor, args) {
      return visitor.visit_doc_string(this, args);
    };
  },

  Cell: function Cell(cell_value) {
    this.cell_value = cell_value;

    this.accept = function(visitor, args) {
      return visitor.visit_cell(this, args);
    };
  },

  CellRow: function CellRow(cells) {
    this.cells = cells;

    this.accept = function(visitor, args) {
      return visitor.visit_cell_row(this, args);
    };
  },

  DataTable: function DataTable(cell_rows) {
    this.cell_rows = cell_rows;

    this.accept = function(visitor, args) {
      return visitor.visit_data_table(this, args);
    };
  }
};
