var assert = require('assert');
var fs = require('fs');
var path = require('path');
var parser = require('../lib').parser;
var Compiler = require('../lib/compiler');

describe('Compiler', function() {
  it('compiles background', function() {
    var source = fs.readFileSync(path.join(__dirname, '../../testdata/with_background.feature'), 'UTF-8');
    var feature = parser.parse(source);
    var units = new Compiler().compile(feature);
    assert.equal(2, units.length);
    assert.equal(2, units[0].steps.length);
    assert.equal('a background step', units[0].steps[0].name.value);
    assert.equal('I have 3 more cukes in my belly', units[0].steps[1].name.value);
  });

  it('compiles scenario outline', function() {
    var source = fs.readFileSync(path.join(__dirname, '../../testdata/with_scenario_outline.feature'), 'UTF-8');
    var feature = parser.parse(source);
    var units = new Compiler().compile(feature);
    assert.equal(3, units.length);

    // TODO: assert.equal([???], units[0].steps[0].stack_frames)
    assert.equal('a background <n> step', units[1].steps[0].name.value);
    assert.equal('I have 20 cukes (20) in my belly', units[1].steps[1].name.value);
    assert.equal( 7, units[1].steps[1].name.locations[0].first_line);
    assert.equal(14, units[1].steps[1].name.locations[1].first_line);
    assert.equal('I eat 20 cukes', units[1].steps[2].name.value);
    assert.equal('I should have 40 cukes in my belly', units[1].steps[3].name.value);
  });
});
