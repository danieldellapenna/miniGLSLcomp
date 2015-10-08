%{
/***********************************************************************
 * --YOUR GROUP INFO SHOULD GO HERE--
 * 
 *   Interface to the parser module for CSC467 course project.
 * 
 *   Phase 2: Implement context free grammar for source language, and
 *            parse tracing functionality.
 *   Phase 3: Construct the AST for the source language program.
 ***********************************************************************/

/***********************************************************************
 *  C Definitions and external declarations for this module.
 *
 *  Phase 3: Include ast.h if needed, and declarations for other global or
 *           external vars, functions etc. as needed.
 ***********************************************************************/

#include <string.h>
#include "common.h"
//#include "ast.h"
//#include "symbol.h"
//#include "semantic.h"
#define YYERROR_VERBOSE
#define yTRACE(x)    { if (traceParser) fprintf(traceFile, "%s\n", x); }

void yyerror(char* s);    /* what to do in case of error            */
int yylex();              /* procedure for calling lexical analyzer */
extern int yyline;        /* variable holding current line number   */

%}

/***********************************************************************
 *  Yacc/Bison declarations.
 *  Phase 2:
 *    1. Add precedence declarations for operators (after %start declaration)
 *    2. If necessary, add %type declarations for some nonterminals
 *  Phase 3:
 *    1. Add fields to the union below to facilitate the construction of the
 *       AST (the two existing fields allow the lexical analyzer to pass back
 *       semantic info, so they shouldn't be touched).
 *    2. Add <type> modifiers to appropriate %token declarations (using the
 *       fields of the union) so that semantic information can by passed back
 *       by the scanner.
 *    3. Make the %type declarations for the language non-terminals, utilizing
 *       the fields of the union as well.
 ***********************************************************************/

%{
#define YYDEBUG 1
%}


// TODO:Modify me to add more data types
// Can access me from flex useing yyval

%union {

  int ival;
  float fval;
  char *idval;
}
// TODO:Replace myToken with your tokens, you can use these tokens in flex
/*%token           myToken1 myToken2  */

/*Literals*/
%token <fval> FLOAT_LIT
%token <ival> INT_LIT
/*%token <bval> BOOL_LIT*/
%token TRUE_LIT FALSE_LIT /*Boolean Literal*/

/*Types*/
%token FLOAT INT BOOL 
%token VEC2 VEC3 VEC4 /*Float Vector*/
%token IVEC2 IVEC3 IVEC4 /*Int Vector*/
%token BVEC2 BVEC3 BVEC4 /*Bool Vector*/
%token VOID

/*Functions*/
%token DP3 LIT RSQ

/*Qualifiers*/
%token CONST

/*Control Logic*/
%token IF ELSE WHILE

/*Identifier*/
%token <idname> ID

/*Operators*/
%token EQ NE LT LE GT GE /*Comparison*/

%token AND OR /*Logic*/

%token NOT /*Unary, minus in math*/

/*Don't actually use built-in precedence, use rules*/
/*Lowest precedence*/
/*%left '||'*/
/*%left '&&'*/
/*%left '==' '!=' '<' '<=' '>' '>='*/

/*%left '+' '-'*/
/*%left '*' '/'*/
/*%right '^'*/
/*%nonassoc '!'*/
/*Highest precedence*/

%start    program

%%

/***********************************************************************
 *  Yacc/Bison rules
 *  Phase 2:
 *    1. Replace grammar found here with something reflecting the source
 *       language grammar
 *    2. Implement the trace parser option of the compiler
 *  Phase 3:
 *    1. Add code to rules for construction of AST.
 ***********************************************************************/
program
  :   tokens       
  ;
tokens
  :  tokens token  
  |      
  ;
// TODO: replace myToken with the token the you defined.
token
  :     INT_LIT 
  |     FLOAT_LIT
  |     TRUE_LIT
  |     FALSE_LIT
  |     INT
  |     BOOL
  |     FLOAT
  |     VEC2
  |     VEC3
  |     VEC4
  |     BVEC2
  |     BVEC3
  |     BVEC4
  |     IVEC2
  |     IVEC3
  |     IVEC4
  |     VOID
  |     ID
  |     DP3
  |     LIT
  |     RSQ
  |     CONST
  |     IF { printf("Bison found if statement\n"); }
  |     ELSE
  |     WHILE
  |     '+'
  |     '-'
  |     '*'
  |     '/'
  |     '^'
  |     EQ
  |     NE
  |     LT
  |     LE
  |     GT
  |     GE
  |     AND
  |     OR
  |     NOT
  |     '('
  |     ')'
  |     '['
  |     ']'
  |     '{'
  |     '}'
  |     ','
  |     ';'
  ;


%%

/***********************************************************************ol
 * Extra C code.
 *
 * The given yyerror function should not be touched. You may add helper
 * functions as necessary in subsequent phases.
 ***********************************************************************/
void yyerror(char* s) {
  if (errorOccurred)
    return;    /* Error has already been reported by scanner */
  else
    errorOccurred = 1;
        
  fprintf(errorFile, "\nPARSER ERROR, LINE %d",yyline);
  if (strcmp(s, "parse error")) {
    if (strncmp(s, "parse error, ", 13))
      fprintf(errorFile, ": %s\n", s);
    else
      fprintf(errorFile, ": %s\n", s+13);
  } else
    fprintf(errorFile, ": Reading token %s\n", yytname[YYTRANSLATE(yychar)]);
}

