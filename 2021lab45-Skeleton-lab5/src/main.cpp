#include <iostream>
#include <string.h>
#include <Type.h>
#include <SymbolTable.h>
#include <unistd.h>
#include "Ast.h"
using namespace std;

Ast ast;
extern FILE *yyin;
extern FILE *yyout;

int yyparse();

char outfile[256] = "a.out";
bool dump_tokens;
bool dump_ast;

int main(int argc, char *argv[])
{
    int opt;
    while ((opt = getopt(argc, argv, "ato:")) != -1)
    {
        switch (opt)
        {
        case 'o':
            strcpy(outfile, optarg);
            break;
        case 'a':
            dump_ast = true;
            break;
        case 't':
            dump_tokens = true;
            break;
        default:
            fprintf(stderr, "Usage: %s [-o outfile] infile\n", argv[0]);
            exit(EXIT_FAILURE);
            break;
        }
    }
    if (optind >= argc)
    {
        fprintf(stderr, "no input file\n");
        exit(EXIT_FAILURE);
    }
    if (!(yyin = fopen(argv[optind], "r")))
    {
        fprintf(stderr, "%s: No such file or directory\nno input file\n", argv[optind]);
        exit(EXIT_FAILURE);
    }
    if (!(yyout = fopen(outfile, "w")))
    {
        fprintf(stderr, "%s: fail to open output file\n", outfile);
        exit(EXIT_FAILURE);
    }

    Type *funcType;
    funcType = new FunctionType(TypeSystem::intType, {});
    SymbolEntry *se = new IdentifierSymbolEntry(funcType, "getint", identifiers->getLevel());
    identifiers->install("getint", se);
        
    Type *funcType1;
    funcType1 = new FunctionType(TypeSystem::voidType, {});
    SymbolEntry *se1 = new IdentifierSymbolEntry(funcType1, "putint", identifiers->getLevel());
    identifiers->install("putint", se1);

    Type *funcType2;
    funcType2 = new FunctionType(TypeSystem::voidType, {});
    SymbolEntry *se2 = new IdentifierSymbolEntry(funcType2, "putint", identifiers->getLevel());
    identifiers->install("putch", se2);

    yyparse();

    if(dump_ast)
        ast.output();
    return 0;
}
