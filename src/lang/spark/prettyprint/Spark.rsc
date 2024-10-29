module lang::spark::prettyprint::Spark

import lang::spark::ast::Spark;
extend lang::functionLang::prettyprinter::Function;
import List;
import String;



public str toString(Spark s){
    switch(s){
        case expression(Expr e):return toString(e);
        case simpleStatement(Statement statement):return toString(statement);
        case statements(list[StatementWithTerminator] stmts): {
           return "<intercalate("\n\n",[ "<toString(sts)><intercalate("",[toString(term)|term<-terms])>"| statementWithTerminator(Statement sts,list[Terminator] terms)<-stmts])>";
            
        } 
        default: throw ToStringException("message:Unable to resolve Spark start",s);
    }
}
public str toString(terminator())= ";";




// Auxiliary Statement

public str toString(Statement::describeStatement(Describe desc)) = toString(desc);



public str toString(Describe desc){
    switch(desc){
        case  describeDb(Desc desc,list[Extended] exts , list[Identifier] ids):return "<toString(desc)> DATABASE <intercalate("",[toString(fn)|fn<-exts])> <intercalate(".",[toString(id)|id<-ids])>";
        case  describeFunc(Desc desc,list[Extended] exts , list[Identifier] ids):return "<toString(desc)> FUNCTION <intercalate("",[toString(fn)|fn<-exts])> <intercalate(".",[id|id<-ids])>";
        case  describeQuery(Desc desc, list[DescribeStatement] dest):return "<toString(desc)> QUERY <prettyOptional(dest, toString)>";
        case  describeTable(Desc desc,list[Table] tbl, list[Extended] exts,TableName tid,list[PartitionClause] pcl):return "<toString(desc)>  <intercalate("",[toString(tb)|tb<-tbl])> <intercalate("",[toString(fn)|fn<-exts])> <toString(tid)> <intercalate("",[toString(tb)|tb<-pcl])>";
        case  describeTableWithId(Desc desc,list[Table] tbl, list[Extended] exts,TableName tid,PartitionClause  pcl , list[Identifier] ids):return "<toString(desc)>  <intercalate("",[toString(tb)|tb<-tbl])> <intercalate("",[toString(fn)|fn<-exts])> <toString(tid)> <intercalate("",[toString(tb)|tb<-pcl])> <intercalate(".",[id|id<-ids])>";
        case  listFile(File file,Url url):return "LIST <toString(file)> <toString(url)>";
        case  listJar(Jar jar, Url url):return "LIST <toString(jar)> <toString(url)>";
        case  refresh(Url url):return "REFRESH <toString(url)>";
        case  refreshTable(list[Table] tb,TableName tid):return "REFRESH <intercalate("",[toString(tbl)|tbl<-tb])> <toString(tid)>";
        case  refreshFuntion(list[Identifier] ids):return "REFRESH FUNCTION <intercalate(".",[id|id<-ids])>";
        case  reset(list[Identifier] ids):return "RESET <intercalate(".",[id|id<-ids])>";
        case  showColumns(ColumnKeyword column,FromOrIn foi,list[FromOrIn] fromorIn):return "SHOW <toString(column)> <toString(foi)> <intercalate("",[toString(tbl)|tbl<-fromorIn])>";      
        case  showCreateTable(TableName tid, list[VarAssignAs] assign):return "SHOW CREATE TABLE <toString(tid)> <intercalate("",["<toString(ass)> serde"| ass<-assign])>";
        case  showDatabases(DatabaseOrSchema dos, list[Expr] exp):return "SHOW <toString(dos)> <intercalate("",["like <toString(e)>"|e<-exp])>";
        case  showFunction(list[FunctionKind] fk,list[FromOrIn] fromorIn,list[Expr] exps):return "show <intercalate("",[toString(e)|e<-fk])> functions <intercalate("",[toString(tbl)|tbl<-fromorIn])> <intercalate("",["like <toString(e)>"|e<-exps])>";
        case  showPartitions(TableName tid, list[PartitionClause] pcl):return "SHOW PARTITIONS <toString(tid)> <intercalate("",[toString(tb)|tb<-pcl])>";
        case  showTableExtended(list[FromOrIn] fromorIn,Expr expr,list[PartitionClause] pcl):return "show table extended <intercalate("",[toString(tb)|tb<-fromorIn])> like <toString(expr)> <intercalate("",[toString(tb)|tb<-pcl])>";
        case  showTables(list[FromOrIn] fromorIn,list[Expr] exps):return "SHOW TABLES <intercalate("",[toString(tb)|tb<-fromorIn])> <intercalate("",["LIKE <toString(e)>"|e<-exps])>";
        case  showTableProperties(TableName tid,UnquotedOrString uqos):return "SHOWS TBLPROPERTIES <toString(tid)> (<toString(uqos)>)";
        case  showViews(list[FromOrIn] fromorIn, list[Expr] exps):return "SHOW VIEW <intercalate("",[toString(tb)|tb<-fromorIn])> <intercalate("",["like <toString(e)>"|e<-exps])>";
        case  uncache(list[IfExists] ifex,TableName tid):return "UNCACHE TABLE <intercalate("",[toString(ifEx)|ifEx<-ifex])> <toString(tid)>";
        default: throw ToStringException("message: Unable to generate DESCRIBE node syntax",desc);
    }
}


public str toString(Desc::desc())= "DESC";
public str toString(Desc::describe())= "DESCRIBE";
public str toString(lazy())= "LAZY";

public str toString(Extended extnd){
    switch(extnd){
        case extended(): return "EXTENDED";
        default: throw  ToStringException("message:Unable to resolve EXTENDED",extnd);
    }
}


public str toString(FromOrIn foi){
    switch(foi){
        case from(list[Identifier] fid): return "from <intercalate(".",[toString(id)|id<-fid])>";
        case \in(list[Identifier] inId): return "in <intercalate(".",[toString(id)|id<-inId])>";
        default: throw ToStringException("message:Prettyprinting error",foi);
    }
}


public str toString(FunctionKind fk){
    switch(fk){
        case user(): return "USER";
        case system(): return "SYSTEM";
        case \all(): return "ALL";
        default: throw ToStringException("message : Unresolved Function Kind",fk);
    }  
}


public str toString(Jar::jars())= "JARS";

public str toString(File::files())= "FILES";
 

public str toString( unquote(str strval))= "<strval>";
       



// Query
public str toString(QueryExpr qryexpr){
    switch(qryexpr){
        case querySpark(QuerySpark querySpark): return "<toString(querySpark)>";
        case queryIntersectSetQuantifier(QueryExpr queryExpr1, IntersectWithSetQuantifier intersectWithSet, QueryExpr queryExpr2): return "<toString(queryExpr1)> <toString(intersectWithSet)> <toString(queryExpr2)>";
        case queryExceptDistinct(QueryExpr queryExpr1, ExceptDistinct exceptDistinct, QueryExpr queryExpr2): return "<toString(queryExpr1)> <toString(exceptDistinct)> <toString(queryExpr2)>";
        case queryMinusSetquantifier(QueryExpr queryExpr1, MinusSetQuantifier minusSetQuantifier, QueryExpr queryExpr2): return "<toString(queryExpr1)> <toString(minusSetQuantifier)> <toString(queryExpr2)>";

        default: throw ToStringException("message: Unable to resolve this query expression",qryexpr);
    }
}

public str toString(IntersectWithSetQuantifier::intersectWithSetQuantifier(SetQuantifier setQuantifier)) = "INTERSECT <toString(setQuantifier)>";
public str toString(exceptDistinct(list[SetQuantifier] setQuantifier)) = "EXCEPT <prettyOptional(setQuantifier, toString)>";
public str toString(minusSetQuantifier(list[SetQuantifier] setQuantifier)) = "MINUS <prettyOptional(setQuantifier, toString)>";

