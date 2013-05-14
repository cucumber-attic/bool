package bool.ast;

public interface MultilineArg {
    public abstract <R, A> R accept(Visitor<R, A> visitor, A arg);

    interface Visitor<R, A> {
        R visit(Table table, A arg);

        R visit(DocString docString, A arg);
    }
}
