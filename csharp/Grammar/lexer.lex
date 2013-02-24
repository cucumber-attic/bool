%namespace Bool
%scannertype Lexer
%visibility public
%tokentype Tokens

%option stack, minimize, parser, verbose, persistbuffer, noembedbuffers, out:Lexer.generated.cs

/* 
 * Expected file format is Unicode. In the event that no 
 * byte order mark prefix is found, revert to raw bytes.
 */
%option unicode, codepage:raw

ws	[ \r\n\t]*
var	[A-Za-z0-9_\-@]+
and	"&&"
or	"||"
not	"!"
lparen	"("
rparen	")"

%%

{var}		{ return (int)Tokens.TOKEN_VAR; }
{and}		{ return (int)Tokens.TOKEN_AND; }
{or}		{ return (int)Tokens.TOKEN_OR; }
{not}		{ return (int)Tokens.TOKEN_NOT; }
{lparen}	{ return (int)Tokens.TOKEN_LPAREN; }
{rparen}	{ return (int)Tokens.TOKEN_RPAREN; }
