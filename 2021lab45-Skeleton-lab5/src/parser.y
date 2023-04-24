%code top{
    #include <iostream>
    #include <assert.h>
    #include "parser.h"
    extern Ast ast;
    int yylex();
    int yyerror( char const * );
}

%code requires {
    #include "Ast.h"
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {
    int itype;
    char* strtype;
    StmtNode* stmttype;
    ExprNode* exprtype;
    IDlist* idlisttype;
    ParameterList* Parameterlisttype;

    Type* type;
}

%start Program
%token <strtype> ID
%token <itype> INTEGER
%token IF ELSE
%token LINECOMMENT
%token WHILE CONTINUE BREAK
%token INT VOID CONST
%token LPAREN RPAREN LB RB LBRACE RBRACE SEMICOLON COMMA
%token ADD SUB MUL DIV OR AND LESS MORE LESSEQ MOREEQ EQUAL UNEQUAL DELIVERY ASSIGNPLUS ASSIGNMINUS ASSIGNMUL ASSIGNDIV ASSIGN
%token UMNUS POSITIVE NON INPLUS INMINUS
%token RETURN

%nterm <stmttype> Stmts Stmt AssignStmt ExprStmt BlockStmt IfStmt BreakStmt WhileStmt ContinueStmt ReturnStmt DeclStmt FuncDef
%nterm <exprtype> Exp AddExp MulExp SlgExp Cond LOrExp PrimaryExp LVal RelExp LAndExp
%nterm <idlisttype> IDlist
%nterm <Parameterlisttype> Parameters CParameters
%nterm <type> Type

%precedence THEN
%precedence ELSE
%%
Program
    : Stmts {
        ast.setRoot($1);
    }
    ;
Stmts
    : Stmt {$$=$1;}
    | Stmts Stmt{
        $$ = new SeqNode($1, $2);
    }
    ;
Stmt
    : AssignStmt {$$=$1;}
    | BlockStmt {$$=$1;}
    | IfStmt {$$=$1;}
    | ReturnStmt {$$=$1;}
    | ExprStmt {$$=$1;}
    | DeclStmt {$$=$1;}
    | WhileStmt {$$=$1;}
    | ContinueStmt {$$=$1;}
    | BreakStmt {$$=$1;}
    | FuncDef {$$=$1;}
    | SEMICOLON {$$ = new EmptyStmt();}
    ;
AssignStmt
    :
    LVal ASSIGN Exp SEMICOLON {
        $$ = new AssignStmt($1, $3);
    }
    ;
ExprStmt
    :
    Exp SEMICOLON {
        $$ = new ExprStmt($1);
    }
BlockStmt
    :   
    LBRACE 
    {identifiers = new SymbolTable(identifiers);} 
    Stmts RBRACE 
    {
        $$ = new CompoundStmt($3);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
    }
    |
    LBRACE {
        identifiers = new SymbolTable(identifiers);
    } 
    RBRACE {
        $$ = new EmptyBlock();
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
    }
    ;
IfStmt
    : IF LPAREN Cond RPAREN Stmt %prec THEN {
        $$ = new IfStmt($3, $5);
    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);
    }
    ;
WhileStmt
    : WHILE LPAREN Cond RPAREN Stmt {
        $$ = new WhileStmt($3, $5);
    }
    ;
ContinueStmt
    :
    CONTINUE SEMICOLON {
        $$ = new ContinueStmt();
    }
    ;
BreakStmt
    :
    BREAK SEMICOLON {
        $$ = new BreakStmt();
    }
    ;
ReturnStmt
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
    ;
Exp
    :
    AddExp {$$ = $1;}
    ;
Cond
    :
    LOrExp {$$ = $1;}
    ;
LVal
    : 
    ID {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new Id(se);
        delete []$1;
    }
    ;
PrimaryExp
    :
    LPAREN Exp RPAREN {
        $$ = $2;
    }
    |
    LVal {
        $$ = $1;
    }
    | INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);
        $$ = new Constant(se);
    }
    |
    ID LPAREN CParameters RPAREN {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        $$ = new FunctionExpr(se, $3);
    }
    |
    ID LPAREN RPAREN {
        SymbolEntry *se;
        se = identifiers->lookup($1);
        $$ = new FunctionExpr(se);
    }
    ;
SlgExp
    :
    PrimaryExp {$$ = $1;}
    |
    SUB SlgExp %prec UMNUS
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::UMNUS, $2);
    }
    |
    ADD SlgExp %prec POSITIVE
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::POSITIVE, $2);
    }
    |
    NON SlgExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::NON, $2);
    }
    |
    INPLUS SlgExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::INPLUS, $2);
    }
    |
    INMINUS SlgExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SingleExpr(se, SingleExpr::INMINUS, $2);
    }
    ;
MulExp
    :
    SlgExp {$$ = $1;}
    |
    MulExp MUL SlgExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
    }
    |
    MulExp DIV SlgExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
    }
    |
    MulExp DELIVERY SlgExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::DELIVERY, $1, $3);
    }
    ;
AddExp
    :
    MulExp {$$ = $1;}
    |
    AddExp ADD MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
    }
    |
    AddExp SUB MulExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
    }
    ;
