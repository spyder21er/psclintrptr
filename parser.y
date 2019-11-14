%{
#include <iostream>
#include <map>
#include <vector>
#include <cmath>
#include <cstring>
using namespace std;

int yylex (void);
void yyerror (const char *);

map<string, double> nums;
map<string, string> strs;
map<string, string> types;
vector<string> vars;

%}

%token START END WRITE WRITELN READLN ABSFUNC EXPRFUNC SQRTFUNC
%token ADD SUBTRACT MULTIPLY DIVIDE
%token ANDOP OROP NOTOP ASSIGNOP 
%token EQUAL GREATERTHAN LESSTHAN GEQ LEQ NOTEQUAL
%token OPENPAR CLOSEPAR COLON COMMA SEMICOLON
%token REP DOCOND FORCOND ELSECOND IFCOND THENCOND TOCOND UNTIL WHILECOND
%token <real> FLTLIT INTLIT 
%token <text> STRLIT ID
%token FLOAT INTEGER STRING VAR CHAR BOOL

%type <real> term factor
%type <text> stringliterals

%left ADD SUBTRACT
%left MULTIPLY DIVIDE

%union{
    char text[256];
    double real;
}

%start  program

%%

program             : { cout << "Empty file!" << endl; exit(1); }
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
                        for (int i = 0; i < vars.size(); i++)
                        {
                            strs[vars[i]];
                            types[vars[i]] = "text";
                        }
                        vars.clear();
                    }
                    | INTEGER 
                    {
                        for (int i = 0; i < vars.size(); i++)
                        {
                            nums[vars[i]];
                            types[vars[i]] = "real";
                        }
                        vars.clear();
                    }
                    | FLOAT 
                    {
                        for (int i = 0; i < vars.size(); i++)
                        {
                            nums[vars[i]];
                            types[vars[i]] = "real";
                        }
                        vars.clear();
                    }
                    | CHAR 
                    | BOOL
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
                        string s($1);
                        nums[s] = $<real>3;
                    }
                    | ID ASSIGNOP stringliterals 
                    {
                        string s($1);
                        strs[s] = string($3);
                    }
                    ;
expressions         : term
                    {
                        $<real>$ = $<real>1;
                    }
                    | expressions ADD term
                    {
                        $<real>$ = $<real>1 + $3;
                    }
                    | expressions SUBTRACT term
                    {
                        $<real>$ = $<real>1 - $3;
                    }
                    ;
term                : factor
                    {
                        $$ = $1;
                    }
                    | term MULTIPLY factor
                    {
                        $$ = $1 * $3;
                    }
                    | term DIVIDE factor
                    {
                        $$ = $1 / $3;
                    }
                    ;
factor              : INTLIT
                    {
                        $$ = $1;
                    }
                    | FLTLIT
                    {
                        $$ = $1;
                    }
                    | ID
                    {
                        $$ = nums[string($1)];
                    }
                    | ABSFUNC OPENPAR expressions CLOSEPAR
                    {
                        $$ = abs($<real>3);
                    }
                    | EXPRFUNC OPENPAR expressions CLOSEPAR
                    {
                        $$ = exp($<real>3);
                    }
                    | SQRTFUNC OPENPAR expressions CLOSEPAR
                    {
                        $$ = sqrt($<real>3);
                    }
                    | OPENPAR expressions CLOSEPAR
                    {
                        $$ = $<real>2;
                    }
                    ;
printstmt           : WRITELN OPENPAR stringliterals CLOSEPAR
                    {
                        cout << string($3) << endl;
                    }
                    | WRITELN OPENPAR expressions CLOSEPAR
                    {
                        cout << $<real>3 << endl;
                    }
                    ;
stringliterals      : STRLIT
                    {
                        strcpy($$, $1);
                    }
                    ;


%%
void yyerror(const char *s)
{
    extern int yylineno;
    printf("%s on line %d.\n", s, yylineno);
}

int main(int argc, char * argv[])
{
    if ((argc > 1) && ((stdin = fopen(argv[1], "r")) == NULL))
    {
        cerr << argv[0] << ": File " << argv[1] << " cannot be opened.\n";
        exit(1);
    }
    yyparse();
    printf("\n");
    return 0;
} 
