module lang::ptl::prettyprint::Expressions
import Map;
import Node;
extend lib::Utils;
extend lang::exprlang::prettyprint::Expressions;
extend lang::ptl::ast::PTL;
import List;
import String;


public str toString(Expr ex){
    switch(ex){
        case functioncallSimple(str name, list[Expr] args, list[AnalyticFunctionClause] al):{
        
                lrel[str key,value val] keywords=toList(getKeywordParameters(ex));
                return "<name>(<intercalate(",\n",[toString(arg)| arg<-args])><intercalate("\n",[",<key>=<val>"| <str key,bool val> <-keywords,val])>)<intercalate("",[toString(arg)| arg<-al])>";

        } 
        case functioncallWithKeyWord(str name, list[Expr] args,list[KWParam] kwparam, list[AnalyticFunctionClause] al):{
                 return "<name>( <intercalate(",\n",[toString(arg)| arg<-args])> <intercalate("\n",[",<name>=<toString(val)>"| keywordParam(str name ,Expr val) <-kwparam])> )<intercalate("",[toString(arg)| arg<-al])>";

        }

        case functioncallKWOnly(str name, list[KWParam] params, list[AnalyticFunctionClause] al):{
                 return "<name>(  <intercalate("\n",[",<name>=<toString(val)>"| keywordParam(str name ,Expr val) <-params])> )<intercalate("",[toString(arg)| arg<-al])>";
        }
        case countStar():return "count(*)";
        case typeConvert(Expr e, Type t): return "(<toString(e)>)::<toString(t)>";
        case castId(list[str] idList, Type t): return "<intercalate(".",[nm|nm<-idList])>::<toString(t)>";
        case castLiteral(Expr e, Type t): return "<toString(e)>::<toString(t)>";
        case functionCast(Expr e, Type \type):{
            return "<toString(e)>::<toString(\type)>";
        }
        case \bracket(Expr e): return "(<toString(e)>)";
        case boolean(str \bool): return "<\bool>";
        case regExp(str regExpLiteral) :return "<regExpLiteral>";
        case listIndex(Expr e, Expr index): return "<toString(e)>[<toString(index)>]";
        case setIndex(Expr e, Expr index): return "<toString(e)>{<toString(index)>}";
        case mapIndex(Expr e, Expr key) : return "<toString(e)>.get(<toString(key)>)";
    
        case nullLiteral(): return "null";
        case nilLiteral(): return "nil";
        case \map(list[Mapping] mapEnt):{
            return "{
                '    <intercalate(",\n",[toString(\map) | \map<-mapEnt])>
                '}";
        }
        case \list(list[Expr] els):return "[<intercalate(",",[toString(el) | el<-els])>]";
        case \set(list[Expr] els):return "set{<intercalate(",",[toString(el) | el<-els])>}";
        case \tuple(list[Expr] els):return "\< <intercalate(",",[toString(el) | el<-els])> \>";
        case dateTime(str  dateTimeLiteral): return "<dateTimeLiteral>";
        
        case block(list[Expr] exprs):return "{
             '    <intercalate(";",[toString(expr) | expr <- exprs])>
             '};";      
        case like(Expr expr1, Expr expr2):return "<toString(expr1)> like <toString(expr2)>";
        case notlike(Expr expr1, Expr expr2):return "<toString(expr1)>not like<toString(expr2)>";
        case isNull(Expr expr):return "<toString(expr)> is null";
        case isNullNot(Expr expr): return "<toString(expr)> is not null";
        case not(Expr expr):return "!" + "<toString(expr)>";
        case and(Expr expr1, Expr expr2):return "<toString(expr1)> and <toString(expr2)>";
        case Expr::or(Expr expr1, Expr expr2):{
              return "<toString(expr1)> or <toString(expr2)>";
            }
        case \in(Expr expr1, Expr expr2):return "<toString(expr1)> in <toString(expr2)>";
        case notIn(Expr expr1, Expr expr2):return "<toString(expr1)> not in <toString(expr2)>";
        case between(Expr e1, Expr e2):return "<toString(e1)> between <toString(e2)> ";
        case \if(Expr cond, Expr thenPart, Expr elsePart):{
            return "if <toString(cond)> 
                '    then <toString(thenPart)> 
                'else <toString(elsePart)>";
        }
        case lambda (str arg, Expr exp):{
            return "<arg> =\> <toString(exp)>";
        }
        case match(Expr e, list[Case] cases, list[Default] d):{
            
            return trim("(<toString(e)>) match {
                '    <intercalate("\n",[toString(\case)|\case<-cases])> 
                '    <intercalate("",[toString(ds)|ds<-d])>
                '}");
        }
          default: throw ToStringException("message: Unable to resolve Expression signature",ex);
    }
}
public str toString(booleanType()) = "Bool";
public str toString(stringType()) = "Str";

public str toString( \any())="Any";
public str toString(generic(str letter,list[Type] typeOpt))="&<letter><intercalate("",["\<:<toString(\type)>"|\type<-typeOpt])>";


public str toString(dateTimeType()) = "Datetime";
public str toString(dateType()) = "Date"; 
public str toString(timeType()) = "Timestamp"; 
public str toString(charType()) = "Char"; 
public str toString(varCharType()) = "Varchar"; 
public str toString(intervalType()) = "Interval"; 
public str toString(\setType(Type t)) = "Set[<toString(t)>]";
public str toString(\mapType(Type k ,Type v)) = "Map[<toString(k)>,<toString(v)>]";
public str toString(\listType(Type t)) = "List[<toString(t)>]";
public str toString(\tupleType(list[Type] ty)) = "Tuple[<intercalate(",",[toString(t)|t<-ty])>]";
public str toString(objectType()) = "Object";
public str toString(referenceType(str entityName)) = "<entityName>";
public str toString(nullType()) = "Null";
public str toString(asType(Expr e,Type t)) = "<toString(e)> as [<toString(t)>]";



public str toString(float())="Float";
public str toString(Type::\int())="Int";
public str toString(Type::smallInt())="SmallInt";
public str toString(Type::bigInt())="BigInt";
  

public str toString(identifier(list[str] nms)){
    
    return "<intercalate(".",[nm|nm<-nms])>";
}


str toString(\case(Expr e1, Expr e2)){
    return "case <toString(e1)> =\> <toString(e2)>;";
}
str toString(\default(Expr e)){
    return "default =\> <toString(e)>;";
}
str toString(analyticFunctionClause(WindowSpecification windowSpec)){
    return "over <toString(windowSpec)>";
}

str toString(WindowSpecification w){

    switch(w){
    case windowSpecification( list[PartitionByClause] partitionByCls, list[OrderByClauseOpt] orderByCls, list[WindowFrameClause] windowFrameCls): return "(<intercalate("",[toString(partitionByCl)|partitionByCl<-partitionByCls])> <intercalate("",[toString(orderByCl)|orderByCl<-orderByCls])> <intercalate("",[toString(windowFrameCl)|windowFrameCl<-windowFrameCls])>)";
    case namedWindow(str name): return name;
    }
    return "";
}

public str toString(OrderByClauseOpt obt){
  return "order by <intercalate(",",[toString(e)|e<-obt.orderEl])>";
}
public str toString(orderElement(AscOrDescOpt asc)){
  return "<toString(asc)>";
}
public str toString(having(Expr e)){
  return "having <toString(e)>";
}
public str toString(AscOrDescOpt asc){

  switch(asc){
    case ascending(Expr e):{
      return  "<toString(e)> ascending";
    }
    case asc(Expr e):{
      return "<toString(e)> asc";
    }
    case descending(Expr e):{
      return "<toString(e)> descending";
    }
    case desc(Expr e):{
      return "<toString(e)> desc";
    }
    default: throw ToStringException("message: Unable to resolve signature",asc);
  }
}

str toString(windowFrameClause(RowsOrRange rowOrRange, FrameStartOrBetween frameStartOrBetween)){
    return "<toString(rowOrRange)> <toString(frameStartOrBetween)>";
}



str toString(partitionByClause(list[Expr] ex)){
    return "partition by <intercalate(",",[toString(e)|e<-ex])>";
}
str toString(DistinctOrAll::distinct( ))="distinct";
str toString(DistinctOrAll::\all( ))="all";



str toString(RowsOrRange ror){
   switch(ror){
    case rows():{
      return "rows";
    }
    case  range():{
      return "range";
    }
  }
   return "";
}

str toString(FrameStartOrBetween f){
    switch(f){
        case frameStart(FrameStart frameStart):return "<toString(frameStart)>";
        case frameBetween(FrameBetween frameBetween):return "<toString(frameBetween)>";
    }
    return "";
}


str toString(FrameStart fs){
    switch(fs){
        case frameStartUnboundedPreceding(UnboundedPreceding unboundedPreceding): return "<toString(unboundedPreceding)>";
        case frameStartNumericPreceding(NumericPreceding np): return "<toString(np)>";
        case frameStartCurrentRow(CurrentRow cr): return "<toString(cr)>";
    }
    return "";
}

str toString(FrameBetween fb){
    switch(fb){
        case frameBetweenUnboundedPreceding(UnboundedPreceding unboundedPreceding, FrameEndA fea):{
            return "between <toString(unboundedPreceding)> and <toString(fea)>";
        }
        case frameBetweenNumericPreceding(NumericPreceding np, FrameEndA fea):{
            return "between <toString(np)>  and <toString(fea)>";
        }
        case frameBetweenCurrentRow(CurrentRow cr, FrameEndB feb):{
            return "between <toString(cr)> and <toString(feb)>";
        }
        case frameBetweenNumericFollowing(NumericFollowing nf, FrameEndC fec):{
          return "between <toString(nf)> and <toString(fec)>";
        }
    }
    return "";
}

str toString(unboundedPreceding()){
    return "unbounded" + "preceding";
}
str toString(unboundedFollowing()){
    return "unbounded" + "following";
}

str toString(numericPreceding(str \int)){
    return "<\int> preceding";
}
str toString(numericFollowing(str \int)){
    return "<\int> following";
}

str toString(currentRow()){
    return "current row";
}

str toString(FrameEndA fea){
    switch(fea){
        case frameEndANumericPreceding(NumericPreceding np):{
            return "<toString(np)>";
        }
        case frameEndACurrentRow(CurrentRow cr):{
            return "<toString(cr)>";
        }
        case frameEndANumericFollowing(NumericFollowing nf):{
            return "<toString(nf)>";
        }
        case frameEndAUnboundedFollowing(UnboundedFollowing uf):{
            return "<toString(uf)>";
        }
    }
    return "";
}
str toString(FrameEndB feb){
    switch(feb){
        case frameEndBCurrentRow(CurrentRow cr):{
            return "<toString(cr)>";
        }
        case frameEndBNumericFollowing(NumericFollowing nf):{
            return "<toString(nf)>";
        }
        case frameEndBUnboundedFollowing(UnboundedFollowing uf):{
            return "<toString(uf)>";
        } 
    }
    return "";
}
str toString(FrameEndC fec){
    switch(fec){
        case frameEndCNumericFollowing(NumericFollowing nf):{
            return "<toString(nf)>";
        }
        case frameEndCUnboundedFollowing(UnboundedFollowing uf):{
            return "<toString(uf)>";
        }
    }
    return "";
}

str toString(mapping(Expr k, Expr v)){
    return "<toString(k)> -\> <toString(v)>";
}