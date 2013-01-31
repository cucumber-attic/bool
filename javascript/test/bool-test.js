var bool = require('bool');
var assert = require('assert');

describe('Bool', function() {
  it('sole tag', function() {
    var expr = bool.parse('@a');

    assert.equal(true, expr.accept(new bool.EvalVisitor(), ['@a']));
    assert.equal(false, expr.accept(new bool.EvalVisitor(), ['@b']));
  });

  it('does and', function() {
    var expr = bool.parse('@a && @b');
    assert.equal(true, expr.accept(new bool.EvalVisitor(), ['@a', '@b']));
    assert.equal(false, expr.accept(new bool.EvalVisitor(), ['@a']));
    assert.equal(false, expr.accept(new bool.EvalVisitor(), ['@b']));
    assert.equal(false, expr.accept(new bool.EvalVisitor(), []));
  });

  it('Does it all', function() {
    var expr = bool.parse('@a && @b || !@c');
    assert.equal(true, expr.accept(new bool.EvalVisitor(), ['@a', '@b']));
    assert.equal(false, expr.accept(new bool.EvalVisitor(), ['@c']));
    assert.equal(true, expr.accept(new bool.EvalVisitor(), []));
  });

  it('double negation', function() {
    var expr = bool.parse('!!@a');
    assert.equal(true, expr.accept(new bool.EvalVisitor(), ['@a']));
    assert.equal(false, expr.accept(new bool.EvalVisitor(), ['@b']));
  });

  it('tag syntax', function() {
    var expr = bool.parse('!@a1A');
    assert.equal(false, expr.accept(new bool.EvalVisitor(), ['@a1A']));
  });
});

