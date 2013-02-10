#include "tinytest.h"

#include "../ast.h"
#include "../unused.h"

/* begin standard C headers. */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

void test_valid_expression()
{
    Node* ast = parse_ast(
        "a && b");
        
    ASSERT("AST should not have returned NULL", ast);
    ASSERT_EQUALS(eAND, ast->type);
    printf("TYPE: %d\n", ast->type);
}

void test_line_and_column()
{
    Node* ast = parse_ast(
        "      \n"
        "      \n"
        "      \n"
        "   && \n");
        
    ASSERT_EQUALS(NULL, ast);

    char message[] = "syntax error, unexpected TOKEN_AND, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN";
    ASSERT_EQUALS(4, last_error.line);
    ASSERT_EQUALS(5, last_error.column);
    ASSERT_STRING_EQUALS(message, last_error.message);
}

void test_invalid_symbol()
{
    Node* ast = parse_ast(
        "^");

    ASSERT_EQUALS(NULL, ast);

    char message[] = "Unexpected character: ^";
    ASSERT_EQUALS(1, last_error.line);
    ASSERT_EQUALS(1, last_error.column);
    ASSERT_STRING_EQUALS(message, last_error.message);
}

void test_invalid_token()
{
    Node* ast = parse_ast(
        "^£$");

    ASSERT_EQUALS(NULL, ast);

    char message[] = "Unexpected character: ^";
    ASSERT_EQUALS(1, last_error.line);
    ASSERT_EQUALS(1, last_error.column);
    ASSERT_STRING_EQUALS(message, last_error.message);
}

void test_invalid_statement()
{
    Node* ast = parse_ast(
        "a ^ e");
    
    ASSERT_EQUALS(NULL, ast);

    char message[] = "Unexpected character: ^";
    ASSERT_EQUALS(1, last_error.line);
    printf("WHERE %d\n", last_error.column);
    ASSERT_EQUALS(3, last_error.column);
    ASSERT_STRING_EQUALS(message, last_error.message);
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
   
    char message[] = "syntax error, unexpected $end, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN";
    ASSERT_EQUALS(6, last_error.line);
    ASSERT_EQUALS(10, last_error.column);
    ASSERT_STRING_EQUALS(message, last_error.message);
}

int main()
{
    RUN(test_valid_expression);
    RUN(test_line_and_column);
    RUN(test_invalid_symbol);
    RUN(test_invalid_token);
    RUN(test_invalid_statement);
    RUN(test_invalid_long_statement);
 
    return TEST_REPORT();
}