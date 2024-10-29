module lang::ptl::translations::translate2bigquery::TranslateExpressions


extend lang::ptl::translations::translate2Base::Declaration;
import lang::ptl::Utils;
import lang::ptl::ast::Declarations;
extend lang::bigquery::ast::BigQuery;
import List;
import Type;


public lang::bigquery::ast::BigQuery::Expr toSQL(\if(Expr cond, Expr thenPart, Expr elsePart)) = ifExp(toSQL(cond), toSQL(thenPart), toSQL(elsePart));


public Expr toSQL(\list(list[Expr] el)){
   exps= [toSQL(e)|e<-el];
   return arrayNoType(listLiteral([exprLit(expr)|expr <- exps]));
}

public lang::basesql::ast::BaseSQL::Expr toSQL(adt:functioncall(str name, list[Expr] args,list[AnalyticFunctionClause] analyticOpt)){
  
  str target="BigQuery";
  if(isFunctionSupported(name,target,adt)){
  return function(udf([], name, [toSQL(al)|al<-args,lambda(_,_)!:=al]));}
  else throw TranslationException("message:this <name> isnt transformable to <target>",typeCast(#node,adt).src);
}

