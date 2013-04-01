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

#define SOURCE(src) scan_init(src)
#define YYLEX yylex()
#define YYTEXT yytext()

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
    ASSERT_EQUALS(NULL, ast);

    ASSERT_EQUALS(4, last_error.first_line);
    ASSERT_STRING_EQUALS(
        "syntax error, unexpected TOKEN_AND, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN", 
        last_error.message);
}

void test_invalid_symbol()
{
    Node* ast = parse_ast(
        "^");

    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(1, last_error.first_line);
    printf("ERR:%s\n", last_error.message);
    ASSERT_STRING_EQUALS("Unexpected character: ^", last_error.message);
}

void test_invalid_token()
{
    Node* ast = parse_ast(
        "^£$");

    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(1, last_error.first_line);
    ASSERT_STRING_EQUALS("Unexpected character: ^", last_error.message);
}

void test_invalid_statement()
{
    Node* ast = parse_ast(
        "a ^ e");
    
    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(1, last_error.first_line);
    ASSERT_STRING_EQUALS("Unexpected character: ^", last_error.message);
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
    ASSERT_EQUALS(6, last_error.first_line);
    ASSERT_STRING_EQUALS(
        "syntax error, unexpected $end, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN", 
        last_error.message);
}

void test_lex_1()
{
    SOURCE("a && b");

    ASSERT_EQUALS(TOKEN_VAR, YYLEX);
    ASSERT_EQUALS(TOKEN_AND, YYLEX);
    ASSERT_EQUALS(TOKEN_VAR, YYLEX);
}

void test_lex_2()
{
    SOURCE("a || b");

    ASSERT_EQUALS(TOKEN_VAR, YYLEX);
    ASSERT_STRING_EQUALS("a", YYTEXT);
    ASSERT_EQUALS(TOKEN_OR, YYLEX);
    ASSERT_EQUALS(TOKEN_VAR, YYLEX);
    ASSERT_STRING_EQUALS("b", YYTEXT);
}

int main()
{
    RUN(test_valid_expression);
//    RUN(test_invalid_symbol);
/*
    RUN(test_line_and_column);
    RUN(test_invalid_token);
    RUN(test_invalid_statement);
    RUN(test_invalid_long_statement);
    RUN(test_lex_1);
    RUN(test_lex_2);
    */
 
    return TEST_REPORT();
}