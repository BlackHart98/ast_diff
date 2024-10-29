module lang::ptl::translations::translate2Spark::TranslateExpressions

extend lang::ptl::translations::translate2Base::Declaration;
import lang::ptl::Utils;
extend lang::spark::ast::Spark;
import List;
import Type;


public Expr toSQL(setIndex(Expr e, Expr index))= setIndex(toSQL(e), toSQL(index));
public Expr toSQL(mapIndex(Expr e, Expr key) )= mapIndex(toSQL(e), toSQL(key));

public Expr toSQL(exist(Expr exp))= exist(toSQL(exp));

public Expr toSQL(lambda (str arg, Expr exp))= lambda(arg, toSQL(exp));

public Expr toSQL(\in(Expr lhs, Expr rhs)) = \in(toSQL(lhs), toSQList(rhs));

public Expr toSQL(match(Expr e, list[Case] cases, list[Default] d)) = match(toSQL(e), [toSQL(\case)| \case <- cases], [toSQL(\default)|\default <- d]);

public Expr toSQL(notIn(Expr lhs, Expr rhs)) = inPredicate(toSQL(lhs), [not()], arraySpark(toSQList(rhs)));

public Expr toSQL(adt:functioncall(str name, list[Expr] args, list[AnalyticFunctionClause] analyticOpt)) {
    str target="Spark";
        if(isFunctionSupported(name,target,adt)){
            return Expr::function(callFunction(regularIdentifier(name), [setQuantifier(distinct())|al<-args,lambda("distinct",_):=al], [toSQL(al)|al<-args,lambda(_,_)!:=al],
            [toSQL(al)|al<-args,lambda("null_handler",_):=al],[toSQL(al)|al<-args,lambda("within_group",_):=al||lambda("filter",_):=al]),[toSQL(al)|al<-analyticOpt]); 
        }
        else throw TranslationException("function <name> cannot be translated to <target>",typeCast(#node,adt).src); 
}

public Expr toSQL(\list(list[Expr] el)){
   exps= [toSQL(e)|e<-el];
   return arrayLit(arraySpark(exps));
}

public list[Expr] toSQList(\list(list[Expr] el)){
   exps= [toSQL(e)|e<-el];
   return exps;
}

public Case toSQL(\case(Expr e1, Expr e2)) = \case(toSQL(e1), toSQL(e2));

public Default toSQL(\default(Expr e)) = \default(toSQL(e));


public AggParam toSQL(lambda("null_handler",boolean("ignore")))=nullOption(ignore());
public AggParam toSQL(lambda("null_handler",boolean("respect")))=nullOption(respect());
public OtherFunctionParameters toSQL(lambda("filter",Expr e))=filterClause(\filter(whereClause(toSQL(e))));
public OtherFunctionParameters toSQL(lambda("within_group",Expr e))=withinGroup(orderByClause([orderExpr(toSQL(e))]));
