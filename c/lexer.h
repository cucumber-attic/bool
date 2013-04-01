#include "ast.h"

void scan_init(char* data);

int yylex(void);

void yyerror(Node** node, const char* msg);

char* yytext(void);
