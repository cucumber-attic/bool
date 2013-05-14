package bool.ast;

public interface FeatureElement extends Union {
    public abstract <R, A> R accept(Visitor<R, A> visitor, A arg);

    interface Visitor<R, A> {
        R visit(Background background, A arg);

        R visit(Scenario scenario, A arg);

        R visit(ScenarioOutline scenarioOutline, A arg);
    }
}
