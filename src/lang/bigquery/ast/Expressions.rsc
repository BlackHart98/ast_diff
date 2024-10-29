module lang::bigquery::ast::Expressions


extend lang::basesql::ast::BaseSQL;

// Name
data SchemaNameDot = schemaNameBigQuery(list[TableNameId] tidList,  TableNameId tid);

// Expression

data Identifier = unquotedIdentifer(str unquotedIdentifer);

data ExpAsVar = withAggregationTreshhold(list[AggregationOptions] aggOptions, list[VarAssign] varAssign);

data AggregationOptions = aggOptions(list[ThresholdOpt] thresholdOpt, list[PrivacyUnitOpt] privacyUnitOpt);

data ThresholdOpt = thresholdOpt(Expr exp, list[str] strConst);

data PrivacyUnitOpt = privacyUnitOpt(Identifier columnName);

data Expr 
    = structWithType(DataType dataType, list[Expr] exps)
    | structNoType(list[ExpAsVarStrict1] asexp)
    | baseStruct(list[ExpAsVarStrict2] baseStruct)
    | explist(ExpList exprLit)
    ; 
data ExpAsVarStrict1 = expAsVarStrict1(Expr exp1, list[VarAssignStrictAs] asExps);
data ExpAsVarStrict2 = expAsVarStrict2(Expr exp1, VarAssignStrictAs asExp);
data VarAssignStrictAs = varAssignStrictAs(VarAssignAs as, Identifier id);


data ExpList = expList(Expr exp, list[Expr] exprList);

data Identifier = arrayIndex(Identifier id, Expr expr);


data Expr
    = arrayWithType(DataType datatype, CompositeLiteral compositeLit)
    | arrayNoType(CompositeLiteral compositeLit)
    | arrayNoKeyword(CompositeLiteral compositeLit)
    ;

data Expr 
    = ifNullExp(Expr lhs, Expr rhs)
    | nullIfExp(Expr lhs, Expr rhs)
    | ifExp(Expr expr1, Expr expr2, Expr expr3)
    | coalesceExp(list[Expr] exprlist)
    ;


data CompositeLiteral 
    = listLiteral(list[ExprOrComposite] exprList)
    | structLiteral(list[ExprOrComposite] exprList)
    ;

data ExprOrComposite = exprLit(Expr exprLit) | compositeLit(CompositeLiteral compLit);


data PrimitiveType 
    = bignumericType(list[ExprInBrackets] exprsOpt)
    | boolType()
    | bytesType(list[ExprInBrackets] exprsOpt)
    | dateType()
    | floatType()
    | geographyType()
    | int64Type()
    | intervalType()
    | jsonType()
    | numericType(list[ExprInBrackets] exprsOpt)
    | stringType(ExprInBrackets exprInBrackets)
    | timeType()
    | nullType()
    ;

data ExprInBrackets = expInBrackets(list[Expr] exprs);


// Function

data Expr = function(FunctionCall funcCall);

data FunctionCall = udf(list[PackageName] pkgNameOpt, str funcName, list[Expr] exprList);


data Expr = funcCall(FunctionCall funccall);


data FunctionCall
    = inBuiltFunction(InBuiltFunction inBuiltFunction, list[AnalyticFunctionClause] analyticFunctionClauseOpt)
    ;

data AnalyticFunctionClause = analyticFunctionClause(WindowSpecification windowSpecification);

data InBuiltFunction
  = aggregateFunction(AggregateFunction aggregateFunction)
  | approximateAggregateFunc(ApproximateAggregateFunc approximateAggregateFunc)
  | conversionFunction(ConversionFunctions conversionFunction)
  | dateFunction(DateFunctions dateFunction)
  | navigationFunctions(NavigationFunctions navigationFunctions)
  | numberingFunctions(NumberingFunctions numberingFunctions)
  | statisticalAggregateFunctions(StatisticalAggregateFunctions statisticalAggregateFunctions)
  | tableFunctions(TableFunctions tableFunctions)
  | textAnalysisFunctions(TextAnalysisFunctions textAnalysisFunctions)
  | arrayFunctions(ArrayFunctions arrayFunctions)
  ;

