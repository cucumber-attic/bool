#include "minunit.h"

#include "../ast.h"
#include "../unused.h"

/* begin standard C headers. */
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

int tests_run;

static char* test_line_and_column()
{
    Node* ast = parse_ast(
        "      \n"
        "      \n"
        "      \n"
        "   && \n");
        
    if (ast == NULL)
    {
        //printf("test_line_and_column: %s, line:%d, col:%d\n", last_error.message, last_error.line, last_error.column);
        
        char message[] = "syntax error, unexpected TOKEN_AND, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN";
        mu_assert("Line number should be 4", last_error.line == 4);
        mu_assert("Column number should be 5", last_error.column == 5);
        mu_assert("Message incorrect", !strcmp(message, last_error.message));
    }
    else
    {
        mu_assert("AST should have returned NULL", 1);
    }
    
    return NULL;
}

static char* test_invalid_symbol()
{
    Node* ast = parse_ast(
        "^");
        
    if (ast == NULL)
    {
        //printf("test_invalid_symbol: %s, line:%d, col:%d\n", last_error.message, last_error.line, last_error.column);
        
        char message[] = "Unexpected character: ^";
        mu_assert("Line number should be 1", last_error.line == 1);
        mu_assert("Column number should be 1", last_error.column == 1);
        mu_assert("Message incorrect", !strcmp(message, last_error.message));
    }
    else
    {
        mu_assert("AST should have returned NULL", 1);
    }
    
    return NULL;
}

static char* test_invalid_token()
{
    Node* ast = parse_ast(
        "^£$");
        
    if (ast == NULL)
    {
        //printf("test_invalid_token: %s, line:%d, col:%d\n", last_error.message, last_error.line, last_error.column);
        
        char message[] = "Unexpected character: ^";
        mu_assert("Line number should be 1", last_error.line == 1);
        mu_assert("Column number should be 1", last_error.column == 1);
        mu_assert("Message incorrect", !strcmp(message, last_error.message));
    }
    else
    {
        mu_assert("AST should have returned NULL", 1);
    }
    
    return NULL;
}

static char* test_invalid_statement()
{
    Node* ast = parse_ast(
        "a ^ e");
        
    if (ast == NULL)
    {
        //printf("test_invalid_statement: %s, line:%d, col:%d\n", last_error.message, last_error.line, last_error.column);
        
        char message[] = "Unexpected character: ^";
        mu_assert("Line number should be 1", last_error.line == 1);
        mu_assert("Column number should be 3", last_error.column == 3);
        mu_assert("Message incorrect", !strcmp(message, last_error.message));
    }
    else
    {
        mu_assert("AST should have returned NULL", 1);
    }
    
    return NULL;
}

static char* test_invalid_long_statement()
{
    Node* ast = parse_ast(
        "          \n"
        "          \n"
        "  a       \n"
        "    ||    \n"
        "      c   \n"
        "        &&");
    
    if (ast == NULL)
    {
        //printf("test_invalid_long_statement: %s, line:%d, col:%d\n", last_error.message, last_error.line, last_error.column);
        
        char message[] = "syntax error, unexpected $end, expecting TOKEN_VAR or TOKEN_NOT or TOKEN_LPAREN";
        mu_assert("Line number should be 6", last_error.line == 6);
        mu_assert("Column number should be 10", last_error.column == 10);
        mu_assert("Message incorrect", !strcmp(message, last_error.message));
    }
    else
    {
        mu_assert("AST should have returned NULL", 1);
    }
    
    return NULL;
}

static char * all_tests() {
    mu_run_test(test_line_and_column);
    mu_run_test(test_invalid_symbol);
    mu_run_test(test_invalid_token);
    mu_run_test(test_invalid_statement);
    mu_run_test(test_invalid_long_statement);
    return 0;
}
 
int main(int argc, char ** argv)
{
    UNUSED(argc);
    UNUSED(argv);
    
    tests_run = 0;
    char *result = all_tests();    
    
    if (result != 0) 
    {
        printf("\e[31m");
        printf("%s\n", result);
        printf("\e[0m");
    }
    else 
    {
        printf("\e[32m");
        printf("ALL TESTS PASSED\n");
        printf("\e[0m");
    }
    printf("Tests run: %d\n", tests_run);
 
    return result != 0;
}