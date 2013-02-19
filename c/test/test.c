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

YYSTYPE yylval;
YYLTYPE yylloc;
yyscan_t scanner;
#define YYLEX yylex(&yylval, &yylloc, scanner)
#define SOURCE(src) yylex_init(&scanner); yy_scan_string(src, scanner)

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
    ASSERT_EQUALS(4, last_error.last_line);
    ASSERT_EQUALS(4, last_error.first_column);
    ASSERT_EQUALS(5, last_error.last_column);
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
    ASSERT_EQUALS(1, last_error.last_line);
    ASSERT_EQUALS(1, last_error.first_column);
    ASSERT_EQUALS(1, last_error.last_column);
    ASSERT_STRING_EQUALS("Unexpected character: ^", last_error.message);
}

void test_invalid_token()
{
    Node* ast = parse_ast(
        "^£$");

    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(1, last_error.first_line);
    ASSERT_EQUALS(1, last_error.last_line);
    ASSERT_EQUALS(1, last_error.first_column);
    ASSERT_EQUALS(1, last_error.last_column);
    ASSERT_STRING_EQUALS("Unexpected character: ^", last_error.message);
}

void test_invalid_statement()
{
    Node* ast = parse_ast(
        "a ^ e");
    
    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(1, last_error.first_line);
    ASSERT_EQUALS(1, last_error.last_line);
    // TODO: should be 2 and 3
    ASSERT_EQUALS(1, last_error.first_column);
    ASSERT_EQUALS(1, last_error.last_column);
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
       //01234567890
    ASSERT_EQUALS(NULL, ast);
    ASSERT_EQUALS(6, last_error.first_line);
    ASSERT_EQUALS(6, last_error.last_line);
    ASSERT_EQUALS(9, last_error.first_column);
    ASSERT_EQUALS(10, last_error.last_column);
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
    ASSERT_EQUALS(TOKEN_OR, YYLEX);
    ASSERT_EQUALS(TOKEN_VAR, YYLEX);
}

int main()
{
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