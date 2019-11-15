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
    VOID,
    TEXT,
    DISCRETE,
    CONTINOUS,
    CHARACTER,
    BOOLEAN
} vType;

struct Node
{
    int i;
    double d;
    string s;
    bool b;
    char c;
    vType type;
    bool isNull;
    bool isID;
};