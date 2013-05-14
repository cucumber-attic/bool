package bool.ast;

import java.util.List;

public class Table implements Union, MultilineArg {
    public final List<List<Token>> rows;

    public Table(List<List<Token>> rows) {
        this.rows = rows;
    }

    @Override
    public <R, A> R accept(Visitor<R, A> visitor, A arg) {
        return visitor.visit(this, arg);
    }
}
