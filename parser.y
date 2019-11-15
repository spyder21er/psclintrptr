%{
#include "header.hpp"

int yylex (void);
void yyerror (const char *);
void addToSym(vector<string> names, vType t);
bool sameType(Node* a, Node* b);
bool isDeclared(string s);
bool isNumber(Node* p);
void printMe(Node* p, bool withendl);
Node* calculate(Node* a, Node* b, int optr);
map<string, Node*> sym;
map<vType, string> typeName;
vector<string> vars;
extern int yylineno;

%}

%token START END WRITE WRITELN READLN ABSFUNC EXPRFUNC SQRTFUNC
%token ADD SUBTRACT MULTIPLY DIVIDE
%token ANDOP OROP NOTOP ASSIGNOP 
%token EQUAL GREATERTHAN LESSTHAN GEQ LEQ NOTEQUAL
%token OPENPAR CLOSEPAR COLON COMMA SEMICOLON
%token REP DOCOND FORCOND ELSECOND IFCOND THENCOND TOCOND UNTIL WHILECOND
%token <real> FLTLIT
%token <integer> INTLIT
%token <text> STRLIT ID
%token FLOAT INTEGER STRING VAR CHAR BOOL

%type <vPtr> term factor expressions print_list

%left ADD SUBTRACT
%left MULTIPLY DIVIDE

%union {
    char text[256];
    int integer;
    double real;
    Node * vPtr;
}

%start  program

%%

program             : { cout << "Empty input file!" << endl; exit(1); }
                    | varpart blockpart
                    | blockpart 
                    ;
varpart             : VAR varlist 
                    ;
varlist             : identifiers COLON type SEMICOLON varlist
                    | 
                    ;
type                : STRING 
                    {
                        addToSym(vars, TEXT);
                        vars.clear();
                    }
                    | INTEGER 
                    {
                        addToSym(vars, DISCRETE);
                        vars.clear();
                    }
                    | FLOAT
                    {
                        addToSym(vars, CONTINOUS);
                        vars.clear();
                    }
                    | CHAR
                    {
                        addToSym(vars, CHARACTER);
                    }
                    | BOOL
                    {
                        addToSym(vars, BOOLEAN);
                    }
                    ;
identifiers         : ID COMMA identifiers
                    {
                        vars.push_back(string($1));
                    }
                    | ID
                    {
                        vars.push_back(string($1));
                    }
                    ;
blockpart           : START optnlstatement END
                    ;
optnlstatement      : statements
                    |
                    ;
statements          : statement SEMICOLON statements
                    | statement SEMICOLON
                    ;
statement           : assignstmt
                    | printstmt
                    ;
