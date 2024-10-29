module lang::ptl::translations::translate2hql::TranslateExpressions
extend lang::ptl::translations::translate2Base::Declaration;
import List;
extend lang::hql::ast::HQL;
import lang::ptl::Utils;
import Type;

 
public Expr toSQL(notIn(Expr lhs, Expr rhs))= inPredicate(toSQL(lhs),[not()],toSQL(rhs));
public Expr toSQL(\in(Expr lhs, Expr rhs))= inPredicate(toSQL(lhs),[],toSQL(rhs));

public ArrayLiteral toSQL(\list(list[Expr] el)){
   exps= [toSQL(e)|e<-el];
   return array(exps);
}


public lang::basesql::ast::BaseSQL::Expr toSQL(adt:functioncall(str name, list[Expr] args,list[AnalyticFunctionClause] analyticOpt)){
  
  str target="Hive";
  if(isFunctionSupported(name,target,adt)){
  return function(callFunction(regularIdentifier(name), [setQuantifier(SetQuantifier::distinct())|al<-args,lambda("distinct",_):=al], [toSQL(al)|al<-args,lambda(_,_)!:=al],[toSQL(al)|al<-args,lambda("null_handler",_):=al],[toSQL(al)|al<-args,lambda("within_group",_):=al||lambda("filter",_):=al]),[toSQL(al)|al<-analyticOpt]);}
  else throw TranslationException("message:this <name> isnt transformable to <target>",name);
}

public Expr toSQL(notIn(Expr lhs, Expr rhs))= inPredicate(toSQL(lhs),[not()],toSQL(rhs));
public Expr toSQL(\in(Expr lhs, Expr rhs))= inPredicate(toSQL(lhs),[],toSQL(rhs));


public lang::basesql::ast::BaseSQL::Expr toSQL(e:functioncallSimple(str name, list[Expr] args, list[AnalyticFunctionClause] analyticOpt)){
  
  str target="hive";
  str fName =translateFunction(target,name,e);   
            return Expr::function(callFunction(regularIdentifier(fName),[], [toSQL(al)|al<-args,lambda(_,_)!:=al],
           [],[toSQL(al)|al<-args,lambda("within_group",_):=al||lambda("filter",_):=al]),[toSQL(al)|al<-analyticOpt]); 
    }
public lang::basesql::ast::BaseSQL::Expr toSQL(countStar()){
  return function(countStar([]), []);
}
public Expr toSQL(e:functioncallWithKeyWord(str name, list[Expr] args,list[KWParam] kwparam, list[AnalyticFunctionClause] analyticOpt)){
      str target="hive";
      str fName =translateFunction(target,name,e);   
     list[OtherFunctionParameters] otherParams=[toSQL(al)|al<-args,lambda("within_group",_):=al||lambda("filter",_):=al];
            return Expr::function(Function::callFunction(regularIdentifier(fName),[setQuantifier(distinct())|param<-kwparam,param.name=="Distinct"], [toSQL(exp)|exp<-args,lambda(_,_)!:=exp],
           [nullOption(ignore())|param<-kwparam,param.name=="IgnoreNull"],otherParams),[toSQL(al)|al<-analyticOpt]); 
    }

public Expr    toSQL(e:functioncallKWOnly(str name, list[KWParam] params, list[AnalyticFunctionClause] analyticOpt)){
      str target="hive";
      str fName =translateFunction(target,name,e);   
            return Expr::function(callFunction(regularIdentifier(fName), [setQuantifier(distinct())|param<-params,param.name=="Distinct"],[],
           [nullOption(ignore())|param<-params,param.name=="IgnoreNull"],[]),[toSQL(al)|al<-analyticOpt]); 
    }

public OtherFunctionParameters toSQL(lambda("filter",Expr e))=filterClause(\filter(whereClause(toSQL(e))));
public OtherFunctionParameters toSQL(lambda("within_group",Expr e))=withinGroup(orderByClause([orderExpr(toSQL(e))]));
