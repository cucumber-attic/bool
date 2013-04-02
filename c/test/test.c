#include "tinytest.h"

#include "../ast.h"
#include "../unused.h"
#include "../parser.h"
#include "../lexer.h"

/* begin standard C headers. */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

extern int yydebug;

void test_valid_expression()
{
    Node* ast = parse_ast(
        "a && b");
        
    ASSERT("AST should not have returned NULL", ast);
    ASSERT_EQUALS(eAND, ast->type);
}

void test_line_and_column()
{
    Node* ast = parse_ast(
        "      \n"
        "      \n"
        "      \n"
        "   && \n");
       //12345678
    ASSERT_EQUALS(NULL, ast);

    ASSERT_EQUALS(4, last_error.token->first_line);
    ASSERT_EQUALS(4, last_error.token->last_line);
    ASSERT_EQUALS(4, last_error.token->first_column);
    ASSERT_EQUALS(6, last_error.token->last_column);
    ASSERT_STRING_EQUALS(
        "syntax error, unexpected TOKEN_AND, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN", 
        last_error.message);
}

void test_invalid_symbol()
{
    Node* ast = parse_ast(
        "      \n"
        "      \n"
        "      \n"
        "    ^^\n");
       //12345678

    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(4, last_error.token->first_line);
    ASSERT_EQUALS(5, last_error.token->first_column);
    ASSERT_STRING_EQUALS("syntax error: ^^\n", last_error.message);
}

void test_invalid_token()
{
    Node* ast = parse_ast(
        "^£$");

    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(1, last_error.token->first_line);
    ASSERT_STRING_EQUALS("syntax error: ^£$", last_error.message);
}

void test_invalid_statement()
{
    Node* ast = parse_ast(
        "a ^ e");
    
    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(1, last_error.token->first_line);
    ASSERT_STRING_EQUALS("syntax error: ^ e", last_error.message);
}

void test_invalid_long_statement()
{
    Node* ast = parse_ast(
        "          \n"
        "          \n"
        "  a       \n"
        "    ||    \n"
        "      c   \n"
        "        &&");
    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(6, last_error.token->first_line);
    ASSERT_EQUALS(9, last_error.token->first_column);
    ASSERT_EQUALS(11, last_error.token->last_column);
    ASSERT_STRING_EQUALS(
        "syntax error, unexpected $end, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN", 
        last_error.message);
}

void test_lex_1()
{
    scan_init("a && b");

    ASSERT_EQUALS(TOKEN_VAR, yylex());
    ASSERT_EQUALS(TOKEN_AND, yylex());
    ASSERT_EQUALS(TOKEN_VAR, yylex());
}

void test_lex_2()
{
    scan_init("a || b");

    ASSERT_EQUALS(TOKEN_VAR, yylex());
    ASSERT_STRING_EQUALS("a", yylval.token->value);
    ASSERT_EQUALS(1, yylval.token->first_line);
    ASSERT_EQUALS(1, yylval.token->last_line);
    ASSERT_EQUALS(1, yylval.token->first_column);
    ASSERT_EQUALS(2, yylval.token->last_column);
    ASSERT_EQUALS(TOKEN_OR, yylex());
    ASSERT_EQUALS(1, yylval.token->first_line);
    ASSERT_EQUALS(1, yylval.token->last_line);
    ASSERT_EQUALS(3, yylval.token->first_column);
    ASSERT_EQUALS(5, yylval.token->last_column);
    ASSERT_EQUALS(TOKEN_VAR, yylex());
    ASSERT_STRING_EQUALS("b", yylval.token->value);
    ASSERT_EQUALS(1, yylval.token->first_line);
    ASSERT_EQUALS(1, yylval.token->last_line);
    ASSERT_EQUALS(6, yylval.token->first_column);
    ASSERT_EQUALS(7, yylval.token->last_column);
}

int main()
{
    //yydebug = 1;
    RUN(test_valid_expression);
    RUN(test_line_and_column);
    RUN(test_invalid_symbol);
    RUN(test_invalid_token);
    RUN(test_invalid_statement);
    RUN(test_invalid_long_statement);
    RUN(test_lex_1);
    RUN(test_lex_2);
 
    return TEST_REPORT();
}