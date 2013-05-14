#ifndef __AST_H__
#define __AST_H__

typedef struct Token {
    char* value;
    int first_line;
    int first_column;
    int last_line;
    int last_column;
} Token;

typedef struct SyntaxError {
    char* message;
    int first_line;
    int first_column;
    int last_line;
    int last_column;
} SyntaxError;

typedef enum NodeType {
    eVAR,
    eAND,
    eOR,
    eNOT,
} NodeType;

/* All of the other node types can be type cast to this
 * type because the first member is always the same.
 * This allows for a kind of lightweight polymorphism.
 */
typedef struct Node {
    NodeType type;
    Token* token;
} Node;

extern Node* parse_ast(const char* source);
extern void free_ast(Node* node);
extern Token* create_token();
extern SyntaxError last_error;

typedef struct Var {
    NodeType type;
    Token* token;
} Var;

typedef struct And {
    NodeType type;
    Token* token;
    Node* left;
    Node* right;
} And;

typedef struct Or {
    NodeType type;
    Token* token;
    Node* left;
    Node* right;
} Or;

typedef struct Not {
    NodeType type;
    Token* token;
    Node* operand;
} Not;

Node* create_var(Token* token);
Node* create_and(Token* token, Node* left, Node* right);
Node* create_or(Token* token, Node* left, Node* right);
Node* create_not(Token* token, Node* other);

#endif

