..\bin\Gplex.exe lexer.lex
move Lexer.generated.cs ..\Bool

..\bin\gppg.exe /gplex parser.y
move BoolParser.generated.cs ..\Bool

if not exist GplexBuffers.cs goto finish
move GplexBuffers.cs ..\Bool

:finish
