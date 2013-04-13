#include "ast.h"

void scan_init(const char* data);

int yylex(void);

void yyerror(Node** node, const char* msg);
