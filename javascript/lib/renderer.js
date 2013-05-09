module.exports = function Renderer() {
  var self = this;

  this.visit_feature = function(node, out) {
    out = render_tags(node.tags, out, '');
    out += node.keyword.value + ' ' + node.name.value + '\n';
    node.description_lines.forEach(function(description_line) {
      out += '  ' + description_line.value + '\n';
    });

    node.feature_elements.forEach(function(feature_element) {
      out = self.render(feature_element, out);
    });
    return out;
  };

  function render_tags(tags, out, indent) {
    tags.forEach(function(tag, n) {
      if(n == 0) {
        out += indent;
      } else {
        out += ' ';
      }
      out += tag.name.value;
    });
    if(tags.length > 0) {
      out += '\n';
    }
    return out;
  }

  function render_described_element(node, out, indent) {
    out += indent + node.keyword.value + ' ' + node.name.value + '\n';
    node.description_lines.forEach(function(description_line) {
      out += indent + '  ' + description_line.value + '\n';
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

  this.visit_background = function(node, out) {
    out += '\n';
    return render_feature_element(node, out);
  }

  this.visit_scenario = function(node, out) {
    out += '\n';
    out = render_tags(node.tags, out, '  ');
    return render_feature_element(node, out);
  }

  this.visit_scenario_outline = function(node, out) {
    out += '\n';
    out = render_tags(node.tags, out, '  ');
    out = render_feature_element(node, out);
    node.examples_list.forEach(function(examples) {
      out = self.render(examples, out);
    });
    return out;
  }

  this.visit_examples = function(node, out) {
    out += '\n';
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
    var col_index;
    // TODO: move out from here to make less cluttered
    var width_finder = {
      visit_table: function(node, col_widths) {
        node.cell_rows.forEach(function(cell_row) {
          return cell_row.accept(width_finder, col_widths);
        });
        return col_widths;
      },

      visit_cell_row: function(node, col_widths) {
        node.cells.forEach(function(cell, i) {
          col_index = i;
          return cell.accept(width_finder, col_widths);
        });
        return col_widths;
      },

      visit_cell: function(node, col_widths) {
        col_widths[col_index] = Math.max(col_widths[col_index] || 0, node.cell_value.value.length);
      }
    };
    var col_widths = node.accept(width_finder, []);

    var out_and_col_widths = {out:out, col_widths:col_widths};
    node.cell_rows.forEach(function(cell_row) {
      out = cell_row.accept(self, out_and_col_widths);
    });

    return out;
  };

  this.visit_cell_row = function(node, out_and_col_widths) {
    out_and_col_widths.out += '     ';
    node.cells.forEach(function(cell, col_index) {
      out_and_col_widths.out = cell.accept(self, {out:out_and_col_widths.out, col_width:out_and_col_widths.col_widths[col_index]});
    });
    out_and_col_widths.out += ' |\n';

    return out_and_col_widths.out;
  };

  this.visit_cell = function(node, out_and_col_width) {
    var pad_width = out_and_col_width.col_width - node.cell_value.value.length;
    var padding = "";
    for (var i = 0; i < pad_width; i++) {
      padding += ' ';
    }
    out_and_col_width.out += ' | ';
    if(node.cell_value.value.match(/\d+/)) {
      out_and_col_width.out += padding + node.cell_value.value;
    } else {
      out_and_col_width.out += node.cell_value.value + padding;
    }

    return out_and_col_width.out;
  };

  this.render = function(node, out) {
    return node.accept(self, out);
  };
};
