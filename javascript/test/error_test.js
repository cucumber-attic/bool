var assert = require('assert');
var fs = require('fs');
var path = require('path');
var parser = require('../lib').parser;
var Compiler = require('../lib/compiler');

describe('Parser', function() {
  var dir = path.join(__dirname, '../../testdata/bad');
  fs.readdirSync(dir).forEach(function(f) {
    if(f.match(/\.feature$/)) {
      var source = fs.readFileSync(path.join(dir, f), 'UTF-8');
      it('should fail to parse ' + f, function() {
//        assert.throws(function() {
          var feature = parser.parse(source);
          var units = new Compiler().compile(feature);
//        }, 'Should not parse ' + f);
      });
    }
  });
});

