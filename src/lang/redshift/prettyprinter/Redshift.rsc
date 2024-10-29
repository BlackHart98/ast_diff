module lang::redshift::prettyprinter::Redshift

extend lang::basesql::prettyprint::BaseSQL;
extend lang::redshift::ast::Redshift;
import List;


// Redshift

public str toString(Redshift redShift) {
    switch(redShift) {
        case expression(Expr expr): return "<toString(expr)>";
        case statements(list[StatementWithTerminator] stmtWithTerminator): return "<intercalate("\n",[toString(stmt)|stmt<-stmtWithTerminator])>";
        default: throw "<redShift> not found";
    }
}

public str toString(StatementWithTerminator::statementWithTerminator(Statement stmt, list[Terminator] terminator)) = "<toString(stmt)> <intercalate("",[toString(termntr)|termntr<-terminator])>";

public str toString(Terminator::terminator()) = ";";

public str toString(Statement stmt) {
    switch(stmt) {
        case abort(list[WorkOrTransaction] workOrTransactionOpt): return "ABORT <intercalate("",[toString(workOrTransaction)|workOrTransaction<-workOrTransactionOpt])>";
        case analyze(list[str] verboseOpt, list[TableName] tblNameOpt, list[BracketCol] bracketColOpt, list[AnalyzeCols] analyzeColsOpt): return "ANALYZE <intercalate("",[verbose|verbose<-verboseOpt])> <intercalate("",[toString(tblName)|tblName<-tblNameOpt])> <intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])> <intercalate("",[toString(analyzeCols)|analyzeCols<-analyzeColsOpt])>";
        case analyzeCompression(list[TableName] tblNameOpt, list[BracketCol] bracketColOpt, list[Comprows] comprowsOpt): return "ANALYZE COMPRESSION <intercalate("",[toString(tblName)|tblName<-tblNameOpt])> <intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])> <intercalate("",[toString(comprows)|comprows<-comprowsOpt])>";
        case attachRlsPolicy(TableName tblName, list[str] tableOpt, list[TableName] tblNAmeList, list[str] toOpt, list[GrantTo] grantToList): return "ATTACH RLS POLICY <toString(tblName)> ON <intercalate("",[table|table<-tableOpt])> <intercalate(", ",[toString(tblNAme)|tblNAme<-tblNAmeList])> <intercalate("",[toStr|toStr<-toOpt])> <intercalate(", ",[toString(grantTo)|grantTo<-grantToList])>";
        case beginStatement(BeginStart beginStart, list[WorkOrTransaction] workOrTransactionOpt, list[IsolationLevel] isolationLevelOpt, list[ReadOpts] readOptsOpt): return "<toString(beginStart)> <intercalate("",[toString(workOrTransaction)|workOrTransaction<-workOrTransactionOpt])> <intercalate(", ",[toString(isolationLevel)|isolationLevel<-isolationLevelOpt])> <intercalate(", ",[toString(readOpts)|readOpts<-readOptsOpt])>";
        case call(TableName tblName, list[Expr] exprList): return "CALL <toString(tblName)> ( <intercalate(", ",[toString(expr)|expr<-exprList])> )";
        case cancel(Expr expr, list[str] strLitOpt): return "CANCEL <toString(expr)> <intercalate("",[strLit|strLit<-strLitOpt])>";
        case close(Expr expr): return "CLOSE <toString(expr)>";
        case comment(CommentOpts commentOpts, Expr expr): return "COMMENT ON <toString(commentOpts)> IS <toString(expr)>";
        case commit(list[WorkOrTransaction] workOrTransactionOpt): return "COMMIT <intercalate("",[toString(workOrTransaction)|workOrTransaction<-workOrTransactionOpt])>";
        case copy(TableName tblName, list[Expr] exprOpt, Expr expr, list[IamRole] iamRoleList, list[FormatAs] formatAsOpt): return "COPY <toString(tblName)> <intercalate("",[toString(exp)|exp<-exprOpt])> FROM <toString(expr)> <intercalate(" ",[toString(iamRole)|iamRole<-iamRoleList])> <intercalate("",[toString(formatAs)|formatAs<-formatAsOpt])>";
        case end(list[WorkOrTransaction] workOrTransactionOpt): return "END <intercalate("",[toString(workOrTransaction)|workOrTransaction<-workOrTransactionOpt])>";
        case deallocate(list[Prepare] prepareOpt, Identifier identifier): return "DEALLOCATE <intercalate("",[toString(prepare)|prepare<-prepareOpt])> <toString(identifier)>";
        case delete(
        list[WithClauseDel] withClauseDelOpt
        , list[FromWord] fromWordOpt
        , TableName tblName
        , list[UsingClause] usingClauseOpt
        , list[WhereClause] whereClauseOpt
        ): {
            return "<intercalate("",[toString(withClauseDel)|withClauseDel<-withClauseDelOpt])> DELETE <intercalate("",[toString(fromWord)|fromWord<-fromWordOpt])> <toString(tblName)> <intercalate("",[toString(usingClause)|usingClause<-usingClauseOpt])> <intercalate("",[toString(whereClause)|whereClause<-whereClauseOpt])>";
        }
        case declareCursor(Identifier id, Query qry): return "DECLARE <toString(id)> CURSOR FOR <toString(qry)>";
        case descDataShare(Identifier id, list[DtShNameSpace] dtShNameSpaceOpt): return "DESC DATASHARE <toString(id)> <intercalate("",[toString(dtShNameSpace)|dtShNameSpace<-dtShNameSpaceOpt])>";
        case descIDProvider(Identifier id): return "DESC IDENTITY PROVIDER <toString(id)>";
        case detachMaskingPolicy(Identifier id, TableName tblName, list[Identifier] idList, DetachMaskingPolicyNames detachMaskingPolicyNames): return "DETACH MASKING POLICY <toString(id)> ON <toString(tblName)> ( <intercalate(", ",[toString(id)|id<-idList])> ) FROM <toString(detachMaskingPolicyNames)>";
        case detachRLSPolicy(Identifier id, list[str] tblOpt, list[TableName] tblNameList, list[DetachMaskingPolicyNames] detachMaskingPolicyNamesList): return "DETACH RLS POLICY <toString(id)> ON <intercalate("",[tbl|tbl<-tblOpt])> <intercalate(", ",[toString(tblName)|tblName<-tblNameList])> FROM <intercalate(", ",[toString(detachMaskingPolicyNames)|detachMaskingPolicyNames<-detachMaskingPolicyNamesList])>";
        case insertWithValue(InsertWithValue insertWithVal): return toString(insertWithVal);
        case mergeStatement(TableName tblName1, TableName tblName2, list[VarAssign] varAssignOpt, Expr expr, list[MergeOpts] mergerOptsOpt): {
            return "MERGE INTO <toString(tblName1)> USING <toString(tblName2)> <intercalate("",[toString(varAssign)|varAssign<-varAssignOpt])> ON " +
            "<toString(expr)> <intercalate("",[toString(merger)|merger<-mergerOptsOpt])>";
        }
        case refreshMaterialized(TableName tblName): {
           return "REFRESH MATERIALIZED VIEW <toString(tblName)>";
        } 
        case reset(NameOrAll nameOrAll): {
           return "RESET <toString(nameOrAll)>";
        }
        case rollback(list[WorkOrTransaction] workOrTransactionOpt): {
           return "ROLLBACK <intercalate("",[toString(workOrTransaction)|workOrTransaction<-workOrTransactionOpt])>";
        }
        case revoke(
        list[GrantOptFor] grantOptForOpt
        , GrantOpts grantOpts
        , list[GrantFor] grantForOpt
        , list[GrantOnStmt] grantOnStmtOpt
        , list[GrantToStmt] grantToStmtOpt
        , list[str] restrictOpt
        ): {
           return "REVOKE <intercalate("",[toString(grantOptFor)|grantOptFor<-grantOptForOpt])> <toString(grantOpts)> <intercalate("",[toString(grantFor)|grantFor<-grantForOpt])> <intercalate("",[toString(grantOnStmt)|grantOnStmt<-grantOnStmtOpt])> <intercalate("",[toString(grantToStmt)|grantToStmt<-grantToStmtOpt])> <intercalate("",[restrict|restrict<-restrictOpt])>";
        } 
        case setStatement(SetOptions setOptions): {
           return "SET <toString(setOptions)>";
        }
        case setSessionAuth(list[str] localOpt, Expr expr): {
           return "SET <intercalate("",[local|local<-localOpt])> SESSION AUTHORIZATION <toString(expr)>";
        }
        default: throw "<stmt> not found";
    }
}

public str toString(Comprows::comprows(Expr expr)) = "COMPROWS <toString(expr)>";

public str toString(FromWord::fromWord()) = "FROM";

public str toString(AnalyzeCols::predicateCol()) = "PREDICATE COLUMNS";

public str toString(AnalyzeCols::allColumns()) = "ALL COLUMNS";

public str toString(BeginStart::begin()) = "BEGIN";

public str toString(BeginStart::\start()) = "START";

public str toString(ReadOpts::readwrite()) = "READ WRITE";

public str toString(ReadOpts::readonly()) = "READ ONLY";

public str toString(CommentOpts::commentTable(TableName tblName)) = "TABLE <toString(tblName)>";

public str toString(CommentOpts::commentColumn(TableName tblName)) = "COLUMN <toString(tblName)>";

public str toString(CommentOpts::comment(TableName tblName1, TableName tblName2)) = "CONSTRAINT <toString(tblName1)> ON <toString(tblName2)>";

public str toString(CommentOpts::commentDatabase(TableName tblName)) = "DATABASE <toString(tblName)>";

public str toString(CommentOpts::commentView(TableName tblName)) = "VIEW <toString(tblName)>";

public str toString(FormatAs::formatAs(list[str] asOpt, Expr expr)) = "<intercalate("",[asStr|asStr<-asOpt])> <toString(expr)>";

public str toString(Prepare::prepare()) = "PREPARE";

public str toString(DtShNameSpace::dtShNamespace(list[AccountId] accountIdOpt, Identifier id)) = "OF <intercalate("",[toString(accountId)|accountId<-accountIdOpt])> NAMESPACE <toString(id)>";

public str toString(WithClauseDel::withClauseDel(WithClause withClause, list[CTEClause] cteClauseList)) = "<toString(withClause)> <intercalate(", ",[toString(cteClause)|cteClause<-cteClauseList])>";

public str toString(DetachMaskingPolicyNames::username(Identifier id)) = "<toString(id)>";

public str toString(DetachMaskingPolicyNames::roleNameType(Identifier id)) = "ROLE <toString(id)>";

public str toString(DetachMaskingPolicyNames::publicNameType()) = "PUBLIC";

// Expressions

