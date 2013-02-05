#include "ast.h"
#include "parser.h"
#include "lexer.h"

void yyerror(yyscan_t scanner, Node** node, const char* msg) {
    //fprintf(stderr,"Error: %s\n", msg);
}
 
Node* parse_ast(const char* source) {
    Node* node;
    yyscan_t scanner;
    YY_BUFFER_STATE state;
 
    if (yylex_init(&scanner)) {
        // couldn't initialize
        return NULL;
    }

    // TODO: Check state here?
    state = yy_scan_string(source, scanner);

    if (yyparse(&node, scanner)) {
        // error parsing
        return NULL;
    }

    yy_delete_buffer(state, scanner);
    yylex_destroy(scanner);
    return node;
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

