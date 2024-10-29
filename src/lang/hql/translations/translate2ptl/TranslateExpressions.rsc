module lang::hql::translations::translate2ptl::TranslateExpressions
import Type;
import List;
extend lang::hql::ast::HQL;
extend lang::ptl::ast::PTL;
extend lang::functionLang::translations::Functions;


public lang::ptl::ast::Expressions::Expr toPTL(Expr expr) {
  switch(expr) {
    case inPredicate(Expr exp, list[Not] not, ArrayLiteral arrayLiteral): {
            if (isEmpty(not)) return lang::ptl::ast::Expressions::\in(toPTL(exp), toPTL(arrayLiteral));
            else return lang::ptl::ast::Expressions::notIn(toPTL(exp), toPTL(arrayLiteral));
    }
    case function(Function func,list[AnalyticFunctionClause] analyticOpt): return toPTL(func);
    case \true: return boolean("true");
    case \false: return boolean("false");
    // TODO: no translation for simple case and interval
    default: throw  TranslationException(" message:Unresolved expression",typeCast(#node,expr).src);
  }
}

lang::ptl::ast::Expressions::Separator toPTL(Separator::separator(Expr exp)) = lang::ptl::ast::Expressions::separator(toPTL(exp));

public lang::ptl::ast::Expressions::Expr toPTL(ArrayLiteral::array(list[Expr] exps)) {
          return \list([ toPTL(exp) | exp <- exps ]);
}
public Expr toPTL(countStar(list[AggParam] dists)) =countStar();