public str toString(Expr::uPlus(Expr expr)) = "+ <toString(expr)>";
public str toString(Expr::absoluteVal(Expr expr)) = "@ <toString(expr)>";
public str toString(Expr::expo(Expr lhs, Expr rhs)) = "<toString(lhs)> ^ <toString(rhs)>";
public str toString(Expr::squareRoot(Expr lhs, Expr rhs)) = "<toString(lhs)> |/ <toString(rhs)>";
public str toString(Expr::cubeRoot(Expr lhs, Expr rhs)) = "<toString(lhs)> ||/ <toString(rhs)>";
public str toString(Expr::and2(Expr lhs, Expr rhs)) = "<toString(lhs)> & <toString(rhs)>";
public str toString(Expr::or2(Expr lhs, Expr rhs)) = "<toString(lhs)> | <toString(rhs)>";
public str toString(Expr::not2(Expr lhs, Expr rhs)) = "<toString(lhs)> # <toString(rhs)>";
public str toString(Expr::shiftleft(Expr lhs, Expr rhs)) = "<toString(lhs)> \<\< <toString(rhs)>";
public str toString(Expr::shiftright(Expr lhs, Expr rhs)) = "<toString(lhs)> \>\> <toString(rhs)>";
public str toString(Expr::bitwiseNot(Expr expr)) = "~ <toString(expr)>";
public str toString(Expr::anyCond(Expr lhs, Expr rhs)) = "<toString(lhs)> = ANY ( <toString(rhs)> )";
public str toString(Expr::someCond(Expr lhs, Expr rhs)) = "<toString(lhs)> = SOME ( <toString(rhs)> )";
public str toString(Expr::isTrue(Expr expr)) = "<toString(expr)> IS TRUE";
public str toString(Expr::isFalse(Expr expr)) = "<toString(expr)> IS FALSE";
public str toString(Expr::isUnknown(Expr expr)) = "<toString(expr)> IS UNKNOWN";
public str toString(Expr::likeEsc(Expr lhs, Expr rhs, EscapeChar escapeChar)) = "<toString(lhs)> LIKE <toString(rhs)> <toString(escapeChar)>";
public str toString(Expr::notlikeEsc(Expr lhs, Expr rhs, EscapeChar escapeChar)) = "<toString(lhs)> NOT LIKE <toString(rhs)> <toString(escapeChar)>";
public str toString(Expr::ilike(Expr lhs, Expr rhs, list[EscapeChar] escapeCharOpt)) = "<toString(lhs)> ILIKE <toString(rhs)> <intercalate("",[toString(escapeChar)|escapeChar<-escapeCharOpt])>";
public str toString(Expr::notilike(Expr lhs, Expr rhs, list[EscapeChar] escapeCharOpt)) = "<toString(lhs)> NOT ILIKE <toString(rhs)> <intercalate("",[toString(escapeChar)|escapeChar<-escapeCharOpt])>";
public str toString(Expr::notbetween(Expr expr1, Expr expr2, Expr expr3)) = "<toString(expr1)> NOT BETWEEN <toString(expr2)> AND <toString(expr3)>";
public str toString(Expr::similar(Expr expr1, list[Not] notOpt, Expr expr2, list[EscapeChar] escapeCharOpt)) = "<toString(expr1)> <intercalate("",[prettyNot(notWord)|notWord<-notOpt])> SIMILAR TO <toString(expr2)> <intercalate("",[toString(escapeChar)|escapeChar<-escapeCharOpt])>";
public str toString(Expr::posix(Expr expr1, Expr expr2)) = "<toString(expr1)> ~ <toString(expr2)>";
public str toString(Expr::posixnot(Expr lhs, Expr rhs)) = "<toString(lhs)> !~ <toString(rhs)>";
public str toString(Expr::inPredicate(Expr expr1, list[Not] notOpt, ArrayLiteral arrayLiteral)) = "<toString(expr1)> <intercalate("",[prettyNot(notWord)|notWord<-notOpt])> IN <toString(arrayLiteral)>";
public str toString(Expr::miscExpr(MiscExpr miscExpr)) = "<toString(miscExpr)>";


public str toString(MiscExpr::miscTablename(TableName tblName)) = "<toString(tblName)>(+)";
public str toString(MiscExpr::defaultExp()) = "DEFAULT";

public str toString(EscapeChar::escapeChar(Expr expr)) = "ESCAPE <toString(expr)>";

public str toString(ArrayLiteral::array(list[Expr] exprList)) = "( <intercalate(", ",[toString(expr)|expr<-exprList])> )";

public str toString(PrimitiveType::integerType()) = "INTEGER";
public str toString(PrimitiveType::numericType()) = "NUMERIC";

// Functions

public str toString(Expr::function(FunctionCall funcCall)) = "<toString(funcCall)>";

public str toString(FunctionCall::inBuiltFunction(InBuiltFunction inBuiltFunction, list[AnalyticFunctionClause] analyticFuncCls)) = "<toString(inBuiltFunction)> <intercalate("",[toString(analyticFunc)|analyticFunc<-analyticFuncCls])>";

public str toString(InBuiltFunction::aggregateFunction(AggregateFunction aggrFunc)) = "<toString(aggrFunc)>";

public str toString(FunctionCall::udf(list[PackageName] pkgNameOpt,  str funcName, list[Expr] params, list[AnalyticFunctionClause] analyticFuncCls)) = "<intercalate("",[toString(pkgName)|pkgName<-pkgNameOpt])> <funcName>( <intercalate(", ",[toString(expr)|expr<-params])> ) <intercalate("",[toString(analyticFunc)|analyticFunc<-analyticFuncCls])>";

public str toString(AnalyticFunctionClause::analyticFunctionClause(WindowSpecification windowSpec)) = "OVER <toString(windowSpec)>";

