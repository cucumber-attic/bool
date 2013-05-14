package bool;

import bool.ast.Position;

/**
 * Common exception for both lex/scan and parse errors.
 */
public class SyntaxError extends RuntimeException {

    public final Position startPos;
    public final Position endPos;

    public SyntaxError(String message, Parser.Location location) {
        this(message, location.begin, location.end);
    }

    public SyntaxError(String message, Position startPos, Position endPos) {
        super(message);
        this.startPos = startPos;
        this.endPos = endPos;
    }
}
