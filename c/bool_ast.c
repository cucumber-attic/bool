#include "bool_ast.h"
#include "parser.h"
#include "lexer.h"

void yyerror(yyscan_t scanner, Node** node, const char* msg) {
    //fprintf(stderr,"Error: %s\n", msg);
}
 
Node* parse_bool_ast(const char* source) {
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
 
Node* create_var(char* value) {
    Var* node = (Var*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eVAR;
    node->value = strdup(value);
    return (Node*) node;
}

Node* create_binary(NodeType type, Node* left, Node* right) {
    Binary* node = (Binary*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = type;
    node->left = left;
    node->right = right;
    return (Node*) node;
}

Node* create_and(Node* left, Node* right) {
    return create_binary(eAND, left, right);
}

Node* create_or(Node* left, Node* right) {
    return create_binary(eOR, left, right);
}

Node* create_unary(NodeType type, Node* refnode) {
    Unary* node = (Unary*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = type;
    node->refnode = refnode;
    return (Node*) node;
}

Node* create_not(Node* node) {
    return create_unary(eNOT, node);
}

void free_bool_ast(Node* node) {
    switch (node->type) {
        case eVAR: 
        {
            Var* var = (Var*) node;
            free(var->value);
            free(var);
            break;
        }
        case eAND:
        case eOR:
        {
            Binary* binary = (Binary*) node;
            free_bool_ast(binary->left);
            free_bool_ast(binary->right);
            free(binary);
            break;
        }
        case eNOT:
        {
            Unary* unary = (Unary*) node;
            free_bool_ast(unary->refnode);
            free(unary);
            break;
        }
    }
}
