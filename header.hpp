#include <iostream>
#include <map>
#include <vector>
#include <cmath>
#include <cstring>
#include <string>
#include <sstream>
using namespace std;

typedef enum
{
    VARIABLE,
    IDENTIFIER,
    OPERATOR
} nodeType;

typedef enum
{
    VOID,
    TEXT,
    DISCRETE,
    CONTINOUS,
    CHARACTER,
    BOOLEAN
} vType;

struct Variable
{
    int i;
    double d;
    string s;
    bool b;
    char c;
    vType t;
    bool initialized;
};

struct Ast
{
    nodeType t;
    int op;
    Variable value;
    struct Ast *l;
    struct Ast *r;
};

typedef Ast* Node;

struct leafNode
{
    nodeType t;
    Variable value;
    string id;
};