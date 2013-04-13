package bool;

/**
 * Common exception for both lex/scan and parse errors.
 */
public class SyntaxError extends RuntimeException {
    private final int firstLine;
    private final int lastLine;
    private final int firstColumn;
    private final int lastColumn;

    public SyntaxError(String message, int firstLine, int lastLine, int firstColumn, int lastColumn) {
        super(message);
        this.firstLine = firstLine;
        this.lastLine = lastLine;
        this.firstColumn = firstColumn;
        this.lastColumn = lastColumn;
    }

    public int getFirstLine() {
        return firstLine;
    }

    public int getFirstColumn() {
        return firstColumn;
    }

    public int getLastLine() {
        return lastLine;
    }

    public int getLastColumn() {
        return lastColumn;
    }
}
