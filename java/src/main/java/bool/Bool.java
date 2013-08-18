package bool;

public class Bool {
    public static Node parse(String source) {
        Lexer lexer = new Lexer(source);
        Parser parser = new Parser(lexer);
        return parser.buildAst();
    }
}
