function SyntaxError(message, hash) {
    this.name = "SyntaxError";
    this.message = message;
    this.hash = hash;
}
SyntaxError.prototype = Error.prototype;
module.exports = SyntaxError;
