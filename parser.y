%{
# include <iostream>
# include "tree.h"
# include "lexer.c"
using namespace std;

struct Node *root = NULL;

%}

%union {
  struct Node* node;
}

    //终结符定义
// KEYWORD
%token <node> ARRAY 
%token <node> MY_BEGIN 
%token <node> BY
%token <node> DO 
%token <node> ELSE 
%token <node> ELSIF 
%token <node> END 
%token <node> EXIT 
%token <node> FOR 
%token <node> IF 
%token <node> IS 
%token <node> LOOP 
%token <node> NOT
%token <node> OF 
%token <node> PROCEDURE
%token <node> PROGRAM 
%token <node> READ
%token <node> RECORD
%token <node> RETURN 
%token <node> THEN 
%token <node> TO
%token <node> TYPE
%token <node> VAR 
%token <node> WRITE 
%token <node> WHILE

// Delimiters
%token <node> Lparentheses   //"("
%token <node> Rparentheses   //")"
%token <node> Lbracket       //"["
%token <node> Rbracket       //"]"
%token <node> Lbrace         //"{"
%token <node> Rbrace         //"}"
%token <node> LAbracket      //"[<"
%token <node> RAbracket      //">]"
%token <node> SEMICOLON      //";"
%token <node> COLON          //":"
%token <node> COMMA          //","
%token <node> DOT            //"."

//ID
%token <node> ID 
%token <node> T_EOF T_COMMENT

//type
%token <node> INTEGER 
%token <node> REAL 
%token <node> STRING

//优先级关系定义
%nonassoc <node> GT LT GE LE EQUAL NE;
%left     <node> AND OR;
%left     <node> ASSIGN;
%left     <node> ADD MINUS MUL DIVIDE DIV MOD;
%right    <node> POS NEG;

    //非终结符定义
%type <node> program 
%type <node> body 

// Declarations
%type <node> declaration 
%type <node> declaration_list 
%type <node> var_decl
%type <node> var_decl_list 
%type <node> type_decl 
%type <node> type_decl_list 
%type <node> precedure_decl 
%type <node> precedure_decl_list
%type <node> formal_param_list
%type <node> fp_section 
%type <node> type 
%type <node> type_opt
%type <node> component
%type <node> component_list 
%type <node> id_list 

// Statements
%type <node> statement
%type <node> statement_list
%type <node> actual_param_list 
%type <node> fp_section_list
%type <node> write_param_list
%type <node> elif_list
%type <node> elif
%type <node> else 
%type <node> interval 

//Expressions
%type <node> expression
%type <node> expression_list 
%type <node> write-expr
%type <node> write_expr_list
%type <node> assign_expr_list
%type <node> array_expr
%type <node> array_expr_list
%type <node> number 
%type <node> lvalue 
%type <node> lvalue_list
%type <node> comp_value_list
%type <node> array_value_list


%%
program: 
  PROGRAM IS body SEMICOLON
  {$$=mknode("Program", 4, $1, $2, $3, $4); root = $$; PrintTree($$, 0);}
  ;

body: 
  /*empty*/ {$$=mkempty("Body");}

  | declaration_list MY_BEGIN statement_list END
  {$$=mknode("Body", 4, $1, $2, $3, $4);}
  ;

declaration_list: 
  /*empty*/ {$$=mkempty("declaration list");}

  | declaration declaration_list 
  {$$=mknode("declaration list", 2, $1, $2);}
  ;

statement_list:
  /*empty*/ {$$=mkempty("statement list");}

  | statement statement_list
  {$$=mknode("statement list", 2, $1, $2);}
  ;
  
declaration: 
  VAR var_decl_list
  {$$=mknode(" Variable declaration", 2, $1, $2);}

  | TYPE type_decl_list
  {$$=mknode("Type declaration", 2, $1, $2);}

  | PROCEDURE precedure_decl_list
  {$$=mknode("Procedure declaration", 2, $1, $2);}
  ;

var_decl_list: 
  /*empty*/ {$$=mkempty("variable declaration list");}

  | error 
  {yyclearin; yyerror("unknown number", cols); yyerrok;} 

  | var_decl var_decl_list
  {$$=mknode("variable declaration list", 2, $1, $2);}
  ;

type_decl_list: 
  /*empty*/ {$$=mkempty("type declaration list");}

  | type_decl type_decl_list
  {$$=mknode("type declaration list", 2, $1, $2);}
  ;

