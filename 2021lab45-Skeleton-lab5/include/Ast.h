#ifndef __AST_H__
#define __AST_H__

#include <fstream>
#include <map>
#include <vector>
#include <Type.h>

class SymbolEntry;

class Node
{
private:
    static int counter;
    int seq;
public:
    Node();
    int getSeq() const {return seq;};
    virtual void output(int level) = 0;
};

class ExprNode : public Node
{
protected:
    SymbolEntry *symbolEntry;
public:
    ExprNode(SymbolEntry *symbolEntry) : symbolEntry(symbolEntry){};
};

//两个操作数的表达式
class BinaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1, *expr2;
public:
    enum {ADD, SUB, MUL, DIV, OR, AND, LESS, MORE, LESSEQ, MOREEQ, EQUAL, UNEQUAL, DELIVERY};
    BinaryExpr(SymbolEntry *se, int op, ExprNode*expr1, ExprNode*expr2) : ExprNode(se), op(op), expr1(expr1), expr2(expr2){};
    void output(int level);
};

//一个操作数的表达式
class SingleExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr;
public:
    enum {UMNUS, POSITIVE, NON, INPLUS, INMINUS};
    SingleExpr(SymbolEntry *se, int op, ExprNode *expr) : ExprNode(se), op(op), expr(expr){};
    void output(int level);
};

class Id : public ExprNode
{
public:
    int value;
    Id(SymbolEntry *se) : ExprNode(se){};
    Id(SymbolEntry *se, int value) : ExprNode(se), value(value){}
    void output(int level);
};

//函数参数类
class ParameterList : public Node
{
public:
    std::vector<Id*> paraList;
    std::vector<std::string> paraNameList;
    std::vector<ExprNode*> paraExpr;
    std::vector<bool> haveVal;
    std::vector<Type*> paramsType;
    ParameterList(std::vector<std::string> paraNameList, std::vector<bool> haveVal, std::vector<Type*> paramsType) : paraNameList(paraNameList), haveVal(haveVal), paramsType(paramsType){}
    ParameterList(std::vector<ExprNode*> paraExpr) : paraExpr(paraExpr) {}
    void output(int level);
};

class FunctionExpr : public ExprNode
{
private:
    ParameterList *paraList;
    bool havaPara;
public:
    FunctionExpr(SymbolEntry *se, ParameterList *paraList) : ExprNode(se), paraList(paraList){havaPara = true;}
    FunctionExpr(SymbolEntry *se) : ExprNode(se){havaPara = false;}
    void output(int level);
};

class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

//添加的Idlist类
class IDlist : public Node
{
public:
    //存放idname列表的结构
    std::map<std::string, ExprNode*> idNamelist;
    std::map<Id*, ExprNode*> idlist;
    
    IDlist(std::map<std::string, ExprNode*> idNamelist) : idNamelist(idNamelist){};
    void output(int level);

};

class StmtNode : public Node
{};

class CompoundStmt : public StmtNode
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt) : stmt(stmt) {};
    void output(int level);
};

class SeqNode : public StmtNode
{
private:
    StmtNode *stmt1, *stmt2;
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
};

class DeclStmt : public StmtNode
{
private:
    IDlist* idlist;
public:
    DeclStmt(IDlist *idlist) : idlist(idlist){};
    void output(int level);
};

class IfStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){};
    void output(int level);
};

class IfElseStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *thenStmt;
    StmtNode *elseStmt;
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {};
    void output(int level);
};

class EmptyStmt : public StmtNode
{
public:
    EmptyStmt(){};
    void output(int level);
};

class ExprStmt : public StmtNode
{
private:
    ExprNode* expr;
public:
    ExprStmt(ExprNode *expr) : expr(expr) {}
    void output(int level);
};

//添加的While节点
class WhileStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *whileStmt;
public:
    WhileStmt(ExprNode *cond, StmtNode *whileStmt) : cond(cond), whileStmt(whileStmt) {};
    void output(int level);
};

class EmptyBlock : public StmtNode
{
public:
    EmptyBlock(){};
    void output(int level);
};

class ContinueStmt : public StmtNode
{
private:
public:
    ContinueStmt(){};
    void output(int level);
};

class BreakStmt : public StmtNode
{
public:
    BreakStmt(){};
    void output(int level);
};

class ReturnStmt : public StmtNode
{
private:
    ExprNode *retValue;
public:
    ReturnStmt(ExprNode*retValue) : retValue(retValue) {};
    void output(int level);
};

class AssignStmt : public StmtNode
{
private:
    ExprNode *lval;
    ExprNode *expr;
public:
    AssignStmt(ExprNode *lval, ExprNode *expr) : lval(lval), expr(expr) {};
    void output(int level);
};

class FunctionDef : public StmtNode
{
private:
    SymbolEntry *se;
    StmtNode *stmt;
    ParameterList *paramsList;
    bool havePara;
public:
    FunctionDef(SymbolEntry *se, StmtNode *stmt) : se(se), stmt(stmt){havePara = false;};
    FunctionDef(SymbolEntry *se, StmtNode *stmt, ParameterList *paramsList) : se(se), stmt(stmt), paramsList(paramsList){havePara = true;};
    void output(int level);
};

class Ast
{
private:
    Node* root;
public:
    Ast() {root = nullptr;}
    void setRoot(Node*n) {root = n;}
    void output();
};

#endif