assignstmt          : ID ASSIGNOP expressions 
                    {
                        if (isDeclared(string($1)))
                        {
                            Node* p = sym[string($1)];
                            if (sameType(p, $3))
                            {
                                p = $3;
                                p->isNull = false;
                                sym[string($1)] = p;
                            }
                            else if (p->type == CONTINOUS && $3->type == DISCRETE)
                            {
                                p->d = (double) $3->i;
                                p->isNull = false;
                                sym[string($1)] = p;
                            }
                            else if (p->type == DISCRETE && $3->type == CONTINOUS)
                            {
                                p->i = (int) $3->d;
                                p->isNull = false;
                                sym[string($1)] = p;
                            }
                            else
                            {
                                cout << "Error: Cannot assign " << typeName[$3->type] << " to " 
                                    << typeName[p->type] << " on line " << yylineno << endl;
                                exit(-1);
                            }
                        }
                        else
                        {
                            cout << "Error: Cannot assign to undeclared indentifier " 
                                << $1 << " on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    ;
expressions         : term
                    {
                        $$ = $1;
                    }
                    | expressions ADD term
                    {
                        if (isNumber($1) && isNumber($3))
                        {
                            $$ = calculate($1, $3, ADD);
                        }
                        else
                        {
                            cout << "Error: Cannot add NAN on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    | expressions SUBTRACT term
                    {
                        if (isNumber($1) && isNumber($3))
                        {
                            $$ = calculate($1, $3, SUBTRACT);
                        }
                        else
                        {
                            cout << "Error: Cannot subtract NAN on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    ;
term                : factor
                    {
                        $$ = $1;
                    }
                    | term MULTIPLY factor
                    {
                        if (isNumber($1) && isNumber($3))
                        {
                            $$ = calculate($1, $3, MULTIPLY);
                        }
                        else
                        {
                            cout << "Error: Cannot multiply NAN on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    | term DIVIDE factor
                    {
                        if (isNumber($1) && isNumber($3))
                        {
                            $$ = calculate($1, $3, DIVIDE);
                        }
                        else
                        {
                            cout << "Error: Cannot divide NAN on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    ;
factor              : INTLIT
                    {
                        Node* p = new Node;
                        p->i = $1;
                        p->type = DISCRETE;
                        $$ = p;
                    }
                    | FLTLIT
                    {
                        Node* p = new Node;
                        p->d = $1;
                        p->type = CONTINOUS;
                        $$ = p;
                    }
                    | STRLIT
                    {
                        Node* p = new Node;
                        p->s = string($1);
                        p->type = TEXT;
                        $$ = p;
                    }
                    | ID
                    {
                        if (isDeclared(string($1)))
                        {
                            Node* p = sym[string($1)];
                            if (p->isNull)
                            {
                                cout << "Error: Cannot use uninitialized identifier " << string($1) << " on line " << yylineno << endl;
                                exit(-1);
                            }
                            $$ = p;
                        }
                        else
                        {
                            cout << "Undeclared identifier " << $1 << " on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    | ABSFUNC OPENPAR expressions CLOSEPAR
                    {
                        vType t = $3->type;
                        Node* p = new Node;
                        if (t == DISCRETE) 
                        {
                            p->i = abs($3->i);
                            p->type = DISCRETE;
                            $$ = p;
                        }
                        else if (t == CONTINOUS)
                        {
                            p->d = abs($3->d);
                            p->type = CONTINOUS;
                            $$ = p;
                        }
                        else
                        {
                            cout << "Error: Cannot get abs() value of NAN on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    | EXPRFUNC OPENPAR expressions CLOSEPAR
                    {
                        vType t = $3->type;
                        Node* p = new Node;
                        if (t == DISCRETE) 
                        {
                            p->i = exp($3->i);
                            p->type = DISCRETE;
                            $$ = p;
                        }
                        else if (t == CONTINOUS)
                        {
                            p->d = exp($3->d);
                            p->type = CONTINOUS;
                            $$ = p;
                        }
                        else
                        {
                            cout << "Error: Cannot get exp() value of NAN on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    | SQRTFUNC OPENPAR expressions CLOSEPAR
                    {
                        vType t = $3->type;
                        Node* p = new Node;
                        if (t == DISCRETE)
                        {
                            p->d = sqrt($3->i);
                            p->type = CONTINOUS;
                            $$ = p;
                        }
                        else if (t == CONTINOUS)
                        {
                            p->d = sqrt($3->d);
                            p->type = CONTINOUS;
                            $$ = p;
                        }
                        else
                        {
                            cout << "Error: Cannot get sqrt() value of NAN on line " << yylineno << endl;
                            exit(-1);
                        }
                    }
                    | OPENPAR expressions CLOSEPAR
                    {
                        $$ = $2;
                    }
                    ;
printstmt           : WRITE OPENPAR print_list CLOSEPAR
                    | WRITELN OPENPAR print_list CLOSEPAR
                    {
                        cout << endl;
                    }
                    ;
print_list          :  print_list COMMA expressions
                    {
                        printMe($3, false);
                    }
                    | expressions
                    {
                        printMe($1, false);
                    }
                    ;


%%
void yyerror(const char *s)
{
    printf("%s on line %d.\n", s, yylineno);
}

void addToSym(vector<string> names, vType t)
{
    for (int i = 0; i < names.size(); i++)
    {
        Node* p = new Node;
        p->isNull = true;
        p->type = t;
        p->isID = true;
        sym[names[i]] = p;
    }
}

bool sameType(Node* a, Node* b)
{
    return a->type == b->type;
}

bool isDeclared(string s)
{
    return sym.find(s) != sym.end();
}

void printMe(Node* p, bool withendl = false)
{
    switch(p->type)
    {
        case DISCRETE:
            cout << p->i;
            break;
        case CONTINOUS:
            cout << p->d;
            break;
        case TEXT:
            cout << p->s;
            break;
        case CHARACTER:
            cout << p->c;
            break;
        case BOOLEAN:
            cout << p->b;
            break;
    }
    if (withendl) cout << endl;
}

bool isNumber(Node* p)
{
    return (p->type == DISCRETE || p->type == CONTINOUS);
}

Node* calculate(Node* a, Node* b, int optr)
{
    Node* p = new Node;
    vType a_type = a->type;
    vType b_type = b->type;
    if (a_type == DISCRETE && b_type == DISCRETE)
    {
        p->type = DISCRETE;
        switch(optr)
        {
            case ADD:
                p->i = a->i + b->i;
                break;
            case SUBTRACT:
                p->i = a->i - b->i;
                break;
            case MULTIPLY:
                p->i = a->i * b->i;
                break;
            case DIVIDE:
                p->i = a->i / b->i;
                break;
        }
    }
    else
    {
        p->type = CONTINOUS;
        double fact1 = (a_type == CONTINOUS) ? a->d : (double) a->i;
        double fact2 = (b_type == CONTINOUS) ? b->d : (double) b->i;
        switch(optr)
        {
            case ADD:
                p->d = fact1 + fact2;
                break;
            case SUBTRACT:
                p->d = fact1 - fact2;
                break;
            case MULTIPLY:
                p->d = fact1 * fact2;
                break;
            case DIVIDE:
                p->d = fact1 / fact2;
                break;
        }
    }

    return p;
}

int main(int argc, char * argv[])
{
    if (argc <= 1)
    {
        cerr << "No file selected!" << endl << "Usage: pascaler <source_file.mpl>" << endl;
        exit(1);
    }
    if ((argc > 1) && ((stdin = fopen(argv[1], "r")) == NULL))
    {
        cerr << "File '" << argv[1] << "' may not exist or is being used by another program.\n";
        exit(1);
    }
    string fileName(argv[1]);
    int fnLen = fileName.length();
    if (".mpl" != fileName.substr(fnLen-4, fnLen))
    {
        cerr << "Invalid file!" << endl << "Input file should be mpl extension." << endl;
        exit(1);
    }
    typeName[VOID] = "VOID";
    typeName[TEXT] = "TEXT";
    typeName[DISCRETE] = "INTEGER";
    typeName[CONTINOUS] = "REAL";
    typeName[CHARACTER] = "CHARACTER";
    typeName[BOOLEAN] = "BOOLEAN";
    yyparse();
    printf("\n");
    return 0;
} 