precedure_decl_list: 
  /*empty*/ {$$=mkempty("procedure declaration list");}

  | precedure_decl precedure_decl_list
  {$$=mknode("procedure declaration list",2 , $1, $2);}
  ;

var_decl: 
  ID id_list type_opt ASSIGN expression SEMICOLON
  {$$=mknode("variable declaration", 6, $1, $2, $3, $4, $5, $6);}
  ;

id_list: 
  /*empty*/ {$$=mkempty("ID list");}

  | COMMA ID id_list
  {$$=mknode("ID list", 3, $1, $2, $3);}
  ;

type_opt: 
  /*empty*/ {$$=mkempty("type option");}

  | COLON type 
  {$$=mknode("type option", 2, $1, $2);}
  ;

type_decl: 
  ID IS type SEMICOLON 
  {$$=mknode("type declaration", 4, $1, $2, $3, $4);}
  ;

precedure_decl: 
  ID formal_param_list type_opt IS body SEMICOLON 
  {$$=mknode("procedure declaration", 6, $1, $2, $3, $4, $5, $6);}
  
  | ID formal_param_list type_opt body SEMICOLON
  {yyclearin;yyerror("expected IS", cols); yyerrok;}
  ;

type: 
  ID 
  {$$=mknode("type", 1, $1);}

  | ARRAY OF type 
  {$$=mknode("array type", 3, $1, $2, $3);}

  | RECORD component component_list END 
  {$$=mknode("record type", 4, $1, $2, $3, $4);}
  ;

component_list: 
  /*empty*/ {$$=mkempty("component list");}
  
  | component component_list
  {$$=mknode("component list", 2, $1, $2);}
  ;

component: 
  ID COLON type SEMICOLON 
  {$$=mknode("component", 4, $1, $2, $3, $4);}
  ;

formal_param_list:  
  Lparentheses fp_section fp_section_list Rparentheses 
  {$$=mknode("formal parameter list", 4, $1, $2, $3, $4);}

  | Lparentheses Rparentheses 
  {$$=mknode("formal parameter list", 2, $1, $2);}
  ;

fp_section_list:   
  /*empty*/ {$$=mkempty("fp section list");}
  
  | SEMICOLON fp_section fp_section_list 
  {$$=mknode("fp section list", 3, $1, $2, $3);}
  ;

fp_section: 
  ID id_list COLON type 
  {$$=mknode("fp section", 4, $1, $2, $3, $4);}
  ;

statement: 
  lvalue ASSIGN expression SEMICOLON 
  {$$=mknode("assign statement", 4, $1, $2, $3, $4);}

  | ID actual_param_list SEMICOLON 
  {$$=mknode("procedure call statement", 3, $1, $2, $3);}

  | READ Lparentheses lvalue lvalue_list Rparentheses SEMICOLON 
  {$$=mknode("read statement",6, $1, $2, $3, $4, $5, $6);}

  | WRITE write_param_list SEMICOLON 
  {$$=mknode("write statement", 3, $1, $2, $3);}

  | WRITE write_param_list 
  {yyclearin; yyerror("expected ;", cols - 5); yyerrok;}

  | IF expression THEN statement_list elif_list else END SEMICOLON 
  {$$=mknode("If statement", 8, $1, $2, $3, $4, $5, $6, $7, $8);}

  | WHILE expression DO statement_list END SEMICOLON 
  {$$=mknode("While statement", 6, $1, $2, $3, $4, $5, $6);}

  | LOOP statement_list END SEMICOLON 
  {$$=mknode("Loop statement", 4, $1, $2, $3, $4);}

  | FOR ID ASSIGN expression TO expression interval DO statement_list END SEMICOLON 
  {$$=mknode("For statement", 11, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);}

  | EXIT SEMICOLON 
  {$$=mknode("Exit statement", 2, $1, $2);}

  | RETURN expression SEMICOLON 
  {$$=mknode("return statement", 3, $1, $2, $3);}

  | RETURN SEMICOLON 
  {$$=mknode("return statement", 2, $1, $2);}
  ;

lvalue_list: 
  /*empty*/ {$$=mkempty("lvalue list");}

  | COMMA lvalue lvalue_list 
  {$$=mknode("lvalue list", 3, $1, $2, $3);}
  ;

elif_list: 
  /*empty*/ {$$=mkempty("else if list");}

  | elif elif_list
  {$$=mknode("else if list",2,$1,$2);}
  ;

