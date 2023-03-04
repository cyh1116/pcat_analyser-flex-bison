// 定义语法树结点结构体&变长参数构造树&遍历树函数
#include <iostream>
#include <vector>
#include <string>
#define UNTERMINATED_STRING 102
#define T_UNKNOWN_CHARACTER 103
using namespace std;
struct Node *mknode(char *, int, ...);
struct Node *mkleaf(char *, int, int);
struct Node *mkempty(char *);
void yyerror(char *);
void yyerror(char *, int);
void PrintNode(struct Node *, int);
void PrintTree(struct Node *, int);
void Free(struct Node *);
/*抽象语法树的结点*/
struct Node
{
  int row;
  int col;
  int empty;
  char *name;
  vector<Node *> children;
  union
  {
    char *string;
    int integer;
    double real;
  };
};
