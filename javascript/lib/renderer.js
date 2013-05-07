module.exports = function Renderer() {
  var self = this;

  this.visit_feature = function(node, out) {
    out += node.keyword.value + ' ' + node.name.value + '\n';
    node.description_lines.forEach(function(description_line) {
      out += '  ' + description_line.value + '\n';
    });

    node.feature_elements.forEach(function(feature_element) {
      out = self.render(feature_element, out);
    });
    return out;
  };

  function render_described_element(node, out, ind) {
    out += '\n';
    out += ind + node.keyword.value + ' ' + node.name.value + '\n';
    node.description_lines.forEach(function(description_line) {
      out += ind + '  ' + description_line.value + '\n';
    });
    if(node.description_lines.length > 0) {
      out += '\n';
    }
    return out;
  }

  function render_feature_element(node, out) {
    out = render_described_element(node, out, '  ');

    node.steps.forEach(function(step) {
      out = self.render(step, out);
    });
    return out;
  }

  this.visit_background = render_feature_element;

  this.visit_scenario = render_feature_element;

  this.visit_scenario_outline = function(node, out) {
    out = render_feature_element(node, out);
    node.examples_list.forEach(function(examples) {
      out = self.render(examples, out);
    });
    return out;
  }

  this.visit_examples = function(node, out) {
    out = render_described_element(node, out, '    ');
    out = self.render(node.table, out);
    return out;
  }

  this.visit_step = function(node, out) {
    out += '    ' + node.keyword.value + node.name.value + '\n';
    if(node.multiline_arg) {
      out = self.render(node.multiline_arg, out);
    }
    return out;
  };

  this.visit_doc_string = function(node, out) {
    out += '      """\n';
    out += node.string + '\n';
    out += '      """\n';
    return out;
  };

  this.visit_table = function(node, out) {
    node.cell_rows.forEach(function(cell_row) {
      out = self.render(cell_row, out);
    });

    return out;
  };

  this.visit_cell_row = function(node, out) {
    out += '      |';
    node.cells.forEach(function(cell) {
      out = self.render(cell, out);
    });
    out += '\n';

    return out;
  };

  this.visit_cell = function(node, out) {
    out += node.cell_value.value + '|';

    return out;
  };

  this.render = function(node, out) {
    return node.accept(self, out);
  };
};
