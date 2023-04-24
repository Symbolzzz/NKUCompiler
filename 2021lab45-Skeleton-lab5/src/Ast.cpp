#include "Ast.h"
#include "SymbolTable.h"
#include <string>
#include <vector>
#include "Type.h"

extern FILE *yyout;
int Node::counter = 0;

Node::Node()
{
    seq = counter++;
}

void BinaryExpr::output(int level)
{
    std::string op_str;
    switch(op)
    {
        case ADD:
            op_str = "add";
            break;
        case SUB:
            op_str = "sub";
            break;
        case MUL:
            op_str = "mul";
            break;
        case DIV:
            op_str = "div";
            break;
        case AND:
            op_str = "and";
            break;
        case OR:
            op_str = "or";
            break;
        case LESS:
            op_str = "less";
            break;
        case MORE:
            op_str = "more";
            break;
        case LESSEQ:
            op_str = "lesseq";
            break;
        case MOREEQ:
            op_str = "moreeq";
            break;
        case EQUAL:
            op_str = "equal";
            break;
        case UNEQUAL:
            op_str = "unequal";
            break;
        case DELIVERY:
            op_str = "delivery";
            break;
    }
    fprintf(yyout, "%*cBinaryExpr\top: %s\n", level, ' ', op_str.c_str());
    expr1->output(level + 4);
    expr2->output(level + 4);
}

void Ast::output()
{
    fprintf(yyout, "program\n");
    if(root != nullptr)
        root->output(4);
}

void SingleExpr::output(int level)
{
    std::string op_str;
    switch (op)
    {
    case UMNUS:
        op_str = "umnus";
        break;
    case POSITIVE:
        op_str = "positive";
    case NON:
        op_str = "non";
        break;
    case INPLUS:
        op_str = "inplus";
        break;
    case INMINUS:
        op_str = "inminus";
        break;
    }
    fprintf(yyout, "%*cSingleExpr\top:%s\n", level, ' ', op_str.c_str());
    expr->output(level + 4);
}

void Constant::output(int level)
{
    std::string type, value;
    type = symbolEntry->getType()->toStr();
    value = symbolEntry->toStr();
    fprintf(yyout, "%*cIntegerLiteral\tvalue: %s\ttype: %s\n", level, ' ',
            value.c_str(), type.c_str());
}

void Id::output(int level)
{
    std::string name, type;
    int scope;
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getScope();
    fprintf(yyout, "%*cId\tname: %s\tscope: %d\ttype: %s\n", level, ' ',
            name.c_str(), scope, type.c_str());
}

void IDlist::output(int level)
{
    std::map<Id*, ExprNode*>::iterator it;
    for(it = idlist.begin();it != idlist.end();it++)
    {
        //如果含有表达式
        if(it->second)
        {
            it->first->output(level);
            it->second->output(level);
        }
        else
        {
            it->first->output(level);
        }
    }
}

void FunctionExpr::output(int level)
{
    fprintf(yyout, "%*cFunctionExpr:\n", level, ' ');
    std::string name, type;
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    fprintf(yyout, "%*cFunctionCall function name: %s, type: %s\n", level + 4, ' ',
            name.c_str(),type.c_str());
    if(havaPara)
    {
        fprintf(yyout, "%*cParameterList:\n", level + 8, ' ');
        for(unsigned int i = 0;i < paraList->paraExpr.size();i++)
        {
            paraList->paraExpr[i]->output(level + 12);
        }
    }
}

void ParameterList::output(int level)
{
    fprintf(yyout, "%*cParameterList:\n", level, ' ');
    for(unsigned int i = 0;i < paraList.size();i++)
    {
        paraList[i]->output(level + 4);
        //如果有值
        if(haveVal[i] == true)
        {
            fprintf(yyout, "%*cvalue: %d\n", level + 4, ' ', paraList[i]->value);
        }
    }
}

void CompoundStmt::output(int level)
{
    fprintf(yyout, "%*cCompoundStmt\n", level, ' ');
    stmt->output(level + 4);
}

void SeqNode::output(int level)
{
    fprintf(yyout, "%*cSequence\n", level, ' ');
    stmt1->output(level + 4);
    stmt2->output(level + 4);
}

void DeclStmt::output(int level)
{
    fprintf(yyout, "%*cDeclStmt\n", level, ' ');
    idlist->output(level + 4);
}

void IfStmt::output(int level)
{
    fprintf(yyout, "%*cIfStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
}

void EmptyStmt::output(int level)
{
    fprintf(yyout, "%*cEmptyStmt\n", level, ' ');
}

void IfElseStmt::output(int level)
{
    fprintf(yyout, "%*cIfElseStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
    elseStmt->output(level + 4);
}

void WhileStmt::output(int level)
{
    fprintf(yyout, "%*cWhileStmt\n", level, ' ');
    cond->output(level + 4);
    whileStmt->output(level + 4);
}

void ExprStmt::output(int level)
{
    fprintf(yyout, "%*cExprStmt\n", level, ' ');
    expr->output(level + 4);
}

void ContinueStmt::output(int level)
{
    fprintf(yyout, "%*cContinueStmt\n", level, ' ');
}

void EmptyBlock::output(int level)
{
    fprintf(yyout, "%*cEmptyBlock\n", level, ' ');
}

void BreakStmt::output(int level)
{
    fprintf(yyout, "%*cBreakStmt\n", level, ' ');
}

void ReturnStmt::output(int level)
{
    fprintf(yyout, "%*cReturnStmt\n", level, ' ');
    retValue->output(level + 4);
}

void AssignStmt::output(int level)
{
    fprintf(yyout, "%*cAssignStmt\n", level, ' ');
    lval->output(level + 4);
    expr->output(level + 4);
}

void FunctionDef::output(int level)
{
    std::string name, type;
    name = se->toStr();
    type = se->getType()->toStr();
    fprintf(yyout, "%*cFunctionDefine function name: %s, type: %s\n", level, ' ', 
            name.c_str(), type.c_str());
    if(havePara)
    {
        paramsList->output(level + 4);
    }
    stmt->output(level + 4);
}
