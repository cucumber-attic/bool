%x AFTER_KEYWORD
%x NAME
%x DOC_STRING
%x CELL

%%

^\s+                                                    { /* skip leading whitespace */ }
'Feature:'                                              { this.begin('AFTER_KEYWORD'); return 'TOKEN_FEATURE'; }
'Background:'                                           { this.begin('AFTER_KEYWORD'); return 'TOKEN_BACKGROUND'; }
'Scenario:'                                             { this.begin('AFTER_KEYWORD'); return 'TOKEN_SCENARIO'; }
'Scenario\u0020Outline:'                                { this.begin('AFTER_KEYWORD'); return 'TOKEN_SCENARIO_OUTLINE'; }
'Examples:'                                             { this.begin('AFTER_KEYWORD'); return 'TOKEN_EXAMPLES'; }
'Given\u0020'|'When\u0020'|'Then\u0020'|'And\u0020'|'But\u0020'
                                                        { this.begin('AFTER_KEYWORD'); return 'TOKEN_STEP'; }
'"""'[ \t]*                                             { this.begin('DOC_STRING'); return 'TOKEN_TREBLE_QUOTE'; }
<DOC_STRING>(.|\s)+(?=\n\s*\"\"\")                      { return 'TOKEN_DOC_STRING'; }
<DOC_STRING>\n\s*'"""'                                  { this.popState(); return 'TOKEN_TREBLE_QUOTE'; }

'|'                                                     { this.begin('CELL'); return 'TOKEN_PIPE'; }
<CELL>[^\|\u000A]+                                      { return 'TOKEN_CELL'; }
<CELL>'|'                                               { return 'TOKEN_PIPE'; }
<CELL>\u000A                                            { this.popState(); return 'TOKEN_EOL'; }
.+													                            { return 'TOKEN_DESCRIPTION_LINE'; }
<AFTER_KEYWORD>\u0020*                                  { /* skip whitespace after keyword */ this.begin('NAME'); }
<NAME>[^\u000A]*                                        { this.popState(); this.popState(); return 'TOKEN_NAME'; }
<<EOF>>                                                 { return 'EOF'; }

%%

module.exports = lexer;

