%x AFTER_KEYWORD
%x NAME

%%

^\s+                                 { /* skip leading whitespace */ }
"Feature:"                           { this.begin('AFTER_KEYWORD'); return 'TOKEN_FEATURE'; }
^(?:(?!(Feature|Given|When|Then))).+ { return 'TOKEN_DESCRIPTION_LINE'; }
"Given "|"When "|"Then "             { this.begin('AFTER_KEYWORD'); return 'TOKEN_STEP'; }
<AFTER_KEYWORD>\s*                   { /* skip whitespace after keyword */ this.begin('NAME'); }
<NAME>.*                             { this.begin('INITIAL'); return 'TOKEN_NAME'; }
<<EOF>>                              { return 'EOF'; }

%%

module.exports = lexer;