data AggregateFunction
  = anyvalue(Expr exp, list[HavingExp])
  | arrayagg(list[Distinct] distinct, Expr exp, list[IgnoreRespect] ignorerespect, list[OrderBy] orderby, list[Limit] limit)
  | arrayconcatagg( Expr exp, list[OrderBy] orderby, list[Limit] limit)
  | avg(list[Distinct] distinct, list[Expr] explist)
  | bitAnd(Expr exp)
  | bitOr(Expr exp)
  | bitXor(list[Distinct], Expr exp)
  | countAll()
  | count(list[Distinct] distinct, Expr exp)
  | countIf(Expr exp)
  | grouping(Expr exp)
  | logicalAnd(Expr exp)
  | logicalOr(Expr exp)
  | max(Expr exp)
  | maxBy(list[Expr] explist)
  | minBy(list[Expr] explist)
  | min(Expr exp)
  | stringAgg(list[Distinct] distinct, list[Expr] explist, list[OrderBy] orderBy, list[Limit] limit)
  | sum(list[Distinct] distinct, Expr exp)
  ;

data ApproximateAggregateFunc
  = approxCountDistinct(Expr exp)
  | approxQuantiles(list[Distinct] distinct, list[Expr] explist, list[IgnoreRespect] ignorerespect)
  | approxTopCount(list[Expr] explist)
  | approxTopSum(list[Expr] explist)
  ;


data ArrayFunctions 
  = array(Expr expr) | array(QueryOrWith qryWith)
  ;


data ConversionFunctions
  = cast(Expr exp, DataType datatype, list[FormatClause] formatClause)
  | safeCast(Expr exp, DataType datatype, list[FormatClause] formatClause)
  | castAsTimestamp(Expr exp1, DataType datatype, list[FormatClause] formatClause, Expr exp2)
  | parseBignumeric(Expr exp)
  | parseNumeric(Expr exp)
  ;

data DateFunctions 
  = currentDate(list[Expr] exp)
  | extract(Expr exp1, Expr exp2)
  ; 

data NavigationFunctions
  = firstValue(Expr exp, list[IgnoreRespect] ignorerespect)
  | lag(list[Expr] explist)
  | lastValue(list[Expr] explist, list[IgnoreRespect] ignorerespect)
  | lead(list[Expr] explist)
  | nthvalue(list[Expr] explist, list[IgnoreRespect] ignorerespect)
  | percentileCont(list[Expr] explist, list[IgnoreRespect] ignorerespect)
  | percentileDisc(list[Expr] explist, list[IgnoreRespect] ignorerespect)

  ;

data NumberingFunctions
  = cumeDist()
  | denseRank()
  | ntile()
  | percentRank()
  | rank()
  | rowNumber()
  ;

data StatisticalAggregateFunctions
  = corr(list[Expr])
  | covarPop(list[Expr] explist)
  | covarSamp(list[Expr] explist)
  | stddev(list[Distinct] distinct,list[Expr] explist)
  | stddevPop(list[Distinct] distinct,list[Expr] explist)
  | stddevSamp(list[Distinct] distinct,list[Expr] explist)
  | varPop(list[Distinct] distinct,list[Expr] explist)
  | varSamp(list[Distinct] distinct,list[Expr] explist)
  | variance(list[Distinct] distinct,list[Expr] explist)
  ;

data TextAnalysisFunctions
  = bagOfWords(list[Expr] explist)
  | textAnalyze(list[Expr] explist)
  | tfIdf(list[Expr] explist) 
  ;

data TableFunctions
  = appends(Expr exp1, Expr exp2)
  | externalObjectTransform(Expr exp1, Expr exp2)
  ;


data Distinct = distinct();

data Limit = limit(int integer);

data IgnoreRespect
  = ignoreNulls()
  | respectNulls()
  ;

data HavingExp = havingExp(MaxMin, Expr exp);

data MaxMin
  = max()
  | min()
  ;

data OverClause
  = overId(Identifier overId)
  | overWindowSpecs(WindowSpecs overWindowSpecs)
  ;

data WindowSpecs
  = windowSpecs(list[Identifier] ids, list[PartitionByExp] partbyexp, list[OrderBy] orderby, list[Expr] exps)
  ;

data PartitionByExp = partitionByExp(Expr exp);

data OrderBy = orderSpecs(Expr exp, list[AscDesc] ascdesc);

data AscDesc
  = asc()
  | desc()
  ;

data FormatClause = formatClause(Expr expr);