public str toString(
    QuerySpark::query(
        SelectClause selectClause
        , list[FromClause] fromClauseOpt
        , list[Distributed] distributedOpt
        , list[SortedByClause] sortedByClauseOpt
        , list[PivotUnpivot] pivotUnpivotOpt
        , list[LateralView] lateralView
        , list[JoinClause] joinClause
        , list[WhereClause] whereClauseOpt
        , list[GroupByClause] groupByClauseOpt
        , list[HavingClause] havingClauseOpt  
        , list[WindowClause] windowClauseOpt
        , list[OrderByClause] orderByClauseOpt 
        , list[LimitOffsetClauses] limitOffsetClausesOpt
        , list[QueryClusterByClause] queryClusterByClauseOpt
    )
) = "<toString(selectClause)>\n" + 
    trim("<prettyOptional(fromClauseOpt, toString, sep="\n")>" + 
            "<prettyOptional(distributedOpt, toString, sep="\n")>" + 
            "<prettyOptional(sortedByClauseOpt, toString, sep="\n")>" +
            "<prettyOptional(pivotUnpivotOpt, toString, sep="\n")>" + 
            "<intercalate(" ",[toString(latView)|latView<-lateralView])>\n" +
            "<prettyOptional(joinClause, toString, sep="\n")>" + 
            "<prettyOptional(whereClauseOpt, toString, sep="\n")>" + 
            "<prettyOptional(groupByClauseOpt, toString, sep="\n")>"+ 
            "<prettyOptional(havingClauseOpt, toString, sep="\n")>" + 
            "<prettyOptional(windowClauseOpt, toString, sep="\n")>" + 
            "<prettyOptional(orderByClauseOpt, toString, sep="\n")>" + 
            "<prettyOptional(limitOffsetClausesOpt, toString, sep="\n")>" + 
            "<prettyOptional(queryClusterByClauseOpt, toString, sep="\n")>"
        );




public str toString(SortedByClause::sortByCls(list[str] openingBracket, list[SortedByElem] sortedByElemList, list[str] closingBracket)) 
    = "SORT BY <intercalate("",[opening|opening<-openingBracket])> <intercalate(", ",[toString(sortByElem)|sortByElem<-sortedByElemList])> <intercalate("",[closing|closing<-closingBracket])>";

public str toString(SortedByElem::sortByElemExpr(Expr expr, list[SortedByDirection] sortedByDirectionList, list[NullFirstOrLast] nullFirstOrLastList)) 
    = "<toString(expr)> <intercalate("",[toString(sortedByDirection)|sortedByDirection<-sortedByDirectionList])> <intercalate("",[toString(nullFirstOrLast)|nullFirstOrLast<-nullFirstOrLastList])>";


public str toString(SelectClause::selectClauseWithTranform(list[SetQuantifier] setQuantifierList, TransformClause transfrmCls)) 
    = "SELECT <intercalate("",[toString(setQuantifier)|setQuantifier<-setQuantifierList])> <toString(transfrmCls)>";

public str toString(TransformClause::transform(list[Expr] exprList, list[RowFormatClause] rowFormatClsList1, list[str] strConstList,
                        str strConst, list[TAlias] tAliasList, list[RowFormatClause] rowFormatClsList2, list[str] strConstList2
                        )) 
    = "TRANSFORM( <intercalate(", ",[toString(expr)|expr<-exprList])> ) <intercalate("",[toString(rowFormatCls)|rowFormatCls<-rowFormatClsList1])> <intercalate("",[strConst1|strConst1<-strConstList])> USING <strConst> <intercalate("",[toString(tAlias)|tAlias<-tAliasList])> <intercalate("",[toString(rowFormatCls2)|rowFormatCls2<-rowFormatClsList2])> <intercalate("",[strConst2|strConst2<-strConstList2])>";

public str toString(TAlias::tAlias(list[ColumnSpecification] cols)) 
    = "AS ( <intercalate(", ",[toString(colSpec)|colSpec<-cols])> )";

public str toString(PivotUnpivot::pivot(lrel[Function aggfunc, list[PivotAlias] pivotAliasList] agg,ColList collist,lrel[ExpressionList explist,list[PivotAlias] pivotAliasList] exl)) 
    = "PIVOT ( <for(aggreg <- agg) {> <toString(aggreg.aggfunc)> <intercalate("",[toString(pivotAlias)|pivotAlias<-aggreg.pivotAliasList])><if (aggreg != agg[-1]) {>, <}> <}> FOR <toString(collist)> IN ( <for(ex <- exl) {> <toString(ex.explist)> <intercalate("",[toString(pivotAlias)|pivotAlias<-ex.pivotAliasList])><if (ex != exl[-1]) {>, <}><}> ) )";

public str toString(PivotUnpivot::unpivot( list[IncludeorEx] incoex , ValueColumnUnpivot valcolun, list[PivotAlias] pivotAliasList)) 
    = "UNPIVOT <for(inclEx <- incoex) {> <toString(inclEx)> NULLS <}> ( <toString(valcolun)> ) <intercalate("",[toString(pivotAlias)|pivotAlias<-pivotAliasList])>";

public str toString(ValueColumnUnpivot::valueColumnUnpivot(ColList collist, str name, lrel[ExpressionList explist, list[PivotAlias] pivotAliasList] exl)) 
    = "<toString(collist)> For <name> IN ( <for(ex <- exl) {><toString(ex.explist)> <intercalate("",[toString(pivotAlias)|pivotAlias<-ex.pivotAliasList])><if (ex != exl[-1]) {>, <}><}> )";

public str toString(IncludeorEx::include()) = "INCLUDE";

public str toString(IncludeorEx::exclude()) = "EXCLUDE";

public str toString(PivotAlias::pivotAs(str id)) = "AS <id>";

public str toString(ColList::singleCol(str id)) = "<id>";

public str toString(ColList::multipleCol(list[str] ids)) = "( <intercalate(", ",[identifier|identifier<-ids])> )";

public str toString(ExpressionList::singleExpr(str exp)) = "<exp>";

public str toString(ExpressionList::multipleExpr(list[Expr] exps)) = "( <intercalate(", ",[toString(exp)|exp<-exps])> )";



public str toString(CTEClause::cteClauseWithParam(Identifier id, list[Identifier] idList, QueryOrWith queryOrWith)) 
    = "<toString(id)> ( <intercalate(", ",[toString(name)|name<-idList])> ) AS ( <toString(queryOrWith)> )";

public str toString(CTEClause::cteClauseNoParam(Identifier id, NestedWith nestedWith)) 
    = "<toString(id)> AS ( <toString(nestedWith)> )";

public str toString(NestedWith::nestedWith(WithClause withClause, list[CTEClause] cteClauseList, Query qry)) 
    = "<toString(withClause)> <intercalate(", ",[toString(cteCls)|cteCls<-cteClauseList])>  ( <toString(qry)> )";

public str toString(Subquery::subqueryWithNested(NestedWith nestedWith)) 
    = "( <toString(nestedWith)> )";

public str toString(TableIdOrSubquery::tableIdWithAs(TableName tableName, Identifier id)) 
    = "<toString(tableName)> AS <toString(id)>";

public str toString(TableIdOrSubquery::tableIdSubqueryWithAs(Query qry, Identifier id)) 
    = "(<toString(qry)>) AS <toString(id)>";

public str toString(TableIdOrSubquery::tableId(TableName tblName, list[Identifier] idList, TableSample tblSample)) 
    = "<toString(tblName)> <intercalate("",[toString(id)|id<-idList])> <toString(tblSample)>";

public str toString(TableIdOrSubquery::tableIdAsExpr(Function funcCall, list[VarAssign] varAssignList, list[TableSample] tblSampleList)) 
    = "<toString(funcCall)> <intercalate("",[toString(varAssign)|varAssign<-varAssignList])> <intercalate("",[toString(tblSample)|tblSample<-tblSampleList])>";

public str toString(TableIdOrSubquery::tableIdWithValue(Value val)) 
    = "<toString(val)>";

public str toString(TableIdOrSubquery::tableIdLateralSubquery(Query qry, list[VarAssign] varAssignList)) 
    = "LATERAL ( <toString(qry)> ) <intercalate("",[toString(varAssign)|varAssign<-varAssignList])>";

public str toString(TableIdOrSubquery::tableIdOrSubqueryNestedWith(NestedWith nestedWith)) 
    = "( <toString(nestedWith)> )";

public str toString(TableSample::tableSample(SampleQuantifier sampleQuant)) 
    = "TABLESAMPLE ( <toString(sampleQuant)> )";

public str toString(SampleQuantifier::exprPercent(Expr expr)) 
    = "<toString(expr)> PERCENT";

public str toString(SampleQuantifier::exprRows(Expr expr)) 
    = "<toString(expr)> ROWS";

