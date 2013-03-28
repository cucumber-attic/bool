#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "ast.h"
#include "parser.h"
#include "lexer.h"
#include "unused.h"

SyntaxError last_error;

void yyerror(Node** node, const char* msg) {
    UNUSED(node);

    if (last_error.token == 0)
    {
        last_error.message = strdup(msg);
    }
    else
    {
        char message[] = "Unexpected character: ";
        last_error.message = malloc(sizeof(char) * (strlen(message) + strlen(last_error.token) + 1));
        sprintf(last_error.message, "%s%s", message, last_error.token); 
    }
/*
    last_error.first_line   = locp->first_line;
    last_error.last_line    = locp->last_line;
    last_error.first_column = locp->first_column;
    last_error.last_column  = locp->last_column;
*/
}

Node* parse_ast(const char* source) {
    int error = 0;
    Node* node;

    scan_init(source);
/*
    if (yylex_init(&scanner)) {
        // couldn't initialize
        return NULL;
    }
*/
    last_error.token = 0;

    // TODO: Check state here?
    //state = yy_scan_string(source, scanner);

    if (yyparse(&node)) {
        // error parsing
        error = 1;
    }
    if (last_error.token)
    {
        // error lexing
        error = 1;
    }

//    yy_delete_buffer(state, scanner);
//    yylex_destroy(scanner);
    return error ? NULL : node;
}

void free_ast(Node* node) {
    
    switch (node->type) {
        case eVAR: 
        {
            Var* var = (Var*) node;
            free(var->value);
            free(var);
            break;
        }
        case eAND:
        {
            And* and = (And*) node;
            free_ast(and->left);
            free_ast(and->right);
            free(and);
            break;
        }
        case eOR:
        {
            Or* or = (Or*) node;
            free_ast(or->left);
            free_ast(or->right);
            free(or);
            break;
        }
        case eNOT:
        {
            Not* not = (Not*) node;
            free_ast(not->other);
            free(not);
            break;
        }
    }
}

//// AST specific node creation functions

Node* create_var(char* value) {
    Var* node = (Var*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eVAR;
    node->value = strdup(value);
    return (Node*) node;
}

Node* create_and(Node* left, Node* right) {
    And* node = (And*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eAND;
    node->left = left;
    node->right = right;
    return (Node*) node;
}

Node* create_or(Node* left, Node* right) {
    Or* node = (Or*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eOR;
    node->left = left;
    node->right = right;
    return (Node*) node;
}

Node* create_not(Node* other) {
    Not* node = (Not*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eNOT;
    node->other = other;
    return (Node*) node;
}

