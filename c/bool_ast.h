#ifndef __EXPRESSION_H__
#define __EXPRESSION_H__

typedef enum NodeType {
    eVAR,
    eAND,
    eOR,
    eNOT,
} NodeType;

typedef struct Node {
    NodeType type;
} Node;

typedef struct Var {
    NodeType type;
    char* value;
} Var;

typedef struct Binary {
    NodeType type;
    Node* left;
    Node* right;
} Binary;

typedef struct Unary {
    NodeType type;
    Node* refnode;
} Unary;

extern Node* parse_bool_ast(const char* source);
extern void free_bool_ast(Node* node);

Node* create_var(char* value);
Node* create_and(Node* left, Node* right);
Node* create_or(Node* left, Node* right);
Node* create_not(Node* node);

#endif
