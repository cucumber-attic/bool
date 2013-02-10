package bool;

/**
 * Common exception for both lex/scan and parse errors.
 */
public class SyntaxError extends RuntimeException {
    private final int line;
    private final int column;

    public SyntaxError(String message, int line, int column) {
        super(message);
        this.line = line;
        this.column = column;
    }

    public int getLine() {
        return line;
    }

    public int getColumn() {
        return column;
    }
}
