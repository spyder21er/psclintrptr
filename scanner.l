%option noyywrap
%option yylineno
%{
#include "header.hpp"
#include "parser.hpp"
using namespace std;

int line_no = 1;
int to_int(const char * s);
double to_real(const char *s);

%}

digit               [0-9]
int_lit             -?{digit}+
letter              [a-zA-Z]
identifier          ("_"|{letter})({letter}|{digit}|"_")*
str_lit             '([^\'\n\r])*'
flt_lit             -?{digit}+\.{digit}+
inline_com          \{[^\n\r]*\}
multi_com           \{\*[^(\*\})]*\*\}
equal               =
less_than           \<
greater_than        \>
not_equal           {less_than}{greater_than}
less_equal          {less_than}{equal}
great_equal         {greater_than}{equal}


%%

"begin"      	    { return START; }
"end"     	        { return END; }
"var"               { return VAR; }
"writeln"           { return WRITELN; }
"write"             { return WRITE; }
"read"              { return READLN; }
"integer"           { return INTEGER; }
"string"            { return STRING; }
"char"              { return CHAR; }
"boolean"           { return BOOL; }
"float"             { return FLOAT; }
"and"               { return ANDOP; }
"or"                { return OROP; }
"not"               { return NOTOP; }
"+"                 { return ADD; }
"-"                 { return SUBTRACT; }
"*"                 { return MULTIPLY; }
"/"                 { return DIVIDE; }
"if"                { return IFCOND; }
"then"              { return THENCOND; }
"else"              { return ELSECOND; }
"rep"|"repeat"      { return REP; }
"until"             { return UNTIL; }
"for"               { return FORCOND; }
"to"                { return TOCOND; }
"do"                { return DOCOND; }
"while"             { return WHILECOND; }
"abs"               { return ABSFUNC; }
"exp"               { return EXPRFUNC; }
"sqrt"              { return SQRTFUNC; }
":="                { return ASSIGNOP; }
":"                 { return COLON; }
";"                 { return SEMICOLON; }
"("                 { return OPENPAR; }
")"                 { return CLOSEPAR; }
","                 { return COMMA; }
"="                 { return EQUAL; }
"<="                { return LEQ; }
">="                { return GEQ; }
"<>"                { return NOTEQUAL; }
"<"                 { return LESSTHAN; }
">"                 { return GREATERTHAN; }
{identifier}        { sscanf(yytext, "%s", yylval.text);return ID; }
{str_lit}           { strcpy(yylval.text, string(yytext).substr(1, strlen(yytext) - 2).c_str()); return STRLIT; }
{int_lit}           { yylval.integer = to_int(yytext); return INTLIT; }
{flt_lit}           { yylval.real = to_real(yytext); return FLTLIT; }
{inline_com}        ;
{multi_com}         ;
[ \t\r]             ;
\n                  { }
.                   { printf ("Unknown character: %s at line %d\n", yytext, yylineno); }

%%

int to_int(const char *s)
{
    stringstream ss(s);
    int n;
    ss >> n;
    return n;
}

double to_real(const char *s)
{
    stringstream ss(s);
    double n;
    ss >> n;
    return n;
}