%option noyywrap
%{
    /*
    * You will need to comment this line in lab5.
    */
    #define ONLY_FOR_LEX
    
    #ifdef ONLY_FOR_LEX

    #else
    #define YYSTYPE void *
    #include "parser.h"
    #endif

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #include <string>

    #ifdef ONLY_FOR_LEX
    #include <ostream>
    #include <fstream>
    using namespace std;
    extern FILE *yyin; 
    extern FILE *yyout;

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }
    #endif
%}

DECIMIAL ([1-9][0-9]*|0)
OCTONARY (0[1-7][0-7]*|0)
HEXADECIMAL (0x[1-9a-fA-F][0-9a-fA-F]*|0X[1-9a-fA-F][0-9a-fA-F]*|0X0|0x0)
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t]
LINECOMMENT \/\/[^\n]*
commentbegin "/*"
commentelement .|\n
commentend "*/"
%x BLOCKCOMMENT

%%
{LINECOMMENT} {}//去掉注释

{commentbegin} {BEGIN BLOCKCOMMENT; }
<BLOCKCOMMENT>{commentelement} {}
<BLOCKCOMMENT>{commentend} {BEGIN INITIAL; }

"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("INT\tint\t"+to_string(yylineno));
    #else
        return INT;
    #endif
}
"void" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("VOID\tvoid\t"+to_string(yylineno));
    #else
        return VOID;
    #endif 
}
"char" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CHAR\tchar\t"+to_string(yylineno));
    #else
        return CHAR;
    #endif 
}
"const" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONST\tconst\t"+to_string(yylineno));
    #else
        return CONST;
    #endif 
}
"if" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("IF\tif\t"+to_string(yylineno));
    #else
        return IF;
    #endif
};
"else" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ELSE\telse\t"+to_string(yylineno));
    #else
        return ELSE;
    #endif
};
"for" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("FOR\tfor\t"+to_string(yylineno));
    #else
        return FOR;
    #endif
}
"return" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RETURN\treturn\t"+to_string(yylineno));
    #else
        return RETURN;
    #endif
}
"break" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("BREAK\tbreak\t"+to_string(yylineno));
    #else
        return BREAK;
    #endif
}
"continue" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONTINUE\tcontinue\t"+to_string(yylineno));
    #else
        return CONTINUE;
    #endif
}
"while" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("WHILE\twhile\t"+to_string(yylineno));
    #else
        return WHILE;
    #endif
}
"scanf" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SCANF\tscanf\t"+to_string(yylineno));
    #else
        return SCANF;
    #endif
}
"printf" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("PRINTF\tprintf\t"+to_string(yylineno));
    #else
        return PRINTF;
    #endif
}
"=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ASSIGN\t=\t"+to_string(yylineno));
    #else
        return ASSIGN;
    #endif
}
"<" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LESS\t<\t"+to_string(yylineno));
    #else
        return LESS;
    #endif
}
">" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MORE\t>\t"+to_string(yylineno));
    #else
        return MORE;
    #endif
}
">=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MOREEQ\t>=\t"+to_string(yylineno));
    #else
        return MOREEQ;
    #endif
}
"<=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LESSEQ\t<=\t"+to_string(yylineno));
    #else
        return LESSEQ;
    #endif
}
"==" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("EQUAL\t==\t"+to_string(yylineno));
    #else
        return EQUAL;
    #endif
}
"!=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("UNEQUAL\t!=\t"+to_string(yylineno));
    #else
        return UNEQUAL;
    #endif
}
"&&" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("AND\t&&\t"+to_string(yylineno));
    #else
        return AND;
    #endif
}
"||" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("OR\t||\t"+to_string(yylineno));
    #else
        return OR;
    #endif
}
"!" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("NON\t!\t"+to_string(yylineno));
    #else
        return NON;
    #endif
}
"%" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DELIVERY\t%\t"+to_string(yylineno));
    #else
        return DELIVERY;
    #endif
}
"+" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ADD\t+\t"+to_string(yylineno));
    #else
        return ADD;
    #endif
}
"-" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SUB\t-\t"+to_string(yylineno));
    #else
        return SUB;
    #endif
}
"*" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MUL\t*\t"+to_string(yylineno));
    #else
        return MUL;
    #endif
}
"/" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DIV\t/\t"+to_string(yylineno));
    #else
        return DIV;
    #endif
}
"[" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LB\t[\t"+to_string(yylineno));
    #else
        return LB;
    #endif
}
"]" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RB\t]\t"+to_string(yylineno));
    #else
        return RB;
    #endif
}
";" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SEMICOLON\t;\t"+to_string(yylineno));
    #else
        return SEMICOLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LPAREN\t(\t"+to_string(yylineno));
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RPAREN\t)\t"+to_string(yylineno));
    #else
    return RPAREN;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LBRACE\t{\t"+to_string(yylineno));
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RBRACE\t}\t"+to_string(yylineno));
    #else
        return RBRACE;
    #endif
}

{EOL} {yylineno++;}
{WHITE} {}
{DECIMIAL} {
    #ifdef ONLY_FOR_LEX
        string t=string(yytext);
        string s="NUMBER\t"+t+"\t"+to_string(yylineno);
        DEBUG_FOR_LAB4(s);
    #else
        return DECIMIAL;
    #endif
}
{OCTONARY} {//八进制
    #ifdef ONLY_FOR_LEX
        
        string s="OCTONARY\t"+to_string(strtol(yytext,NULL,0))+"\t"+to_string(yylineno);
        DEBUG_FOR_LAB4(s);
    #else
        return OCTONARY;
    #endif
}
{HEXADECIMAL} {//16进制
    #ifdef ONLY_FOR_LEX
    
        string s="HEXADECIMAL\t"+to_string(strtol(yytext,NULL,0))+"\t"+to_string(yylineno);
        DEBUG_FOR_LAB4(s);
    #else
        return HEXADECIMAL;
    #endif
}
{ID} {
    #ifdef ONLY_FOR_LEX
        string t=string(yytext);
        string s="ID\t"+t+"\t"+to_string(yylineno);
        DEBUG_FOR_LAB4(s);
    #else
        return ID;
    #endif
}
%%

#ifdef ONLY_FOR_LEX
int main(int argc, char **argv){
    if(argc != 5){
        fprintf(stderr, "Argument Not Enough");
        exit(EXIT_FAILURE);
    }

    if(!(yyin = fopen(argv[1], "r"))){
        fprintf(stderr, "No such file or directory: %s", argv[1]);
        exit(EXIT_FAILURE);
    }

    if(!(yyout = fopen(argv[3], "w"))){
        fprintf(stderr, "No such file or directory: %s", argv[3]);
        exit(EXIT_FAILURE);
    }
    string s="token\tlexeme\tlineno\n";
    fputs(s.c_str(), yyout);

    yylex();
    return 0;
}
#endif
