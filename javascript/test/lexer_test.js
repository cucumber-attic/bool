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

  it('tokenizes a named feature with given when', function() {
    lexer.setInput("Feature:     Hello\n" +
                   "  Given I have 4 cukes in my belly\n" +
                   "  When I go shopping\n"
                   );

    assert.deepEqual([ 'TOKEN_FEATURE', 'Feature:' ], lex());
    assert.deepEqual([ 'TOKEN_NAME', 'Hello' ], lex());
    assert.deepEqual([ 'TOKEN_STEP', 'Given ' ], lex());
    assert.deepEqual([ 'TOKEN_NAME', 'I have 4 cukes in my belly' ], lex());
    assert.deepEqual([ 'TOKEN_STEP', 'When ' ], lex());
    assert.deepEqual([ 'TOKEN_NAME', 'I go shopping' ], lex());
  });

  it('tokenizes a named feature with description', function() {
    lexer.setInput("Feature:     Hello\n  This is a description\n  and so is this");

    assert.deepEqual([ 'TOKEN_FEATURE', 'Feature:' ], lex());
    assert.deepEqual([ 'TOKEN_NAME', 'Hello' ], lex());
    assert.deepEqual([ 'TOKEN_DESCRIPTION_LINE', 'This is a description' ], lex());
    assert.deepEqual([ 'TOKEN_DESCRIPTION_LINE', 'and so is this' ], lex());
  });

  it ('tokenizes descriptions and given when then even when description is long', function() {
    lexer.setInput("Feature:     description1\n  this is a longer description than the given step\n  Given a step");

    assert.deepEqual([ 'TOKEN_FEATURE', 'Feature:' ], lex());
    assert.deepEqual([ 'TOKEN_NAME', 'description1' ], lex());
    assert.deepEqual([ 'TOKEN_DESCRIPTION_LINE', 'this is a longer description than the given step' ], lex());
    assert.deepEqual([ 'TOKEN_STEP', 'Given ' ], lex());
    assert.deepEqual([ 'TOKEN_NAME', 'a step' ], lex());
  });
});

