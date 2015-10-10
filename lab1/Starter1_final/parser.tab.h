/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

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

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    LIT_FLOAT = 258,
    LIT_INT = 259,
    LIT_TRUE = 260,
    LIT_FALSE = 261,
    FLOAT = 262,
    INT = 263,
    BOOL = 264,
    VEC2 = 265,
    VEC3 = 266,
    VEC4 = 267,
    IVEC2 = 268,
    IVEC3 = 269,
    IVEC4 = 270,
    BVEC2 = 271,
    BVEC3 = 272,
    BVEC4 = 273,
    VOID = 274,
    DP3 = 275,
    LIT = 276,
    RSQ = 277,
    CONST = 278,
    IF = 279,
    ELSE = 280,
    WHILE = 281,
    ID = 282,
    EQ = 283,
    NE = 284,
    LT = 285,
    LE = 286,
    GT = 287,
    GE = 288,
    AND = 289,
    OR = 290,
    NOT = 291
  };
#endif
/* Tokens.  */
#define LIT_FLOAT 258
#define LIT_INT 259
#define LIT_TRUE 260
#define LIT_FALSE 261
#define FLOAT 262
#define INT 263
#define BOOL 264
#define VEC2 265
#define VEC3 266
#define VEC4 267
#define IVEC2 268
#define IVEC3 269
#define IVEC4 270
#define BVEC2 271
#define BVEC3 272
#define BVEC4 273
#define VOID 274
#define DP3 275
#define LIT 276
#define RSQ 277
#define CONST 278
#define IF 279
#define ELSE 280
#define WHILE 281
#define ID 282
#define EQ 283
#define NE 284
#define LT 285
#define LE 286
#define GT 287
#define GE 288
#define AND 289
#define OR 290
#define NOT 291

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 61 "parser.y" /* yacc.c:1909  */


  int ival;
  float fval;
  char *idval;

#line 133 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
