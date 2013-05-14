package bool.ast;

import java.util.List;

public class DocString implements Union, MultilineArg {
    private List<Token> lines;

    public DocString(List<Token> lines) {
        this.lines = lines;
    }

    @Override
    public <R, A> R accept(MultilineArg.Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
