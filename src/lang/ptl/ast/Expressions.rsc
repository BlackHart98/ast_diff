module lang::ptl::ast::Expressions

extend lang::exprlang::ast::Expressions;

data Expr 
    = typeConvert(Expr e, Type \type)
    | castId(list[str] idList, Type \type)
    | castLiteral(Expr literal, Type \type)
    | functionCast(Expr e, Type \type)
    | asExp(Expr e1,Expr e2)
    | asType(Expr e,Type t)
    | exist(Expr exp)
    | functioncallSimple(str name, list[Expr] args, list[AnalyticFunctionClause] al)
    | functioncallWithKeyWord(str name, list[Expr] args,list[KWParam] kwparam, list[AnalyticFunctionClause] al)
    | functioncallKWOnly(str name, list[KWParam] params, list[AnalyticFunctionClause] al)
    | countStar()
    | identifier(list[str] names)
    | \bracket(Expr e)
	| boolean(str booleanLiteral)
	| dateTime(str dtlit) 
	| regExp(str regExpLiteral) 
	| nullLiteral() 
	| nilLiteral()
    | \set(list[Expr] el)
    | \list(list[Expr] el)
    | \tuple(list[Expr] el) 
	| \map(list[Mapping] mapEntries)
    | fieldAccess(Expr e, str field)
    | listIndex(Expr e, Expr index)
    | setIndex(Expr e, Expr index)
    | mapIndex(Expr e, Expr key) 
    | not(Expr e)
    | logicalNot(Expr e)
    | like(Expr lhs, Expr rhs)
    | notlike(Expr lhs, Expr rhs)
    | isNull( Expr e)
    | isNullNot(Expr e)
    | match(Expr e, list[Case] cases, list[Default] d)
    | block(list[Expr] exprs) 
    | and(Expr lhs, Expr rhs)
    | or(Expr lhs, Expr rhs)
    | \in(Expr lhs, Expr rhs)
    | notIn(Expr lhs, Expr rhs)
    | between(Expr e1, Expr e2)
    | \if(Expr cond, Expr thenPart, Expr elsePart)
    | lambda (str arg, Expr exp)
    ;

data KWParam 
    = keywordParam(str name ,Expr val)
    | distinct(Expr val)
    ;

data Star = star();
data Separator = separator(Expr e);

data DistinctOrAll =\all()| distinct();

data Distinct = distinct();




data Case = \case(Expr e1, Expr e2);

data Default = \default(Expr e);

data Type 
    = booleanType()
    | \any()
    | generic(str capital,list[Type] tOpt)
    | byteType()
    | stringType()
    | \int()
    | smallInt()
    | bigInt()
    | float()
    | dateTimeType()
    | timeType()
    | dateType() 
    | charType()
    | varCharType()
    | intervalType()
    | \setType(Type t)
	| \mapType(Type k , Type v)
	| \listType(Type t)
    | \tupleType(list[Type] ty)
    | structType(lrel[str id ,Type datatype] structProperty)
    | objectType()
    | referenceType(str entityName)
    | nullType()
    ;


  

data Reference
    = objectType()
    | referenceType(str entityName)
    | nullType()
  ;


data Mapping
    = mapping(Expr k, Expr v)
    ;


data AnalyticFunctionClause = analyticFunctionClause(WindowSpecification windowSpec);


data WindowSpecification 
  = windowSpecification(
    list[PartitionByClause] partitionByCls
    , list[OrderByClauseOpt] orderByCls
    , list[WindowFrameClause] windowFrameCls
    )
  | namedWindow(str name)
  ;

data OrderByClauseOpt = orderByClause(list[OrderElement] orderEl);


data OrderElement = orderElement(AscOrDescOpt asc);

data AscOrDescOpt = having(Expr e);

data AscOrDescOpt
    = ascending(Expr e) 
    | asc(Expr e)
    | descending(Expr e)
    | desc(Expr e)
    ;


data PartitionByClause = partitionByClause(list[Expr] e);  

data WindowFrameClause 
    = windowFrameClause(RowsOrRange rowOrRange, FrameStartOrBetween frameStartOrBetween)
    ;

data RowsOrRange 
    = rows()
    | range()
    ;
data FrameStartOrBetween
    = frameStart(FrameStart frameStart)
    | frameBetween(FrameBetween frameBetween)
    ; 

data FrameBetween
    = frameBetweenUnboundedPreceding(UnboundedPreceding unboundedPreceding, FrameEndA frameEndA)
    | frameBetweenNumericPreceding(NumericPreceding numericPreceding, FrameEndA frameEndA)
    | frameBetweenCurrentRow(CurrentRow currentRow, FrameEndB frameEndB)
    | frameBetweenNumericFollowing(NumericFollowing numericFollowing, FrameEndC frameEndC)
    ;

data FrameStart
    = frameStartUnboundedPreceding(UnboundedPreceding unboundedPreceding)
    | frameStartNumericPreceding(NumericPreceding numericPreceding)
    | frameStartCurrentRow(CurrentRow currentRow)
    ;


data FrameEndA
    = frameEndANumericPreceding(NumericPreceding numericPreceding)
    | frameEndACurrentRow(CurrentRow currentRow)
    | frameEndANumericFollowing(NumericFollowing numericFollowing)
    | frameEndAUnboundedFollowing(UnboundedFollowing unboundedFollowing)
    ;

data FrameEndB
    = frameEndBCurrentRow(CurrentRow currentRow)
    | frameEndBNumericFollowing(NumericFollowing numericFollowing)
    | frameEndBUnboundedFollowing(UnboundedFollowing unboundedFollowing)
    ; 


data FrameEndC
  = frameEndCNumericFollowing(NumericFollowing numericFollowing)
  | frameEndCUnboundedFollowing(UnboundedFollowing unboundedFollowing)
  ; 


data UnboundedPreceding = unboundedPreceding(); 

data NumericPreceding = numericPreceding(str \int);

data UnboundedFollowing = unboundedFollowing();

data NumericFollowing = numericFollowing(str \int);

data CurrentRow = currentRow();
