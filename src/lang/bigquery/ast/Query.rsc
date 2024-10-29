module lang::bigquery::ast::Query


extend lang::bigquery::ast::Expressions;

// Misc.
data FromTimestamp = fromTimestamp(Expr expr);

// Query
data QueryExpr
    = queryBigquery(QueryBigquery queryBigquery)
    | queryExceptDistinct(QueryExpr qryexpr1, ExceptDistinct exceptDistinct, QueryExpr qryexpr2)
    ;

data QueryBigquery 
    = query(
        SelectClause selectCls
        , list[FromClause] fromCls
        , list[SortedByClause] sortedByClauseOpt
        , list[TableSampleOperator] tblSampleOpt
        , list[PivotUnpivot] pivotUnpivotOpt
        , list[JoinClause] joinCls
        , list[WhereClause] whereCls
        , list[GroupByClause] groupCls 
        , list[HavingClause] havingCls
        , list[QualifyClause] qualifyClause
        , list[WindowClause] windowCls 
        , list[OrderByClause] orderByCls 
        , list[LimitOffsetClauses] limitOffsetCls
    )
    ;

data ExceptDistinct = exceptDistinct();

data QualifyClause = qualifyClause(Expr exp);


data TableIdOrSubquery 
    = tableIdOrSubquerySubqueryNoId(QueryOrWith qryOrWith)
    | subqueryWithAsId(QueryOrWith qryOrWith, Identifier id)
    | tableIdWithAsId(TableName tblName, Identifier id)
    | unnestOperatorWithAs(UnnestOptions unnestedOpts, list[VarAssign] varAssignOpt, list[UnnestWithOffset] unnestWithOffsetOpt)
    ;


data TableSampleOperator = tableSample(str integer);

data UnnestWithOffset =withOffset(list[VarAssign] varAssignOpt);

data UnnestOptions
    = unnestExp(Expr array_expression) 
    | unnestPath(Path array_path)
    ;


data Path = path(list[PathExpr] pathExpr);


data PathExpr = pathExpr(list[Identifier] id, SubsequentPart subsequentPart, list[PathExtra] pathExtra);

data PathExtra = pathExtra(SubPre, SubsequentPart);

data SubPre = slash() | colon() | hyphen();


data SubsequentPart = id(Identifier id) | number(Expr lit);



data ExpAsVarOrStar 
    = tableNameDotStar(TableName tblName, SelectExcept selectExcept)
    | tableNameDotStar(TableName tblName, list[SelectExcept] selectExceptOpt, SelectReplace)
    | projectionStar(SelectExcept selectExcept)
    | projectionStar(list[SelectExcept] selectExceptOpt, SelectReplace)
    ;



data SelectExcept = selectExcept(list[Identifier] idList);
data SelectReplace = selectReplace(list[ExpAsVarStrict2] expAsVarList);

data SelectClause 
    = selectClause(list[DiffPrivacyclause] diffPrivacyClsOpt,list[SetQuantifier] setQuantifierOpt, StructOrValue structOrVal, Projection proj)
    | selectClauseDiffPrivacyclause(DiffPrivacyclause diffPrivacyCls,list[SetQuantifier] setQuantifierOpt, Projection proj)
    ;


data DiffPrivacyclause = diffPrivacyClause(PrivacyParams privParams);

data PrivacyParams = privacyParams(Expr exp1, Expr exp2, list[OptionalParam] optionalParam, Identifier);

data OptionalParam = optionalParam(Expr exp);


data StructOrValue = struct() |  \value();



data PivotUnpivot 
    = pivot(lrel[AggregateFunction aggfunc,list[str] pa] agg,ColList collist,lrel[ExpressionList explist,list[str] pa] exl)
    | unpivot( list[IncludeorEx] incoex , ValueColumnUnpivot valcolun, list[str] pa)
    ;




data LateralView
    = lateralView(list[Outer] outerOpt, FunctionCall functionCall, Identifier identifier,  list[Identifier] idList)
    ;


data ValueColumnUnpivot = valueColumnUnpivot(ColList collist, str nameVal,lrel[ExpressionList explist,list[str] pa] exl);

data ExpressionList = singleExpr(str exp) | multiple(list[Expr] exps);


data ColList = singleCol(str) | multiple(list[str] ids);



data IncludeorEx = include()| exclude();



data JoinCondition = onUsingClause(Expr column_list);


data JoinClause = outerJoinClause(OuterType outerType, list[Outer] outerOpt, TableIdOrSubquery tblOrSubqry, list[JoinClause] joinclsOpt);


data GroupByClause 
    = groupSetSpecs(GroupSet groupSet)
    | rollupSpecs(GroupRollup groupRollUp)
    | cubeSpecs(GroupCube groupCube)
    | groupBracket()
    ;


data GroupSet = groupSet(list[GroupList] grouplist);

data GroupList 
    = listrollup(GroupRollup groupRollUp)
    | listCube(GroupCube groupCube)
    | groupListItem(ExprOrComposite exprOrCompsite)
    ;



data GroupRollup = groupRollup(list[Expr] expr) ;

data GroupCube = groupCube(list[ExprOrComposite] exprOrComposite) ;


data OrderElem
    = orderExprNullsOptions(Expr expr, NullsOptions nullOptions)
    | ascNullOptions(Expr expr, NullsOptions nullOptions)
    | descNullsOptions(Expr expr, NullsOptions nullOptions)
    ;


data NullsOptions 
    = nullsfirst()
    | nullslast()
    ;


data WithClause = withRecursiveClause();



data CTEClause = cteClauseNotQuery(Identifier, Expr expr);