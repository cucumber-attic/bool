%x AFTER_KEYWORD
%x NAME
%x TOKEN_DESCRIPTION_LINE

%%

^\s+                  { /* skip leading whitespace */ }
"Feature:"            { this.begin('AFTER_KEYWORD'); return 'TOKEN_FEATURE'; }
"Given "|"When "      { this.begin('AFTER_KEYWORD'); return 'TOKEN_STEP'; }
<AFTER_KEYWORD>\s*    { /* skip whitespace after keyword */ this.begin('NAME'); }
<NAME>.*              { this.begin('INITIAL'); return 'TOKEN_NAME'; }
<<EOF>>               { return 'EOF'; }

%%

module.exports = lexer;

