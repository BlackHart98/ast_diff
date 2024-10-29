module lang::redshift::ast::Query

extend lang::basesql::ast::BaseSQL;

// Expr
data Expr
    = uPlus(Expr expr)
    | absoluteVal(Expr expr)
    | expo(Expr lhs, Expr rhs)
    | squareRoot(Expr lhs, Expr rhs)
    | cubeRoot(Expr lhs, Expr rhs)
    | and2(Expr lhs, Expr rhs)
    | or2(Expr lhs, Expr rhs)
    | not2(Expr lhs, Expr rhs)
    | shiftleft(Expr lhs, Expr rhs)
    | shiftright(Expr lhs, Expr rhs)
    | bitwiseNot(Expr expr)
    | anyCond(Expr lhs, Expr rhs)
    | someCond(Expr lhs, Expr rhs)
    | isTrue(Expr expr)
    | isFalse(Expr expr)
    | isUnknown(Expr expr)
    | likeEsc(Expr lhs, Expr rhs, EscapeChar escapeChar)
    | notlikeEsc(Expr lhs, Expr rhs, EscapeChar escapeChar)
    | ilike(Expr lhs, Expr rhs, list[EscapeChar] escapeCharOpt)
    | notilike(Expr lhs, Expr rhs, list[EscapeChar] escapeCharOpt)
    | notbetween(Expr expr1, Expr expr2, Expr expr3)
    | similar(Expr expr1, list[Not] notOpt, Expr expr2, list[EscapeChar] escapeCharOpt)
    | posix(Expr expr1, Expr expr2)
    | posixnot(Expr lhs, Expr rhs)
    | inPredicate(Expr expr1, list[Not] notOpt, ArrayLiteral arrayLiteral)
    | miscExpr(MiscExpr miscExpr)
    ;


data MiscExpr = miscTablename(TableName tblName) | defaultExp();

data EscapeChar = escapeChar(Expr expr);


data ArrayLiteral = array(list[Expr] exprList);

data PrimitiveType = integerType() | numericType();

// Functions
data Expr = function(FunctionCall funcCall);
data FunctionCall = inBuiltFunction(InBuiltFunction inBuiltFunction, list[AnalyticFunctionClause] analyticFuncCls);
data InBuiltFunction = aggregateFunction(AggregateFunction aggrFunc);
data FunctionCall 
  = udf(list[PackageName] pkgNameOpt,  str funcName, list[Expr] params, list[AnalyticFunctionClause] analyticFuncCls)
  ;

data AnalyticFunctionClause = analyticFunctionClause(WindowSpecification windowSpec);

data AggregateFunction
    = anyvalue(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | approximatePercentileDisc(Expr expr, WithinGroup withinGroup)
    | avg(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | countAll()
    | count(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | approximatecount(SetQuantifier setQuantifier, Expr expr)
    | listagg(list[SetQuantifier] setQuantifierOpt, Expr expr, WithinGroup withinGroup)
    | max(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | median(Expr expr)
    | min(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | percentileCont(Expr expr, WithinGroup withinGroup)
    | stddev(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | stddevSamp(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | stddevpop(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | variance(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | varsamp(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | varPop(list[SetQuantifier] setQuantifierOpt, Expr expr)
    | sum(list[SetQuantifier] setQuantifierOpt, Expr expr)
    ;

data WithinGroup = withinGroup(Expr expr);



// Query
data Subquery = subqueryWithClause(QueryOrWith qryOrWith);
data WithClause = withRecursiveClause();
data CTEClause = cteClauseRecursive(Identifier id1, list[Identifier] idList, QueryOrWith qryOrWith);


data QueryExpr
  = queryRedshift(QueryRedshift queryRedshift)
  ;

data QueryRedshift 
    = query(
      SelectClause selectCls
      , list[IntoTable] intoTableOpt
      , list[FromClause] fromClsOpt
      , list[SortedByClause] sortedByClsOpt
      , list[PivotUnpivot] pivotUnpivotOpt
      , list[JoinClause] joinClsOpt
      , list[WhereClause] whereClsOpt
      , list[StartAndConnect] startAndConnectOpt
      , list[GroupByClause] groupClsOpt
      , list[HavingClause] havingClsOpt
      , list[QualifyClause] qualifyClsOpt
      , list[WindowClause] windowClsOpt
      , list[OrderByClause] orderByClsOpt
      , list[LimitOffsetClauses] limitOffsetClsOpt
      , list[QueryClusterByClause] queryClusterByClsOpt
    )
    ;



data SelectClause = selectClauseWithTop(TopNumber topNumber, list[SetQuantifier] setQuantifierOpt, Projection projection);
data TopNumber = topNumber(str integer);
data PivotUnpivot = pivot(PivotOperator pivotOperator) | unpivot(UnpivotOperator unpivotOperator);

data IntoTable = intoTable(list[TempVariant] tempVariantOpt, list[Table] tableOpt, TableName tblName);

data TempVariant = temp() | temporary();


data PivotOperator = pivotOperator(ExpAsVar expAsVar, Identifier id, list[ExpAsVar] expAsVarList, list[VarAssign] varAssignList);



data StartAndConnect = startAndConnect(list[StartWith] startWithOpt1, ConnectOperators connectOperators,  Expr expr, list[StartWith] startWithOpt2);
data StartWith = startWith(Expr expr);
data ConnectOperators = level() | prior();


data TableIdOrSubquery 
    = subqueryNoId(Query qry)
    | tableWithStringId(TableName tblName, list[str] optAs, str strLit)
    | subqueryWithString(Query qry, list[str] optAs, str strLit) 
    ;


data TableIdOrSubquery
    = subqueryWithAs(Query qry, Identifier id, list[BracketColumnAlias] bracketColAliasOpt) 
    | tableIdWithAs(TableName tblName, Identifier id, list[BracketColumnAlias] bracketColAliasOpt)
    ;


data UnpivotOperator = unpivotOperator(list[AddNulls] addNulls, ColumnUnpivot columnPivot, list[VarAssign] varAssignOpt);


data ColumnUnpivot = singleUnpivot(Identifier id1, Identifier id2, list[ColumnsToUnpivot] colsToPivotList);
data ColumnsToUnpivot = toUnpivot(Expr expr, list[VarAssign] varAssignList);
data QualifyClause = qualifyClause(Expr expr);


data BracketColumnAlias = bracketColumnAlias(list[Identifier] ids);

data GroupByClause = groupByClauseSpecs(list[GroupSpecs] groupSpecsList);

data GroupSpecs = groupSetSpecs(GroupSet groupSet) | groupBracket();

data GroupSet = groupSet(list[GroupList] groupList);
data GroupList = groupListItem(Expr expr);
data GroupRollup = groupRollup(list[Expr] exprList);
data GroupCube = groupCube(list[Expr] exprList);


data AddNulls = includenulls() | excludenulls();

data JoinCondition = using(UsingClause usingClause);
data UsingClause = usingClause(Expr expr);