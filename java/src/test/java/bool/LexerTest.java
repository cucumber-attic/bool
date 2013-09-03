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

    @Test
    public void tokenizes_a_docstring() {
        lexer = new Lexer(
                "  \"\"\"  \n" +
                "  This is\n" +
                "   a DocString\n" +
                "  \"\"\"\n" +
                "Given something\n" +
                "  \"\"\"  \n" +
                "  The next\n" +
                "DocString\n" +
                "  \"\"\"\n");
        assertLex(Lexer.TOKEN_DOC_STRING_LINE, "  This is\n");
        assertLex(Lexer.TOKEN_DOC_STRING_LINE, "   a DocString\n");
        assertLex(Lexer.TOKEN_STEP, "Given ");
        assertLex(Lexer.TOKEN_NAME, "something");
        assertLex(Lexer.TOKEN_DOC_STRING_LINE, "  The next\n");
    }

    @Test
    public void tokenizes_cells() {
        lexer = new Lexer("|foo|bar|  \n  ");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_CELL, "foo");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_CELL, "bar");
        assertLex(Lexer.TOKEN_PIPE, "|  ");
        assertLex(Lexer.TOKEN_EOL, "\n");
    }

    @Test
    public void tokenizes_empty_cells() {
        lexer = new Lexer("|||\n");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_EOL, "\n");
    }

    @Test
    public void tokenizes_rows_of_cells() {
        lexer = new Lexer("  | aaa | |\n  || ddd |\n");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_CELL, " aaa ");
        assertLex(Lexer.TOKEN_PIPE, "| ");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_EOL, "\n");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_PIPE, "| ");
        assertLex(Lexer.TOKEN_CELL, "ddd ");
        assertLex(Lexer.TOKEN_PIPE, "|");
        assertLex(Lexer.TOKEN_EOL, "\n");
    }

    private void assertLex(int type, String value) {
        int actualType = lexer.yylex();
        assertEquals(value, lexer.getLVal().getValue());
        assertEquals(type, actualType);
    }

}
