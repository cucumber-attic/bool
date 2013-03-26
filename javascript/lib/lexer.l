%x AFTER_KEYWORD
%x NAME

%%

^\s+                                                    { /* skip leading whitespace */ }
"Feature:"                                              { this.begin('AFTER_KEYWORD'); return 'TOKEN_FEATURE'; }
^(?:(?!(Feature:|Given\u0020|When\u0020|Then\u0020))).+ { return 'TOKEN_DESCRIPTION_LINE'; }
"Given\u0020"|"When\u0020"|"Then\u0020"                 { this.begin('AFTER_KEYWORD'); return 'TOKEN_STEP'; }
<AFTER_KEYWORD>\s*                                      { /* skip whitespace after keyword */ this.begin('NAME'); }
<NAME>.*                                                { this.begin('INITIAL'); return 'TOKEN_NAME'; }
<<EOF>>                                                 { return 'EOF'; }

%%

module.exports = lexer;

