var parser = require('../lib');
var assert = require('assert');

describe('Bool', function() {
  it('sole tag', function() {
    var expr = parser.parse('@a');

    assert.equal(true, expr.describeTo(new parser.Evaluator(), ['@a']));
    assert.equal(false, expr.describeTo(new parser.Evaluator(), ['@b']));
  });

  it('does and', function() {
    var expr = parser.parse('@a && @b');
    assert.equal(true, expr.describeTo(new parser.Evaluator(), ['@a', '@b']));
    assert.equal(false, expr.describeTo(new parser.Evaluator(), ['@a']));
    assert.equal(false, expr.describeTo(new parser.Evaluator(), ['@b']));
    assert.equal(false, expr.describeTo(new parser.Evaluator(), []));
  });

  it('Does it all', function() {
    var expr = parser.parse('@a && @b || !@c');
    assert.equal(true, expr.describeTo(new parser.Evaluator(), ['@a', '@b']));
    assert.equal(false, expr.describeTo(new parser.Evaluator(), ['@c']));
    assert.equal(true, expr.describeTo(new parser.Evaluator(), []));
  });

  it('double negation', function() {
    var expr = parser.parse('!!@a');
    assert.equal(true, expr.describeTo(new parser.Evaluator(), ['@a']));
    assert.equal(false, expr.describeTo(new parser.Evaluator(), ['@b']));
  });

  it('tag syntax', function() {
    var expr = parser.parse('!@a1A');
    assert.equal(false, expr.describeTo(new parser.Evaluator(), ['@a1A']));
  });
});

