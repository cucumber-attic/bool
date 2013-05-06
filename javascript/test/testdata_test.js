var parser = require('../lib').parser;
var Renderer = require('../lib/renderer');
var assert = require('assert');
var fs = require('fs');
var path = require('path');

describe('Testdata', function() {
  var dir = path.join(__dirname, '../../testdata');
  fs.readdirSync(dir).forEach(function(f) {
    var source = fs.readFileSync(path.join(dir, f), 'UTF-8');
    it(f, function() {
      var feature = parser.parse(source);
      var rendered = new Renderer().render(feature, "");
      //console.log(rendered);
      assert.equal(source, rendered);
    });
  });
});

