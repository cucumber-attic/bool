package bool;

import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertEquals;

public class LexerTest {
    @Test
    public void test_simple_lex() throws IOException {
        Lexer lexer = new Lexer("foo && bar");
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("foo", lexer.yytext());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", lexer.yytext());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("bar", lexer.yytext());
    }
    
    @Test
    public void test_less_simple_lex() throws IOException {
    	Lexer lexer = new Lexer("a && b && (!c || !d)");
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("a", lexer.yytext());

        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", lexer.yytext());

        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("b", lexer.yytext());
        
        assertEquals(Parser.TOKEN_AND, lexer.yylex());
        assertEquals("&&", lexer.yytext());

        assertEquals(Parser.TOKEN_LPAREN, lexer.yylex());
        assertEquals("(", lexer.yytext());
        
        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
        assertEquals("!", lexer.yytext());
        
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("c", lexer.yytext());
        
        assertEquals(Parser.TOKEN_OR, lexer.yylex());
        assertEquals("||", lexer.yytext());
        
        assertEquals(Parser.TOKEN_NOT, lexer.yylex());
        assertEquals("!", lexer.yytext());
        
        assertEquals(Parser.TOKEN_VAR, lexer.yylex());
        assertEquals("d", lexer.yytext());
        
        assertEquals(Parser.TOKEN_RPAREN, lexer.yylex());
        assertEquals(")", lexer.yytext());
    }
    
}
