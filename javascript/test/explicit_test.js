var parser = require('../lib').parser;
var Explicit = require('../lib/explicit');
var assert = require('assert');

describe('Explicit', function() {
  it('test and or precedence', function() {
    var expr = parser.parse('@a && @b || @c');
    assert.equal('((@a && @b) || @c)', expr.describeTo(new Explicit(), null));
  });
});

describe('Explicit', function() {
  it('test not precedence', function() {
    var expr = parser.parse('!(@a && @b || !@c)');
    assert.equal('!((@a && @b) || !@c)', expr.describeTo(new Explicit(), null));
  });
});


describe('Explicit', function() {
  it('test or and precedence', function() {
    var expr = parser.parse('@a || @b && @c');
    assert.equal('(@a || (@b && @c))', expr.describeTo(new Explicit(), null));
  });
});


