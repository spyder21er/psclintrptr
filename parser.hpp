/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSER_HPP_INCLUDED
# define YY_YY_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    START = 258,
    END = 259,
    WRITE = 260,
    WRITELN = 261,
    READLN = 262,
    ABSFUNC = 263,
    EXPRFUNC = 264,
    SQRTFUNC = 265,
    ADD = 266,
    SUBTRACT = 267,
    MULTIPLY = 268,
    DIVIDE = 269,
    ANDOP = 270,
    OROP = 271,
    NOTOP = 272,
    ASSIGNOP = 273,
    EQUAL = 274,
    GREATERTHAN = 275,
    LESSTHAN = 276,
    GEQ = 277,
    LEQ = 278,
    NOTEQUAL = 279,
    OPENPAR = 280,
    CLOSEPAR = 281,
    COLON = 282,
    COMMA = 283,
    SEMICOLON = 284,
    REP = 285,
    DOCOND = 286,
    FORCOND = 287,
    ELSECOND = 288,
    IFCOND = 289,
    THENCOND = 290,
    TOCOND = 291,
    UNTIL = 292,
    WHILECOND = 293,
    FLTLIT = 294,
    INTLIT = 295,
    STRLIT = 296,
    ID = 297,
    FLOAT = 298,
    INTEGER = 299,
    STRING = 300,
    VAR = 301,
    CHAR = 302,
    BOOL = 303
  };
#endif
/* Tokens.  */
#define START 258
#define END 259
#define WRITE 260
#define WRITELN 261
#define READLN 262
#define ABSFUNC 263
#define EXPRFUNC 264
#define SQRTFUNC 265
#define ADD 266
#define SUBTRACT 267
#define MULTIPLY 268
#define DIVIDE 269
#define ANDOP 270
#define OROP 271
#define NOTOP 272
#define ASSIGNOP 273
#define EQUAL 274
#define GREATERTHAN 275
#define LESSTHAN 276
#define GEQ 277
#define LEQ 278
#define NOTEQUAL 279
#define OPENPAR 280
#define CLOSEPAR 281
#define COLON 282
#define COMMA 283
#define SEMICOLON 284
#define REP 285
#define DOCOND 286
#define FORCOND 287
#define ELSECOND 288
#define IFCOND 289
#define THENCOND 290
#define TOCOND 291
#define UNTIL 292
#define WHILECOND 293
#define FLTLIT 294
#define INTLIT 295
#define STRLIT 296
#define ID 297
#define FLOAT 298
#define INTEGER 299
#define STRING 300
#define VAR 301
#define CHAR 302
#define BOOL 303

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 35 "parser.y" /* yacc.c:1909  */

    char text[256];
    int integer;
    double real;
    Node * vPtr;

#line 157 "parser.hpp" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_HPP_INCLUDED  */
