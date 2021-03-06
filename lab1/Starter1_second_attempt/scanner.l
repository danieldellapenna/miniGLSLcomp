%{
/**********************************************************************
 *
 *   Group :
 *
 *   Daniel Della Penna 999180808
 *
 *   Sai Kiran Varikooty 998440307
 *
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include "string.h"
#include "limits.h"
#include <stdlib.h>
#include <errno.h>


#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

int CheckInt(void);
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

    float valLitFloat = strtof(yytext, NULL); /* always read as unsigned integer as the sign is not included for token */

    if (valLitFloat > MAX_FLOAT) {

        yERROR("Exceeded MAX_FLOAT value");
    }

    else {
    
        yTRACE(LIT_FLOAT);
        yylval.fval = valLitFloat;
        return LIT_FLOAT; 
    }

/* Do we have a max float val? We should, it could overflow */

}

{int_dec} { 

    unsigned int valLitInt = strtoul(yytext, NULL, 10); /* always read as unsigned integer as the sign is not included for token */
    /*printf("%u\n", valLitInt);*/

    if (valLitInt > MAX_INTEGER) {

        yERROR("Exceeded MAX_INTEGER value");
    }

    else {
    
        yTRACE(LIT_INT);
        yylval.ival=valLitInt;
        return LIT_INT; 
    }
}

{int_oct} { 

    unsigned int valLitInt = strtoul(yytext, NULL, 8); /* always read as unsigned integer as the sign is not included for token */
    /*printf("%u\n", valLitInt);*/

    if (valLitInt > MAX_INTEGER) {

        yERROR("Exceeded MAX_INTEGER value");
    }

    else {
    
        yTRACE(LIT_INT);
        yylval.ival=valLitInt;
        return LIT_INT; 
    }
}

{int_hex} { 

    unsigned int valLitInt = strtoul(yytext, NULL, 16); /* always read as unsigned integer as the sign is not included for token */
    /*printf("%u\n", valLitInt);*/

    if (valLitInt > MAX_INTEGER) {

        yERROR("Exceeded MAX_INTEGER value");
    }

    else {
    
        yTRACE(LIT_INT);
        yylval.ival=valLitInt;
        return LIT_INT; 
    }
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

.           { yERROR("Unknown token"); }

%%
