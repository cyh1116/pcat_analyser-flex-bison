%{
#include "stdio.h"
#include "stdlib.h"
#include "yacc.h"
int cols = 1;
int rows = 1;

%}
%option yylineno
%option noyywrap

PROGRAM PROGRAM
IS IS
AND AND
ARRAY ARRAY
BY BY
DIV DIV
DO DO
ELSE ELSE
ELSIF ELSIF
VAR VAR
MY_BEGIN BEGIN
END END
WRITE WRITE 
READ READ
OF OF
RECORD RECORD
PROCEDURE PROCEDURE
TYPE TYPE
NOT NOT
MOD MOD
OR OR
RETURN RETURN
EXIT EXIT
FOR FOR
LOOP LOOP
WHILE WHILE
IF IF
THEN THEN
TO TO

SEMICOLON ;
COMMA ,
COLON :
Lparentheses \(
Rparentheses \)
Lbracket \[
Rbracket \]
DOT \.
Lbrace \{
Rbrace \}
LAbracket \[<
RAbracket >\]

GT >
LT <
EQUAL =
GE >=
LE <=
NE <>
ASSIGN :=
MUL \*
DIVIDE \/
ADD \+
MINUS -

WS              [ \t]+
CHANGELINE      (\n)
LETTER		    [a-zA-Z]
DIGIT           [0-9]
INTEGER         ({DIGIT}+)
REAL            ({DIGIT}+"."{DIGIT}*) 
STRING          (\"([^\n"]*)\")
ID		        (({LETTER})({LETTER}|{DIGIT})*)
UNTERMINATED_STRING       (\"[^\n"]*)

%x IN_COMMENT

%%
{WS}                     {cols += yyleng;}
{CHANGELINE}             {cols = 1; rows++; }
{SEMICOLON}              {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng;  return SEMICOLON;}
{COLON}                  {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng;  return COLON;}
{COMMA}                  {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng;  return COMMA;}
{Lparentheses}           {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng;  return Lparentheses;}
{Rparentheses}           {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng;  return Rparentheses;}
{ASSIGN}                 {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return ASSIGN;}
{ADD}                    {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return ADD;}
{MINUS}                  {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return MINUS;}
{MUL}                    {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return MUL;}
{DIVIDE}                 {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return DIVIDE;}
{PROGRAM}                {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return PROGRAM;}
{IS}                     {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return IS;}
{ARRAY}                  {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return ARRAY;}
{MY_BEGIN}               {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return MY_BEGIN;}
{BY}                     {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return BY;}
{DIV}                    {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return DIV;}
{DO}                     {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return DO;}
{ELSE}                   {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return ELSE;}
{ELSIF}                  {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return ELSIF;}
{VAR}                    {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return VAR;}
{END}                    {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return END;}
{WRITE}                  {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng;  return WRITE;} 
{READ}                   {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return READ;}
{Lbracket}               {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng; return Lbracket;}
{Rbracket}               {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng; return Rbracket;}
{DOT}                    {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng; return DOT;}
{OF}                     {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return OF;}
{RECORD}                 {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return RECORD;}
{PROCEDURE}              {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return PROCEDURE;}
{TYPE}                   {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return TYPE;}
{MOD}                    {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return MOD;}
{NOT}                    {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return NOT;}
{AND}                    {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return AND;}
{OR}                     {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return OR;}
{GT}                     {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return GT;}
{LT}                     {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return LT;}
{EQUAL}                  {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return EQUAL;}
{GE}                     {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return GE;}
{LE}                     {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return LE;}
{NE}                     {yylval.node=mkleaf("OPERATOR",yylineno,cols); cols+=yyleng; return NE;}
{LAbracket}              {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng; return LAbracket;}
{RAbracket}              {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng; return RAbracket;}
{Lbrace}                 {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng; return Lbrace;}
{Rbrace}                 {yylval.node=mkleaf("DELIMITER",yylineno,cols); cols+=yyleng; return Rbrace;}
{RETURN}                 {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return RETURN;}
{EXIT}                   {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return EXIT;}
{FOR}                    {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return FOR;}
{LOOP}                   {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return LOOP;}
{WHILE}                  {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return WHILE;}
{IF}                     {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return IF;}
{THEN}                   {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return THEN;}
{TO}                     {yylval.node=mkleaf("KEYWORD",yylineno,cols); cols+=yyleng; return TO;}

{ID}                     {yylval.node=mkleaf("IDENTIFIER",yylineno,cols); cols+=yyleng; return ID;}
{STRING}                 {yylval.node=mkleaf("STRING",yylineno,cols); cols+=yyleng; return STRING;}
{INTEGER}			           {yylval.node=mkleaf("INTEGER",yylineno,cols); cols+=yyleng; return INTEGER;}
{REAL}			             {yylval.node=mkleaf("REAL",yylineno,cols); cols+=yyleng; return REAL;}

{UNTERMINATED_STRING}    {return UNTERMINATED_STRING;}
.                        {return T_UNKNOWN_CHARACTER;}

"(*"                     {cols += yyleng; BEGIN IN_COMMENT;}
<IN_COMMENT>\n           {cols = 1; rows++;} 
<IN_COMMENT>"*)"         {cols += yyleng; BEGIN INITIAL;}
<IN_COMMENT>.            {cols += yyleng;}
<IN_COMMENT><<EOF>>      {return T_COMMENT;}
%%

