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

    if(last_error.message) {
        // When we get an error from the scanner, we'll also get one from the parser.
        // Discard the 2nd one from the parser in that case!
        return;
    }

    last_error.message      = strdup(msg);
    last_error.first_line   = yylloc.first_line;
    last_error.first_column = yylloc.first_column;
    last_error.last_line    = yylloc.last_line;
    last_error.last_column  = yylloc.last_column;
}

Node* parse_ast(const char* source) {
    Node* node;
    int error = 0;
    last_error.message = NULL;

    scan_init(source);

    if (yyparse(&node)) {
        // error parsing
        error = 1;
    }
    if (last_error.message) {
        // error lexing
        error = 1;
    }

    return error ? NULL : node;
}

void free_ast(Node* node) {
    
    free(node->token->value);
    free(node->token);
    switch (node->type) {
        case eVAR: 
        {
            Var* var = (Var*) node;
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
            free_ast(not->operand);
            free(not);
            break;
        }
    }
}

Token* create_token() {
    Token* tok = (Token*) malloc(sizeof* tok);
    tok->value        = strdup("");
    tok->first_line   = yylloc.first_line;
    tok->first_column = yylloc.first_column;
    tok->last_line    = yylloc.last_line;
    tok->last_column  = yylloc.last_column;
    return tok;
}

//// AST specific node creation functions

Node* create_var(Token* token) {
    Var* node = (Var*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eVAR;
    node->token = token;
    return (Node*) node;
}

Node* create_and(Token* token, Node* left, Node* right) {
    And* node = (And*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eAND;
    node->token = token;
    node->left = left;
    node->right = right;
    return (Node*) node;
}

Node* create_or(Token* token, Node* left, Node* right) {
    Or* node = (Or*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eOR;
    node->token = token;
    node->left = left;
    node->right = right;
    return (Node*) node;
}

Node* create_not(Token* token, Node* operand) {
    Not* node = (Not*) malloc(sizeof* node);
    if (node == NULL) return NULL;
 
    node->type = eNOT;
    node->token = token;
    node->operand = operand;
    return (Node*) node;
}

