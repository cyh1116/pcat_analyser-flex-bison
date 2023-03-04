#include <iostream>
#include <cstdio>
#include <cstdarg>
#include <cstdlib>
#include <cstring>
#include <vector>
#include "yacc.h"
#include "tree.h"
using namespace std;

int yylex();
int yyparse();
extern "C" int lcol;
extern "C" int col;
extern "C" int rows;
extern "C" char *yytext;
extern "C" int yyleng;
extern "C" int yylineno;
extern "C" struct Node *root;
extern "C" FILE *yyin;

FILE *fp = stdin;
char *fileOut;
char *tab = (char *)"\t";
int syntax_error = 0; // 判断是否输出语法树

// 创建内部节点
struct Node *mknode(char *name, int ncld, ...)
{
  va_list ap;
  struct Node *parent = new (struct Node);
  parent->name = name;
  parent->empty = 0;
  va_start(ap, ncld);
  struct Node *child;
  child = va_arg(ap, struct Node *);
  parent->children.push_back(child);
  parent->row = child->row; // 父节点的行号应该等于第一个子节点的行号，因此必须使用右递归
  for (int i = 1; i < ncld; i++)
  {
    child = va_arg(ap, struct Node *);
    parent->children.push_back(child);
  }
  return parent;
}

// 构建叶节点
struct Node *mkleaf(char *name, int row, int col)
{
  struct Node *leaf = new (struct Node);
  leaf->name = name;
  leaf->row = row;
  leaf->col = col;
  leaf->empty = 0;
  // 判断叶节点的值
  if (!strcmp(leaf->name, "INTEGER"))
  {
    leaf->integer = atoi(yytext);
  }
  else if (!strcmp(leaf->name, "REAL"))
  {
    leaf->real = atof(yytext);
  }
  else
  {
    char *str = (char *)malloc(sizeof(char *) * 50);
    strcpy(str, yytext);
    leaf->string = str;
  }
  return leaf;
}

// 构建空字节点
struct Node *mkempty(char *name)
{
  struct Node *empty = new (struct Node);
  empty->name = name;
  empty->empty = 1;
  return empty;
}

// 输出语法树
void PrintNode(struct Node *node, int level)
{
  for (int i = 0; i < level; i++)
    fprintf(fp, "-");
  if (!node->empty) // 空字不输出
  {
    fprintf(fp, "%s", node->name);
    if (!strcmp(node->name, "INTEGER"))
      fprintf(fp, ": %d", node->integer);
    else if (!strcmp(node->name, "REAL"))
      fprintf(fp, ": %.1f", node->real);
    else
    {
      if (node->string) // 不加这个判断会输出（null）
        fprintf(fp, ": %s", node->string);
    }
    fprintf(fp, "    <row: %d, col: %d>\n", node->row, node->col);
  }
  for (auto i = node->children.begin(); i != node->children.end(); i++)
    PrintNode(*i, level + 1);
}

// 由于对于case11-14只输出报错信息，不输出语法树，因此单独定义一个函数来判断是否输出语法树
void PrintTree(struct Node *node, int level)
{
  if (syntax_error == 0)
    PrintNode(node, level);
}

// 如果正确输出语法树，则在程序结束前释放空间
void Free(struct Node *node)
{
  for (auto i = node->children.begin(); i != node->children.end(); i++)
    Free(*i);
  delete node;
}

void yyerror(char *msg, int col)
{
  syntax_error = 1; // 不输出语法树
  fprintf(fp, "[syntax error on rows: %d, col: %d]: %s\n", yylineno, col, msg);
}

void yyerror(char *msg)
{
  syntax_error = 1; // 不输出语法树
}

// 针对case11的词法错误处理程序
void lex_error(FILE *FileOut)
{
  while (1)
  {
    int n = yylex();
    if (n == T_EOF)
    {
      break;
    }
    else if (n == T_COMMENT)
    {
      fprintf(FileOut, "[lexical error on rows: %d]: %s\n", yylineno, "unterminated comment");
      break;
    }
    else if (n == INTEGER)
    {
      if (atoll(yytext) > 2147483647)
        fprintf(FileOut, "[lexical error on rows: %d]: %s\n", yylineno, "integer out of range");
    }
    else if (n == STRING)
    {
      if (yyleng > 257)
        fprintf(FileOut, "[lexical error on rows: %d]: %s\n", yylineno, "overly long string");
      else if (strstr(yytext, tab) != NULL)
        fprintf(FileOut, "[lexical error on rows: %d]: %s\n", yylineno, "invalid string with tab in it");
    }
    else if (n == ID)
    {
      if (yyleng > 255)
        fprintf(FileOut, "[lexical error on rows: %d]: %s\n", yylineno, "overly long identifier");
    }
    else if (n == UNTERMINATED_STRING)
    {
      fprintf(FileOut, "[lexical error on rows: %d]: %s\n", yylineno, "unterminated string");
    }
    else if (n == T_UNKNOWN_CHARACTER)
    {
      fprintf(FileOut, "[lexical error on rows: %d]: %s\n", yylineno, "unknown character");
    }
  }
}

int main(int argc, char *args[])
{
  FILE *fileIn = fopen(args[1], "r");
  yyin = fileIn;
  fileOut = args[2];
  fp = fopen(fileOut, "w");
  // 针对case11，只做词法错误分析
  if (argc > 3 && !strcmp(args[3], "-lex"))
    lex_error(fp);
  // 其他case不分析词法错误
  else
  {
    yyparse();
    // 若程序既没有词法错误也没有语法错误，能够正确生成语法树，则在结束后释放所有空间
    if (syntax_error == 0)
      Free(root);
  }
  fclose(fp);
  return 0;
}
