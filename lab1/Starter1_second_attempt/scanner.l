%{
/**********************************************************************
 *
 * **YOUR GROUP INFO SHOULD GO HERE**
 *
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include "string.h"


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
digit [0-9]

validIDName ({alpha}|_)({alpha}|{digit}|_)*

float {digit}+\.{digit}+ 
int {digit}+

%%

{WS} /* Skip Whitespace (WS) */

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

    /*Literals*/
{float}     { yTRACE(FLOAT_LIT); yylval.fval = atof(yytext); return FLOAT_LIT; 

/* Do we have a max float val? We should, it could overflow */

}
{int}       { 

    unsigned int valIntLit = atoi(yytext);
    /*printf("%u\n",valIntLit);*/

    if (valIntLit > MAX_INTEGER) {

        yERROR("Exceeded MAX_INTEGER value");
    }

    else {
    
        yTRACE(INT_LIT);
        yylval.ival=valIntLit;
        return INT_LIT; 
    }

}

"true" { yTRACE(TRUE_LIT); return TRUE_LIT; }
"false" { yTRACE(FALSE_LIT); return FALSE_LIT; }

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
    /*Use characters for basic math operations*/
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
