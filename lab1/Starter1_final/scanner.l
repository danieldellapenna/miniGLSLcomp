%{
/**********************************************************************
 *   Group : cd-012
 *
 *   Daniel Della Penna 999180808
 *
 *   Sai Kiran Varikooty 998440307
 *
 *  scanner.l
 *
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include <string.h>
#include <limits.h>
#include <stdlib.h>
#include <errno.h>
#include <float.h>

#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

unsigned long CheckInt(int base);
float CheckFloat();
int yyline = 1;

%}
%option noyywrap

WS          [ \t]

alpha [a-zA-Z]
dec_digit [0-9]
oct_digit [0-7]
hex_digit [0-9a-fA-F] 

validIDName ({alpha}|_)({alpha}|{dec_digit}|_)*

float_no_exp {dec_digit}*\.{dec_digit}+
float_exp {dec_digit}*\.?{dec_digit}+([eE][-+]?{dec_digit}+)
float {float_no_exp}|{float_exp}
int_dec ([1-9]{dec_digit}*)|0
int_oct 0[1-7]{oct_digit}*
int_hex 0[xX]{hex_digit}+

%%

{WS} /* Skip Whitespace (WS) */

"/*" {
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

    /*Literals*/
{float} { 

        yylval.fval = CheckFloat();
        yTRACE(LIT_FLOAT);
        return LIT_FLOAT;
}

{int_dec} { 

        yylval.ival = CheckInt(10);
        yTRACE(LIT_INT);
        return LIT_INT; 
}

{int_oct} { 

        yylval.ival = CheckInt(8);
        yTRACE(LIT_INT);
        return LIT_INT; 
}

{int_hex} { 

        yylval.ival = CheckInt(6);
        yTRACE(LIT_INT);
        return LIT_INT; 
}

"true" { yTRACE(LIT_TRUE); return LIT_TRUE; }
"false" { yTRACE(LIT_FALSE); return LIT_FALSE; }

    /*Types*/
"float" { yTRACE(FLOAT); return FLOAT; }
"int" { yTRACE(INT); return INT; }
"bool" { yTRACE(BOOL); return BOOL; }
"vec2" { yTRACE(VEC2); return VEC2; }
"vec3" { yTRACE(VEC3); return VEC3; }
"vec4" { yTRACE(VEC4); return VEC4; }
"ivec2" { yTRACE(IVEC2); return IVEC2; }
"ivec3" { yTRACE(IVEC3); return IVEC3; }
"ivec4" { yTRACE(IVEC4); return IVEC4; }
"bvec2" { yTRACE(BVEC2); return BVEC2; } 
"bvec3" { yTRACE(BVEC3); return BVEC3; }
"bvec4" { yTRACE(BVEC4); return BVEC4; }
"void" { yTRACE(VOID); return VOID; }

    /*Functions*/
"dp3" { yTRACE(DP3); return DP3; }
"lit" { yTRACE(LIT); return LIT; }
"rsq" { yTRACE(RSQ); return RSQ; }

    /*Qualifiers*/
"const" { yTRACE(CONST); return CONST; }

    /*Control Logic*/
"if" { yTRACE(IF); return IF; }
"else" { yTRACE(ELSE); return ELSE; }
"while" { yTRACE(WHILE); return WHILE; }

    /*Operators*/

    /*Equals*/
"=" { yTRACE(yytext[0]); return yytext[0]; }

    /*Math*/
    /*Use ASCII for basic math operations*/
"+"|"-"|"*"|"/"|"^" { yTRACE(yytext[0]); return yytext[0]; }

    /*Use tokens for comparisons*/
"==" { yTRACE(EQ); return EQ; }
"!=" { yTRACE(NE); return NE; }
"<"  { yTRACE(LT); return LT; }
"<=" { yTRACE(LE); return LE; }
">"  { yTRACE(GT); return GT; }
">=" { yTRACE(GE); return GE; }

    /*Logic*/
"&&" { yTRACE(AND); return AND; }

    /*Unary*/
"!" { yTRACE(NOT); return NOT; }

    /*Brackets*/
"("|")"|"["|"]"|"{"|"}" { yTRACE(yytext[0]); return yytext[0]; }

    /*Delimiters*/
"," { yTRACE(yytext[0]); return yytext[0]; }
";" { yTRACE(yytext[0]); return yytext[0]; }

    /*Identifier*/
    /*Should be at end, avoids problems with identifiers named after keywords*/
{validIDName} { 

    if (yyleng > MAX_IDENTIFIER) {

        yERROR("Exceeded MAX_IDENTIFIER value");
    }

    else {

        yTRACE(ID); 
        yylval.idval = strdup(yytext);
        return ID;
    }
}

"\n" { yyline++; }

.           { yERROR("Unknown token"); }

%%

unsigned long CheckInt (int base) {

    errno = 0;

    unsigned long valLitInt = strtoul(yytext, NULL, base); /* always read as unsigned integer as the sign is not included for token */
    /*printf("%ul\n", valLitInt);*/

    if (errno == ERANGE) {

        yERROR("Integer value overflow"); 
    }

    else if (valLitInt > MAX_INTEGER) {

        yERROR("Exceeded MAX_INTEGER value");
    }

    else {
    
        return valLitInt; 
    }
}

float CheckFloat (void) {

    errno = 0;

    float valLitFloat = strtof(yytext, NULL); /* always read as unsigned integer as the sign is not included for token */
    /*printf("%f\n", valLitInt);*/

    if (errno == ERANGE) {

        yERROR("Float value overflow"); 
    }

    else if (valLitFloat > MAX_FLOAT) {

        yERROR("Exceeded MAX_FLOAT value");
    }

    else {
    
        return valLitFloat; 
    }
}
