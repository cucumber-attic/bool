%%

\s+                   { /* skip whitespace */ }
[A-Za-z0-9_\-@]+      { return 'TOKEN_VAR'; }
"&&"                  { return 'TOKEN_AND'; }
"||"                  { return 'TOKEN_OR'; }
"!"                   { return 'TOKEN_NOT'; }
"("                   { return 'TOKEN_LPAREN'; }
")"                   { return 'TOKEN_RPAREN'; }
<<EOF>>               { return 'EOF'; }
