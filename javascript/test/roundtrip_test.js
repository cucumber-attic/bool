var assert = require('assert');
var fs = require('fs');
var util = require('util');
var path = require('path');
var parser = require('../lib').parser;
var lexer = require('../lib/lexer');
var Renderer = require('../lib/renderer');

var debug = false;

describe('Parser and renderer', function() {
  var dir = path.join(__dirname, '../../testdata/good');
  fs.readdirSync(dir).forEach(function(f) {
    if(f.match(/\.feature$/)) {
      var source = fs.readFileSync(path.join(dir, f), 'UTF-8');
      it('roundtrips ' + f, function() {
        var feature = parser.parse(source);
        var rendered = new Renderer().render(feature, "");
        if(debug) {
          console.log("---");
          console.log(rendered);
          console.log("===");
        }
        assert.equal(source, rendered);
      });

      if(debug) {
        it('scans ' + f, function() {
          console.log("====== %s ======", f);
          lexer.setInput(source);
          while(true) {
            var tok = lexer.lex();
            console.log("%s %s %s", tok, util.inspect(lexer.yytext), lexer.conditionStack);
            if(tok == 'EOF') {
              break;
            }
          }
        });
      }
  	}
  });
});