public str toString(SampleQuantifier::exprBucket(Expr expr1, Expr expr2)) 
    = "BUCKET <toString(expr1)> OUT OF <toString(expr2)>";

// LateralView
public str toString(LateralView::lateralView(
    list[Outer] outerOpt    
    , Function func
    , Identifier id1
    , list[Identifier] ids
  )
) = "LATERAL VIEW <prettyOptional(outerOpt, prettyOuter)> <toString(func)> <toString(id1)> AS <intercalate(",", [ toString(id) | id <- ids ])>";

public str toString(LateralView::lateralViewNoId(
    list[Outer] outerOpt    
    , Function func
    , list[Identifier] ids
  )
) = "LATERAL VIEW <prettyOptional(outerOpt, prettyOuter)> <toString(func)> AS <intercalate(",", [ toString(id) | id <- ids ])>";

// GroupByClause

public str toString(GroupByClause::groupByClauseGroupingSets(list[ExpAsVar] expAsVarList, GroupingSets groupingSets, list[WithOption] withOptionList)) 
= "GROUP BY <intercalate(",", [ toString(expAsVar) | expAsVar <- expAsVarList ])> <toString(groupingSets)>  <intercalate("", [ toString(withOption) | withOption <- withOptionList ])>";

public str toString(GroupByClause::groupByClauseWithOption(list[ExpAsVar] expAsVarList, WithOption withOption))
= "GROUP BY <intercalate(",", [ toString(expAsVar) | expAsVar <- expAsVarList ])> <toString(withOption)>";

public str toString(WithOption::rollupWith()) 
= "WITH ROLLUP";

public str toString(WithOption::cubeWith()) 
= "WITH CUBE";

public str toString(GroupingSets::groupingSets(list[GroupingSet] groupingSetList))
= "( <intercalate(",", [ toString(groupingSet) | groupingSet <- groupingSetList ])> )";

public str toString(GroupingSet::group(list[Expr] exprList))
= "( <intercalate(",", [ toString(expr) | expr <- exprList ])> )";

public str toString(JoinClause::semiJoinClause(SemiJoin semiJoin, TableIdOrSubquery tableIdOrSubquery, JoinCondition joinCond, list[JoinClause] joinClauseList))
= "<toString(semiJoin)> <toString(tableIdOrSubquery)> <toString(joinCond)> <intercalate("", [ toString(joinClause) | joinClause <- joinClauseList ])>";

public str toString(SemiJoin::semiJoin()) = "SEMI JOIN";

public str toString(LimitClause::limitClauseAll()) = "LIMIT ALL";

// Functions

public str toString(Expr::function(Function fCall, list[AnalyticFunctionClause] analyticOpt))=
 "<toString(fCall)> <prettyOptional(analyticOpt,toString)>";


public str toString(\filter(WhereClause wcl))="FILTER(<toString(wcl)>)";






public str toString(TableValued::range(list[Expr] exps)) = "RANGE ( <intercalate(", ",[toString(e)|e<-exps])> )";


public str toString(NullOption::ignore()) = "IGNORE NULLS";
public str toString(NullOption::respect()) = "RESPECT NULLS";



public str toString(Predicate::ilikeF(Expr exp1,Expr exp2)) = "ilike(<toString(exp1)>,<toString(exp2)>)";
public str toString(Predicate::likeF(Expr exp1,Expr exp2)) = "like(<toString(exp1)>,<toString(exp2)>)";
public str toString(Predicate::regExp(Expr exp1,Expr exp2)) = "regexp(<toString(exp1)>,<toString(exp2)>)";
public str toString(Predicate::rlikeF(Expr exp1,Expr exp2)) = "rlike(<toString(exp1)>,<toString(exp2)>)";
public str toString(Expr::\in(Expr exp1,list[Expr] exprs2)) = "<toString(exp1)> in (<intercalate(",",[toString(e)|e<-exprs2])>)";




public str toString(ConditionalFunction::nvlFunction(Expr e1,Expr e2)) = "nvl(<toString(e1)>,<toString(e2)>)";
public str toString(ConditionalFunction::nvl2(Expr e1,Expr e2,Expr e3)) = "nvl2(<toString(e1)>,<toString(e2)>,<toString(e3)>)";
public str toString(ConditionalFunction::ifFunction(Expr e1,Expr e2,Expr e3)) = "if(<toString(e1)>,<toString(e2)>,<toString(e3)>)";
public str toString(ConditionalFunction::coalesce(Expr e1,list[Expr] es)) = "nvl(<toString(e1)>,<intercalate("",[toString(e)|e<-es])>)";
public str toString(ConditionalFunction::ifNull(Expr e1,Expr e2)) = "ifNull(<toString(e1)><toString(e2)>)";
public str toString(ConditionalFunction::nullIf(Expr e1,Expr e2)) = "nullIf(<toString(e1)><toString(e2)>)";





public str toString(AnalyticFunctionClause::analyticFunctionClause(WindowSpecification windSpec)) = "OVER <toString(windSpec)>";

public str toString(VarAssign::varAssignFunc(list[VarAssignAs] varAssignAsList,  Identifier id, list[Expr] exprList)) = "<intercalate(", ", [toString(varAssignAs) | varAssignAs <- varAssignAsList])> <toString(id)>( <intercalate(", ", [toString(expr) | expr <- exprList])> )";

// WindowFunction
public str toString(WindowFunction::lead(Expr expr, list[LeadLagOffSet] leadLagOffSet)) = "LEAD(<toString(expr)> <prettyOptional(leadLagOffSet, toString)>)";
public str toString(WindowFunction::lag(Expr expr,  list[LeadLagOffSet] leadLagOffSet)) = "LAG(<toString(expr)> <prettyOptional(leadLagOffSet, toString)>)";
public str toString(WindowFunction::firstValue(Identifier id, list[CommaThenBoolean] commaThenBoolean)) = "FIRST_VALUE(<toString(id)> <prettyOptional(commaThenBoolean, toString)>)";
public str toString(WindowFunction::lastValue(Identifier id, list[CommaThenBoolean] commaThenBoolean)) = "LAST_VALUE(<toString(id)> <prettyOptional(commaThenBoolean, toString)>)";
public str toString(WindowFunction::dense()) = "DENSE_RANK()";
public str toString(WindowFunction::rank()) = "RANK()";
public str toString(WindowFunction::cumeDist()) = "CUME_DIST()";
public str toString(WindowFunction::nthValue(Expr input, list[Expr] offsetList)) = "NTH_VALUE( <toString(input)> <for(offset <- offsetList) {>, <toString(offset)><}> )";

// LeadLagOffSet
public str toString(LeadLagOffSet::leadLagOffSet(str \int, list[LeadLagDefault] leadLagDefault)) = ", <\int> <prettyOptional(leadLagDefault, toString)>";

// LeadLagDefault
public str toString(LeadLagDefault::leadLagDefault(Expr expr)) = ", <toString(expr)>";

// CommaThenBoolean
public str toString(CommaThenBoolean::commaThenBoolean(Boolean boolean)) = ", <toString(boolean)>";

// AnalyticFunctionClause
public str toString(AnalyticFunctionClause::analyticFunctionClause(WindowSpecification windSpec)) = "OVER <toString(windSpec)>";







