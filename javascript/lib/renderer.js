module.exports = function Renderer() {
  var self = this;

  this.visit_feature = function(node, _) {
    var description = node.description_lines.map(function(line) {
      return '  ' + line.value;
    }).join('\n');
    return node.keyword.value + ' ' + node.name.value + '\n' + description + '\n';
  };

  this.render = function(node) {
    return node.accept(self, null);
  };
};
