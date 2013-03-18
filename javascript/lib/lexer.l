%x AFTER_KEYWORD
%x NAME

%%

^\s+                  { /* skip leading whitespace */ }
"Feature:"            { this.begin('AFTER_KEYWORD'); return 'TOKEN_FEATURE'; }
"Given "              { this.begin('AFTER_KEYWORD'); return 'TOKEN_STEP'; }
<AFTER_KEYWORD>\s*    { this.begin('NAME'); }
<NAME>.*              { this.begin('INITIAL'); return 'TOKEN_NAME'; }
<<EOF>>               { return 'EOF'; }

%%

module.exports = lexer;

