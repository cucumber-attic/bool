package bool;

public class Token implements Union {
    private final String value;
    private final Position startPos;
    private final Position endPos;

    public Token(String value, Position location) {
        this(value, location, location);
    }

    public Token(String value, Position startPos, Position endPos) {
        this.value = value;
        this.startPos = startPos;
        this.endPos = endPos;
    }

    public String getValue() {
        return value;
    }
}