public str toString(AggregateFunction::anyvalue(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "ANY_VALUE ( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)>)";

public str toString(AggregateFunction::approximatePercentileDisc(Expr expr, WithinGroup withinGroup)) = "APPROXIMATE PERCENTILE_DISC ( <toString(expr)> ) <toString(withinGroup)>";

public str toString(AggregateFunction::avg(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "AVG( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)>)";

public str toString(AggregateFunction::countAll()) = "COUNT(*)";

public str toString(AggregateFunction::count(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "COUNT( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)>)";

public str toString(AggregateFunction::approximatecount(SetQuantifier setQuantifier, Expr expr)) = "APPROXIMATE COUNT( <toString(setQuantifier)> <toString(expr)> )";

public str toString(AggregateFunction::listagg(list[SetQuantifier] setQuantifierOpt, Expr expr, WithinGroup withinGroup)) = "LISTAGG( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> ) <toString(withinGroup)>";

public str toString(AggregateFunction::max(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "MAX( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::median(Expr expr)) = "MEDIAN( <toString(expr)> )";

public str toString(AggregateFunction::min(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "MIN( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::percentileCont(Expr expr, WithinGroup withinGroup)) = "PERCENTILE_CONT( <toString(expr)> ) <toString(withinGroup)>";

public str toString(AggregateFunction::stddev(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "STDDEV( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::stddevSamp(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "STDDEV_SAMP( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::stddevpop(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "STDDEV_POP( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::variance(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "VARIANCE( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::varsamp(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "VAR_SAMP( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::varPop(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "VAR_POP( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(AggregateFunction::sum(list[SetQuantifier] setQuantifierOpt, Expr expr)) = "SUM( <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(expr)> )";

public str toString(WithinGroup::withinGroup(Expr expr)) = "WITHIN GROUP ( ORDER BY <toString(expr)> )";


// Query

public str toString(Subquery::subqueryWithClause(QueryOrWith qryOrWith)) = "( <toString(qryOrWith)> )";

public str toString(WithClause::withRecursiveClause()) = "WITH RECURSIVE";

public str toString(CTEClause::cteClauseRecursive(Identifier id1, list[Identifier] idList, QueryOrWith qryOrWith)) = "<toString(id1)>( <intercalate(", ",[toString(id)|id<-idList])> ) AS ( <toString(qryOrWith)> )";

public str toString(Query::queryWithPivotUnpivot(
      SelectClause selectCls
      , list[IntoTable] intoTableOpt
      , list[FromClause] fromClsOpt
      , list[SortedByClause] sortedByClsOpt
      , PivotUnpivot pivotUnpivot
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
    )) 
    = "<toString(selectCls)> <intercalate("",[toString(intoTable)|intoTable<-intoTableOpt])> <intercalate("",[toString(fromCls)|fromCls<-fromClsOpt])> " + 
    "<intercalate("",[toString(sortedByCls)|sortedByCls<-sortedByClsOpt])> <toString(pivotUnpivot)> <intercalate("",[toString(joinCls)|joinCls<-joinClsOpt])> <intercalate("",[toString(whereCls)|whereCls<-whereClsOpt])> " + 
    "<intercalate("",[toString(startAndConnect)|startAndConnect<-startAndConnectOpt])> <intercalate("",[toString(groupCls)|groupCls<-groupClsOpt])> <intercalate("",[toString(havingCls)|havingCls<-havingClsOpt])> " + 
    "<intercalate("",[toString(qualifyCls)|qualifyCls<-qualifyClsOpt])> <intercalate("",[toString(windowCls)|windowCls<-windowClsOpt])> " + 
    "<intercalate("",[toString(orderByCls)|orderByCls<-orderByClsOpt])> <intercalate("",[toString(limitOffsetCls)|limitOffsetCls<-limitOffsetClsOpt])> <intercalate("",[toString(queryClusterByCls)|queryClusterByCls<-queryClusterByClsOpt])>";

public str toString(Query::query(
      SelectClause selectCls
      , list[IntoTable] intoTableOpt
      , list[FromClause] fromClsOpt
      , list[SortedByClause] sortedByClsOpt
      , list[JoinClause] joinClsOpt
      , list[WhereClause] whereClsOpt
      , list[StartAndConnect] startAndConnectOpt
      , list[GroupByClause] groupClsOpt
      , list[HavingClause] havingClsOpt
      , QualifyClause qualifyCls
      , list[WindowClause] windowClsOpt
      , list[OrderByClause] orderByClsOpt
      , list[LimitOffsetClauses] limitOffsetClsOpt
      , list[QueryClusterByClause] queryClusterByClsOpt
    )) 
    = "<toString(selectCls)> <intercalate("",[toString(intoTable)|intoTable<-intoTableOpt])> <intercalate("",[toString(fromCls)|fromCls<-fromClsOpt])> " + 
    "<intercalate("",[toString(sortedByCls)|sortedByCls<-sortedByClsOpt])> <intercalate("",[toString(joinCls)|joinCls<-joinClsOpt])> <intercalate("",[toString(whereCls)|whereCls<-whereClsOpt])> " + 
    "<intercalate("",[toString(startAndConnect)|startAndConnect<-startAndConnectOpt])> <intercalate("",[toString(groupCls)|groupCls<-groupClsOpt])> <intercalate("",[toString(havingCls)|havingCls<-havingClsOpt])> " + 
    "<toString(qualifyCls)> <intercalate("",[toString(windowCls)|windowCls<-windowClsOpt])> " + 
    "<intercalate("",[toString(orderByCls)|orderByCls<-orderByClsOpt])> <intercalate("",[toString(limitOffsetCls)|limitOffsetCls<-limitOffsetClsOpt])> <intercalate("",[toString(queryClusterByCls)|queryClusterByCls<-queryClusterByClsOpt])>";

public str toString(Query::queryWithStartAndConnect(
      SelectClause selectCls
      , list[IntoTable] intoTableOpt
      , list[FromClause] fromClsOpt
      , list[SortedByClause] sortedByClsOpt
      , list[JoinClause] joinClsOpt
      , list[WhereClause] whereClsOpt
      , StartAndConnect startAndConnect
      , list[GroupByClause] groupClsOpt
      , list[HavingClause] havingClsOpt
      , list[WindowClause] windowClsOpt
      , list[OrderByClause] orderByClsOpt
      , list[LimitOffsetClauses] limitOffsetClsOpt
      , list[QueryClusterByClause] queryClusterByClsOpt
    )) 
    = "<toString(selectCls)> <intercalate("",[toString(intoTable)|intoTable<-intoTableOpt])> <intercalate("",[toString(fromCls)|fromCls<-fromClsOpt])> " + 
    "<intercalate("",[toString(sortedByCls)|sortedByCls<-sortedByClsOpt])> <intercalate("",[toString(joinCls)|joinCls<-joinClsOpt])> <intercalate("",[toString(whereCls)|whereCls<-whereClsOpt])> " + 
    "<toString(startAndConnect)> <intercalate("",[toString(groupCls)|groupCls<-groupClsOpt])> <intercalate("",[toString(havingCls)|havingCls<-havingClsOpt])> " + 
    "<intercalate("",[toString(windowCls)|windowCls<-windowClsOpt])> <intercalate("",[toString(orderByCls)|orderByCls<-orderByClsOpt])> " +
    "<intercalate("",[toString(limitOffsetCls)|limitOffsetCls<-limitOffsetClsOpt])> <intercalate("",[toString(queryClusterByCls)|queryClusterByCls<-queryClusterByClsOpt])>";

public str toString(SelectClause::selectClauseWithTop(TopNumber topNumber, list[SetQuantifier] setQuantifierOpt, Projection projection)) = "SELECT <toString(topNumber)> <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierOpt])> <toString(projection)>";

public str toString(TopNumber::topNumber(str integer)) = "TOP <integer>";

public str toString(PivotUnpivot::pivot(PivotOperator pivotOperator)) = "<toString(pivotOperator)>";

public str toString(PivotUnpivot::unpivot(UnpivotOperator unpivotOperator)) = "<toString(unpivotOperator)>";

public str toString(IntoTable::intoTable(list[TempVariant] tempVariantOpt, list[Table] tableOpt, TableName tblName)) = "INTO <intercalate("",[toString(tempVariant)|tempVariant<-tempVariantOpt])> <intercalate("",[toString(table)|table<-tableOpt])> <toString(tblName)>";

public str toString(TempVariant::temp()) = "TEMP";

public str toString(TempVariant::temporary()) = "TEMPORARY";

public str toString(PivotOperator::pivotOperator(ExpAsVar expAsVar, Identifier id, list[ExpAsVar] expAsVarList, list[VarAssign] varAssignList)) = "PIVOT ( <toString(expAsVar)> FOR <toString(id)> IN ( <intercalate(", ",[toString(expAs)|expAs<-expAsVarList])> ) ) <intercalate(", ",[toString(varAssign)|varAssign<-varAssignList])>";

public str toString(StartAndConnect::startAndConnect(list[StartWith] startWithOpt1, ConnectOperators connectOperators,  Expr expr, list[StartWith] startWithOpt2)) = "<intercalate("",[toString(startWithOpt)|startWithOpt<-startWithOpt1])> CONNECT BY <toString(connectOperators)> <toString(expr)> <intercalate("",[toString(startWith2)|startWith2<-startWithOpt2])>";

public str toString(StartWith::startWith(Expr expr)) = "START WITH <toString(expr)>";

public str toString(ConnectOperators::level()) = "LEVEL";

public str toString(ConnectOperators::prior()) = "PRIOR";

public str toString(TableIdOrSubquery::subqueryNoId(Query qry)) = "( <toString(qry)> )";

public str toString(TableIdOrSubquery::tableWithStringId(TableName tblName, list[str] optAs, str strLit)) = "<toString(tblName)> <intercalate("",[asWord|asWord<-optAs])> <strLit>";

public str toString(TableIdOrSubquery::subqueryWithString(Query qry, list[str] optAs, str strLit)) = "( <toString(qry)> ) <intercalate("",[asWord|asWord<-optAs])> <strLit>";

public str toString(TableIdOrSubquery::subqueryWithAs(Query qry, Identifier id, list[BracketColumnAlias] bracketColAliasOpt)) = "( <toString(qry)> ) AS <toString(id)> <intercalate("",[toString(bracketColAlias)|bracketColAlias<-bracketColAliasOpt])>";

public str toString(TableIdOrSubquery::tableIdWithAs(TableName tblName, Identifier id, list[BracketColumnAlias] bracketColAliasOpt)) = "<toString(tblName)> AS <toString(id)> <intercalate("",[toString(bracketColAlias)|bracketColAlias<-bracketColAliasOpt])>";

public str toString(UnpivotOperator::unpivotOperator(list[AddNulls] addNulls, ColumnUnpivot columnPivot, list[VarAssign] varAssignOpt)) = "UNPIVOT <intercalate("",[toString(addNull)|addNull<-addNulls])> ( <toString(columnPivot)> ) <intercalate("",[toString(varAssign)|varAssign<-varAssignOpt])>";

public str toString(ColumnUnpivot::singleUnpivot(Identifier id1, Identifier id2, list[ColumnsToUnpivot] colsToPivotList)) = "<toString(id1)> FOR <toString(id2)> IN ( <intercalate(", ",[toString(colsToPivot)|colsToPivot<-colsToPivotList])> )";

public str toString(ColumnsToUnpivot::toUnpivot(Expr expr, list[VarAssign] varAssignList)) = "<toString(expr)> <intercalate(", ",[toString(varAssign)|varAssign<-varAssignList])>";

public str toString(QualifyClause::qualifyClause(Expr expr)) = "QUALIFY <toString(expr)>";

public str toString(BracketColumnAlias::bracketColumnAlias(list[Identifier] ids)) = "( <intercalate(", ",[toString(id)|id<-ids])> )";

public str toString(GroupByClause::groupByClauseSpecs(list[GroupSpecs] groupSpecsList)) = "GROUP BY <intercalate(", ",[toString(groupSpecs)|groupSpecs<-groupSpecsList])>";

public str toString(GroupSpecs::groupSetSpecs(GroupSet groupSet)) = "<toString(groupSet)>";

public str toString(GroupSpecs::groupBracket()) = "( )";

public str toString(GroupSet::groupSet(list[GroupList] groupList)) = "GROUPING SETS ( <intercalate(", ",[toString(group)|group<-groupList])> )";

public str toString(GroupList::groupListItem(Expr expr)) = "<toString(expr)>";

public str toString(GroupRollup::groupRollup(list[Expr] exprList)) = "ROLLUP ( <intercalate(", ",[toString(expr)|expr<-exprList])> )";

public str toString(GroupCube::groupCube(list[Expr] exprList)) = "CUBE ( <intercalate(", ",[toString(expr)|expr<-exprList])> )";

public str toString(AddNulls::includenulls()) = "INCLUDE NULLS";

public str toString(AddNulls::excludenulls()) = "EXCLUDE NULLS";

public str toString(JoinCondition::using(UsingClause usingClause)) = "<toString(usingClause)>";

public str toString(UsingClause::usingClause(Expr expr)) = "USING <toString(expr)>";

// DML

public str toString(InsertWithValue::intoValue(TableName tblName, list[BracketCol] bracketColOpt, list[InsertOpts] insertOptsOpt)) 
    = "INSERT INTO <toString(tblName)> <intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])> <intercalate(", ",[toString(insertOpts)|insertOpts<-insertOptsOpt])>";

public str toString(GrantOptFor::grantOptionFor()) = "GRANT OPTION FOR";

public str toString(WorkOrTransaction::work()) = "WORK";

public str toString(WorkOrTransaction::transaction()) = "TRANSACTION";

public str toString(NameOrAll::nameopt(TableName tblName)) = "<toString(tblName)>";

public str toString(NameOrAll::allopt()) = "ALL";

public str toString(InsertOpts::defvalue()) = "DEFAULT VALUES";

public str toString(InsertOpts::valExpr(list[ArrayLiteral] arrayLitList)) = "VALUES <intercalate(", ",[toString(arrayLit)|arrayLit<-arrayLitList])>";

public str toString(MergeOpts::mergeOpts(MatchedOpts matchedOpts1, MatchedOpts matchedOpts2)) = "WHEN MATCHED THEN <toString(matchedOpts1)> WHEN NOT MATCHED THEN INSERT <toString(matchedOpts2)>";

public str toString(MatchedOpts::thenupdate(Expr expr1, list[Expr] exprList)) = "UPDATE SET <toString(expr1)> = <intercalate(", ",[toString(expr)|expr<-exprList])>";

public str toString(MatchedOpts::thenDelete()) = "DELETE";

public str toString(MatchedOpts::thenVals(list[BracketCol] bracketColOpt, list[Expr] exprList)) = "<intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])> VALUES( <intercalate(", ",[toString(expr)|expr<-exprList])> )";

public str toString(MatchedOpts::thenRemove()) = "REMOVE DUPLICATES";

public str toString(GrantOpts::grantExpr(list[Expr] exprList, list[BracketCol] bracketColOpt)) = "<intercalate(", ",[toString(expr)|expr<-exprList])> <intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])>";

public str toString(GrantOpts::allPrivileges(Privilege privilege, list[BracketCol] bracketColOpt)) = "<toString(privilege)> <intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])>";

public str toString(GrantOpts::usage()) = "USAGE";

public str toString(GrantOpts::grantModel()) = "CREATE MODEL";

public str toString(GrantOpts::grantExplain()) = "EXPLAIN RLS";

public str toString(GrantOpts::grantInclude()) = "INCLUDE RLS";

public str toString(GrantOpts::grantSelect(list[str] tableOpt, list[TableName] tblNameList)) = "SELECT ON <intercalate("",[table|table<-tableOpt])> <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOpts::grantExecute(list[GrantExecute] grantExecuteList)) = "<intercalate(", ",[toString(grantExecute)|grantExecute<-grantExecuteList])>";

public str toString(Privilege::privilege(list[str] privilegeOpt)) = "ALL <intercalate("",[privilege|privilege<-privilegeOpt])>";

public str toString(GrantFor::grantFor(Expr expr, list[GrantOn] grantOnList)) = "FOR <toString(expr)> IN <intercalate(" ",[toString(grantOn)|grantOn<-grantOnList])>";

public str toString(GrantOnStmt::grantOnStmt(GrantOn grantOn)) = "ON <toString(grantOn)>";

public str toString(GrantToStmt::grantToStmt(list[GrantTo] grantToList, list[WithGrantOption] withGrantOptionOpt, list[WithAdminOption] withAdminOptionOpt)) = "TO <intercalate(", ",[toString(grantTo)|grantTo<-grantToList])> <intercalate("",[toString(withGrantOption)|withGrantOption<-withGrantOptionOpt])> <intercalate("",[toString(withAdminOption)|withAdminOption<-withAdminOptionOpt])>";

public str toString(GrantTo::grantToUsername(TableName tblName)) = "<toString(tblName)>";

public str toString(GrantTo::grantToRole(list[TableName] tblNameOpt)) = "ROLE <intercalate("",[toString(tblName)|tblName<-tblNameOpt])>";

public str toString(GrantTo::grantToGroup(TableName tblName)) = "GROUP <toString(tblName)>";

public str toString(GrantTo::grantToPublic()) = "PUBLIC";

public str toString(GrantTo::grantToIamRole(IamRole iamRole)) = "<toString(iamRole)>";

public str toString(GrantTo::grantToNamespace(list[str] strLitList)) = "NAMESPACE <intercalate(", ",[strLit|strLit<-strLitList])>";

public str toString(GrantTo::grantToAccount(str strLit, list[ViaDataCatalog] viadatacatalogOpt)) = "ACCOUNT <strLit> <intercalate("",[toString(viadatacatalog)|viadatacatalog<-viadatacatalogOpt])>";

public str toString(ViaDataCatalog::viadatacatalog()) = "VIA DATA CATALOG";

public str toString(WithGrantOption::withGrantOption()) = "WITH GRANT OPTION";

public str toString(WithAdminOption::withAdminOption()) = "WITH ADMIN OPTION";

public str toString(GrantOn::gTable(list[TableName] tblNameList)) = "TABLE <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOn::gAllTables(list[TableName] tblNameList)) = "ALL TABLES IN SCHEMA <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOn::gDatabase(list[TableName] tblNameList)) = "DATABASE <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOn::gSchema(list[TableName] tblNameList)) = "SCHEMA <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOn::gFunction(list[TableName] tblNameList, BracketNameModeType bracketNameModeType)) = "FUNCTION <intercalate(", ",[toString(tblName)|tblName<-tblNameList])> <toString(bracketNameModeType)>";

public str toString(GrantOn::gAllFuncs(list[TableName] tblNameList)) = "ALL FUNCTIONS IN SCHEMA <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOn::gLanguage(list[TableName] tblNameList)) = "LANGUAGE <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOn::gExternal(list[TableName] tblNameList)) = "EXTERNAL TABLE <intercalate(", ",[toString(tblName)|tblName<-tblNameList])>";

public str toString(GrantOn::gDatashare()) = "DATABASE";

public str toString(GrantOn::gModel(TableName tblName)) = "MODEL <toString(tblName)>";

public str toString(SetOptions::setOpt(list[SessionLocal] sessionLocalOpt, TableName tblName, ToEq toEp, Expr expr)) = "<intercalate("",[toString(sessionLocal)|sessionLocal<-sessionLocalOpt])> <toString(tblName)> <toString(toEp)> <toString(expr)>";

public str toString(SessionLocal::session()) = "SESSION";

public str toString(SessionLocal::local()) = "LOCAL";

public str toString(GrantExecute::grantExecute()) = "EXECUTE";

public str toString(Statement::show(TableName tblName)) = "SHOW <toString(tblName)>";

public str toString(Statement::showColumns(list[TableName] tblNameOpt, list[ShowLike] showLikeOpt, list[LimitClause] limitClauseOpt)) = "SHOW COLUMNS FROM TABLE <intercalate("",[toString(tblName)|tblName<-tblNameOpt])> <intercalate("",[toString(showLike)|showLike<-showLikeOpt])> <intercalate("",[toString(limitClause)|limitClause<-limitClauseOpt])>";

public str toString(Statement::showExternalTable(TableName tblName, list[str] partitionOpt)) = "SHOW EXTERNAL TABLE <toString(tblName)> <intercalate("",[partition|partition<-partitionOpt])>";

public str toString(Statement::showDatabasesWithLike(ShowLike showLike, list[IamRole] iamRoleOpt)) = "SHOW DATABASES FROM DATA CATALOG <toString(showLike)> <intercalate("",[toString(iamRole)|iamRole<-iamRoleOpt])>";

public str toString(Statement::showDatabasesWithIamRole(IamRole iamRole)) = "SHOW DATABASES FROM DATA CATALOG <toString(iamRole)>";

public str toString(Statement::showModel(NameOrAll nameOrAll)) = "SHOW MODEL <toString(nameOrAll)>";

public str toString(Statement::showDatashares(list[ShowLike] showLikeOpt)) = "SHOW DATASHARES <intercalate("",[toString(showLike)|showLike<-showLikeOpt])>";

public str toString(Statement::showProcedure(TableName tblName, list[BracketNameModeType] bracketNameModeTypeOpt)) = "SHOW PROCEDURE <toString(tblName)> <intercalate("",[toString(bracketNameModeType)|bracketNameModeType<-bracketNameModeTypeOpt])>";

public str toString(Statement::showSchemas(TableName tblName, list[ShowLike] showLikeOpt, list[LimitClause] limitClauseOpt)) = "SHOW SCHEMAS FROM DATABASE <toString(tblName)> <intercalate("",[toString(showLike)|showLike<-showLikeOpt])> <intercalate("",[toString(limitClause)|limitClause<-limitClauseOpt])>";

public str toString(Statement::showTable(TableName tblName)) = "SHOW TABLE <toString(tblName)>";

public str toString(Statement::showTables(TableName tblName, list[ShowLike] showLikeOpt, list[LimitClause] limitClauseOpt)) = "SHOW TABLES FROM SCHEMA <toString(tblName)> <intercalate("",[toString(showLike)|showLike<-showLikeOpt])> <intercalate("",[toString(limitClause)|limitClause<-limitClauseOpt])>";

public str toString(Statement::showView(TableName tblName)) = "SHOW VIEW <toString(tblName)>";

public str toString(ShowLike::showLike(Expr expr)) = "LIKE <toString(expr)>";

// DDL

public str toString(Statement::createDatabase(
      TableName tblName
      , list[WithClause] withClauseOpt
      , list[Owner] ownerOpt
      , list[ConnectionLimit] connectionLimitOpt
      , list[Collate] collateOpt
      , list[IsolationLevel] isolationLevelOpt
      , list[FromDatashare] fromDatashareOpt
      , list[WithDataCatalog] withDataCatalogOpt
      , list[IamRole] iamRoleOpt
      )) 
    = "CREATE DATABASE <toString(tblName)> <intercalate("",[toString(withClause)|withClause<-withClauseOpt])> <intercalate("",[toString(owner)|owner<-ownerOpt])> <intercalate("",[toString(connectionLimit)|connectionLimit<-connectionLimitOpt])> <intercalate("",[toString(collate)|collate<-collateOpt])> <intercalate("",[toString(isolationLevel)|isolationLevel<-isolationLevelOpt])> <intercalate("",[toString(fromDatashare)|fromDatashare<-fromDatashareOpt])> <intercalate("",[toString(withDataCatalog)|withDataCatalog<-withDataCatalogOpt])> <intercalate("",[toString(iamRole)|iamRole<-iamRoleOpt])>";

public str toString(Statement::createDatashare(TableName tblName, list[SetAccessible] setAccessibleOpt)) = "CREATE DATASHARE <toString(tblName)> <intercalate("",[toString(setAccessible)|setAccessible<-setAccessibleOpt])>";

public str toString(Statement::createExternalFunction(
      list[OrReplace] orReplaceOpt
      , TableName tblName
      , list[DataType] datatypelist
      , ReturnDatatype returnType
      , VolatileStableImmutable volatileStblImmutbl
      , list[SageMaker] sageMakerOpt
      , list[LambdaName] lambdaNameOpt
      , IamRole iamRole
      , list[RetryTimeout] retryTimeoutOpt
      , list[MatchBatchRows] matchBatchRowsOpt
      , list[MatchBatchSize] matchBatchSizeOpt
      )) 
    = "CREATE <intercalate("",[toString(orReplace)|orReplace<-orReplaceOpt])> EXTERNAL FUNCTION <toString(tblName)> ( <intercalate(", ",[toString(datatype)|datatype<-datatypelist])> ) <toString(returnType)> <toString(volatileStblImmutbl)> <intercalate("",[toString(sageMaker)|sageMaker<-sageMakerOpt])> <intercalate("",[toString(lambdaName)|lambdaName<-lambdaNameOpt])> <toString(iamRole)> <intercalate("",[toString(retryTimeout)|retryTimeout<-retryTimeoutOpt])> <intercalate("",[toString(matchBatchRows)|matchBatchRows<-matchBatchRowsOpt])> <intercalate("",[toString(matchBatchSize)|matchBatchSize<-matchBatchSizeOpt])>";

public str toString(Statement::createExternalSchema(
      list[IfNotExists] ifNotExistsOpt
      , TableName tblName
      , list[str] dataCatalogOpt
      , list[ExternalSchemaOpts] externalSchemaOptsOpt
      , list[DatabaseName] databaseNameOpt
      , list[SchemaName] schemaNameOpt
      , list[RegionName] regionNameOpt
      , list[UriPort] uriPortOpt
      , IamRole iamRole
      , list[SecretArn] secretArnOpt
      , list[Auth] authOpt
      , list[ClusterArn] clusterArnOpt
      , list[CatalogRole] catalogRoleOpt
      , list[CreateExternalDB] createExternalDBOpt
      , list[CatalogId] catalogIdOpt
      )) 
    = "CREATE EXTERNAL SCHEMA <intercalate("",[toString(ifNotExists)|ifNotExists<-ifNotExistsOpt])> <toString(tblName)> FROM <intercalate("",[dataCatalog|dataCatalog<-dataCatalogOpt])> <intercalate("",[toString(externalSchemaOpts)|externalSchemaOpts<-externalSchemaOptsOpt])> <intercalate("",[toString(databaseName)|databaseName<-databaseNameOpt])> <intercalate("",[toString(schemaName)|schemaName<-schemaNameOpt])> <intercalate("",[toString(regionName)|regionName<-regionNameOpt])> <intercalate("",[toString(uriPort)|uriPort<-uriPortOpt])> <toString(iamRole)> <intercalate("",[toString(secretArn)|secretArn<-secretArnOpt])> <intercalate("",[toString(auth)|auth<-authOpt])> <intercalate("",[toString(clusterArn)|clusterArn<-clusterArnOpt])> <intercalate("",[toString(catalogRole)|catalogRole<-catalogRoleOpt])> <intercalate("",[toString(createExternalDB)|createExternalDB<-createExternalDBOpt])> <intercalate("",[toString(catalogId)|catalogId<-catalogIdOpt])>";

public str toString(Statement::createExternalTableAsQuery1(
        TableName tblName
        , PartitionBy partitionedByCls
        , list[RowFormatClause] rowFormatClsOpt
        , list[StorageClause] storedAsOpt
        , list[LocationClause] locationClsOpt
        , list[TablePropertiesClause] tblPropertiesClsOpt
        , CreateTableQuery asSelect
       )) 
    = "CREATE EXTERNAL TABLE <toString(tblName)> <toString(partitionedByCls)> <intercalate("",[toString(rowFormatCls)|rowFormatCls<-rowFormatClsOpt])> <intercalate("",[toString(storedAs)|storedAs<-storedAsOpt])> <intercalate("",[toString(locationCls)|locationCls<-locationClsOpt])> <intercalate("",[toString(tblPropertiesCls)|tblPropertiesCls<-tblPropertiesClsOpt])> <toString(asSelect)>";

public str toString(Statement::createExternalTableAsQuery2(
        TableName tblName
        , list[RowFormatClause] rowFormatClsOpt
        , list[StorageClause] storedAsOpt
        , LocationClause locationCls
        , list[TablePropertiesClause] tblPropertiesClsOpt
        , CreateTableQuery asSelect
       )) 
    = "CREATE EXTERNAL TABLE <toString(tblName)> <intercalate("",[toString(rowFormatCls)|rowFormatCls<-rowFormatClsOpt])> <intercalate("",[toString(storedAs)|storedAs<-storedAsOpt])> <toString(locationCls)> <intercalate("",[toString(tblPropertiesCls)|tblPropertiesCls<-tblPropertiesClsOpt])> <toString(asSelect)>";

public str toString(Statement::createExternalTableAsQuery3(
        TableName tblName
        , list[RowFormatClause] rowFormatClsOpt
        , list[StorageClause] storedAsOpt
        , TablePropertiesClause tblPropertiesCls
        , CreateTableQuery asSelect
       )) 
    = "CREATE EXTERNAL TABLE <toString(tblName)> <intercalate("",[toString(rowFormatCls)|rowFormatCls<-rowFormatClsOpt])> <intercalate("",[toString(storedAs)|storedAs<-storedAsOpt])> <toString(tblPropertiesCls)> <toString(asSelect)>";

public str toString(Statement::createExternalView(TableName tblName, list[IfNotExists] ifNotExistsOpt, CreateTableQuery asSelect)) 
    = "CREATE EXTERNAL PROTECTED VIEW <toString(tblName)> <intercalate("",[toString(ifNotExists)|ifNotExists<-ifNotExistsOpt])> <toString(asSelect)>";

public str toString(Statement::createFunction(
        list[OrReplace] orReplaceOpt
        , TableName tblName
        , BracketNameModeType bracketNameModeType
        , ReturnDatatype returnDatatype
        , VolatileStableImmutable volatileStblImmutbl
        , Expr expr
        , Language language
        )) 
    = "CREATE <intercalate("",[toString(orReplace)|orReplace<-orReplaceOpt])> FUNCTION <toString(tblName)> <toString(bracketNameModeType)> <toString(returnDatatype)> <toString(volatileStblImmutbl)> AS $$ <toString(expr)> $$ <toString(language)>";

public str toString(Statement::createGroup(TableName tblName, list[WithUser] withUserOpt)) = "CREATE GROUP <toString(tblName)> <intercalate("",[toString(withUser)|withUser<-withUserOpt])>";

public str toString(Statement::createIdentityProvider(TableName tblName, Identifier identifier, Expr expr, str strLit)) 
    = "CREATE IDENTITY PROVIDER <toString(tblName)> TYPE <toString(identifier)> NAMESPACE <toString(expr)> PARAMETERS <strLit>";

public str toString(Statement::createLibrary(list[OrReplace] orReplaceOpt, TableName tblName, Language language, LibraryOpts libraryOpts)) 
    = "CREATE <intercalate("",[toString(orReplace)|orReplace<-orReplaceOpt])> LIBRARY <toString(tblName)> <toString(language)> FROM <toString(libraryOpts)>";

public str toString(Statement::createMaterializedView(TableName tblName, list[Backup] backupOpt, list[TableAttributes] tblAttrOpt, list[AutoRefresh] autoRefreshOpt, CreateTableQuery asSelect)) 
    = "CREATE MATERIALIZED VIEW <toString(tblName)> <intercalate("",[toString(backup)|backup<-backupOpt])> <intercalate("",[toString(tblAttr)|tblAttr<-tblAttrOpt])> <intercalate("",[toString(autoRefresh)|autoRefresh<-autoRefreshOpt])> <toString(asSelect)>";

public str toString(Statement::createModel(
        TableName tblName
        , Expr expr
        , list[Target] targetOpt
        , Function function
        , list[ReturnDatatype] returnDatatypeOpt
        , IamRole iamRole
        , list[TypeId] typeIdList
        , list[Settings] settingsOpt
        )) 
    = "CREATE MODEL <toString(tblName)> FROM <toString(expr)> <intercalate("",[toString(target)|target<-targetOpt])> <toString(function)> <intercalate("",[toString(returnDatatype)|returnDatatype<-returnDatatypeOpt])> <toString(iamRole)> <intercalate(" ",[toString(typeId)|typeId<-typeIdList])> <intercalate("",[toString(settings)|settings<-settingsOpt])>";

public str toString(Statement::createProcedure(
        list[OrReplace] orReplaceOpt
        , TableName tblName
        , BracketNameModeType bracketNameModeType
        , list[str] nonatomicOpt
        , Expr expr
        , Language language
        , list[Security] securityOpt
        )) 
    = "CREATE <intercalate("",[toString(orReplace)|orReplace<-orReplaceOpt])> PROCEDURE <toString(tblName)> <toString(bracketNameModeType)> <intercalate("",[nonatomic|nonatomic<-nonatomicOpt])> AS $$ <toString(expr)> $$ <toString(language)> <intercalate("",[toString(security)|security<-securityOpt])>";

public str toString(Statement::createRlsPolicy(TableName tblName, list[WithRls] withRlsOpt, Expr expr)) 
    = "CREATE RLS POLICY <toString(tblName)> <intercalate("",[toString(withRls)|withRls<-withRlsOpt])> USING ( <toString(expr)> )";

public str toString(Statement::createRole(TableName tblName, list[ExternalId] externalIdOpt)) 
    = "CREATE ROLE <toString(tblName)> <intercalate("",[toString(externalId)|externalId<-externalIdOpt])>";

public str toString(Statement::createSchema(list[TableName] tblNameOpt1, list[str] authorizationOpt, list[IfNotExists] ifNotExistsOpt, TableName tblName2, list[Quota] quotaOpt)) 
    = "CREATE SCHEMA <intercalate("",[toString(tblName1)|tblName1<-tblNameOpt1])> <intercalate("",[authorization|authorization<-authorizationOpt])> <intercalate("",[toString(ifNotExists)|ifNotExists<-ifNotExistsOpt])> <toString(tblName2)> <intercalate("",[toString(quota)|quota<-quotaOpt])>";

public str toString(Statement::createUser(TableName tblName, list[UserId] userIdOpt, list[str] withOpt, list[UserOptions] userOptionsList)) 
    = "CREATE USER <toString(tblName)> <intercalate("",[toString(userId)|userId<-userIdOpt])> <intercalate("",[with|with<-withOpt])> <intercalate(" ",[toString(userOptions)|userOptions<-userOptionsList])>";

public str toString(Statement::createViewWithNoSchema(list[OrReplace] orReplaceOpt, TableName tblName, list[BracketCol] bracketColOpt, CreateTableQuery asSelect, WithNoSchema withNoSchema)) 
    = "CREATE <intercalate("",[toString(orReplace)|orReplace<-orReplaceOpt])> VIEW <toString(tblName)> <intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])> <toString(asSelect)> <toString(withNoSchema)>";

public str toString(Statement::createOrReplaceView(OrReplace orReplace, TableName tblName, list[BracketCol] bracketColOpt, CreateTableQuery asSelect))
    = "CREATE <toString(orReplace)> VIEW <toString(tblName)> <intercalate("",[toString(bracketCol)|bracketCol<-bracketColOpt])> <toString(asSelect)>";



public str toString(CreateTable::createTable2(
      list[str] localOpt
      , list[TempVariant] tempVariantOpt
      , list[IfNotExists] ifNotExistsOpt
      , TableName tblname
      , list[BracketCrtableOpts] bracketCrtableOptsOpt
      , list[BracketCol] btacketColOpt
      , list[Backup] backupOpt
      , list[TableAttributes] tblAttrList
      , list[CreateTableQuery] createTblQryOpt
      )) 
    = "CREATE <intercalate("",[local|local<-localOpt])> <intercalate("",[toString(tempVariant)|tempVariant<-tempVariantOpt])> TABLE <intercalate("",[toString(ifNotExists)|ifNotExists<-ifNotExistsOpt])> <toString(tblname)> <intercalate("",[toString(bracketCrtableOpts)|bracketCrtableOpts<-bracketCrtableOptsOpt])> <intercalate("",[toString(btacketCol)|btacketCol<-btacketColOpt])> <intercalate("",[toString(backup)|backup<-backupOpt])> <intercalate(" ",[toString(tblAttr)|tblAttr<-tblAttrList])> <intercalate("",[toString(createTblQry)|createTblQry<-createTblQryOpt])>";

public str toString(BracketCrtableOpts::bracketCrtableOpts(list[CreateTableOpts] createTblOptsOpt)) = "( <intercalate(", ",[toString(createTblOpts)|createTblOpts<-createTblOptsOpt])> )";

public str toString(CreateTableOpts::cr1(TableName tblName, DataType datatype, list[AttrOrConst] attrOrConstList)) 
    = "<toString(tblName)> <toString(datatype)> <intercalate(" ",[toString(attrOrConst)|attrOrConst<-attrOrConstList])>";

public str toString(CreateTableOpts::cr2(TableConstraints tblConstraints)) = "<toString(tblConstraints)>";

public str toString(CreateTableOpts::cr3(TableName tblName, IncludingOrExcluding includingOrExcluding)) = "LIKE <toString(tblName)> <toString(includingOrExcluding)>";

public str toString(PartitionBy::partitionBy(BracketNameModeType bracketNameModeType)) = "PARTITIONED BY <toString(bracketNameModeType)>";

public str toString(TableConstraints::tableConstraints(UniqOrPrimOrFrgn uniqOrPrimOrFrgn)) = "<toString(uniqOrPrimOrFrgn)>";

public str toString(AttrOrConst::colAttr(ColumnAttributes colAttrs)) = "<toString(colAttrs)>";

public str toString(AttrOrConst::colConst(ColumnConstraints colConstr)) = "<toString(colConstr)>";

public str toString(IncludingOrExcluding::including()) = "INCLUDING DEFAULTS";

public str toString(IncludingOrExcluding::excluding()) = "EXCLUDING DEFAULTS";

public str toString(ExternalId::externalId(Expr expr)) = "EXTERNALID <toString(expr)>";

public str toString(ExternalId::externalIdTo(Identifier id)) = "EXTERNAL ID TO <toString(id)>";

public str toString(ExternalId::externalIdToStr(str strLit)) = "EXTERNAL ID TO <strLit>";

public str toString(UserId::userId(Identifier id)) = ":<toString(id)>";

public str toString(UniqOrPrimOrFrgn::unique(list[BracketCol] bracketcols)) = "UNIQUE <intercalate("",[toString(\bracket)|\bracket<-bracketcols])>";

public str toString(UniqOrPrimOrFrgn::primaryKey(list[BracketCol] bracketcols)) = "PRIMARY KEY <intercalate("",[toString(\bracket)|\bracket<-bracketcols])>";

public str toString(UniqOrPrimOrFrgn::foreignKey(BracketCol bracketCol, References refs)) = "FOREIGN KEY <toString(bracketCol)> <toString(refs)>";

public str toString(ColumnAttributes::colOrAttrDef(DefaultExpr caDef)) = "<toString(caDef)>";

public str toString(ColumnAttributes::colOrAttrId(Identity caId)) = "<toString(caId)>";

public str toString(ColumnAttributes::colOrAttrGen(GeneratedBy caGen)) = "<toString(caGen)>";

public str toString(ColumnAttributes::colOrAttrEnc(Encode caEnc)) = "<toString(caEnc)>";

public str toString(ColumnAttributes::colOrAttrDist(Distkey caDist)) = "<toString(caDist)>";

public str toString(ColumnAttributes::colOrAtttrSort(Sortkey caSort)) = "<toString(caSort)>";

public str toString(ColumnAttributes::colOrAttrColl(Collate caColl)) = "<toString(caColl)>";

public str toString(ColumnConstraints::nullOpt(NullOptions nullOpt)) = "<toString(nullOpt)>";

public str toString(ColumnConstraints::upf(UniqOrPrimOrFrgn upf)) = "<toString(upf)>";

public str toString(ColumnConstraints::ref(References ref)) = "<toString(ref)>";

public str toString(References::references(Identifier id, list[BracketCol] bracketcols)) = "REFERENCES <toString(id)> <intercalate("",[toString(\bracket)|\bracket<-bracketcols])>";

public str toString(Identity::identity(list[ExprExpr] expexpOpt)) = "IDENTITY <intercalate("",[toString(expexp)|expexp<-expexpOpt])>";

public str toString(ExprExpr::expexp(Expr exp1, Expr exp2)) = "( <toString(exp1)>, <toString(exp2)> )";

public str toString(GeneratedBy::generatedBy(list[ExprExpr] exprexprOpt)) = "GENERATED BY DEFAULT AS IDENTITY <intercalate("",[toString(exprexpr)|exprexpr<-exprexprOpt])>";

public str toString(Encode::encode(Expr expr)) = "ENCODE <toString(expr)>";

public str toString(DefaultExpr::defaultExpr(Expr expr)) = "DEFAULT <toString(expr)>";

public str toString(Sortkey::sortkey()) = "SORTKEY";

public str toString(NullOptions::null()) = "NULL";

public str toString(NullOptions::notNull()) = "NOT NULL";

public str toString(WithNoSchema::withNoSchema()) = "WITH NO SCHEMA BINDING";

public str toString(TableAttributes::tableDistStyle(DistStyle taDistS)) = "<toString(taDistS)>";

public str toString(TableAttributes::tableDistKey(Distkey taDistK)) = "<toString(taDistK)>";

public str toString(TableAttributes::tableSortKey(SortKey taSort)) = "<toString(taSort)>";

public str toString(TableAttributes::tableEncode(EncodeAuto taEnc)) = "<toString(taEnc)>";

public str toString(DistStyle::distStyle(DistOpts distOpts)) = "DISTSTYLE <toString(distOpts)>";

public str toString(SortKey::sortKey(BracketCol bracketcol, list[str] strConst, list[str] autoConst)) = "SORTKEY <toString(bracketcol)> <intercalate("",[sortStr|sortStr<-strConst])> <intercalate("",[autoStr|autoStr<-autoConst])>";

public str toString(EncodeAuto::encodeAuto()) = "ENCODE AUTO";

public str toString(Distkey::distkey(list[BracketCol] bracketcol)) = "DISTKEY <intercalate("",[toString(\bracket)|\bracket<-bracketcol])>";

public str toString(DistOpts::auto()) = "AUTO";

public str toString(DistOpts::even()) = "EVEN";

public str toString(DistOpts::key()) = "KEY";

public str toString(DistOpts::distall()) = "ALL";

public str toString(UserOptions::createNoCreateDb(CreateNoCreateDb crdb)) = "<toString(crdb)>";

public str toString(UserOptions::createNoCreateUser(CreateNoCreateUser cruser)) = "<toString(cruser)>";

public str toString(UserOptions::sysRes(RestrictedUnrestricted restricedOrNot)) = "SYSLOG ACCESS <toString(restricedOrNot)>";

public str toString(UserOptions::passw(UserOptionSecureType useroptssec,list[Validity] validityOpt)) = "PASSWORD <toString(useroptssec)> <intercalate("",[toString(validity)|validity<-validityOpt])>";

public str toString(UserOptions::renameId(TableName tablename)) = "RENAME TO <toString(tablename)>";

public str toString(UserOptions::connlimit(ConnectionLimit connlimit)) = "<toString(connlimit)>";

public str toString(UserOptions::sessionTimeout(SessionLimit sessionLimit)) = "SESSION TIMEOUT <toString(sessionLimit)>";

public str toString(UserOptions::settoval(Expr expr1, ToEq toeq, Expr expr2)) = "SET <toString(expr1)> <toString(toeq)> <toString(expr2)>";

public str toString(UserOptions::resetAlter(Expr expr)) = "RESET <toString(expr)>";

public str toString(UserOptions::exterId(ExternalId eid)) = "<toString(eid)>";

public str toString(UserOptions::inGroup(list[TableName] tablenames)) = "IN GROUP <intercalate(", ",[toString(tablename)|tablename<-tablenames])>";

public str toString(ToEq::to()) = "TO";

public str toString(ToEq::eq()) = "=";

public str toString(SessionLimit::sessionLimit(str integer)) = "<integer>";

public str toString(SessionLimit::timeoutSession()) = "RESET SESSION TIMEOUT";

public str toString(Validity::validUntil(Expr expr)) = "VALID UNTIL <toString(expr)>";

public str toString(RestrictedUnrestricted::restricted()) = "RESTRICTED";

public str toString(RestrictedUnrestricted::unrestriced()) = "UNRESTRICTED";

public str toString(CreateNoCreateDb::createDb()) = "CREATEDB";

public str toString(CreateNoCreateDb::nCreateDB()) = "NOCREATEDB";

public str toString(CreateNoCreateUser::createUser()) = "CREATEUSER";

public str toString(CreateNoCreateUser::noCreateUser()) = "NOCREATEUSER";

public str toString(TablePropertiesClause::tablePropertiesClause2(list[TableProperty] tblPropsList)) = "TABLE PROPERTIES ( <intercalate(", ",[toString(tblProps)|tblProps<-tblPropsList])> )";

public str toString(WithUser::withUser(User user)) = "WITH <toString(user)>";

public str toString(User::user(list[TableName] tblNameOpt)) = "USER <intercalate(", ",[toString(tblName)|tblName<-tblNameOpt])>";

public str toString(Language::lang(LangOpts langOpts)) = "LANGUAGE <toString(langOpts)>";

public str toString(Target::target(Expr expr)) = "TARGET <toString(expr)>";

public str toString(TypeId::typeid(Identifier id, Expr expr)) = "<toString(id)> <toString(expr)>";

public str toString(ByteFormat::kb()) = "KB";

public str toString(ByteFormat::mb()) = "MB";

public str toString(ByteFormat::gb()) = "GB";

public str toString(ByteFormat::tb()) = "TB";

public str toString(VolatileStableImmutable::volatile()) = "VOLATILE";

public str toString(VolatileStableImmutable::stable()) = "STABLE";

public str toString(VolatileStableImmutable::immutable()) = "IMMUTABLE";

public str toString(OrReplace::orReplace()) = "OR REPLACE";

public str toString(BracketCol::bracketCol(list[Expr] exprList)) = "( <intercalate(", ",[toString(expr)|expr<-exprList])> )";

public str toString(DatabaseName::databaseName(str strConst)) = "DATABASE <strConst>";

public str toString(SchemaName::schemaName(str strConst)) = "SCHEMA <strConst>";

public str toString(RegionName::regionName(str strConst)) = "REGION <strConst>";

public str toString(UriPort::uriPort(str strConst,list[PortNumber] portNumber)) = "URI <strConst> <intercalate("",[toString(portNum)|portNum<-portNumber])>";

public str toString(PortNumber::portNumber(str integer)) = "PORT <integer>";

public str toString(SecretArn::secretArn(str strConst)) = "SECRET_ARN <strConst>";

public str toString(Auth::auth(str strConst)) = "AUTHENTICATION <strConst>";

public str toString(ClusterArn::clusterArn(str strConst)) = "CLUSTER_ARN <strConst>";

public str toString(CatalogRole::catalogRole(str strConst)) = "CATALOG_ROLE <strConst>";

public str toString(CatalogId::catalogId(str strConst)) = "CATALOG_ID <strConst>";

public str toString(CreateExternalDB::createExternalDB(IfNotExists ifnotexists)) = "CREATE EXTERNAL DATABASE <toString(ifnotexists)>";

public str toString(Settings::settings(list[TypeId] typeidOpt)) = "SETTINGS ( <intercalate(" ",[toString(typeid)|typeid<-typeidOpt])> )";

public str toString(Backup::backup(YesOrNo yesorno)) = "BACKUP <toString(yesorno)>";

public str toString(AutoRefresh::autoRefresh(YesOrNo id)) = "AUTO REFRESH <toString(id)>";

public str toString(YesOrNo::yes()) = "YES";

public str toString(YesOrNo::no()) = "NO";

public str toString(IamRole::iAmRole(Identifier id, IamRoleOptions roleOpts)) = "<toString(id)> <toString(roleOpts)>";

public str toString(IamRoleOptions::roleDefault()) = "DEFAULT";

public str toString(IamRoleOptions::roleSession()) = "SESSION_USER";

public str toString(IamRoleOptions::roleCustom(str strConst)) = "<strConst>";

public str toString(LangOpts::plpythonu()) = "PLPYTHONU";

public str toString(LangOpts::sql()) = "SQL";

public str toString(LangOpts::plpsql()) = "PLPGSQL";

public str toString(ReturnDatatype::returnType(DataType datatype)) = "RETURNS <toString(datatype)>";

public str toString(SageMaker::sageMaker(str strConst)) = "SAGEMAKER <strConst>";

public str toString(LambdaName::lambdaStr(str strConst)) = "LAMBDA <strConst>";

public str toString(RetryTimeout::retryTimeout(Expr expr)) = "RETRY_TIMEOUT <toString(expr)>";

public str toString(MatchBatchRows::maxBatchRows(Expr count)) = "MAX_BATCH_ROWS <toString(count)>";

public str toString(MatchBatchSize::maxBatchSize(Expr expr, ByteFormat byteformat)) = "MAX_BATCH_SIZE <toString(expr)> <toString(byteformat)>";

public str toString(WithDataCatalog::withDataCatalog(list[str] noOpt, list[str] strConst)) = "WITH <intercalate("",[noStr|noStr<-noOpt])> DATA CATALOG SCHEMA <intercalate("",[strWord|strWord<-strConst])>";

public str toString(Owner::owner(list[str] eqLit, TableName tablename)) = "OWNER <intercalate("",[eqStr|eqStr<-eqLit])> <toString(tablename)>";

public str toString(ConnectionLimit::connectionLimit(ConnLimitOptions connlimitOpts)) = "CONNECTION LIMIT <toString(connlimitOpts)>";

public str toString(Quota::unlimited()) = "QUOTA UNLIMITED";

public str toString(Quota::quotaUnit(str integer, list[ByteFormat] memorySizeUnitOpt)) = "QUOTA <integer> <intercalate("",[toString(memorySizeUnit)|memorySizeUnit<-memorySizeUnitOpt])>";

public str toString(Collate::collate(CaseOption caseOption)) = "COLLATE <toString(caseOption)>";

public str toString(IsolationLevel::isolationLevel(SerializableSnapshot serialSnap)) = "ISOLATION LEVEL <toString(serialSnap)>";

public str toString(CaseOption::caseSensitive()) = "CASE_SENSITIVE";

public str toString(CaseOption::caseInsensitive()) = "CASE_INSENSITIVE";

public str toString(SerializableSnapshot::serializable()) = "SERIALIZABLE";

public str toString(SerializableSnapshot::snapshot()) = "SNAPSHOT";

public str toString(ConnLimitOptions::limit(str integer)) = "<integer>";

public str toString(ConnLimitOptions::connunlimited()) = "UNLIMITED";

public str toString(FromDatashare::fromDatashare(list[WithPermissions] withPermissionsOpt, TableName tablename, list[AccountId] accId,Expr expr)) 
    = "<intercalate("",[toString(withPermissions)|withPermissions<-withPermissionsOpt])> FROM DATASHARE <toString(tablename)> OF <intercalate("",[toString(acc)|acc<-accId])> NAMESPACE <toString(expr)>";

public str toString(SetAccessible::setAccessible(list[str] strConst, Boolean tOrf)) = "SET PUBLICACCESSIBLE <intercalate("",[strWord|strWord<-strConst])> <toString(tOrf)>";

public str toString(AccountId::accountId(Expr expr)) = "ACCOUNT <toString(expr)>";

public str toString(WithPermissions::withPermissions()) = "WITH PERMISSIONS";

public str toString(BracketNameModeType::bracketNameModeType(list[NameModeType] nameModeType)) = "( <intercalate(", ",[toString(nameMode)|nameMode<-nameModeType])> )";

public str toString(Function::function(TableName tblName, list[DataType] datatypeOpt)) = "FUNCTION <toString(tblName)> <for(datatype <- datatypeOpt) {> ( <intercalate(", ",[toString(dtype)|dtype<-datatype])> ) <}>";

public str toString(Security::securityInvoker()) = "SECURITY INVOKER";

public str toString(Security::securityDefiner()) = "SECURITY DEFINER";

public str toString(ArgMode::argIn()) = "IN";

public str toString(ArgMode::argout()) = "OUT";

public str toString(ArgMode::argInOut()) = "INOUT";

public str toString(UserOptionSecureType::disable()) = "DISABLE";

public str toString(UserOptionSecureType::passExpr(Expr expr)) = "<toString(expr)>";

public str toString(NameModeType::nameModeType(Identifier id, list[ArgMode] argModeOpt, list[DataType] datatypeOpt)) 
    = "<toString(id)> <intercalate("",[toString(argMode)|argMode<-argModeOpt])> <intercalate("",[toString(datatype)|datatype<-datatypeOpt])>";

public str toString(WithRls::withRls(BracketNameModeType bracketNameModeType, list[str] strConstOpt, list[TableName] tblNameOpt)) = "WITH <toString(bracketNameModeType)> <intercalate("",[strConst|strConst<-strConstOpt])> <intercalate("",[toString(tblName)|tblName<-tblNameOpt])>";

public str toString(ExternalSchemaOpts::hiveMetastore()) = "HIVE METASTORE";

public str toString(ExternalSchemaOpts::postgres()) = "POSTGRES";

public str toString(ExternalSchemaOpts::mysql()) = "MYSQL";

public str toString(ExternalSchemaOpts::kinesis()) = "KINESIS";

public str toString(ExternalSchemaOpts::msk()) = "MSK";

public str toString(ExternalSchemaOpts::redshift()) = "REDSHIFT";

public str toString(RegionAs::regionAs(list[VarAssignAs] asStr, Expr expr)) = "REGION <intercalate("",[toString(asWord)|asWord<-asStr])> <toString(expr)>";

public str toString(LibraryOpts::libOpts(str strConst, list[IamRole] iamroleOpt1, list[RegionAs] regionAsOpt, list[IamRole] iamroleOpt2)) 
    = "<strConst> <intercalate("",[toString(iamrole1)|iamrole1<-iamroleOpt1])> <intercalate("",[toString(regionAs)|regionAs<-regionAsOpt])> <intercalate("",[toString(iamrole2)|iamrole2<-iamroleOpt2])>";

public str toString(AlterTable::addConstraints(TableName tblName, list[Constraints] constraintOpt, TableConstraints tblConstraints)) 
    = "ALTER TABLE <toString(tblName)> ADD <intercalate("",[toString(constraint)|constraint<-constraintOpt])> <toString(tblConstraints)>";

public str toString(AlterTable::dropConstraints(TableName tblName, Identifier id, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)) 
    = "ALTER TABLE <toString(tblName)> DROP CONSTRAINT <toString(id)> <intercalate("",[toString(cascadeOrForceOrRestrict)|cascadeOrForceOrRestrict<-cascadeOrForceOrRestrictOpt])>";

public str toString(AlterTable::changeOwner(TableName tblName, Identifier id)) 
    = "ALTER TABLE <toString(tblName)> OWNER TO <toString(id)>";

public str toString(AlterTable::renameColumn(TableName tblName, Identifier id1, Identifier id2)) 
    = "ALTER TABLE <toString(tblName)> RENAME COLUMN <toString(id1)> TO <toString(id2)>";

public str toString(AlterTable::alterColumnType(TableName tblName, Identifier id, Expr expr)) 
    = "ALTER TABLE <toString(tblName)> ALTER COLUMN <toString(id)> TYPE <toString(expr)>";

public str toString(AlterTable::alterColumnEncode(TableName tblName, Identifier id, list[Identifier] idList)) 
    = "ALTER TABLE <toString(tblName)> ALTER COLUMN <toString(id)> ENCODE <intercalate(", ",[toString(identifier)|identifier<-idList])>";

public str toString(AlterTable::distAndSortKeyList(list[DistAndSortKey] distAndSortKeyList)) 
    = "<intercalate(", ",[toString(distAndSortKey)|distAndSortKey<-distAndSortKeyList])>";

public str toString(AlterTable::encodeAutoAlter()) = "ALTER ENCODE AUTO";

public str toString(AlterTable::addColumn(
        TableName tblName
        , list[str] columnOpt
        , Identifier id1
        , Identifier id2
        , list[DefaultExpr] defaultExprOpt
        , list[Encode] encodeOpt
        , list[NullOptions] nullOptionsOpt
        , list[CollateOpt] collateOpt
        )) 
    = "ALTER TABLE <toString(tblName)> ADD <intercalate("",[column|column<-columnOpt])> <toString(id1)> <toString(id2)> <intercalate("",[toString(defaultExpr)|defaultExpr<-defaultExprOpt])> <intercalate("",[toString(encode)|encode<-encodeOpt])> <intercalate("",[toString(nullOptions)|nullOptions<-nullOptionsOpt])> <intercalate("",[toString(collate)|collate<-collateOpt])>";

public str toString(AlterTable::dropColumn(TableName tblName, list[str] columnOpt, Identifier id, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)) 
    = "ALTER TABLE <toString(tblName)> DROP <intercalate("",[column|column<-columnOpt])> <toString(id)> <intercalate("",[toString(cascadeOrForceOrRestrict)|cascadeOrForceOrRestrict<-cascadeOrForceOrRestrictOpt])>";

public str toString(AlterTable::rowLevelSecurity(TableName tblName, OnOrOff onOrOff, list[CjnTypes] cjnTypesOpt)) 
    = "ALTER TABLE <toString(tblName)> ROW LEVEL SECURITY <toString(onOrOff)> <intercalate("",[toString(cjnTypes)|cjnTypes<-cjnTypesOpt])>";

public str toString(AlterTable::setLocation(TableName tblName, SetLocation setLocation)) 
    = "ALTER TABLE <toString(tblName)> <toString(setLocation)>";

public str toString(AlterTable::setFileFormat(TableName tblName, Identifier id)) 
    = "ALTER TABLE <toString(tblName)> SET FILE FORMAT <toString(id)>";

public str toString(AlterTable::setExternalTableProperties(TableName tblName, AlterPropsVal alterPropsVal)) 
    = "ALTER TABLE <toString(tblName)> SET TABLE PROPERTIES ( <toString(alterPropsVal)> )";

public str toString(AlterTable::setExternalPartition(TableName tblName, list[AlterPropsVal] alterPropsValOpt, SetLocation setLocation)) 
= "ALTER TABLE <toString(tblName)> PARTITION ( <intercalate("",[toString(alterPropsVal)|alterPropsVal<-alterPropsValOpt])> ) <toString(setLocation)>";


public str toString(Constraints::constraint(Identifier id)) = "CONSTRAINT <toString(id)>";

public str toString(CascadeOrForceOrRestrict::cascade()) = "CASCADE";

public str toString(CascadeOrForceOrRestrict::force()) = "FORCE";

public str toString(CascadeOrForceOrRestrict::restrict()) = "RESTRICT";

public str toString(SetLocation::setLoc(str strConst)) = "SET LOCATION <strConst>";

public str toString(CjnTypes::cjnTypes(AndOr andor, list[FrDtShare] frDtShareOpt)) = "CONJUNCTION TYPE <toString(andor)> <intercalate("",[toString(frDtShare)|frDtShare<-frDtShareOpt])>";

public str toString(CollateOpt::collOpt(CaseOption caseopt)) = "COLLATE <toString(caseopt)>";

public str toString(OnOrOff::on()) = "ON";

public str toString(OnOrOff::off()) = "OFF";

public str toString(DistAndSortKey::altTbDist(Identifier id)) = "ALTER DISTKEY <toString(id)>";

public str toString(DistAndSortKey::altTbDistStyle(AltTbDstStyleOption a)) = "ALTER DISTSTYLE <toString(a)>";

public str toString(DistAndSortKey::sortKey(list[AltTbCmpd] alttbcmpd, AltTbSrtOpt altTbSrtOpt)) = "ALTER <intercalate("",[toString(alttbc)|alttbc<-alttbcmpd])> SORTKEY <toString(altTbSrtOpt)>";

public str toString(AlterPropsVal::altPropsVal(list[Identifier] ids, Expr expr)) = "\' <intercalate(".",[toString(id)|id<-ids])> \' = <toString(expr)>";

public str toString(FrDtShare::frDtShare()) = "FOR DATASHARES";

public str toString(AndOr::and()) = "AND";

public str toString(AndOr::or()) = "OR";

public str toString(AltTbCmpd::compound()) = "COMPOUND";

public str toString(AltTbDstStyleOption::dstAll()) = "ALL";

public str toString(AltTbDstStyleOption::dstEven()) = "EVEN";

public str toString(AltTbDstStyleOption::dstAuto()) = "AUTO";

public str toString(AltTbDstStyleOption::dstKey(Identifier id)) = "KEY DISTKEY <toString(id)>";

public str toString(AltTbSrtOpt::srtAuto()) = "AUTO";

public str toString(AltTbSrtOpt::srtNone()) = "NONE";

public str toString(AltTbSrtOpt::withColName(list[Identifier] ids)) = "( <intercalate(", ",[toString(id)|id<-ids])> )";

public str toString(Statement::alterDatabase(list[TableName] tblNameOpt, AlterDBOptions alterDBOptions)) 
    = "ALTER DATABASE <intercalate("",[toString(tblName)|tblName<-tblNameOpt])> <toString(alterDBOptions)>";

public str toString(Statement::alterAddOrRemoveObjects(Identifier id, AddOrRemoveObjects addOrRemoveObjs, AlterDataShareOptions alterDataShareOptions)) 
    = "ALTER DATASHARE <toString(id)> <toString(addOrRemoveObjs)> <toString(alterDataShareOptions)>";

public str toString(Statement::alterConfigPropsOpt(Identifier id, list[SetPubAcc] setPubAccOpt, list[SetIncNew] setIncNewOpt)) 
    = "ALTER DATASHARE <toString(id)> <intercalate("",[toString(setPubAcc)|setPubAcc<-setPubAccOpt])> <intercalate("",[toString(setIncNew)|setIncNew<-setIncNewOpt])>";

public str toString(Statement::alterExternalView(TableName tblName, list[str] forceOpt, list[CreateTableQuery] createTblQryOpt, list[RemoveDefinition] removeDefOpt)) 
    = "ALTER EXTERNAL VIEW <toString(tblName)> <intercalate("",[force|force<-forceOpt])> <intercalate("",[toString(createTblQry)|createTblQry<-createTblQryOpt])> <intercalate("",[toString(removeDef)|removeDef<-removeDefOpt])>";

public str toString(Statement::alterDefaultPrivileges(list[ForUser] forUserOpt, list[InSchema] InSchemaOpt, GrantOrRevoke grantRevoke)) 
    = "ALTER DEFAULT PRIVILEGES <intercalate("",[toString(forUser)|forUser<-forUserOpt])> <intercalate("",[toString(InSchema)|InSchema<-InSchemaOpt])> <toString(grantRevoke)>";

public str toString(Statement::alterMaskingPolicy(TableName tblName, Expr expr)) 
    = "ALTER MASKING POLICY <toString(tblName)> USING ( <toString(expr)> )";

public str toString(Statement::alterIdentityProvider(TableName tblName, str strLit)) 
    = "ALTER IDENTITY PROVIDER <toString(tblName)> PARAMETERS <strLit>";

public str toString(Statement::alterGroup(TableName tblName, AlterGroupOption alterGroupOption)) 
    = "ALTER GROUP <toString(tblName)> <toString(alterGroupOption)>";

public str toString(Statement::alterMaterializedView(Identifier id, list[AutoRefresh] autorefreshOpt, list[RowLevelSecurity] rowLevelSecurityOpt)) 
    = "ALTER MATERIALIZED VIEW <toString(id)> <intercalate("",[toString(autorefresh)|autorefresh<-autorefreshOpt])> <intercalate("",[toString(rowLevelSecurity)|rowLevelSecurity<-rowLevelSecurityOpt])>";

public str toString(Statement::alterRlsPolicy(Identifier id, Expr expr)) 
    = "ALTER RLS POLICY <toString(id)> USING ( <toString(expr)> )";

public str toString(Statement::alterRole(Identifier id, list[str] withOpt, list[AlterRoleOption] alterRoleOptionList, list[ExternalId] externalIdOpt)) 
    = "ALTER ROLE <toString(id)> <intercalate("",[with|with<-withOpt])> <intercalate(", ",[toString(alterRoleOption)|alterRoleOption<-alterRoleOptionList])> <intercalate("",[toString(externalId)|externalId<-externalIdOpt])>";

public str toString(Statement::alterProcedure(TableName tblName, list[AlterProcedureOptions] alterProcOptsOpt, RenameOrChange renameOrChange, ProcedureToOption procedureOption)) 
    = "ALTER PROCEDURE <toString(tblName)> <intercalate("",[toString(alterProcOpts)|alterProcOpts<-alterProcOptsOpt])> <toString(renameOrChange)> TO <toString(procedureOption)>";

public str toString(Statement::alterSchema(Identifier id, AlterSchemaOptions alterSchemaOptions)) 
    = "ALTER SCHEMA <toString(id)> <toString(alterSchemaOptions)>";

public str toString(Statement::alterSystem(SystemLvlConf systemLevelConf, SysLvlConfVal sysLvlConfVal)) 
    = "ALTER SYSTEM SET <toString(systemLevelConf)> = <toString(sysLvlConfVal)>";

public str toString(Statement::alterUser(TableName tblName, list[UserId] userIdOpt, list[str] withOpt, list[UserOptions] userOptionsList)) 
    = "ALTER USER <toString(tblName)> <intercalate("",[toString(userId)|userId<-userIdOpt])> <intercalate("",[with|with<-withOpt])> <intercalate(" ",[toString(userOptions)|userOptions<-userOptionsList])>";


public str toString(SystemLvlConf::dtCat()) = "data_catalog_auto_mount";

public str toString(SystemLvlConf::mtSec()) = "metadata_security";

public str toString(AlterGroupOption::addUser(list[Identifier] ids)) = "ADD USER <intercalate(", ",[toString(id)|id<-ids])>";

public str toString(AlterGroupOption::altdropUser(list[Identifier] ids)) = "DROP USER <intercalate(", ",[toString(id)|id<-ids])>";

public str toString(AlterGroupOption::altrenameGroup(Identifier id)) = "RENAME TO <toString(id)>";

public str toString(RowLevelSecurity::rowLevelSecurity(OnOrOff onoff, list[ConjuctionType] cjtypeOpt, list[ForDtShares] fordtOpt)) 
    = "ROW LEVEL SECURITY <toString(onoff)> <intercalate("",[toString(cjtype)|cjtype<-cjtypeOpt])> <intercalate("",[toString(fordt)|fordt<-fordtOpt])>";

public str toString(SetPubAcc::setPubAcc(list[str] strConst, Boolean torf)) = "SET PUBLIC ACCESSIBLE <intercalate("",[equals|equals<-strConst])> <toString(torf)>";

public str toString(SetIncNew::setInNew(list[str] strConstOpt, Boolean torf, Identifier id)) 
    = "SET INCLUDE NEW <intercalate("",[equals|equals<-strConstOpt])> <toString(torf)> FOR SCHEMA <toString(id)>";

public str toString(SysLvlConfVal::trueVal2()) = "T";

public str toString(SysLvlConfVal::falseVal2()) = "F";

public str toString(SysLvlConfVal::onOff(OnOrOff  onOffLit)) = "<toString(onOffLit)>";

public str toString(SysLvlConfVal::booleanVal(Boolean boolLit)) = "<toString(boolLit)>";

public str toString(ConjuctionType::conjuctionType(AndOr andor)) = "CONJUCTION TYPE <toString(andor)>";

public str toString(ForDtShares::forDtShares()) = "FOR DATA SHARES";

public str toString(RenameOrChange::renameAlter()) = "RENAME";

public str toString(RenameOrChange::ownerAlter()) = "OWNER";

public str toString(ProcedureToOption::newOwner(Identifier id)) = "<toString(id)>";

public str toString(ProcedureToOption::currentUser()) = "CURRENT_USER";

public str toString(ProcedureToOption::sessionUser()) = "SESSION_USER";

public str toString(AlterSchemaOptions::renameSchema(Identifier id)) = "RENAME TO <toString(id)>";

public str toString(AlterSchemaOptions::changeSchemaOwner(Identifier id)) = "OWNER TO <toString(id)>";

public str toString(AlterSchemaOptions::quota(Quota quota)) = "<toString(quota)>";

public str toString(AlterRoleOption::renameToRole(Identifier id)) = "RENAME TO <toString(id)>";

public str toString(AlterRoleOption::ownerToId(Identifier id)) = "OWNER TO <toString(id)>";

public str toString(AlterDBOptions::rnOpt(Identifier id)) = "RENAME TO <toString(id)>";

public str toString(AlterDBOptions::chOwnOpt(Identifier id)) = "OWNER TO <toString(id)>";

public str toString(AlterDBOptions::conOpt(ConnectionLimitOptions connlimitOpts)) = "CONNECTION LIMIT <toString(connlimitOpts)>";

public str toString(AlterDBOptions::colOpt(CaseOption caseopt)) = "COLLATE <toString(caseopt)>";

public str toString(AlterDBOptions::isoOpt(SerializableSnapshot sersnap)) = "ISOLATION LEVEL <toString(sersnap)>";

public str toString(AlterDBOptions::integrOpt(AllOrInerror allInner, list[IntegrationRefreshOptions] integrOpt)) = "INTEGRATION REFRESH <toString(allInner)> TABLES <intercalate("",[toString(integr)|integr<-integrOpt])>";

public str toString(ConnectionLimitOptions::conOptInt(str integer)) = "<integer>";

public str toString(ConnectionLimitOptions::conOptUnlimited()) = "UNLIMITED";

public str toString(AllOrInerror::aall()) = "ALL";

public str toString(AllOrInerror::inError()) = "IN ERROR";

public str toString(IntegrationRefreshOptions::intRefInSchema(list[TableName] tablenameList)) = "IN SCHEMA <intercalate(", ",[toString(tablename)|tablename<-tablenameList])>";

public str toString(IntegrationRefreshOptions::intRefTable(list[TableName] tablenameList)) = "TABLE <intercalate(", ",[toString(tablename)|tablename<-tablenameList])>";

public str toString(AddOrRemoveObjects::addObject()) = "ADD";

public str toString(AddOrRemoveObjects::removeObject()) = "REMOVE";

public str toString(AlterDataShareOptions::tableOpt(list[TableName] tablenameList)) = "TABLE <intercalate(", ",[toString(tablename)|tablename<-tablenameList])>";

public str toString(AlterDataShareOptions::schemaOpt(list[TableName] tablenameList)) = "SCHEMA <intercalate(", ",[toString(tablename)|tablename<-tablenameList])>";

public str toString(AlterDataShareOptions::funcOpt(list[Expr] expr)) = "FUNCTION <intercalate(", ",[toString(exp)|exp<-expr])>";

public str toString(AlterDataShareOptions::allTbInSchema(list[TableName] tablenameList)) = "ALL TABLES IN SCHEMA <intercalate(", ",[toString(tablename)|tablename<-tablenameList])>";

public str toString(AlterDataShareOptions::allFnInSchema(list[TableName] tablenameList)) = "ALL FUNCTIONS IN SCHEMA <intercalate(", ",[toString(tablename)|tablename<-tablenameList])>";

public str toString(RemoveDefinition::removeDefinition()) = "REMOVE DEFINITION";

public str toString(InSchema::inSchema(list[Identifier] ids)) = "IN SCHEMA <intercalate(", ",[toString(id)|id<-ids])>";

public str toString(ForUser::forUser(list[Identifier] idList)) = "FOR USER <intercalate(", ",[toString(id)|id<-idList])>";

public str toString(GrantOrRevoke::grantPrivileges(GrantPrivileges grantPrivileges)) = "GRANT <toString(grantPrivileges)>";

public str toString(GrantOrRevoke::revokePrivileges(RevokePrivileges revokePrivileges)) = "REVOKE <toString(revokePrivileges)>";

public str toString(GrantPrivileges::grantOnTables(CommandListOrAll cmdlistorall, list[T1] t1)) = "<toString(cmdlistorall)> ON TABLES TO <intercalate(", ",[toString(t1Type)|t1Type<-t1])>";

public str toString(GrantPrivileges::grantOnFn(ExecuteOrAll exorall, list[T1] t1)) = "<toString(exorall)> ON FUNCTIONS TO <intercalate(", ",[toString(t1Type)|t1Type<-t1])>";

public str toString(GrantPrivileges::grantOnProced(ExecuteOrAll exorall, list[T1] t1)) = "<toString(exorall)> ON PROCEDURES TO <intercalate(", ",[toString(t1Type)|t1Type<-t1])>";

public str toString(RevokePrivileges::revokeUserOnTable(list[GrantOptionFor] grantoptFor, CommandListOrAll cmdlistorall, list[Identifier] ids, list[Restrict] restrict)) 
    = "<intercalate("",[toString(grantopt)|grantopt<-grantoptFor])> <toString(cmdlistorall)> ON TABLES FROM <intercalate(", ",[toString(id)|id<-ids])> <intercalate("",[toString(restrct)|restrct<-restrict])>";

public str toString(RevokePrivileges::revokeCategoryOnTable(CommandListOrAll cmdlistorall, list[GroupRoles] grouproles, list[Restrict] restrict)) 
    = " <toString(cmdlistorall)> ON TABLES FROM <intercalate(", ",[toString(groupRole)|groupRole<-grouproles])> <intercalate("",[toString(restrct)|restrct<-restrict])>";

public str toString(RevokePrivileges::revokeUserOnFunctions(list[GrantOptionFor] grantoptFor, ExecuteOrAll exorall, list[Identifier] ids, list[Restrict] restrict)) 
    = "<intercalate("",[toString(grantopt)|grantopt<-grantoptFor])> <toString(exorall)> ON FUNCTIONS FROM <intercalate(", ",[toString(id)|id<-ids])> <intercalate("",[toString(restrct)|restrct<-restrict])>";

public str toString(RevokePrivileges::revokeCategoryOnFunctions(ExecuteOrAll exorall, list[GroupRoles] grouproles, list[Restrict] restrict)) 
    = "<toString(exorall)> ON FUNCTIONS FROM <intercalate(", ",[toString(groupRole)|groupRole<-grouproles])> <intercalate("",[toString(restrct)|restrct<-restrict])>";

public str toString(RevokePrivileges::revokeUserOnProcedures(list[GrantOptionFor] grantoptFor, ExecuteOrAll exorall, list[Identifier] ids, list[Restrict] restrict)) 
    = "<intercalate("",[toString(grantopt)|grantopt<-grantoptFor])> <toString(exorall)> ON PROCEDURES FROM <intercalate(", ",[toString(id)|id<-ids])> <intercalate("",[toString(restrct)|restrct<-restrict])>";

public str toString(RevokePrivileges::revokeCategoryOnPocedures(ExecuteOrAll exorall, list[GroupRoles] grouproles, list[Restrict] restrict)) 
    = "<toString(exorall)> ON PROCEDURES FROM <intercalate(", ",[toString(groupRole)|groupRole<-grouproles])> <intercalate("",[toString(restrct)|restrct<-restrict])>";

public str toString(Restrict::restrictKey()) = "RESTRICT";

public str toString(GrantOptionFor::grantOptionFor()) = "GRANT OPTION FOR";

public str toString(ExecuteOrAll::execute()) = "EXECUTE";

public str toString(ExecuteOrAll::allPrivOnFn(AllPrivileges allPriv)) = "<toString(allPriv)>";

public str toString(CommandListOrAll::command(list[Command] cmdList)) = "<intercalate(", ",[toString(cmd)|cmd<-cmdList])>";

public str toString(CommandListOrAll::allPrivOnTb(AllPrivileges allPriv)) = "<toString(allPriv)>";

public str toString(AllPrivileges::allPrivileges(list[str] strConst)) = "ALL <intercalate("",[priv|priv<-strConst])>";

public str toString(T1::gUser(Identifier id, list[WithGrant] withGrantOpt)) = "<toString(id)> <intercalate("",[toString(withGrant)|withGrant<-withGrantOpt])>";

public str toString(T1::groupRoles(GroupRoles grouproles)) = "<toString(grouproles)>";

public str toString(GroupRoles::groupRole(Identifier id)) = "ROLE <toString(id)>";

public str toString(GroupRoles::groupGroup(Identifier id)) = "GROUP <toString(id)>";

public str toString(GroupRoles::groupPublic()) = "PUBLIC";

public str toString(WithGrant::withGrant()) = "WITH GRANT OPTIONS";

public str toString(AlterProcedureOptions::altProcOptionParenthesis(list[AlterProcOptionArg] altargList)) 
    = "( <intercalate(", ",[toString(altarg)|altarg<-altargList])> )";

public str toString(AlterProcOptionArg::alterProcOptionArg(list[Identifier] idOpt, list[ArgMode] argModeOpt, DataType datatype)) 
    = "<intercalate("",[toString(id)|id<-idOpt])> <intercalate("",[toString(argMode)|argMode<-argModeOpt])> <toString(datatype)>";

public str toString(Statement::dropStmt(DropStatement dropStmt)) = "<toString(dropStmt)>";

public str toString(DropStatement::dropFunction(list[IfExists] ifExists, Identifier id, BracketNameModeType2 bracketNMT2, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)) 
    = "DROP FUNCTION <intercalate("",[toString(ifexists)|ifexists<-ifExists])> <toString(id)> <toString(bracketNMT2)> <intercalate("",[toString(cascadeOrForceOrRestrict)|cascadeOrForceOrRestrict<-cascadeOrForceOrRestrictOpt])>";

public str toString(DropStatement::dropTable(list[IfExists] ifExists, TableName tblName, list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt)) 
    = "DROP TABLE <intercalate("",[toString(ifexists)|ifexists<-ifExists])> <toString(tblName)> <intercalate("",[toString(cascadeOrForceOrRestrict)|cascadeOrForceOrRestrict<-cascadeOrForceOrRestrictOpt])>";

public str toString(DropStatement::dropStatement(
        DropOptions dropType
        , list[IfExists] ifExists1
        , list[TableName] tblNameList
        , list[DropExternalDatabase] dropExtDB
        , list[BracketNameModeType] bracketNMTOpt
        , list[IfExists] ifExists2
        , list[CascadeOrForceOrRestrict] cascadeOrForceOrRestrictOpt
        , list[TableName] tblNameOpt)) 
    = "DROP <toString(dropType)> <intercalate("",[toString(ifexists)|ifexists<-ifExists1])> <intercalate(", ",[toString(tblName)|tblName<-tblNameList])> <intercalate("",[toString(dropExt)|dropExt<-dropExtDB])> <intercalate("",[toString(bracketNMT)|bracketNMT<-bracketNMTOpt])> <intercalate("",[toString(ifexists2)|ifexists2<-ifExists2])> " +
    "<intercalate("",[toString(cascadeOrForceOrRestrict)|cascadeOrForceOrRestrict<-cascadeOrForceOrRestrictOpt])> <intercalate("",[toString(tblName2)|tblName2<-tblNameOpt])>";

public str toString(DropOptions::dDatabase()) = "DATABASE";

public str toString(DropOptions::dDatashare()) = "DATASHARE";

public str toString(DropOptions::dExternalView()) = "EXTERNAL VIEW";

public str toString(DropOptions::dGroup()) = "GROUP";

public str toString(DropOptions::dIdentityProvider()) = "IDENTITY PROVIDER";

public str toString(DropOptions::dLibrary()) = "LIBRARY";

public str toString(DropOptions::dMaskingPolicy()) = "MASKING POLICY";

public str toString(DropOptions::dModel()) = "MODEL";

public str toString(DropOptions::dMaterializedView()) = "MATERIALIZED VIEW";

public str toString(DropOptions::dProcedure()) = "PROCEDURE";

public str toString(DropOptions::dRlsPolicy()) = "RLS POLICY";

public str toString(DropOptions::dRole()) = "ROLE";

public str toString(DropOptions::dSchema()) = "SCHEMA";

public str toString(DropOptions::dUser()) = "USER";

public str toString(DropOptions::dView()) = "VIEW";

public str toString(DropExternalDatabase::dropExternalDatabase()) = "DROP EXTERNAL DATABAS";

public str toString(NameModeType2::nameModeType2(list[Identifier] idOpt, list[ArgMode] argModeOpt, DataType datatype)) = "<intercalate("",[toString(id)|id<-idOpt])> <intercalate("",[toString(argMode)|argMode<-argModeOpt])> <toString(datatype)>";

public str toString(Command::selectCmd()) = "SELECT";

public str toString(Command::insertCmd()) = "Insert";

public str toString(Command::updateCmd()) = "UPDATE";

public str toString(Command::deleteCmd()) = "Delete";

public str toString(Command::dropCmd(DropStatement dstmnt)) = "<toString(dstmnt)>";

public str toString(Command::referenceCmd()) = "REFERENCES";

public str toString(Command::truncateCmd()) = "TRUNCATE";

public str toString(BracketNameModeType2::bracketNameModeType(list[NameModeType2] nameModeType2)) = "( <intercalate(", ",[toString(nameMode)|nameMode<-nameModeType2])> )";
