var assert = require('assert');
var lexer = require('../lib/lexer');
// Install our own parseError function that doesn't depend on the parser.
var SyntaxError = require('../lib/syntax_error');
lexer.parseError = function(message, hash){
  throw new SyntaxError(message, hash);
};

function lex() {
  return [lexer.lex(), lexer.yytext];
}

describe('Lexer', function() {
  it('tokenizes a feature keyword', function() {
    lexer.setInput("  \n  Feature:");

    assert.deepEqual([ 'TOKEN_FEATURE', 'Feature:' ], lex());
  });

  it('tokenizes a named feature with given', function() {
    lexer.setInput("Feature:     Hello\n  Given ");

    assert.deepEqual([ 'TOKEN_FEATURE', 'Feature:' ], lex());
    assert.deepEqual([ 'TOKEN_NAME', 'Hello' ], lex());
    assert.deepEqual([ 'TOKEN_STEP', 'Given ' ], lex());
  });

});