public str toString(ArrayFunction::arrayFunc(list[Expr] exps)) = "array(<intercalate(",",[toString(exp)|exp<-exps])>)";
public str toString(ArrayFunction::struct(list[Expr] exps)) = "struct(<intercalate(",",[toString(exp)|exp<-exps])>)";
public str toString(ArrayFunction::arrayAppend( Expr e1, Expr e2)) = "array_append(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::arrayCompact(Expr exp)) = "array_compact(<toString(exp)>)";
public str toString(ArrayFunction::arrayContains( Expr e1, Expr e2)) = "array_contains(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::arrayDistinct(Expr exp)) = "array_distinct(<toString(exp)>)";
public str toString(ArrayFunction::arrayExcept( Expr e1, Expr e2)) = "array_except(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::\insert( Expr e1, Expr e2, Expr e3)) = "array_insert(<toString(e1)>,<toString(e2)>,<toString(e3)>)";
public str toString(ArrayFunction::intersect( Expr e1, Expr e2)) = "array_intersect(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::\join( Expr e1, Expr e2,list[Expr] exps)) = "array_join(<toString(e1)>,<toString(e2)> <intercalate("",[",<toString(q)>"|q<-exps])>)";
public str toString(ArrayFunction::arrayMax(Expr exp)) = "array_max(<toString(exp)>)";
public str toString(ArrayFunction::arrayMin(Expr exp)) = "array_min(<toString(exp)>)";
public str toString(ArrayFunction::arrayPos( Expr e1, Expr e2)) = "array_position(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::array_prepend( Expr e1, Expr e2)) = "array_prepend(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::array_remove( Expr e1, Expr e2)) = "array_remove(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::arrayRepeat( Expr e1, Expr e2)) = "array_repeat(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::union( Expr e1, Expr e2)) = "array_union(<toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::overlap( Expr e1, Expr e2)) = "arrays_overlap(<toString(e1)>,<toString(e2)>)"; 
public str toString(ArrayFunction::zip(Expr exp, list[Expr] exps)) = "zip( <toString(exp)>,<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(ArrayFunction::flatten(Expr exp)) = "flatten(<toString(exp)>)";
public str toString(ArrayFunction::get( Expr e1, Expr e2)) = "get( <toString(e1)>,<toString(e2)>)";
public str toString(ArrayFunction::sequence( Expr e1, Expr e2,Expr e3)) = "sequence( <toString(e1)>,<toString(e2)>,<toString(e3)>)";
public str toString(ArrayFunction::shuffle(Expr exp)) = "shuffle(<toString(exp)>)";
public str toString(ArrayFunction::slice( Expr e1, Expr e2,Expr e3)) = "slice( <toString(e1)>,<toString(e2)>,<toString(e3)>)";
public str toString(ArrayFunction::sort( Expr e1,list[Expr]  exps)) = "sort_array(<toString(e1)> <intercalate("",[",<toString(q)>"|q<-exps])>)";

public str toString(ignoreNull()) = "IGNORE NULLS";
public str toString(Order::cont()) = "PERCENTILE_CONT";
public str toString(Order::disc()) = "PERCENTILE_DISC";

public str toString(distributed(list[Expr] exps))="DISTRIBUTE BY <intercalate(",",[toString(fcl)|fcl<-exps])>";




public str toString(DateTimeFunction::toDate(Expr exp)) = "to_date(<toString(exp)>)";
public str toString(DateTimeFunction::toUtcTimestamp(Expr exp1, Expr exp2)) = "TO_UTC_TIMESTAMP((<toString(exp1)>,<toString(exp2)>))";
public str toString(DateTimeFunction::fromUtcTimestamp(Expr exp1, Expr exp2)) = "FROM_UTC_TIMESTAMP((<toString(exp1)>,<toString(exp2)>))";
public str toString(DateTimeFunction::fromUnixTimeTwoParam(Expr exp1, Expr exp2)) = "FROM_UNIXTIME(<toString(exp1)>,<toString(exp2)>)";
public str toString(DateTimeFunction::unixTimestampNoParam()) = "UNIX_TIMESTAMP()";
public str toString(DateTimeFunction::unixTimestampOneParam(Expr exp)) = "UNIX_TIMESTAMP(<toString(exp)>)";
public str toString(DateTimeFunction::unixTimestampTwoParam(Expr exp1, Expr exp2)) = "UNIX_TIMESTAMP(<toString(exp1)>,<toString(exp2)>)";
public str toString(DateTimeFunction::dateSub(Expr exp1, Expr exp2)) = "DATE_SUB(<toString(exp1)>,<toString(exp2)>)";
public str toString(DateTimeFunction::dateAdd(Expr exp1, Expr exp2)) = "DATE_ADD(<toString(exp1)>,<toString(exp2)>)";
public str toString(DateTimeFunction::dateDiff(Expr exp1, Expr exp2)) = "DATEDIFF(<toString(exp1)>,<toString(exp2)>)";
public str toString(DateTimeFunction::currentTimeStamp()) = "CURRENT_TIMESTAMP()";
public str toString(DateTimeFunction::currentDate()) = "CURRENT_DATE()";
public str toString(DateTimeFunction::monthsBetween(Expr exp1, Expr exp2)) = "MONTHS_BETWEEN(<toString(exp1)>,<toString(exp2)>)";
public str toString(DateTimeFunction::month(Expr exp)) = "month(<toString(exp)>)";
public str toString(DateTimeFunction::year(Expr exp)) = "year(<toString(exp)>)";
public str toString(DateTimeFunction::addMonths(Expr exp1, Expr exp2)) = "add_months(<toString(exp1)>,<toString(exp2)>)";




