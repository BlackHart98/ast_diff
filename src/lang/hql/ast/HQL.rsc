module lang::hql::ast::HQL

import lang::hql::grammar::HQL;

extend lang::functionLang::ast::Function;

data HQLStart 
  = expression(Expr expr)
  | statements(list[StatementWithTerminator] stmtWithTerminator)
  ;


// Expression

data Expr = inPredicate(Expr expr, list[Not] not, ArrayLiteral arrayLiteral);

data ArrayLiteral = array(list[Expr] expr);
// DDL
data Statement = setStatement(SetStatement setStmt);

data SetStatement = setStatementHive(list[HiveVar] hiveVarOpt, str id, SetValue setValue);

data HiveVar = hivevar();

data SetValue = unquotedSetValue(str unquotedSetValue);


// Functions
data Expr = function(Function functionCall,list[AnalyticFunctionClause] afClauseOpt);


data Function = countStar(list[AggParam] setQuantifierOpt);
data InBuiltFunction
  = analyticFunction(AnalyticFunction analyticFunction)
  | aggregateFunction(AggregateFunction aggregateFunction)
  | windowFunction(WindowFunction windowFunction)
  | conditionalFunction(ConditionalFunction conditionalFunction)
  | mathFunction(MathFunction mathFunction)
  | dateTimeFunction(DateTimeFunction dateTimeFunction)
  | stringFunction(StringFunction stringFunction)
  ;

data AggregateFunction
  = count(list[Distinct] distinct,  StarOrExpr starOrExpr)
  | min(list[Distinct] distinct, Expr expr)
  | max(list[Distinct] distinct, Expr expr)
  | sum(list[Distinct] distinct, Expr expr)
  | avg(list[Distinct] distinct, Expr expr)
  | arrayavg(list[Distinct] distinct, Expr expr)
  | listagg(list[Distinct] distinct, Expr expr, list[Separator] separator)
  ;

data Separator = separator(Expr expr);

data AnalyticFunction
  = rank()
  | rowNumber()
  | denseRank()
  | cumeDist()
  | percentRank()
  | ntile()
  ;

data DateTimeFunction
  = toDate(Expr expr)
  | toUtcTimestamp(Expr expr1, Expr expr2)
  | fromUtcTimestamp(Expr expr1,  Expr expr2)
  | fromUnixTimeOneParam(Expr expr)
  | fromUnixTimeTwoParam(Expr expr1,  Expr expr2)
  | unixTimestampNoParam()
  | unixTimestampOneParam(Expr expr)
  | unixTimestampTwoParam(Expr expr1,  Expr expr2)
  | dateSub(Expr expr1,  Expr expr2)
  | dateAdd(Expr expr1,  Expr expr2)
  | dateDiff(Expr expr1,  Expr expr2)
  | currentTimeStamp()
  | currentDate()
  | monthsBetween(Expr expr1,  Expr expr2)
  | month(Expr expr)
  | year(Expr expr)
  | addMonths(Expr expr1,  Expr expr2)
  ;

data StringFunction
  = regExpReplace(Expr expr1, Expr expr2, Expr expr3)
  | length(Expr expr)
  | concat(Expr expr1, list[Expr] exprlist)
  | instr(Expr expr1, Expr expr2)
  | substring(Expr expr1, Expr expr2)
  | substringWithEnd(Expr expr1, Expr expr2, Expr expr3)
  | substr(Expr expr1, Expr expr2)
  | substrWithEnd(Expr expr1, Expr expr2, Expr expr3)
  | upper(Expr expr)
  | uCase(Expr expr)
  | lower(Expr expr)
  | lCase(Expr expr)
  | getJsonObject(Expr expr1, Expr expr2)
  ;


data ConditionalFunction
  = nvlFunction(Expr expr1, Expr expr2)
  | ifFunction(Expr expr1, Expr expr2, Expr expr3)
  | coalesce(Expr expr1, list[Expr] exprlist)
  ;

data MathFunction
  = ceilFunction(Expr expr)
  | ceilingFunction(Expr expr)
  | exponent(Expr expr)
  ;

data WindowFunction
  = lead(Expr expr,  list[LeadLagOffSet] leadLagOffSet)
  | lag(Expr expr,  list[LeadLagOffSet] leadLagOffSet)
  | firstValue(Identifier identifier, list[CommaThenBoolean] commaThenBoolean)
  | lastValue(Identifier identifier, list[CommaThenBoolean] commaThenBoolean)
  ;


data LeadLagOffSet = leadLagOffSet(str \int,  list[LeadLagDefault] leadLagDefault);

data LeadLagDefault = leadLagDefault(Expr expr);

data CommaThenBoolean = commaThenBoolean(Boolean boolean);

data AnalyticFunctionClause = analyticFunctionClause(WindowSpecification windowSpecification);


// Query
data QueryExpr
  = queryHQL(QueryHQL queryHQL)
  ;


data QueryHQL
    = query(
        SelectClause selectClause
        , list[FromClause] fromClauseOpt
        , list[LateralView] lateralView
        , list[JoinClause] joinClauseOpt
        , list[WhereClause] whereClauseOpt
        , list[GroupByClause] groupByClauseOpt 
        , list[HavingClause] havingClauseOpt
        , list[OrderByClause] orderByClauseOpt
        , list[WindowClause] windowClauseOpt
        , list[LimitOffsetClauses] limitOffestOpt
        , list[QueryClusterByClause] queryClusterByClauseOpt
    )
    ;



data LateralView
  = lateralView(list[Outer] outerOpt, Function functionCall, Identifier identifier,  list[Identifier] idList)
  ;



data SelectClause
  = transform(
        list[Expr] expr
        , list[RowFormatClause] rowFormatCls1
        , str strConst
        , list[TransformColumnSpecification] transformColumnSpecification
        , list[RowFormatClause] rowFormatCls2
        , list[RecordReaderClause] recordReader
    )
  ;


data TransformColumnSpecification = transformColumnSpecification(Identifier identifier, list[DataType] datatype);

