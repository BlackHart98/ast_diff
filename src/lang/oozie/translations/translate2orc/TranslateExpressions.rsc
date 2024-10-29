module lang::oozie::translations::translate2orc::TranslateExpressions

import lang::orc::ast::Expressions;
import lang::oozie::ast::Expressions;
import lang::oozie::grammar::Oozie;
import List;


public list[lang::orc::ast::Expressions::Expr] toOrc(oozieExpr(OozieProg expression)){
    return toOrc(expression);
}

public list[lang::orc::ast::Expressions::Expr] toOrc(ooziExps(list[OozieExpr] oexps)){
    list[lang::orc::ast::Expressions::Expr] exp_result = [toOrc(e)|e<-oexps];
    return exp_result;
}

public lang::orc::ast::Expressions::Expr toOrc(OozieExpr oexp){
    switch(oexp){
        case immediateEval(Expr exp):{
            return toOrc(exp);
        }
        case deferredEval(Expr exp):{
            return toOrc(exp);
        }
        default: throw "<oexp> not found";
    }
}

public lang::orc::ast::Expressions::Expr toOrc(Expr expr){
    switch(expr){
        case variable(list[str] ids):{
            str id = intercalate(".",[i|i<-ids]);
            return identifier(id);
        }
        case not(Expr exp):{
            return not(toOrc(exp));
        }
        case logicalNot(Expr exp):{
            return not(toOrc(exp));
        }
        case mul(Expr lhs, Expr rhs):{
            return mul(toOrc(lhs), toOrc(rhs));
        }
        case div(Expr lhs, Expr rhs):{
            return div(toOrc(lhs), toOrc(rhs));
        }
        case division(Expr lhs, Expr rhs):{
            return div(toOrc(lhs), toOrc(rhs));
        }
        case add(Expr lhs, Expr rhs):{
            return add(toOrc(lhs), toOrc(rhs));
        }
        case sub(Expr lhs, Expr rhs):{
            return sub(toOrc(lhs), toOrc(rhs));
        }
        case lt(Expr lhs, Expr rhs):{
            return lt(toOrc(lhs), toOrc(rhs));
        }
        case gt(Expr lhs, Expr rhs):{
            return gt(toOrc(lhs), toOrc(rhs));
        }
        case lte(Expr lhs, Expr rhs):{
            return lte(toOrc(lhs), toOrc(rhs));
        }
        case gte(Expr lhs, Expr rhs):{
            return gte(toOrc(lhs), toOrc(rhs));
        }
        case lessThan(Expr lhs, Expr rhs):{
            return lt(toOrc(lhs), toOrc(rhs));
        }
        case greaterThan(Expr lhs, Expr rhs):{
            return gt(toOrc(lhs), toOrc(rhs));
        }
        case lessThanOrEqual(Expr lhs, Expr rhs):{
            return lte(toOrc(lhs), toOrc(rhs));
        }
        case greaterThanOrEqual(Expr lhs, Expr rhs):{
            return gte(toOrc(lhs), toOrc(rhs));
        }
        case twoEqual(Expr lhs, Expr rhs):{
            return twoEqual(toOrc(lhs), toOrc(rhs));
        }
        case neq1(Expr lhs, Expr rhs):{
            return neq1(toOrc(lhs), toOrc(rhs));
        }
        case equality(Expr lhs, Expr rhs):{
            return eq(toOrc(lhs), toOrc(rhs));
        }
        case inequality(Expr lhs, Expr rhs):{
            return neq1(toOrc(lhs), toOrc(rhs));
        }
        case and(Expr lhs, Expr rhs):{
            return and(toOrc(lhs), toOrc(rhs));
        }
        case logicalAnd(Expr lhs, Expr rhs):{
            return and(toOrc(lhs), toOrc(rhs));
        }
        case cct(Expr lhs, Expr rhs):{
            return cct(toOrc(lhs), toOrc(rhs));
        }
        case logicalOr(Expr lhs, Expr rhs):{
            return or(toOrc(lhs), toOrc(rhs));
        }
        default: throw "case for this <expr> not found";
    }
}