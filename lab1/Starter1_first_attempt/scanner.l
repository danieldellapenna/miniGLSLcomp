%{
/**********************************************************************
 *
 * **YOUR GROUP INFO SHOULD GO HERE**
 *
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/

#include <cstdio>
#include <iostream>
using namespace std;
#define YY_DECL extern "C" int yylex()

#include "common.h"
#include "parser.tab.h"
#include <string.h>

#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }
#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)

int CheckInt(void);
int yyline = 1;

%}
%option noyywrap

WS          [ \t]

%%

[0-9]+\.[0-9]+      SAVE_TOKEN; return T_FLOAT;
[0-9]+              SAVE_TOKEN; return T_INT;
"="                 return yylval.token = T_EQUAL;
"{"                 return yylval.token = T_LBRACE;
"}"                 return yylval.token = T_RBRACE;
"("                 return yylval.token = T_LPAREN;
")"                 return yylval.token = T_RPAREN;
"+"                 return yylval.token = T_PLUS;
"-"                 return yylval.token = T_MINUS;
"*"                 return yylval.token = T_STAR;
"/"


"/*"        {
              int c1      = 0;
              int c2      = yyinput();
              int curline = yyline;
              for(;;) {
                if (c2 == EOF) {
                  fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: Unmatched /*\n", curline);
                  errorOccurred = TRUE;
                  yyterminate();
                }
                if (c1 == '*' && c2 == '/')
                  break;
                c1 = c2;
                c2 = yyinput();
                if (c1 == '\n' && c2 != EOF)
                  yyline++;
              }
            }

.           { yERROR("Unknown token"); }

%%
