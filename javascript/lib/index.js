var parser = require('./parser');

function SyntaxError(message, hash) {
    this.name = "SyntaxError";
    this.message = message;
    this.hash = hash;
}
SyntaxError.prototype = Error.prototype;

parser.parser.parseError = function parseError(message, hash) {
    throw new SyntaxError(message, hash);
};
module.exports.parse = parser.parse;
module.exports.EvalVisitor = require('./eval_visitor');
