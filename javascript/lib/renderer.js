module.exports = function Renderer() {
  var self = this;

  this.render = function(feature, out) {
    out = render_tags(feature.tags, out, '');
    out += feature.keyword.value + ' ' + feature.name.value + '\n';
    feature.description_lines.forEach(function(description_line) {
      out += '  ' + description_line.value + '\n';
    });

    feature.feature_elements.forEach(function(feature_element) {
      out = feature_element.accept(self, out);
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
      out += '    ' + step.keyword.value + step.name.value + '\n';
      if(step.multiline_arg) {
        out = step.multiline_arg.accept(self, out);
      }
    });
    return out;
  }

  this.visit_background = function(background, out) {
    out += '\n';
    return render_feature_element(background, out);
  }

  this.visit_scenario = function(scenario, out) {
    out += '\n';
    out = render_tags(scenario.tags, out, '  ');
    return render_feature_element(scenario, out);
  }

  this.visit_scenario_outline = function(scenario_outline, out) {
    out += '\n';
    out = render_tags(scenario_outline.tags, out, '  ');
    out = render_feature_element(scenario_outline, out);
    scenario_outline.examples_list.forEach(function(examples) {
      out += '\n';
      out = render_tags(examples.tags, out, '    ');
      out = render_described_element(examples, out, '    ');
      out = examples.table.accept(self, out);
    });
    return out;
  }

  this.visit_doc_string = function(doc_string, out) {
    out += '      """\n';
    doc_string.lines.forEach(function(line) {
      out += line.value;
    });
    out += '      """\n';
    return out;
  };

  this.visit_table = function(table, out) {
    var col_widths = find_column_widths(table);

    //var out_and_col_widths = {out:out, col_widths:col_widths};
    table.rows.forEach(function(row) {
      out += '     ';
      row.forEach(function(cell, col_index) {
        var pad_width = col_widths[col_index] - cell.value.length;
        var padding = "";
        for (var i = 0; i < pad_width; i++) {
          padding += ' ';
        }
        out += ' | ';
        if(cell.value.match(/\d+/)) {
          out += padding + cell.value;
        } else {
          out += cell.value + padding;
        }
      });
      out += ' |\n';
    });
    return out;
  };

  function find_column_widths(table) {
    col_widths = [];
    table.rows.forEach(function(row) {
      row.forEach(function(cell, col_index) {
        col_widths[col_index] = Math.max(col_widths[col_index] || 0, cell.value.length);
      });
    });
    return col_widths;
  }

};
