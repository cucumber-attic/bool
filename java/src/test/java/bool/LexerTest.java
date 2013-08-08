package bool;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class LexerTest {

    private Lexer lexer;

    @Test
    public void test_simple_lex() {
        lexer = new Lexer("  \n  Feature: hello\n");
        assertLex(Parser.TOKEN_FEATURE, "Feature:");
        assertLex(Parser.TOKEN_NAME, "hello");
    }

    @Test
    public void tokenizes_tags() {
        lexer = new Lexer("@foo @bar @zap\n\n");
        assertLex(Parser.TOKEN_TAG, "@foo");
        assertLex(Parser.TOKEN_TAG, "@bar");
        assertLex(Parser.TOKEN_TAG, "@zap");
    }

    @Test
    public void tokenizes_a_named_feature_with_given_when() {
        lexer = new Lexer("" +
                "Feature:     Hello\n" +
                "  Given I have 4 cukes in my belly\n" +
                "  When  I go shopping\n");
        assertLex(Parser.TOKEN_FEATURE, "Feature:");
        assertLex(Parser.TOKEN_NAME, "Hello");
        assertLex(Parser.TOKEN_STEP, "Given ");
        assertLex(Parser.TOKEN_NAME, "I have 4 cukes in my belly");
        assertLex(Parser.TOKEN_STEP, "When ");
        assertLex(Parser.TOKEN_NAME, " I go shopping");
    }

    @Test
    public void tokenizes_a_named_feature_with_description() {
        lexer = new Lexer("" +
                "Feature:     Hello\n" +
                "  this is a description\n" +
                "  and so is this");
        assertLex(Parser.TOKEN_FEATURE, "Feature:");
        assertLex(Parser.TOKEN_NAME, "Hello");
        assertLex(Parser.TOKEN_DESCRIPTION_LINE, "this is a description");
        assertLex(Parser.TOKEN_DESCRIPTION_LINE, "and so is this");
    }

    private void assertLex(int type, String value) {
        int actualType = lexer.yylex();
        assertEquals(value, lexer.getLVal().getValue());
        assertEquals(type, actualType);
    }

    //    @Test
//    public void test_less_simple_lex() throws IOException {
//        Lexer lexer = new Lexer("a && b && (!c || !d)");
//        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
//        assertEquals("a", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_AND, lexer.yylex());
//        assertEquals("&&", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
//        assertEquals("b", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_AND, lexer.yylex());
//        assertEquals("&&", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_LPAREN, lexer.yylex());
//        assertEquals("(", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
//        assertEquals("!", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
//        assertEquals("c", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_OR, lexer.yylex());
//        assertEquals("||", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
//        assertEquals("!", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
//        assertEquals("d", getToken(lexer).getValue());
//
//        assertEquals(Parser.TOKEN_RPAREN, lexer.yylex());
//        assertEquals(")", getToken(lexer).getValue());
//    }
//
//    @Test
//    public void test_lex_error() throws IOException {
//        Lexer lexer = new Lexer("" +
//                "          \n" +
//                "          \n" +
//                "  a       \n" +
//                "    ?     \n"
//        );
//        lexer.yylex();
//        try {
//            lexer.yylex();
//            fail();
//        } catch (SyntaxError expected) {
//            assertEquals("syntax error: ?     \n", expected.getMessage());
//            assertEquals(4, expected.getToken().getFirstLine());
//            assertEquals(5, expected.getToken().getFirstColumn());
//            assertEquals(5, expected.getToken().getLastColumn());
//        }
//    }
}
