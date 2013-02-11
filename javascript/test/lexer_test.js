var parser = require('../lib');
var assert = require('assert');
var lexer = parser.parser.lexer;

function lex() {
  return [parser.parser.terminals_[lexer.lex()], lexer.yytext];
}

describe('Lexer', function() {
  it('tokenizes a good stream', function() {
    lexer.setInput("  a   &&  b  ");

    assert.deepEqual([ 'TOKEN_VAR', 'a' ], lex());
    assert.deepEqual([ 'TOKEN_AND', '&&' ], lex());
    assert.deepEqual([ 'TOKEN_VAR', 'b' ], lex());
  });
});

