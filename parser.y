%{
#include "header.hpp"

int yylex (void);
extern int yylineno;
void yyerror(const char * s);
void yyerror(string s);
void addToSym(vector<string> names, vType t);
bool isDeclared(string s);
map<string, Variable*> symTbl;
map<vType, string> typeName;
vector<string> varnames;
Node n_operator(int optr, Node left, Node Right);
Node n_identifier(string id);
Node n_variable(Variable v);
Variable eval(Node r);
Variable makeVar(vType vt = VOID, int vi = 0, double vd = 0.0, string vs = "", bool vb = false, char vc = ' ', bool init = false);

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

%type <v> term factor expressions print_list assignstmt simple_expression

%left ADD SUBTRACT
%left MULTIPLY DIVIDE

%union {
    char text[256];
    int integer;
    double real;
    Node v;
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
                        addToSym(varnames, TEXT);
                        varnames.clear();
                    }
                    | INTEGER 
                    {
                        addToSym(varnames, DISCRETE);
                        varnames.clear();
                    }
                    | FLOAT
                    {
                        addToSym(varnames, CONTINOUS);
                        varnames.clear();
                    }
                    | CHAR
                    {
                        addToSym(varnames, CHARACTER);
                        varnames.clear();
                    }
                    | BOOL
                    {
                        addToSym(varnames, BOOLEAN);
                        varnames.clear();
                    }
                    ;
identifiers         : ID COMMA identifiers
                    {
                        varnames.push_back(string($1));
                    }
                    | ID
                    {
                        varnames.push_back(string($1));
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
                        $$ = n_operator(ASSIGNOP, n_identifier(string($1)), $3);
                    }
                    ;
expressions         : simple_expression
                    {
                        $$ = $1;
                    }
                    | simple_expression EQUAL simple_expression
                    {
                        $$ = n_operator(EQUAL, $1, $3);
                    }
                    | simple_expression NOTEQUAL simple_expression
                    {
                        $$ = n_operator(NOTEQUAL, $1, $3);
                    }
                    | simple_expression LEQ simple_expression
                    {
                        $$ = n_operator(LEQ, $1, $3);
                    }
                    | simple_expression GEQ simple_expression
                    {
                        $$ = n_operator(GEQ, $1, $3);
                    }
                    | simple_expression LESSTHAN simple_expression
                    {
                        $$ = n_operator(LESSTHAN, $1, $3);
                    }
                    | simple_expression GREATERTHAN simple_expression
                    {
                        $$ = n_operator(GREATERTHAN, $1, $3);
                    }
                    ;
simple_expression   : term
                    {
                        $$ = $1;
                    }
                    | simple_expression ADD term
                    {
                        $$ = n_operator(ADD, $1, $3);
                    }
                    | simple_expression SUBTRACT term
                    {
                        $$ = n_operator(SUBTRACT, $1, $3);
                    }
                    | simple_expression OROP term
                    {
                        $$ = n_operator(OROP, $1, $3);
                    }
                    ;
term                : factor
                    {
                        $$ = $1;
                    }
                    | term MULTIPLY factor
                    {
                        $$ = n_operator(MULTIPLY, $1, $3);
                    }
                    | term DIVIDE factor
                    {
                        $$ = n_operator(DIVIDE, $1, $3);
                    }
                    | term ANDOP factor
                    {
                        $$ = n_operator(ANDOP, $1, $3);
                    }
                    ;
factor              : INTLIT
                    {
                        $$ = n_variable(makeVar(DISCRETE, $1));
                    }
                    | FLTLIT
                    {
                        $$ = n_variable(makeVar(CONTINOUS, 0, $1));
                    }
                    | STRLIT
                    {
                        $$ = n_variable(makeVar(TEXT, 0, 0.0, $1));
                    }
                    | NOTOP factor
                    {
                        $$ = n_operator(NOTOP, $2, NULL);
                    }
                    | ID
                    {
                        $$ = n_identifier(string($1));
                    }
                    | ABSFUNC OPENPAR expressions CLOSEPAR
                    {
                        $$ = n_operator(ABSFUNC, $3, NULL);
                    }
                    | EXPRFUNC OPENPAR expressions CLOSEPAR
                    {
                        $$ = n_operator(EXPRFUNC, $3, NULL);
                    }
                    | SQRTFUNC OPENPAR expressions CLOSEPAR
                    {
                        $$ = n_operator(SQRTFUNC, $3, NULL);
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
                    | expressions
                    ;


%%

void addToSym(vector<string> names, vType t)
{
    for (int i = 0; i < names.size(); i++)
    {
        Variable * p;
        if ((p = new Variable) == NULL)
        {
            yyerror("Cannot allocate new memory.");
        }
        p->initialized = false;
        p->t = t;
        symTbl[names[i]] = p;
    }
}

bool isDeclared(string s)
{
    return symTbl.find(s) != symTbl.end();
}

Variable makeVar(vType vt, int vi, double vd, string vs, bool vb, char vc, bool init)
{
    Variable v;
    v.t = vt, v.i = vi, v.d = vd, v.s = vs, v.b = vb, v.c = vc, v.initialized = init;
    return v;
}

bool operator == (Variable a, Variable b)
{
    if (a.t == DISCRETE)
        return (a.i == b.i);
    else if (a.t == CONTINOUS)
        return (a.d == b.d);
    else if (a.t == BOOLEAN)
        return (a.b == b.b);
    else if (a.t == CHARACTER)
        return (a.c == b.c);
    else if (a.t == TEXT)
        return (a.s == b.s);
}

bool operator != (Variable a, Variable b)
{
    return !(a == b);
}

Node n_operator(int optr, Node l, Node r)
{
    Node p;
    if ((p = new Ast) == NULL)
    {
        yyerror("Cannot allocate new memory.");
    }
    p->t = OPERATOR;
    p->l = l;
    p->r = r;
    return p;
}

Node n_variable(Variable v)
{
    leafNode *p;
    if ((p = new leafNode) == NULL)
    {
        yyerror("Cannot allocate new memory.");
    }
    p->t = VARIABLE;
    p->value = v;
    return (Node) p;
}

Node n_identifier(string s)
{
    leafNode * p;
    if ((p = new leafNode) == NULL)
    {
        yyerror("Cannot allocate new memory.");
    }
    p->t = IDENTIFIER;
    p->id = s;
    return (Node) p;
}

Variable eval(Node r)
{
    if (r == NULL)
        return makeVar();
    
    Variable result;

    switch (r->t)
    {
        case OPERATOR:
            /* code */
            break;
        case IDENTIFIER:
            /* code */
            break;
        case VARIABLE:
            /* code */
            break;
        default:
            yyerror("Unknown node encountered.");
            break;
    }
}

void yyerror(const char *s)
{
    yyerror(string(s));
}

void yyerror(string s)
{
    cout << "Error on line " << yylineno << ". " << s << endl;
    exit(1);
}

int main(int argc, char * argv[])
{
    if ((argc > 1) && ((stdin = fopen(argv[1], "r")) == NULL))
    {
        cerr << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
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
