module lang::functionLang::translations::Functions
extend lang::basesql::translations::translate2ptl::TranslateDeclarations;
extend lang::functionLang::ast::Function;
import lang::basesql::prettyprint::BaseSQL;
import lang::ptl::ast::Expressions;
import Node;
import Type;

public lang::ptl::ast::Expressions::Expr toPTL(callFunction(Identifier funName, list[AggParam] aggParam1,list[Expr] arguments, list[AggParam] aggParam2,list[OtherFunctionParameters] otherFunctionParams)){ 
    list[AggParam] otherParams=aggParam1+aggParam2;
    list[OtherFunctionParameters] nulls=[e|e<-otherFunctionParams,nullOpt(_ ):=e];
          Expr function=lang::ptl::ast::Expressions::functioncallSimple(toString(funName),[toPTL(e)|e<-arguments]+[toPTL(e)|e<-otherFunctionParams,nullOpt(_ )!:=e],[]);

   
    if([]!:=otherParams||[]!:=nulls){
        newMap= (toMap(otherParams[0])|it+toMap(param)|param<-otherParams+nulls);
       return setKeywordParameters(function,newMap);
     }
     else return function;
    }
    
map[str,value] toMap(AggParam::setQuantifier(SetQuantifier sq))= toMap(sq);
map[str,value] toMap(SetQuantifier::distinct())= ("Distinct":true);
map[str,value] toMap(SetQuantifier::\all())= ("Distinct":false);
map[str,value] toMap(AggParam ap){

    switch(ap){
        case nullOption(ignore()):return ("IgnoreNull":true);
        case nullOption(respect()):return ("IgnoreNull":false);

        default: throw TranslationException("message:Unhandled translation",typeCast(#node,ap).src);
    }
}
public AnalyticFunctionClause toPTL(analyticFunctionClause(WindowSpecification windowSpec))=analyticFunctionClause(toPTL(windowSpec));


public Expr toPTL(filterClause(\filter(whereClause(Expr expr))))= lambda("filter",toPTL(expr));
public map[str,value]  toMap(nullOpt(NullOption nullOpt)){
     switch(nullOpt){
        
        case ignore():return ("IgnoreNull":true);
        case respect():return ("IgnoreNull":false);

        default: throw TranslationException("message:Unhandled translation",typeCast(#node,nullOpt).src);
    }
}
public Expr toPTL(withinGroup(orderByClause(list[OrderElem] orderElem)))= lambda("within_group",[toPTL(e.expr)|e<-orderElem][0]);


public WindowSpecification toPTL(windowSpecification(
    list[PartitionByClause] partitionByCls
    , list[OrderByClause] orderByCls
    , list[WindowFrameClause] windowFrameCls
    ))= lang::ptl::ast::Expressions::windowSpecification(
        [toPTL(partitionByCl)|partitionByCl<-partitionByCls]
        , [toPTL(orderByCl)|orderByCl<-orderByCls]
        , [toPTL(windowFrameCl)|windowFrameCl<-windowFrameCls]
    );

public WindowFrameClause  toPTL(windowFrameClause(RowsOrRange rowOrRange, FrameStartOrBetween frameStartOrBetween))=windowFrameClause( toPTL(rowOrRange) , toPTL(frameStartOrBetween) );
public PartitionByClause toPTL(partitionByClause(list[Expr] ex))=  partitionByClause([toPTL(e)|e<-ex]);  
public WindowSpecification toPTL(namedWindow( quotedIdentifier(identifier)))= lang::ptl::ast::Expressions::namedWindow( identifier);

public RowsOrRange toPTL(rows())=rows();
public RowsOrRange toPTL(range())=range();

public FrameStartOrBetween toPTL(frameStart(FrameStart frameStart))
    = FrameStartOrBetween::frameStart(toPTL(frameStart));
public FrameStartOrBetween toPTL(frameBetween(FrameBetween frameBetween))=FrameStartOrBetween::frameBetween(toPTL(frameBetween))
    ; 

public FrameBetween toPTL(frameBetweenUnboundedPreceding(UnboundedPreceding unboundedPreceding, FrameEndA frameEndA))
    = frameBetweenUnboundedPreceding(toPTL(unboundedPreceding), toPTL(frameEndA));

public FrameBetween toPTL(frameBetweenNumericPreceding(NumericPreceding numericPreceding, FrameEndA frameEndA))=frameBetweenNumericPreceding(toPTL(numericPreceding),toPTL(frameEndA));
public FrameBetween toPTL(frameBetweenCurrentRow(CurrentRow currentRow, FrameEndB frameEndB))=frameBetweenCurrentRow(toPTL(currentRow),toPTL(frameEndB));
public FrameBetween toPTL(frameBetweenNumericFollowing(NumericFollowing numericFollowing, FrameEndC frameEndC))=frameBetweenNumericFollowing(toPTL(numericFollowing),toPTL(frameEndC))
    ;

public FrameStart toPTL(frameStartUnboundedPreceding(UnboundedPreceding unboundedPreceding))
    = frameStartUnboundedPreceding(toPTL(unboundedPreceding) );
public FrameStart toPTL(frameStartNumericPreceding(NumericPreceding numericPreceding))=frameStartNumericPreceding( toPTL(numericPreceding));
public FrameStart toPTL(frameStartCurrentRow(CurrentRow currentRow))=frameStartCurrentRow( toPTL(currentRow));
    


public FrameEndA toPTL(frameEndANumericPreceding(NumericPreceding numericPreceding))
    = frameEndANumericPreceding( toPTL(numericPreceding));
public FrameEndA toPTL(frameEndACurrentRow(CurrentRow currentRow))=frameEndACurrentRow(toPTL(currentRow));
public FrameEndA toPTL(frameEndANumericFollowing(NumericFollowing numericFollowing))=frameEndANumericFollowing(toPTL(numericFollowing));
public FrameEndA toPTL(frameEndAUnboundedFollowing(UnboundedFollowing unboundedFollowing))=frameEndAUnboundedFollowing( toPTL(unboundedFollowing))
    ;


public FrameEndB toPTL(frameEndBCurrentRow(CurrentRow currentRow))=frameEndBCurrentRow(toPTL(currentRow));
public FrameEndB toPTL(frameEndBNumericFollowing(NumericFollowing numericFollowing))=frameEndBNumericFollowing(toPTL(numericFollowing));
public FrameEndB toPTL(frameEndBUnboundedFollowing(UnboundedFollowing unboundedFollowing))=frameEndBUnboundedFollowing(toPTL(unboundedFollowing));
    


public FrameEndC toPTL(frameEndCNumericFollowing(NumericFollowing numericFollowing))= frameEndCNumericFollowing( toPTL(numericFollowing));
public FrameEndC toPTL(frameEndCUnboundedFollowing(UnboundedFollowing unboundedFollowing))=frameEndCUnboundedFollowing(toPTL(unboundedFollowing))
  ; 


public UnboundedPreceding toPTL(unboundedPreceding()) = unboundedPreceding(); 

public NumericFollowing toPTL( numericFollowing(str \int)) =  numericFollowing(\int); 

public NumericPreceding toPTL( numericPreceding(str \int)) =  numericPreceding(\int); 

public UnboundedFollowing toPTL(unboundedFollowing()) = unboundedFollowing(); 

public CurrentRow toPTL(currentRow()) = currentRow();
