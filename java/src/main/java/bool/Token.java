package bool;

public class Token implements Union {
    private final String value;
    private final int firstLine;
    private final int lastLine;
    private final int firstColumn;
    private final int lastColumn;

    public Token(String value, int firstLine, int lastLine, int firstColumn, int lastColumn) {
        this.value = value;
        this.firstLine = firstLine;
        this.lastLine = lastLine;
        this.firstColumn = firstColumn;
        this.lastColumn = lastColumn;
    }

    public String getValue() {
        return value;
    }

    public int getFirstLine() {
        return firstLine;
    }

    public int getLastLine() {
        return lastLine;
    }

    public int getFirstColumn() {
        return firstColumn;
    }

    public int getLastColumn() {
        return lastColumn;
    }
}
