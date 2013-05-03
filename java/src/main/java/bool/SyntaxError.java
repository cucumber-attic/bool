package bool;

/**
 * Common exception for both lex/scan and parse errors.
 */
public class SyntaxError extends RuntimeException {

    private final Token token;

    public SyntaxError(String message, Token token) {
        super(message);
        this.token = token;
    }

    public Token getToken() {
        return token;
    }
}
