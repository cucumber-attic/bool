package bool.ast;

public class Token implements Union {
    private final String value;
    private final int firstLine;
    private final int firstColumn;
    private final int lastLine;
    private final int lastColumn;

    public Token(String value, int firstLine, int firstColumn, int lastLine, int lastColumn) {
        this.value = value;
        this.firstLine = firstLine;
        this.firstColumn = firstColumn;
        this.lastLine = lastLine;
        this.lastColumn = lastColumn;
    }

    public String getValue() {
        return value;
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
