%option noyywrap
%{
    #define YY_NO_UNPUT
    #define YY_NO_INPUT

    #include "parser.h"
    #include <ostream>
    #include <fstream>
    using namespace std;

    extern FILE *yyin; 
    extern FILE *yyout;
    extern bool dump_tokens;

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }
%}

DECIMIAL ([1-9][0-9]*|0)
OCTONARY (0[1-7][0-7]*|00)
HEXADECIMAL (0x[1-9,a-f,A-F][0-9,a-f,A-F]*|0X[1-9,a-f,A-F][0-9,a-f,A-F]*|0x0|0X0)
ID [[:alpha:]_][[:alpha:][:digit:]_]*
COMMA "," 
EOL (\r\n|\n|\r)
WHITE [\t ]
LINECOMMENT \/\/[^\n]*
commentbegin "/*"
commentelement .|\n
commentend "*/"
%x BLOCKCOMMENT

%%
{LINECOMMENT} { }

{commentbegin} {BEGIN BLOCKCOMMENT; }
<BLOCKCOMMENT>{commentelement} {}
<BLOCKCOMMENT>{commentend} {BEGIN INITIAL; }

"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    if(dump_tokens)
        DEBUG_FOR_LAB4("INT\tint");
    return INT;
}
"const int" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONST\tconst");
    return CONST;
}
"void" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("VOID\tvoid");
    return VOID;
}
"if" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("IF\tif");
    return IF;
}
"else" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ELSE\telse");
    return ELSE;
}
"return" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RETURN\treturn");
    return RETURN;
}
"continue" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONTINUE\tcontinue");
    return CONTINUE;
}
"while" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("WHILE\twhile");
    return WHILE;
}
"break" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("BREAK\tbreak");
    return BREAK;
}
"=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGN\t=");
    return ASSIGN;
}
"<" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LESS\t<");
    return LESS;
}
">" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MORE\t>");
    return MORE;
}
"<=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LESSEQ\t<=");
    return LESSEQ;
}
">=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MOREEQ\t>=");
    return MOREEQ;
}
"==" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("EQUAL\t==");
    return EQUAL;
}
"!=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("UNEQUAL\t!=");
    return UNEQUAL;
}
"&&" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("AND\t&&");
    return AND;
}
"||" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("OR\t||");
    return OR;
}
"!" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("NON\t!");
    return NON;
}
"+" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ADD\t+");
    return ADD;
}
"-" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SUB\t-");
    return SUB;
}
"*" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MUL\t*");
    return MUL;
}
"/" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("DIV\t/");
    return DIV;
}
"%" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("DELIVERY\t%");
    return DELIVERY;
}
"++" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("INPLUS\t++");
    return INPLUS;
}
"--" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("INMINUS\t--");
    return INMINUS;
}
"+=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGNPLUS\t+=");
    return ASSIGNPLUS;
}
"-=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGNMINUS\t-=");
    return ASSIGNMINUS;
}
"*=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGNMUL\t*=");
    return ASSIGNMUL;
}
"/=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGNDIV\t/=");
    return ASSIGNDIV;
}
"," {
    if(dump_tokens)
        DEBUG_FOR_LAB4("COMMA\t,");
    return COMMA;
}
"[" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LB\t[");
    return LB;
}
"]" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RB\t]");
    return RB;
}
";" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SEMICOLON\t;");
    return SEMICOLON;
}
"(" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LPAREN\t(");
    return LPAREN;
}
")" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RPAREN\t)");
    return RPAREN;
}
"{" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LBRACE\t{");
    return LBRACE;
}
"}" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RBRACE\t}");
    return RBRACE;
}

{DECIMIAL} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    yylval.itype = atoi(yytext);
    return INTEGER;
}

{OCTONARY} {     
    char res[32]="\0";
    char s[32];
    int x=strtol(yytext, NULL, 8);
    sprintf(s, "%d", x);
    strcat(res,s);
    if(dump_tokens)
        DEBUG_FOR_LAB4(res);
    yylval.itype = atoi(res);
    return INTEGER;
}

{HEXADECIMAL} {
    char res[32]="\0";
    char s[32];
    int x=strtol(yytext, NULL, 16);
    sprintf(s, "%d", x);
    strcat(res,s);
    if(dump_tokens)
        DEBUG_FOR_LAB4(res);
    yylval.itype = atoi(res);
    return INTEGER;
}

{ID} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    return ID;
}
{EOL} yylineno++;
{WHITE}
%%
