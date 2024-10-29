module lang::spark::translations::Expressions
extend lib::Utils;
import lang::spark::ast::Expressions;
extend lang::ptl::ast::PTL;
extend lang::functionLang::translations::Functions;
import List;
import Node;
import Type;
import IO;






public lang::ptl::ast::Expressions::Expr toPTL(Expr exp){
  // println(exp);
    switch(exp) {
    case  exist(Expr exp) : return exist(toPTL(exp));
    case mapIndex(Expr expr1, Expr exp2):return mapIndex(toPTL(expr1), toPTL(exp2));
    case setIndex(Expr expr1, Expr exp2):return setIndex(toPTL(expr1), toPTL(exp2));
    case arrayLit(arraySpark(list[Expr] exps)):return \list([toPTL(ex)|ex<-exps]);
    case inPredicate(Expr expr, list[Not] not,arraySpark(list[Expr] exps)):{return size(not)>0?notIn(toPTL(expr),\list([toPTL(ex)|ex<-exps])):\in(toPTL(expr),\list([toPTL(ex)|ex<-exps]));}
    case  match(Expr e, list[Case] cases, list[Default] d) : return match(toPTL(e),[toPTL(\case)|\case<-cases],[toPTL(de)|de<-d]);
    case  block(list[Expr] exprs) : return block([toPTL(e)|e<-exprs]); 
    case  lambda (str arg, Expr exp) : return lambda(arg,toPTL(exp));
    case  function(callFunction(regularIdentifier(str funName), list[AggParam] aggParam1,list[Expr] arguments, list[AggParam] aggParam2,list[OtherFunctionParameters] otherFunctionParams), list[AnalyticFunctionClause] analyticOpt) :{
       list[AggParam] otherParams=aggParam1+aggParam2;
       list[OtherFunctionParameters] nulls=[e|e<-otherFunctionParams,nullOpt(_ ):=e];
       Expr function=lang::ptl::ast::Expressions::functioncallSimple(funName,[toPTL(e)|e<-arguments]+[toPTL(e)|e<-otherFunctionParams,nullOpt(_ )!:=e],[toPTL(analytic)|analytic<-analyticOpt]);  
       
       if([]!:=otherParams||[]!:=nulls){
        newMap= (toMap(otherParams[0])|it+toMap(param)|param<-otherParams+nulls);
       return setKeywordParameters(function,newMap);
     }
     else return function;   
    }
    case illegalNull(): return nullLiteral();
    case \true: return boolean("true");
    case \false: return boolean("false");
    default: throw TranslationException(" expression not found",typeCast(#node, exp).src);
   
     }
}
 
public Expr toPTL(simpleCase(list[Expr] _,list[WhenClause] wcl,list[ElseClause] elcl)){

return  getIf(wcl,elcl);}

public lang::ptl::ast::Expressions::Expr getIf(list[WhenClause] whencond, list[ElseClause] elseCond){
    startProcess= reverse(whencond);
    if(whenClause(Expr exp1, Expr exp2):=startProcess[0]){
         result = \if(toPTL(exp1),toPTL(exp2),toPTL(elseCond[0]));
    
    return (result | lang::ptl::ast::Expressions::\if(toPTL(exp1), toPTL(exp2), it) | whenClause(Expr exp1, Expr exp2) <- tail(startProcess));

    } 
    else throw TranslationException("when clause  not found ",startProcess[0]);
   
}
public Expr toPTL(elseClause(Expr exp))= toPTL(exp);

public Type toPTL( DataType dt){
    switch(dt){
         case  doubleType(): return Type::float();
         case  decimalType(_): return float();
         case  stringType(): return stringType();
         case  boolType(): return booleanType();
         case  arrayType(DataType dtype): return listType(toPTL(dtype));
         case  timestampNTZType(): return Type::timeType();

        default:throw TranslationException("DataType <dt> not found  ",dt);
    }
}


public Distinct toPTL(lang::spark::ast::Expressions::Distinct _)= Distinct::distinct();

public Separator toPTL(separator (Expr e))= Separator::separator(toPTL(e));

public lang::ptl::ast::Expressions::Case toPTL(\case(Expr e1, Expr e2)){  
  return lang::ptl::ast::Expressions::\case(toPTL(e1),toPTL(e2));
}
public lang::ptl::ast::Expressions::Default toPTL(\default(Expr e))= lang::ptl::ast::Expressions::\default(toPTL(e));