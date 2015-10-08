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

#include "scanner_test.tab.h"  // to get the token types that we return

/*#include "common.h"*/
/*#include "parser.tab.h"*/
/*#include <string.h>*/

/*#define YY_USER_INIT { yyin = inputFile; }*/
/*#define	yyinput      input*/
/*#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }*/
/*#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }*/
/*#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)*/
/*#define TOKEN(t) (yylval.token = t)*/

/*int CheckInt(void);*/
/*int yyline = 1;*/

%}
%option noyywrap

WS          [ \t]

%%

[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); return FLOAT; }    
[0-9]+           { cout << "Found a integer number:" << yytext << endl; }   
"="                { cout << "Found token:" << yytext << endl; }

.               ;

%%

