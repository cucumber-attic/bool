package bool.ast;

import bool.Parser;

public class Token implements Union {
    private final String value;
    private Parser.Location location;

    public Token(String value, Parser.Location location) {
        this.value = value;
        this.location = location;
    }

    public String getValue() {
        return value;
    }

    public int getFirstLine() {
        return location.begin.line;
    }

    public int getLastLine() {
        return location.end.line;
    }

    public int getFirstColumn() {
        return location.begin.column;
    }

    public int getLastColumn() {
        return location.end.column;
    }
}
