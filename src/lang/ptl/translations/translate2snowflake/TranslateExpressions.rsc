module lang::ptl::translations::translate2snowflake::TranslateExpressions

extend lang::ptl::translations::translate2Base::Declaration;
import lang::ptl::Utils;
import lang::ptl::ast::Declarations;
extend lang::snowflake::ast::SnowFlake;
import List;
import Type;



public Expr toSQL(\if(Expr cond, Expr thenPart, Expr elsePart))= iffExp(iffExpression(toSQL(cond), toSQL(thenPart), toSQL(elsePart)));
public Expr toSQL(notIn(Expr lhs, Expr rhs))= expNotInList(toSQL(lhs),[not()],expList([toSQL(rhs)]));
public Expr toSQL(\in(Expr lhs, Expr rhs))= expNotInList(toSQL(lhs),[],expList([toSQL(rhs)]));

public Expr toSQL(typeConvert(Expr e, Type t))= castExp(toSQL(e), toSQL(t));

public Expr toSQL(\list(list[Expr] el)){
   exps= [toSQL(e)|e<-el];
   return arrayExp(arrayExpList([expList(exps)]));
}

public Expr toSQL(adt:functioncall(str name, list[Expr] args,list[AnalyticFunctionClause] analyticOpt)){
  str target="SnowFlake";
  
  if(isFunctionSupported(name,target,adt)){
    return functionCallExp(aggregateFunc(idNoDistinct(propRef([regularIdentifier(name)]), [toSQL(al)|al<-args,lambda(_,_)!:=al])));
  }
  else throw TranslationException("This <name> isnt transformable to <target>",typeCast(#node,adt).src);
}

public DataType toSQL(dateTimeType())= dateTimeDataType([]);
public DataType toSQL(timeType())= timeStampDataType([]);
public DataType toSQL(objectType())= objectDataType();
