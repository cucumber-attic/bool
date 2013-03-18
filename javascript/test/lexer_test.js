var lexer = require('../lib/lexer');
var assert = require('assert');

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
});

