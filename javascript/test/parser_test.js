var parser = require('../lib');
var assert = require('assert');

describe('Bool', function() {
  it('sole tag', function() {
    var expr = parser.parse('@a');

    assert.equal(true, expr.accept(new parser.EvalVisitor(), ['@a']));
    assert.equal(false, expr.accept(new parser.EvalVisitor(), ['@b']));
  });

  it('does and', function() {
    var expr = parser.parse('@a && @b');
    assert.equal(true, expr.accept(new parser.EvalVisitor(), ['@a', '@b']));
    assert.equal(false, expr.accept(new parser.EvalVisitor(), ['@a']));
    assert.equal(false, expr.accept(new parser.EvalVisitor(), ['@b']));
    assert.equal(false, expr.accept(new parser.EvalVisitor(), []));
  });

  it('Does it all', function() {
    var expr = parser.parse('@a && @b || !@c');
    assert.equal(true, expr.accept(new parser.EvalVisitor(), ['@a', '@b']));
    assert.equal(false, expr.accept(new parser.EvalVisitor(), ['@c']));
    assert.equal(true, expr.accept(new parser.EvalVisitor(), []));
  });

  it('double negation', function() {
    var expr = parser.parse('!!@a');
    assert.equal(true, expr.accept(new parser.EvalVisitor(), ['@a']));
    assert.equal(false, expr.accept(new parser.EvalVisitor(), ['@b']));
  });

  it('tag syntax', function() {
    var expr = parser.parse('!@a1A');
    assert.equal(false, expr.accept(new parser.EvalVisitor(), ['@a1A']));
  });
});