RelExp
    :
    AddExp {$$ = $1;}
    |
    RelExp LESS AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    |
    RelExp MORE AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MORE, $1, $3);
    }
    |
    RelExp LESSEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESSEQ, $1, $3);
    }
    |
    RelExp MOREEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MOREEQ, $1, $3);
    }
    |
    RelExp EQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQUAL, $1, $3);
    }
    |
    RelExp UNEQUAL AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::UNEQUAL, $1, $3);
    }
    ;
LAndExp
    :
    RelExp {$$ = $1;}
    |
    LAndExp AND RelExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;
LOrExp
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;
Type
    : INT {
        $$ = TypeSystem::intType;
    }
    | VOID {
        $$ = TypeSystem::voidType;
    }
    | CONST {
        $$ = TypeSystem::constType;
    }
    ;
IDlist
    :
    IDlist COMMA ID ASSIGN Exp {
        IDlist* idlist = $1;
        idlist->idNamelist[$3] = $5;
        $$ = new IDlist(idlist->idNamelist);
        delete []$3;
    }
    |
    IDlist COMMA ID {
        IDlist* idlist = $1;
        idlist->idNamelist[$3] = nullptr;
        $$ = new IDlist(idlist->idNamelist);
        delete []$3;
    }
    |
    ID ASSIGN Exp {
        std::map<std::string, ExprNode*> idlist;
        idlist[$1] = $3;
        $$ = new IDlist(idlist);
        delete []$1;
    }
    |
    ID {
        std::map<std::string, ExprNode*> idlist;
        idlist[$1] = nullptr;
        $$ = new IDlist(idlist);
        delete []$1;
    }
    ;
DeclStmt
    :
    Type IDlist SEMICOLON {
        IDlist *idl = $2;
        std::map<std::string, ExprNode*>::iterator it;
        for(it = idl->idNamelist.begin();it != idl->idNamelist.end(); it++)
        {
            SymbolEntry *se;
            se = new IdentifierSymbolEntry($1, it->first, identifiers->getLevel());
            Id *id = new Id(se);
            identifiers->install(it->first, se);
            if(it->second)
            {
                idl->idlist[id] = it->second;
            }
            else
            {
                idl->idlist[id] = nullptr;
            }
        }
        $$ = new DeclStmt($2);
    }
    ;
Parameters
    :
    Parameters COMMA Type ID ASSIGN INTEGER {
        ParameterList* paralist = $1;
        
        paralist->paraNameList.push_back($4);
        paralist->haveVal.push_back(true);
        paralist->paramsType.push_back($3);
        $$ = new ParameterList(paralist->paraNameList, paralist->haveVal, paralist->paramsType);
    }
    |
    Parameters COMMA Type ID {
        ParameterList* paralist = $1;
        
        paralist->paraNameList.push_back($4);
        paralist->haveVal.push_back(false);
        paralist->paramsType.push_back($3);
        $$ = new ParameterList(paralist->paraNameList, paralist->haveVal, paralist->paramsType);
    }
    |
    Type ID ASSIGN INTEGER {
        std::vector<std::string> paralist;
        std::vector<bool> haveVal;
        std::vector<Type*> paramsType;
        
        paralist.push_back($2);
        haveVal.push_back(true);
        paramsType.push_back($1);
        $$ = new ParameterList(paralist, haveVal, paramsType);
        delete []$2;
    }
    |
    Type ID {
        std::vector<std::string> paralist;
        std::vector<bool> haveVal;
        std::vector<Type*> paramsType;
        
        paralist.push_back($2);
        haveVal.push_back(false);
        paramsType.push_back($1);
        $$ = new ParameterList(paralist, haveVal, paramsType);
        delete []$2;
    }
    ;
CParameters
    :
    CParameters COMMA Exp {
        ParameterList* cparalist = $1;
        cparalist->paraExpr.push_back($3);
        $$ = new ParameterList(cparalist->paraExpr);       
    }
    |
    Exp {
        std::vector<ExprNode*> cparalist;
        cparalist.push_back($1);
        $$ = new ParameterList(cparalist);        
    }
    ;
FuncDef
    :
    Type ID LPAREN {
        Type *funcType;
        funcType = new FunctionType($1,{});
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);
    }
    RPAREN Stmt
    {
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, $6);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    |
    Type ID LPAREN Parameters 
    {
        ParameterList *paralist = $4;
        Type *funcType;
        funcType = new FunctionType($1, paralist->paramsType);
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());
        identifiers->install($2, se);
        identifiers = new SymbolTable(identifiers);
        for(unsigned int i = 0;i < paralist->paraNameList.size();i++)
        {
            SymbolEntry *se;
            se = new IdentifierSymbolEntry(paralist->paramsType[i], paralist->paraNameList[i], identifiers->getLevel());
            Id *id = new Id(se);
            identifiers->install(paralist->paraNameList[i], se);
            paralist->paraList.push_back(id);
        }
    }
    RPAREN Stmt
    {    
        SymbolEntry *se;
        se = identifiers->lookup($2);
        assert(se != nullptr);
        $$ = new FunctionDef(se, $7, $4);
        SymbolTable *top = identifiers;
        identifiers = identifiers->getPrev();
        delete top;
        delete []$2;
    }
    ;
%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}
