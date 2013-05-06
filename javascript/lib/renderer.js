module.exports = function Renderer() {
  var self = this;

  this.visit_feature = function(node, out) {
    out += node.keyword.value + ' ' + node.name.value + '\n';
    node.description_lines.forEach(function(description_line) {
      out += '  ' + description_line.value + '\n';
    });
    out += '\n';

    node.feature_elements.forEach(function(feature_element) {
      out = self.render(feature_element, out);
    });
    return out;
  };

  this.visit_scenario = function(node, out) {
    out += '  ' + node.keyword.value + ' ' + node.name.value + '\n';
    node.description_lines.forEach(function(description_line) {
      out += '    ' + description_line.value + '\n';
    });
    out += '\n';

    node.steps.forEach(function(step) {
      out = self.render(step, out);
    });
    return out;
  };

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

  this.render = function(node, out) {
    return node.accept(self, out);
  };
};
