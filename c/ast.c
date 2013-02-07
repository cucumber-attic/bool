#include "ast.h"
#include "parser.h"
#include "lexer.h"

#define LAST_ERROR_MSG_BUFFER_SIZE 512

char last_error_msg[LAST_ERROR_MSG_BUFFER_SIZE];

void yyerror(YYLTYPE *locp, yyscan_t scanner, Node** node, const char* msg) {
    snprintf(last_error_msg, LAST_ERROR_MSG_BUFFER_SIZE,"%s (line:%d, column:%d)", msg, locp->first_line, locp->first_column);
}
 
Node* parse_ast(const char* source) {
    Node* node;
    yyscan_t scanner;
    YY_BUFFER_STATE state;

	last_error_msg[0]  = 0;
 
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
        case eOR:
        {
            Binary* binary = (Binary*) node;
            free_ast(binary->left);
            free_ast(binary->right);
            free(binary);
            break;
        }
        case eNOT:
        {
            Unary* unary = (Unary*) node;
            free_ast(unary->refnode);
            free(unary);
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

