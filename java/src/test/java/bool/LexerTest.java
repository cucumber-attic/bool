package bool;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class LexerTest {

    private Lexer lexer;

    @Test
    public void tokenizes_a_feature_keyword() {
        lexer = new Lexer("  \n  Feature: hello\n");
        assertLex(Lexer.TOKEN_FEATURE, "Feature:");
        assertLex(Lexer.TOKEN_NAME, "hello");
    }

    @Test
    public void tokenizes_tags() {
        lexer = new Lexer("@foo @bar @zap\n\n");
        assertLex(Lexer.TOKEN_TAG, "@foo");
        assertLex(Lexer.TOKEN_TAG, "@bar");
        assertLex(Lexer.TOKEN_TAG, "@zap");
    }

    @Test
    public void tokenizes_steps() {
        lexer = new Lexer(" Given  I have 4 cukes in my belly\n");
        assertLex(Lexer.TOKEN_STEP, "Given ");
        assertLex(Lexer.TOKEN_NAME, "I have 4 cukes in my belly");
    }

    @Test
    public void tokenizes_a_named_feature_with_given_when() {
        lexer = new Lexer(
                "Feature:     Hello\n" +
                "  Given I have 4 cukes in my belly\n" +
                " When  I go shopping\n");
        assertLex(Lexer.TOKEN_FEATURE, "Feature:");
        assertLex(Lexer.TOKEN_NAME, "Hello");
        assertLex(Lexer.TOKEN_STEP, "Given ");
        assertLex(Lexer.TOKEN_NAME, "I have 4 cukes in my belly");
        assertLex(Lexer.TOKEN_STEP, "When ");
        assertLex(Lexer.TOKEN_NAME, "I go shopping");
    }

    @Test
    public void tokenizes_scenarios() {
        lexer = new Lexer(
                "Scenario:     Hello\n" +
                "Scenario Outline:World\n");
        assertLex(Lexer.TOKEN_SCENARIO, "Scenario:");
        assertLex(Lexer.TOKEN_NAME, "Hello");
        assertLex(Lexer.TOKEN_SCENARIO_OUTLINE, "Scenario Outline:");
        assertLex(Lexer.TOKEN_NAME, "World");
    }

    @Test
    public void tokenizes_a_named_feature_with_description() {
        lexer = new Lexer(
                "Feature:     Hello\n" +
                "  this is a description\n" +
                "  and so is this");
        assertLex(Lexer.TOKEN_FEATURE, "Feature:");
        assertLex(Lexer.TOKEN_NAME, "Hello");
        assertLex(Lexer.TOKEN_DESCRIPTION_LINE, "this is a description");
        assertLex(Lexer.TOKEN_DESCRIPTION_LINE, "and so is this");
    }

    private void assertLex(int type, String value) {
        int actualType = lexer.yylex();
        assertEquals(value, lexer.getLVal().getValue());
        assertEquals(type, actualType);
    }

}
