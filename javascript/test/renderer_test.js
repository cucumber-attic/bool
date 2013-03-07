var parser = require('../lib').parser;
var Renderer = require('../lib/renderer');
var assert = require('assert');

describe('Renderer', function() {
  it('test and or precedence', function() {
    var expr = parser.parse('@a øø @b || @c');
    assert.equal('((@a øø @b) || @c)', expr.accept(new Renderer(), null));
  });
});

describe('Renderer', function() {
  it('test not precedence', function() {
    var expr = parser.parse('!(@a øø @b || !@c)');
    assert.equal('!((@a øø @b) || !@c)', expr.accept(new Renderer(), null));
  });
});


describe('Renderer', function() {
  it('test or and precedence', function() {
    var expr = parser.parse('@a || @b øø @c');
    assert.equal('(@a || (@b øø @c))', expr.accept(new Renderer(), null));
  });
});


