var assert = require('assert');
var lexer = require('../lib/lexer');
// Install our own parseError function that doesn't depend on the parser.
var SyntaxError = require('../lib/syntax_error');
lexer.parseError = function(message, hash){
  throw new SyntaxError(message, hash)
};

function lex() {
  return [lexer.lex(), lexer.yytext];
}

describe('Lexer', function() {
  it('tokenizes a good stream', function() {
    lexer.setInput("  a   &&  b  ");

    assert.deepEqual([ 'TOKEN_VAR', 'a' ], lex());
    assert.deepEqual([ 'TOKEN_AND', '&&' ], lex());
    assert.deepEqual([ 'TOKEN_VAR', 'b' ], lex());
  });

  it('complains when input cannot be scanned', function() {
    lexer.setInput("???");
    try {
      lex();
      throw new Error('should fail');
    } catch(expected) {
      assert.equal('Lexical error on line 1. Unrecognized text.\n???\n^', expected.message);
    }
  });
});

