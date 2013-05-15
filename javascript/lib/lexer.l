%x AFTER_KEYWORD
%x NAME
%x DOC_STRING
%x CELL
%x TAGS

%%

^\s+                                                    { }
'@'\w+                                                  { this.begin('TAGS'); return 'TOKEN_TAG'; }
<TAGS>\u0020+                                           { }
<TAGS>\u000A                                            { this.popState(); }
<TAGS>'@'\w+                                            { return 'TOKEN_TAG'; }
'Feature:'                                              { this.begin('AFTER_KEYWORD'); return 'TOKEN_FEATURE'; }
'Background:'                                           { this.begin('AFTER_KEYWORD'); return 'TOKEN_BACKGROUND'; }
'Scenario:'                                             { this.begin('AFTER_KEYWORD'); return 'TOKEN_SCENARIO'; }
'Scenario\u0020Outline:'                                { this.begin('AFTER_KEYWORD'); return 'TOKEN_SCENARIO_OUTLINE'; }
'Examples:'                                             { this.begin('AFTER_KEYWORD'); return 'TOKEN_EXAMPLES'; }
'Given\u0020'|'When\u0020'|'Then\u0020'|'And\u0020'|'But\u0020'
                                                        { this.begin('AFTER_KEYWORD'); return 'TOKEN_STEP'; }
'"""'[ \t]*\u000A                                       { this.begin('DOC_STRING'); }
<DOC_STRING>.+\u000A                                    { 
                                                            if(yytext.indexOf('"""') == -1) {
                                                              return 'TOKEN_DOC_STRING_LINE';
                                                            } else {
                                                              this.popState();
                                                            }
                                                        }
'|'                                                     { this.begin('CELL'); return 'TOKEN_PIPE'; }
<CELL>[^\|\u000A]+                                      { return 'TOKEN_CELL'; }
<CELL>'|'\u0020*                                        { return 'TOKEN_PIPE'; }
<CELL>\u000A                                            { this.popState(); return 'TOKEN_EOL'; }
.+													                            { return 'TOKEN_DESCRIPTION_LINE'; }
<AFTER_KEYWORD>\u0020*                                  { /* skip whitespace after keyword */ this.begin('NAME'); }
<NAME>[^\u000A]*                                        { this.popState(); this.popState(); return 'TOKEN_NAME'; }
<<EOF>>                                                 { return 'EOF'; }

%%

module.exports = lexer;

