var parser = require('../lib');
var assert = require('assert');
var fs = require('fs');
var path = require('path');

describe('Testdata', function() {
  var dir = path.join(__dirname, '../../testdata');
  fs.readdirSync(dir).forEach(function(f) {
    var lines = fs.readFileSync(path.join(dir, f), 'UTF-8').split(/\n/);
    it(f, function() {
      var expr = parser.parse(lines[0]);
      var vars = lines[1].split(/\s+/);
      var expected = lines[2];
      assert.equal(expected, expr.accept(new parser.EvalVisitor(), vars).toString());
    });
  }); 
});