elif: 
  ELSIF expression THEN statement_list
  {$$=mknode("else if",4,$1,$2,$3,$4);}
  ;

else: 
  /*empty*/ {$$=mkempty("else");}

  | ELSE statement_list 
  {$$=mknode("else", 2, $1, $2);}
  ;

interval: 
  /*empty*/ {$$=mkempty("interval");}

  | BY expression 
  {$$=mknode("interval", 2, $1, $2);}
  ;

write_param_list: 
  Lparentheses write-expr write_expr_list Rparentheses 
  {$$=mknode("Write parameter list", 4, $1, $2, $3, $4);}

  | Lparentheses Rparentheses 
  {$$=mknode("Write parameter list", 2, $1, $2);}
  ;

write_expr_list: 
  /*empty*/ {$$=mkempty("Write expression list");}

  | COMMA write-expr write_expr_list 
  {$$=mknode("Write expression list", 3, $1, $2, $3);}
  ;

write-expr: 
  STRING 
  {$$=mknode("Write expression", 1, $1);}

  | expression 
  {$$=mknode("Write expression", 1, $1);}
  ;

expression: 
  number 
  {$$=mknode("numder expression", 1, $1);}

  | lvalue 
  {$$=mknode("lvalue expression", 1, $1);}

  | Lparentheses expression Rparentheses 
  {$$=mknode("expression", 3, $1, $2, $3);}
  
  | ADD expression %prec POS 
  {$$=mknode("unary op expression",2,$1,$2);}
  | MINUS expression %prec NEG 
  {$$=mknode("unary op expression",2,$1,$2);}
  | NOT expression 
  {$$=mknode("unary op expression",2,$1,$2);}
  | expression ADD expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression MINUS expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression MUL expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression DIVIDE expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression DIV expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression MOD expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression OR expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression AND expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression LT expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression LE expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression GT expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression GE expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression EQUAL expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}
  | expression NE expression 
  {$$=mknode("binary op expression",3,$1,$2,$3);}

  | ID actual_param_list 
  {$$=mknode("procedure call expression", 2, $1, $2);}

  | ID comp_value_list 
  {$$=mknode("record expression", 2, $1, $2);}

  | ID array_value_list 
  {$$=mknode("array expression", 2, $1, $2);}
  ;

lvalue: 
  ID 
  {$$=mknode("lvalue", 1, $1);}

  | lvalue Lbracket expression Rbracket 
  {$$=mknode("lvalue", 4, $1, $2, $3, $4);}

  | lvalue DOT ID 
  {$$=mknode("lvalue", 3, $1, $2, $3);}
  ;

actual_param_list: 
  Lparentheses expression expression_list Rparentheses 
  {$$=mknode("actual parameter list", 4, $1, $2, $3, $4);}

  | Lparentheses Rparentheses 
  {$$=mknode("actual parameter list", 2, $1, $2);}
  ;

expression_list: 
  /*empty*/ {$$=mkempty("expression list");}

  | COMMA expression expression_list 
  {$$=mknode("expression list", 3, $1, $2, $3);}
  ;

comp_value_list: 
  Lbrace ID ASSIGN expression assign_expr_list Rbrace 
  {$$=mknode("comp value list", 6, $1, $2, $3, $4, $5, $6);}
  ;

assign_expr_list:
  /*empty*/ {$$=mkempty("assign expression list");}

  | SEMICOLON ID ASSIGN expression assign_expr_list 
  {$$=mknode("assign expression list", 5, $1, $2, $3, $4, $5);}
  ;

array_value_list: 
  LAbracket array_expr array_expr_list RAbracket 
  {$$=mknode("array value list", 4, $1, $2, $3, $4);}
  ;

array_expr_list: 
  /*empty*/ {$$=mkempty("array expression list");}

  | COMMA array_expr array_expr_list 
  {$$=mknode("array expression list", 3, $1, $2, $3);}
  ;

array_expr: 
  expression 
  {$$=mknode("array expression", 1, $1);}

  | expression OF expression 
  {$$=mknode("array expression", 3, $1, $2, $3);}
  ;

number: 
  INTEGER 
  {$$=mknode("number", 1, $1);}
  
  | REAL 
  {$$=mknode("number", 1, $1);}
  ;

%%