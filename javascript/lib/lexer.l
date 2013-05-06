%x AFTER_KEYWORD
%x NAME
%x DOC_STRING

%%

^\s+                                                    { /* skip leading whitespace */ }
"Feature:"                                              { this.begin('AFTER_KEYWORD'); return 'TOKEN_FEATURE'; }
"Scenario:"                                             { this.begin('AFTER_KEYWORD'); return 'TOKEN_SCENARIO'; }
'"""'[ \t]*                                 			{ this.begin('DOC_STRING'); return 'TOKEN_TREBLE_QUOTE'; }
<DOC_STRING>(.|\s)+(?=\n\s*\"\"\")                           { return 'TOKEN_DOC_STRING'; }
<DOC_STRING>\n\s*'"""'                                       { this.popState(); return 'TOKEN_TREBLE_QUOTE'; }
^(?:(?!(Feature:|Scenario:|Given\u0020|When\u0020|Then\u0020|'"""'))).+
														{ return 'TOKEN_DESCRIPTION_LINE'; }
"Given\u0020"|"When\u0020"|"Then\u0020"                 { this.begin('AFTER_KEYWORD'); return 'TOKEN_STEP'; }
<AFTER_KEYWORD>\s*                                      { /* skip whitespace after keyword */ this.begin('NAME'); }
<NAME>.*                                                { this.begin('INITIAL'); return 'TOKEN_NAME'; }
<<EOF>>                                                 { return 'EOF'; }

%%

module.exports = lexer;

