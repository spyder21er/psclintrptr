%{
#include <iostream>
using namespace std;

int yylex (void);
void yyerror (const char *);
%}

%token  START END WRITE WRITELN READLN ABSFUNC EXPRFUNC SQRTFUNC
%token  ADD SUBTRACT MULTIPLY DIVIDE
%token  ANDOP OROP NOTOP ASSIGNOP 
%token  EQUAL GREATERTHAN LESSTHAN GEQ LEQ NOTEQUAL
%token  OPENPAR CLOSEPAR COLON COMMA SEMICOLON
%token  REP DOCOND FORCOND ELSECOND IFCOND THENCOND TOCOND UNTIL WHILECOND
%token  FLTLIT INTLIT STRLIT
%token  FLOAT ID INTEGER STRING VAR CHAR BOOL

%start  program

%%

program             : varpart blockpart
                    | blockpart 
                    ;
varpart             : VAR varlist 
                    ;
varlist             : identifiers COLON type SEMICOLON varlist
                    | 
                    ;
type                : STRING | INTEGER | FLOAT | CHAR | BOOL
identifiers         : ID COMMA identifiers
                    | ID
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
                    | loopstmt
                    | ifstmt
                    | printstmt
                    ;
assignstmt          : ID ASSIGNOP expressions
                    ;
expressions         : ID
                    ;
loopstmt            : forstmt | whilestmt | repstmt
                    ;
forstmt             : ID
                    ;
whilestmt           : ID
                    ;
repstmt             : ID
                    ;
ifstmt              : ifthenstmt
                    | ifthenstmt elsestmt
                    ;
ifthenstmt          : IFCOND expressions THENCOND statement
                    | IFCOND expressions THENCOND START statements END
                    ;
booleanexps         : booleanexp booleanoptr booleanexps
                    | ID
                    ;
booleanoptr         : ANDOP | OROP
                    ;                    
booleanexp          : booleanoprd reloptr booleanoprd
                    ;
booleanoprd         : ID | INTLIT | STRLIT | FLTLIT
                    ;
reloptr             : EQUAL | LESSTHAN | GREATERTHAN | NOTEQUAL | LEQ | GEQ
                    ;
elsestmt            : ELSECOND statement
                    | ELSECOND START statements END
                    ;
printstmt           : WRITE OPENPAR printable CLOSEPAR
                    | WRITELN OPENPAR printable CLOSEPAR
                    ;
printable           : ID
                    ;


                
                

%%
void yyerror(const char *s)
{
    printf("%s.\n", s);
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
