module lang::hql::prettyprint::Expressions

import lang::hql::ast::HQL;
import List;

extend lang::functionLang::prettyprinter::Function;



public str toString(Expr::inPredicate(Expr exp, list[Not] not, ArrayLiteral arrLtrl)) = "(<toString(exp)> <prettyOptional(not, prettyNot)> IN <toString(arrLtrl)>)";
public str toString(
  ArrayLiteral::array(list[Expr] exprs
)) = "(<intercalate(",", [ toString(exp) | exp <- exprs])>)";