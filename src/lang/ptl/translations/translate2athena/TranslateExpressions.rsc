module lang::ptl::translations::translate2athena::TranslateExpressions

extend lang::ptl::translations::translate2Base::Declaration;
import lang::ptl::Utils;
extend lang::athena::ast::Athena;
import List;
import Type;


public Expr toSQL(notIn(Expr lhs, Expr rhs))= inPredicate(toSQL(lhs),[not()],toSQL(rhs));
public Expr toSQL(\in(Expr lhs, Expr rhs))= inPredicate(toSQL(lhs),[],toSQL(rhs));


public ArrayLiteral toSQL(\list(list[Expr] el)){
   exps= [toSQL(e)|e<-el];
   return array(exps);
}

public lang::basesql::ast::BaseSQL::Expr toSQL(adt:functioncall(str name, list[Expr] args,list[AnalyticFunctionClause] analyticOpt)){
  
  str target="Athena";
  if(isFunctionSupported(name,target,adt)){
    return function(udf([], name, [toSQL(al)|al<-args,lambda(_,_)!:=al]));
  }
  else throw TranslationException("function <name> cannot be translated to <target>",typeCast(#node,adt).src);
}