public str toString(MathFunction::ceilFunction(list[Expr] exps)) = "ceil(<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(MathFunction::ceilingFunction(list[Expr] exps)) = "ceiling(<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(MathFunction::exponent(Expr exp)) = "exp(<toString(exp)>)";
public str toString(MathFunction::hex(Expr exp)) = "hex(<toString(exp)>)";
public str toString(MathFunction::unhex(Expr exp)) = "unhex(<toString(exp)>)";
public str toString(MathFunction::div(Expr exp1, Expr exp2)) = "<toString(exp1)> div <toString(exp2)>";



public str toString(StringFunction::ascii(Expr exp)) = "ascii(<toString(exp)>)";
public str toString(StringFunction::regExpReplace(Expr exp1, Expr exp2,Expr exp3)) = "regexp_replace(<toString(exp1)>,<toString(exp2)>,<toString(exp3)>)";
public str toString(StringFunction::base64(Expr exp)) = "base64(<toString(exp)>)";
public str toString(StringFunction::btrim(Expr exp, list[Expr] e)) = "btrim(<toString(exp)> <intercalate("",[",<toString(ex)>"|ex<-e])>)";
public str toString(StringFunction::blen(Expr exp)) = "bit_length(<toString(exp)>)";
public str toString(StringFunction::encode(Expr exp1, Expr exp2)) = "encode(<toString(exp1)>,<toString(exp2)>)";
public str toString(StringFunction::decode(Expr exp1, Expr exp2)) = "decode(<toString(exp1)>,<toString(exp2)>)";
public str toString(StringFunction::char(Expr exp)) = "char(<toString(exp)>)";
public str toString(StringFunction::chr(Expr exp)) = "chr(<toString(exp)>)";
public str toString(StringFunction::length(Expr exp)) = "length(<toString(exp)>)";
public str toString(StringFunction::len(Expr exp)) = "len(<toString(exp)>)";
public str toString(StringFunction::concat(Expr exp, list[Expr] e)) = "concat(<toString(exp)>,<intercalate(",",[<toString(ex)>|ex<-e])>)";
public str toString(StringFunction::instr(Expr exp1, Expr exp2)) = "instr(<toString(exp1)><toString(exp2)>)";
public str toString(StringFunction::substring(Expr exp1, Expr exp2)) = "substring(<toString(exp1)>,<toString(exp2)>)";
public str toString(StringFunction::substringWithEnd(Expr exp1, Expr exp2,Expr exp3)) = "substring(<toString(exp1)>,<toString(exp2)>,<toString(exp3)>)";
public str toString(StringFunction::substr(Expr exp1, Expr exp2)) = "substr(<toString(exp1)>,<toString(exp2)>)";
public str toString(StringFunction::substrfrom(Expr exp, From fr)) = "substr(<toString(exp)> <toString(fr)>)";
public str toString(StringFunction::substringfrom(Expr exp, From fr)) = "substring(<toString(exp)> <toString(fr)>)";
public str toString(StringFunction::substrWithEnd(Expr exp1, Expr exp2,Expr exp3)) = "substr(<toString(exp1)>,<toString(exp2)>,<toString(exp3)>)";
public str toString(StringFunction::upper(Expr exp)) = "upper(<toString(exp)>)";
public str toString(StringFunction::uCase(Expr exp)) = "ucase(<toString(exp)>)";
public str toString(StringFunction::lower(Expr exp)) = "lower(<toString(exp)>)";
public str toString(StringFunction::lCase(Expr exp)) = "lcase(<toString(exp)>)";
public str toString(StringFunction::left( Expr exp1,Expr exp2)) = "left(<toString(exp1)> , <toString(exp2)>)";   
public str toString(StringFunction::getJsonObject(Expr exp1, Expr exp2)) = "get_json_object(<toString(exp1)> , <toString(exp2)>)";
public str toString(StringFunction::char_len(Expr exp)) = "char_length(<toString(exp)> )";
public str toString(StringFunction::character_len(Expr exp)) = " character_length(<toString(exp)> )";
public str toString(StringFunction::concat_ws(Expr exp, list[Expr] e)) = "concat_ws(<toString(exp)><intercalate("",[",<toString(es)>"|es<-e])> )";    
public str toString(StringFunction::contains(Expr exp1, Expr exp2)) = "contains(<toString(exp1)> , <toString(exp2)>)";
public str toString(StringFunction::decodewithSearch(Expr exp, lrel[ Expr search,Expr result] exps , list[Expr] ex)) = "decode(<toString(exp)><intercalate("",["<toString(q.search)>,<toString(q.result)>"|q<-exps])>) <intercalate("",[",<toString(es)>"|es<-ex])>"; 
        // case elt(Expr exp, list[Expr] e)) = "elt(<toString(exp)><intercalate("",[",<toString(es)>"|es<-e])> )";        
public str toString(StringFunction::endsWith(Expr exp1, Expr exp2)) = "endswith(<toString(exp1)> , <toString(exp2)>)";       
public str toString(StringFunction::fis(Expr exp1, Expr exp2)) = "find_in_set(<toString(exp1)> , <toString(exp2)>)"; 
public str toString(StringFunction::fNumber(Expr exp1, Expr exp2)) = "format_number(<toString(exp1)> , <toString(exp2)>)";
public str toString(StringFunction::formatString(Expr exp, list[Expr] e)) = "format_string(<toString(exp)><intercalate("",[",<toString(es)>"|es<-e])> )";    
public str toString(StringFunction::initCap(Expr exp)) = "initcap(<toString(exp)> )";    
public str toString(StringFunction::leven(Expr exp1, Expr exp2,list[Expr] exps3)) = "levenshtein(<toString(exp1)>,<toString(exp2)><intercalate("",[",<toString(es)>"|es<-exps3])> )"; 
public str toString(StringFunction::locate(Expr exp1, Expr exp2,list[Expr] exps3)) = "locate(<toString(exp1)>,<toString(exp2)><intercalate("",[",<toString(es)>"|es<-exps3])>)";     
public str toString(StringFunction::lpad(Expr exp1, Expr exp2,list[Expr] exps3)) = "lpad(<toString(exp1)>,<toString(exp2)><intercalate("",[",<toString(es)>"|es<-exps3])>)"; 
public str toString(StringFunction::ltrim( Expr exp)) = "ltrim(<toString(exp)>)";    
public str toString(StringFunction::lhunCheck( Expr exp)) = "lhunCheck(<toString(exp)>)";
public str toString(StringFunction::mask(Expr exp, list[Expr] e)) = "mask(<toString(exp)><intercalate("",[",<toString(es)>"|es<-e])>) "; 
public str toString(StringFunction::oct_len( Expr exp)) = "octet_length(<toString(exp)>)";   
public str toString(StringFunction::overlay( Expr input, Expr replace, Expr pos,list[Expr] len )) = "overlay(<toString(input)>,<toString(replace)>,<toString(pos)><intercalate("",[",<toString(es)>"|es<-len])>)";   
public str toString(Function::overlayWithSnippet( Expr input, Expr replace, Expr pos,list[Expr] len )) = "overlay(<toString(input)> placing <toString(replace)> from <toString(pos)> <intercalate("",["for <toString(es)>"|es<-len])>)";
public str toString(StringFunction::position( Expr input, Expr replace,list[Expr] len )) = "position(<toString(input)>,<toString(replace)><intercalate("",[",<toString(es)>"|es<-len])>)";
public str toString(StringFunction::replace( Expr input, Expr replace,list[Expr] len )) = "position(<toString(input)>,<toString(replace)><intercalate("",[",<toString(es)>"|es<-len])>)";    
public str toString(StringFunction::\right(Expr exp1, Expr exp2)) = "right(<toString(exp1)>,<toString(exp2)>)";  
public str toString(StringFunction::rtrim(Expr exp)) = "rtrim(<toString(exp)>)";
public str toString(StringFunction::space(Expr exp)) = "space(<toString(exp)>)";
public str toString(StringFunction::startsWith(Expr exp1, Expr exp2)) = "startswith(<toString(exp1)>,<toString(exp2)>)";
public str toString(StringFunction::substring_index(Expr exp1, Expr exp2, Expr exp3)) = "substring_index(<toString(exp1)>,<toString(exp2)>,<toString(exp3)>)";    
public str toString(StringFunction::trim(Expr exp)) = "trim(<toString(exp)>)";
public str toString(StringFunction::trimfrom(TrimDir tdir, From from)) = "trim(<toString(tdir)> <toString(from)>)";
public str toString(StringFunction::trimstr(list[TrimDir] tdirs,  Expr trimStr, From fromExp)) = "trim(<intercalate("",["<toString(es)>"|es<-tdirs])> <toString(trimStr)> <toString(fromExp)>)";  
public str toString(StringFunction::positionIn(Expr exp)) = "position(<toString(exp)>)";



public str toString(from(Expr e, list[NumericLiteral] numlit))= "FROM <toString(e)> <intercalate("",["for <toString(lit)>"|lit<-numlit])> ";

public str toString(TrimDir td){
    switch(td){
        case trail(): return "trailing";
        case lead():return "leading";
        case both(): return "both";
        default: throw ToStringException("message: Unable to resolve signature",td);
    }
}

public str toString(OrderElem::orderExprNulls(Expr expr, NullFirstOrLast nullFirstOrLast)) = "<toString(expr)> <toString(nullFirstOrLast)>";

public str toString(OrderElem::ascNulls(Expr expr, NullFirstOrLast nullFirstOrLast)) = "<toString(expr)> ASC <toString(nullFirstOrLast)>";

public str toString(OrderElem::descNulls(Expr expr, NullFirstOrLast nullFirstOrLast)) = "<toString(expr)> DESC <toString(nullFirstOrLast)>";

public str toString(NullFirstOrLast::nullsFirst()) = "NULLS FIRST";

public str toString(NullFirstOrLast::nullsLast()) = "NULLS LAST";


public str toString(MapFunction::elementAt(Expr e1, Expr e2)) = "element_at(<toString(e1)>,<toString(e2)>)";
public str toString(MapFunction::\map(lrel[str id, Expr e] mapitems)) = "map( <intercalate("",["<mp.id>,<toString(mp.e)>"|mp<-mapitems])>)";
public str toString(MapFunction::concat(list[Expr] es)  ) = "map_concat(<intercalate("",[toString(mp)|mp<-es])>)"; 
public str toString(MapFunction::contain(Expr e1, Expr e2)) = "map_contains_key(<toString(e1)>,<toString(e2)>)";
public str toString(MapFunction::entries(Expr e)) = "map_entries(<toString(e)>)";   
public str toString(MapFunction::fromArrays(Expr e1, Expr e2)) = "map_from_arrays(<toString(e1)>,<toString(e2)>)";  
public str toString(MapFunction::fromEntries(Expr e)) = "map_from_entries(<toString(e)>)"; 
public str toString(MapFunction::keys(Expr e)) = "map_from_entries(<toString(e)>)"; 
public str toString(MapFunction::values(Expr e)) = "map_values(<toString(e)>)";
public str toString(MapFunction::strToMap(Expr e1, lrel[Expr e2, list[Expr] e3s]erel)) = "str_to_map(<toString(e1)> <intercalate("",[",<toString(r.e2)> <intercalate("",[toString(r1)|r1<-r.e3s])>"|r<-erel])> )"; 
public str toString(MapFunction::tryEl(Expr e1, Expr e2)) = "try_element_at(<toString(e1)>,<toString(e2)>)";



public str toString(Generator::explode( Expr expr)) = "explode(<toString(expr)>)";   
public str toString(Generator::ex_outer( Expr expr)) = "explode_outer(<toString(expr)>)";
public str toString(Generator::inline( list[Expr] exps)) = "inline(<intercalate(",",[toString(expr)|expr<-exps])>)";
public str toString(Generator::in_outer( Expr exp)) = "inline_outer(<toString(exp)>)";   
public str toString(Generator::posEx( Expr exp)) = "posexplode(<toString(exp)>)";        
public str toString(Generator::posEx_outer( Expr exp)) = "posexplode_outer(<toString(exp)>)";    
public str toString(Generator::stack( Expr exp, list[Expr] e)) = "stack(<toString(exp)>,<intercalate(",",[toString(expr)|expr<-e])>)";




// Expressions
public str toString(Expr::arrayLit(ArrayLiteral arrayLit)) = "<toString(arrayLit)>";
public str toString(Expr::exist(Expr exp)) = "EXISTS <toString(exp)>";
public str toString(Expr::not(Expr e)) = "!<toString(e)>";
public str toString(Expr::likeAll(Expr exp,list[Expr] exps)) = "<toString(exp)> LIKE ALL (<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(Expr::notlikeAll(Expr exp,list[Expr] exps)) = "<toString(exp)>  NOT LIKE ALL (<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(Expr::likeAny(Expr exp,list[Expr] exps)) = "<toString(exp)>   LIKE ANY (<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(Expr::notlikeAny(Expr exp,list[Expr] exps)) = "<toString(exp)>  NOT LIKE ANY (<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(Expr::notlikeSome(Expr exp,list[Expr] exps)) = "<toString(exp)>  NOT LIKE SOME (<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(Expr::likeSome(Expr exp,list[Expr] exps)) = "<toString(exp)> LIKE SOME (<intercalate(",",[toString(e)|e<-exps])>)";
public str toString(Expr::rlike(Expr lhs, RLikeOrRegex rli, Expr rhs, EscapeEx escex)) =  "<toString(lhs)> <toString(rli)> <toString(rhs)> <toString(escex)>";
public str toString(Expr::rlikeNoEsc(Expr lhs, RLikeOrRegex rli, Expr rhs)) =  "<toString(lhs)> <toString(rli)> <toString(rhs)>";
public str toString(Expr::ilike(Expr lhs, Expr rhs ,list[EscapeEx] ex)) = "<toString(lhs)> ILIKE <toString(rhs)> <intercalate("",[toString(es)|es<-ex])>";  
public str toString(Expr::likeEsc(Expr lhs, Expr rhs, EscapeEx ex)) = "<toString(lhs)> LIKE <toString(rhs)> <toString(ex)>";  
public str toString(Expr::match(Expr e, list[Case] cases, list[Default] d)) = "(<toString(e)>) MATCH {<intercalate("",[toString(\case)|\case<-cases])> <intercalate("",[toString(a)|a<-d])>}";
public str toString(Expr::lambda (str arg, Expr exp)) = "<arg> =\> <toString(exp)>";
public str toString(Expr::optValue(OptionValue opt)) = "<toString(opt)>";

public str toString(Expr::inPredicate(Expr exp, list[Not] not, Expr arrLtrl)) = "(<toString(exp)> <prettyOptional(not, prettyNot)> IN <toString(arrLtrl)>)";


public str toString(NumericLiteral::\int(str intlit)) = intlit;



public str toString(RLikeOrRegex::rLike()) = "RLIKE";
public str toString(RLikeOrRegex::regexp()) = "REGEXP";





public str toString(escape(Expr expr))= "ESCAPE <toString(expr)>"; 

public str toString(comment(str strConst)) = "COMMENT <strConst>";

public str toString(\case(Expr e1, Expr e2)){
   return "CASE <toString(e1)> =\> <toString(e2)> ;" ;
}



public str toString(\default(Expr e)){
    return "DEFAULT =\> <toString(e)> ;";
}

public str toString(ArrayLiteral::arraySpark(list[Expr] expr)) = "ARRAY ( <intercalate(", ",[toString(e)|e<-expr])> )";

public str toString(OptionValue::none()) = "NONE";
public str toString(OptionValue::disk1()) = "DISK_ONLY";
public str toString(OptionValue::disk2()) = "DISK_ONLY_2";
public str toString(OptionValue::disk3()) = "DISK_ONLY_3";
public str toString(OptionValue::memory1()) = "MEMORY_ONLY";
public str toString(OptionValue::memory2()) = "MEMORY_ONLY_2";
public str toString(OptionValue::memoryOnlyser()) = "MEMORY_ONLY_SER";
public str toString(OptionValue::memoryOnlyser2()) = "MEMORY_ONLY_SER_2";
public str toString(OptionValue::memAndDisk()) = "MEMORY_AND_DISK";
public str toString(OptionValue::memoryAndDisk2()) = "MEMORY_AND_DISK_2";
public str toString(OptionValue::memoryAndDiskSer()) = "MEMORY_AND_DISK_SER";
public str toString(OptionValue::memoryAndDiskSer2()) = "MEMORY_AND_DISK_SER_2";
public str toString(OptionValue::offHeap()) = "OFF_HEAP";
public str toString(PrimitiveType::byteType()) = "BYTE";
public str toString(PrimitiveType::longType()) = "LONG";
public str toString(PrimitiveType::shortType()) = "SHORT";
public str toString(PrimitiveType::numericType()) = "NUMERIC";
public str toString(PrimitiveType::decType()) = "DEC";
public str toString(PrimitiveType::timestampNTZType()) = "TIMESTAMP_NTZ";
public str toString(PrimitiveType::realType()) = "REAL";





// DDL statement
public str toString(Statement stmt){
    switch(stmt){
        case  alterdb(AlterSelectors altsel, Identifier id, SetStatement setStm):return "ALTER <toString(altsel)> <toString(id)> <toString(setStm)>";
        case  alterview(AlterView altView):return "ALTER VIEW <toString(altView)>";
        case  dropDb(DatabaseOrSchema dos, list[IfExists] ifex, Identifier id, list[RestrictOrCascade] roc):{
            return "DROP <toString(dos)> <intercalate("",[toString(ifEx)|ifEx<-ifex])> <toString(id)> <intercalate("",[toString(ro)|ro<-roc])>";
        }
        case  dropFunction(list[TemporaryOrGlobal] temp,list[IfExists] ifex,list[Identifier] ids):{
            return "DROP  <intercalate("",[toString(t)|t<-temp])> FUNCTION <intercalate("",[toString(ifEx)|ifEx<-ifex])> <intercalate(".",[toString(id)|id<-ids])>";
        }
        case  dropTable(list[IfExists] ifex, TableName tid, list[Purge] purge):{
            return "DROP TABLE <intercalate("",[toString(ifEx)|ifEx<-ifex])> <toString(tid)> <intercalate("",[toString(p)|p<-purge])>";
        }
        case createViewWithReplace(
            OrReplaceOrTemporary orReplaceOrTemporary
            , list[IfNotExists] ifNotExistsOpt
            , TableName viewId
            , list[CreateViewClause] createViewClauseList
            , QueryOrWith queryOrWith
            
        ): {
            return "CREATE <toString(orReplaceOrTemporary)> VIEW <intercalate("",[toString(ifEx)|ifEx<-ifNotExistsOpt])> <toString(viewId)>" +
                "<intercalate("\n", [toString(t)|t<-createViewClauseList])>\n" +
                "AS <toString(queryOrWith)>";
        }
        case createDb(
            DatabaseOrSchema dos
            , list[IfNotExists] ifnotexist
            , Identifier id
            , list[CommentLiteral] commlit
            , list[LocationClause] location
            , list[WithDB] wdb
        ): {
            return "CREATE <toString(dos)> <intercalate("",[toString(fcl)|fcl<-ifnotexist])> <toString(id)> <intercalate("",[toString(fcl)|fcl<-commlit])> <intercalate(",",[toString(fcl)|fcl<-location])> <intercalate(",",[toString(fcl)|fcl<-wdb])>";
        }
        case createFunction(
            list[OrReplaceOrTemporary] replaceTemp
            , list[IfNotExists] ifnotexist
            , list[Identifier] ids
            , str literal
            , list[ResourceLocation] rsl
        ): {
            return "CREATE <intercalate("",[toString(or)|or<-replaceTemp])> FUNCTION  <intercalate("",[toString(or)|or<-ifnotexist])> <intercalate(",",[toString(or)|or<-ids])> as <literal> <intercalate("",[toString(or)|or<-rsl])>";
        }
        case setStatement(SetStatement setStmt): return "<toString(setStmt)>";
        case repair(TableName tblName, list[AddDropSync] addDropSync): return "REPAIR TABLE <toString(tblName)> <prettyOptional(addDropSync, toString)>";
        default: throw ToStringException("message: Unable to resolve statement",stmt);
    }

}




public str toString(rLoc(RType rtype, str strconst))= "USING <toString(rtype)> <strconst>";
    

public str toString(globalTemporaryTable())="GLOBAL TEMPORARY";
   


public str toString(RType rtype){
    switch(rtype){
        case jar(): return "JAR";
        case file(): return "FILE";
        case archive(): return "ARCHIVE";
        default: throw ToStringException("message: Unable to resolve signature",rtype);
    }
}




public str toString(CreateViewClause createviewcls){
    switch(createviewcls){
        case columnLevel(lrel[Identifier id,list[CommentLiteral] cmlt] clevel): return "(<intercalate(",",["<p.id> <intercalate("",[toString(c)|c<-p.cmlt])>"|p<-clevel])>)";
        case viewLevel(CommentLiteral commentLit): return "<toString(commentLit)>";
        case tbl(TablePropertiesClause tableProp): return "<toString(tableProp)>";
        default: throw ToStringException("message: Unable to resolve signature",createviewcls);
    }
}




public str toString(AddDropSync addDropSync){
    switch(addDropSync){
        case add(): return "ADD PARTITIONS";
        case drop(): return "DROP PARTITIONS";
        case sync(): return "SYNC PARTITIONS";
        default: throw ToStringException("message: Unable to resolve signature",addDropSync);
    }
}


public str toString(option(list[Options] ov))="OPTIONS(<intercalate(",",[toString(id)|id<-ov])>)";


public str toString(Options os){
    switch(os){
        case Options::optionStr(str str1, str str2):return "<str1> = <str2>" ; 
        case Options::pair(str id, Expr e):return "<id> <toString(e)>";
        case Options::storageLevel(str strLit,Expr e):return "<strLit> <toString(e)>";
        default: throw ToStringException("message: Unable to resolve signature",os);

    }
    
}




public str toString(fromSource(
            list[IfNotExists] ifex
            , list[TableName]  tid
            , list[Columns] columnsOpt
            , UsingClause s
            , list[PartitionedByClause] pbcl
            , lrel[list[ClusteredByClause] clby, list[SortedByClause] sbcl, Expr lit] clusterby
            , list[LocationClause] locate
            , list[CommentLiteral] commlit
            , list[TablePropertiesClause] tblp
            , list[AsSelect] as
        ))= trim("CREATE TABLE <intercalate("",[toString(or)|or<-ifex])> <intercalate("",[toString(or)|or<-tid])> <intercalate("",[toString(col)|col<-columnsOpt])> <toString(s)>  
             <intercalate("",[toString(or)|or<-pbcl])> 
             <intercalate("",["<intercalate("",[toString(c)|c<-clusterby.clby])> 
             <intercalate("",[toString(c)|c<-clusterby.sbcl])>
             INTO <toString(cl.lit)> BUCKETS"|cl<-clusterby])> <intercalate("",[toString(c)|c<-locate])> 
             <intercalate("",[toString(c)|c<-commlit])> <intercalate("",[toString(c)|c<-tblp])> 
             <intercalate("",[toString(c)|c<-as])>");
        
public str toString(AsSelect aselect){
    switch(aselect){
        case withAs(QueryOrWith queryOrWith): return toString(queryOrWith);
        case cte(QueryOrWith queryOrWith): return toString(queryOrWith);
        default: throw ToStringException("message: Unable to resolve signature",aselect);
    }
}


public str toString(with(lrel[str ids, Expr exp] props))="WITH DBPROPERTIES (<intercalate(",",["<p.ids>=<toString(p.exp)>"|p<-props])>)";


public str toString(usingClause(StoredAsType storedAsType, list[Option] option))="USING <toString(storedAsType)> <prettyOptional(option, toString)>";
      

public str toString(StoredAsType::hive()) = "HIVE";


public str toString(ColumnSpecification::columnNoType(Expr e)) = "<toString(e)>";



public str toString(OrReplaceOrTemporary orReplaceOrTemporary){
    switch(orReplaceOrTemporary){
        case orReplace(): return "OR REPLACE";
        case temporary(TemporaryTable tempTbl): return "<toString(tempTbl)>";
        case replaceTemporary(TemporaryTable tempTbl): return "OR REPLACE <toString(tempTbl)>";
        default: throw  ToStringException("message: Unable to resolve signature",orReplaceOrTemporary);
    }
}



public str toString(DatabaseOrSchema databaseOrSchema){
    switch(databaseOrSchema){
        case database(): return "DATABASE";
        case schemaKeyword(): return "SCHEMA";
        case databases(): return "DATABASES";
        default: throw  ToStringException("message: Unable to resolve signature",databaseOrSchema);
    }
}


public str toString(RestrictOrCascade restrictOrCascade){
    switch(restrictOrCascade){
        case restrict(): return "RESTRICT";
        case cascade(): return "CASCADE";
        default: throw  ToStringException("message: Unable to resolve signature",restrictOrCascade);
    }
}


public str toString(TemporaryOrGlobal temporaryOrGlobal){
    switch(temporaryOrGlobal){
        case temporary(): return "TEMPORARY";
        case global(): return "GLOBAL";
        default: throw  ToStringException("message: Unable to resolve signature",temporaryOrGlobal);
    }
}



public str toString(ColumnKeyword col){
    switch(col){
        case col():return "COLUMN";
        case cols(): return "COLUMNS";
        default: throw ToStringException("message: Unable to resolve signature",col);
    }
}

public str toString(AlterTable alterTbl){
    switch(alterTbl){
        case  replaceColumn(
            TableName tid
            , list[PartitionClause] pclOpt
            , lrel[Identifier id ,DataType datatype] columns
            , CommentLiteral comm
        ):{
            return "ALTER TABLE <toString(tid)> <intercalate("",[toString(pc)|pc<-pclOpt])> REPLACE COLUMNS (<intercalate(",",["<toString(q.id)> <toString(q.datatype)>"|q<-columns])> <toString(comm)>)";
        }
        case  dropColumn(TableName tid, ColumnKeyword col, list[Identifier] ids):{
            return "ALTER TABLE <toString(tid)> DROP <toString(col)> ( <intercalate(",",[toString(id)|id<-ids])>)";
        }
        case  setTableProperties(TableName tid,lrel[str str1,str str2] tblprops):{
            return "ALTER TABLE <toString(tid)> SET TBLPROPERTIES ( <intercalate(",",["<id.str1>=<id.str2>"|id<-tblprops])>)";
        }
        case  addColumn(TableName tableId ,lrel[Identifier  id,list[DataType] datatype] cols):{
            return "ALTER TABLE <toString(tableId)> ADD COLUMNS (<intercalate(",",["<toString(q.id)> <intercalate("",[toString(d)|d<-q.datatype])>"|q<-cols])>)";
        }
        case  unsetTableProperties(TableName tid,list[str] keys):return "ALTER TABLE <toString(tid)> UNSET TBLPROPERTIES ( <intercalate(",",[id|id<-keys])>)";
        case  recover(TableName tid):return "ALTER TABLE <toString(tid)> RECOVER PARTITIONS";
        case  setLocation(TableName tid, list[PartitionClause] pcl , str string ):return "ALTER TABLE <toString(tid)> <intercalate("",[toString(pc)|pc<-pcl])> SET LOCATION <string>";
        case  setFileFormat(TableName tid,list[PartitionClause] pcl, StoredAsType fform):return "ALTER TABLE <toString(tid)> <intercalate("",[toString(pc)|pc<-pcl])> SET FILEFORMAT <toString(fform)> ";
        case  setSerdeProp(TableName tid, list[PartitionClause] pcl,lrel[str str1,str str2] tblprops ):return "ALTER TABLE <toString(tid)> <intercalate("",[toString(pc)|pc<-pcl])> SET SERDEPROPERTIES  (<intercalate(",",["<id.str1>=<id.str2>"|id<-tblprops])>) ";
        case  setSerdePropWith(TableName tid, list[PartitionClause] pcl,str id, list[SerdePropertiesClause] spc):return "ALTER TABLE <toString(tid)> <intercalate("",[toString(pc)|pc<-pcl])> SET SERDE <id> <intercalate("",[toString(pc)|pc<-spc])>";
        case  renameColumn(TableName tid, Identifier id1,Identifier id2):return "ALTER table <toString(tid)> rename COLUMN <toString(id1)> to <toString(id2)>";
        default: throw ToStringException("message: Unable to resolve Alter table signature",alterTbl);
    }
}

public str toString(AlterView av){
    switch(av){
        case rename(TableName vid1,TableName vid2): return "<toString(vid1)> RENAME TO <toString(vid2)>";
        case setView(TableName vid,lrel[str ids ,str strings] props):return"<toString(vid)> SET TBLPROPERTIES (<intercalate(",",["<id.ids>=<id.strings>"|id<-props])> )";
        case unsetView(TableName vid, list[IfExists] ifex, list[str] strings):return "<toString(vid)> UNSET TBLPROPERTIES <intercalate("",[toString(ifx)|ifx<-ifex])> (<intercalate(",",[id|id<-strings])>)";
        case selectView(TableName vid, QueryOrWith queryorwith): return "<toString(vid)> AS <toString(queryorwith)>";
        default: throw ToStringException("message: Unable to resolve Alter view signature",av);

    }
}

public str toString(AlterSelectors as){
    switch(as){
        case schema():return "SCHEMA";
        case db(): return "DATABASE";
        case namespace(): return "NAMESPACE";
        default: throw ToStringException("message: Unable to resolve  signature",as);
    }
}




public str toString(SetStatement setStm){
    switch(setStm){
        case setProperty(list[PropertyType] proptype, lrel[str str1, str str2] propassignments):{
            return "SET <intercalate("",[toString(v)|v<-proptype])> (<intercalate(", ",["<v.str1> = <v.str2>"|v<-propassignments])>)";
        }
        case setLocation(str val) :return "SET LOCATION <val>";
        case noValue(list[Output] output): return "SET <intercalate("",[toString(v)|v<-output])>";
        case setStatementSpark(str expandedIdentifier, SetValue setValue):{ 
            return "SET <expandedIdentifier> = <toString(setValue)>";
        }
        default: throw ToStringException("message: Unable to resolve  signature",setStm);
    }
}



public str toString(PropertyType as){
    switch(as){
        case dbprop():return "DBPROPERTIES";
        case prop(): return "PROPERTIES";
        default: throw ToStringException("message: Unable to resolve  signature",as);
    }
}

public str toString(Output::v())= "-v";


// SetValue
public str toString(SetValue::unquotedSetValue(str unquotedCharSeq)) = unquotedCharSeq; 



// DML statement

public str toString(
  Statement::insertOverwriteDirectory(
    list[Local] lcl
    , list[UsingClause] rowFormatCls
    , list[StoredAs] storedAs
    , Query qry
  )
) = "INSERT OVERWRITE DIRECTORY" + "<prettyOptional(lcl, prettyLocal)>" + trim("<prettyOptional(rowFormatCls, toString)> <prettyOptional(storedAs, toString)>") + " <toString(qry)>";


public str toString(
  Statement::insertOverwriteDirectoryPath(
    list[Local] lcl
    , DirectoryPath directoryPath
    , UsingClause rowFormatCls
    , list[StoredAs] storedAs
    , Query qry
  )
) = "INSERT OVERWRITE " + "<prettyOptional(lcl, prettyLocal)>" + " DIRECTORY <toString(directoryPath)> " + trim("<toString(rowFormatCls)> <prettyOptional(storedAs, toString)>") + " <toString(qry)>";


public str toString(
  Statement::loadInto(
    list[Local] lcl
    , str directoryPath
    , TableName tblName
    , list[PartitionClause] partitionCls
  )
) = "LOAD DATA " + "<prettyOptional(lcl, prettyLocal)>" + " DIRECTORY <directoryPath> " + "INTO INTO TABLE " + trim("<toString(tblName)> <prettyOptional(partitionCls, toString)>");




public str toString(
  Statement::loadOverwrite(
    list[Local] lcl
    , str directoryPath
    , list[Expr] expr
    , TableName tblName
    , list[PartitionClause] partitionCls
  )
) = "LOAD DATA " + "<prettyOptional(lcl, prettyLocal)>" + " INPATH <directoryPath> " + "OVERWRITE " + "<prettyOptional(expr, toString)>" + "INTO TABLE " + trim("<toString(tblName)> <prettyOptional(partitionCls, toString)>");


public str toString(Statement::insertWithQuery(InsertWithQuery insertWithQry)) = "<toString(insertWithQry)>";



// InsertWithQuery
public str toString(
  InsertWithQuery::intoWithValue(
    list[Table] tbl
    , TableName tblName
    , list[PartitionWithOptionValueClause] partitionWithOptValCls 
    , list[IfNotExists] ifNotExists
    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
    , Value vl
  )
) = "INSERT INTO <prettyOptional(tbl, toString)> <toString(tblName)> <prettyOptional(partitionWithOptValCls, toString)> <prettyOptional(ifNotExists, toString)> <prettyOptional(columnSpecificationForInsert, toString)> <toString(vl)>";


public str toString(
  InsertWithQuery::overwriteWithValue(
    list[Table] tbl
    , TableName tblName
    , list[PartitionWithOptionValueClause] partitionWithOptValCls 
    , list[IfNotExists] ifNotExists
    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
    , Value vl
  )
) = "INSERT OVERWRITE <prettyOptional(tbl, toString)> <toString(tblName)> <prettyOptional(partitionWithOptValCls, toString)> <prettyOptional(ifNotExists, toString)> <prettyOptional(columnSpecificationForInsert, toString)> <toString(vl)>";


public str toString(
  InsertWithQuery::intoWithValueFromTable(
    TableName tblName
    , Table tbl
    , TableName tblName
    , list[PartitionWithOptionValueClause] partitionWithOptValCls 
    , list[IfNotExists] ifNotExists
    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
    , Value vl
  )
) = "INSERT INTO <toString(tbl)> <toString(tblName)> <prettyOptional(partitionWithOptValCls, toString)> <prettyOptional(ifNotExists, toString)> <prettyOptional(columnSpecificationForInsert, toString)> <toString(vl)>";


public str toString(
  InsertWithQuery::overwriteWithValueFromTable(
    TableName tblName
    , Table tbl
    , TableName tblName
    , list[PartitionWithOptionValueClause] partitionWithOptValCls 
    , list[IfNotExists] ifNotExists
    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
    , Value vl
  )
) = "INSERT INTO <toString(tbl)> <toString(tblName)> <prettyOptional(partitionWithOptValCls, toString)> <prettyOptional(ifNotExists, toString)> <prettyOptional(columnSpecificationForInsert, toString)> <toString(vl)>";



public str toString(
  InsertWithQuery::intoFromTable(
    TableName tblName
    , Table tbl
    , TableName tblName
    , list[PartitionWithOptionValueClause] partitionWithOptValCls 
    , list[IfNotExists] ifNotExists
    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
    , list[Query] qry
  )
) = "INSERT INTO <toString(tbl)> <toString(tblName)> <prettyOptional(partitionWithOptValCls, toString)> <prettyOptional(ifNotExists, toString)> <prettyOptional(columnSpecificationForInsert, toString)> <prettyOptional(qry, toString)>";



public str toString(
  InsertWithQuery::overwriteFromTable(
    TableName tblName
    , Table tbl
    , TableName tblName
    , list[PartitionWithOptionValueClause] partitionWithOptValCls 
    , list[IfNotExists] ifNotExists
    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
    , list[Query] qry
  )
) = "INSERT OVERWRITE <toString(tbl)> <toString(tblName)> <prettyOptional(partitionWithOptValCls, toString)> <prettyOptional(ifNotExists, toString)> <prettyOptional(columnSpecificationForInsert, toString)> <prettyOptional(qry, toString)>";


public str toString(
  InsertWithQuery::intoWithReplace(
    list[Table] tbl
    , list[TableName] tblName
    , list[Columns] cols 
    , Expr expr
    , QueryOrWith qryOrWith
  )
) = "INSERT INTO <prettyOptional(tbl, toString)> <prettyOptional(tblName, toString)> <prettyOptional(cols, toString)> REPLACE WHERE <toString(expr)> <toString(qryOrWith)>";




public str toString(Value::valuesas(ValuesBuilder vb,list[VarAssign]  varass))= "<toString(vb)> <intercalate("",[toString(v)|v<-varass])>";
public str toString(valuesBuilder(list[ValueSet] exprs))="VALUES <intercalate(",",[toString(v)|v<-exprs])>";
public str toString(valset(list[Expr] e))="(<intercalate(",",[toString(v)|v<-e])>) ";



