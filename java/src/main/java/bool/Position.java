package bool;

public class Position {
    public int getLine() {
        return line;
    }

    public int getColumn() {
        return column;
    }

    private final int line;
    private final int column;

    public Position(int line, int column) {
        this.line = line;
        this.column = column;
    }
}
