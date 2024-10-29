module lang::bigquery::prettyprint::Query

extend lang::bigquery::prettyprint::Expressions;
import List;

public str toString(fromTimestamp(Expr expr)) = "FOR SYSTEM_TIME AS OF <toString(expr)>";

public str toString(QueryExpr qryexpr) {
    switch(qryexpr){
        case queryBigquery(QueryBigquery queryBigquery): return "<toString(queryBigquery)>";
        case queryExceptDistinct(QueryExpr qryexpr1, ExceptDistinct exceptDistinct, QueryExpr qryexpr2): return "<toString(qryexpr1)> <toString(exceptDistinct)> <toString(qryexpr2)>";
        default: throw "unhandled <qryexpr>";
    }
}


public str toString(QueryBigquery::query(
        SelectClause selectCls
        , list[FromClause] fromClauseOpt
        , list[SortedByClause] sortedByClauseOpt
        , list[TableSampleOperator] tblSampleOpt
        , list[PivotUnpivot] pivotUnpivotOpt
        , list[JoinClause] joinClauseOpt
        , list[WhereClause] whereClauseOpt
        , list[GroupByClause] groupByClauseOpt 
        , list[HavingClause] havingClauseOpt
        , list[QualifyClause] qualifyClauseOpt
        , list[WindowClause] windowClauseOpt 
        , list[OrderByClause] orderByClauseOpt 
        , list[LimitOffsetClauses] limitOffsetClausesOpt
    )) = "<toString(selectCls)> 
        <intercalate("",[toString(fcls)|fcls<-fromClauseOpt])> 
        <intercalate("",[toString(sbco)|sbco<-sortedByClauseOpt])> 
        <intercalate("",[toString(tso)|tso<-tblSampleOpt])> 
        <intercalate("",[toString(piv)|piv<-pivotUnpivotOpt])> 
        <intercalate("",[toString(jcls)|jcls<-joinClauseOpt])> 
        <intercalate("",[toString(wcls)|wcls<-whereClauseOpt])> 
        <intercalate("",[toString(gcls)|gcls<-groupByClauseOpt])>
        <intercalate("",[toString(hclo)|hclo<-havingClauseOpt])> 
        <intercalate("",[toString(qclo)|qclo<-qualifyClauseOpt])> 
        <intercalate("",[toString(wdcls)|wdcls<-windowClauseOpt])> 
        <intercalate("",[toString(obcls)|obcls<-orderByClauseOpt])> 
        <intercalate("",[toString(losc)|losc<-limitOffsetClausesOpt])>";


public str toString(exceptDistinct()) = "EXCEPT DISTINCT";

public str toString(qualifyClause(Expr exp)) = "QUALIFY <toString(exp)>";

public str toString(TableIdOrSubquery tabOrSQ){
    switch(tabOrSQ){
        case tableIdOrSubquerySubqueryNoId(QueryOrWith qryOrWith):{
            return "(<toString(qryOrWith)>)";
        }
        case subqueryWithAsId(QueryOrWith qryOrWith, Identifier id):{
            return "(<toString(qryOrWith)>) AS <toString(id)>";
        }
        case tableIdWithAsId(TableName tblName, Identifier id):{
            return "<toString(tblName)> AS <toString(id)>";
        }
        case unnestOperatorWithAs(UnnestOptions unnestedOpts, list[VarAssign] varAssignOpt, list[UnnestWithOffset] unnestWithOffsetOpt):{
            return "<toString(unnestedOpts)> <intercalate("",[toString(vass)|vass<-varAssignOpt])> <intercalate("",[toString(uwo)|uwo<-unnestWithOffsetOpt])>";
        }
        default: throw "<tabOrSQ> not seen ";
    }
}

public str toString(tableSample(str integer)) = "TABLESAMPLE SYSTEM( <integer> PERCENT )";

public str toString(withOffset(list[VarAssign] varAssignOpt)) = "WITH OFFSET <intercalate("",[toString(vass)|vass<-varAssignOpt])>";

public str toString(UnnestOptions unnestopt){
    switch(unnestopt){
        case unnestExp(Expr array_expression):{
            return "UNNEST (<toString(array_expression)>)";
        }
        case unnestPath(Path array_path):{
            return "UNNEST (<toString(array_path)>)";
        }
        default: throw "<unnestopt> not seen ";
    }
}

public str toString(path(list[PathExpr] pathExpr)) = "<intercalate(".",[toString(pe)|pe<-pathExpr])>";

public str toString(pathExpr(list[Identifier] ids, SubsequentPart subsequentPart, list[PathExtra] pathExtra))
        = "<intercalate("",[toString(i)|i<-ids])>/<toString(subsequentPart)> <intercalate(" ",[toString(pextr)|pextr<-pathExtra])>";

public str toString(pathExtra(SubPre subpre, SubsequentPart subsequentPart)) = "<toString(subpre)> <toString(subsequentPart)>";

public str toString(SubPre sbpre){
    switch(sbpre){
        case slash():{return "/";}
        case colon():{return ":";}
        case hyphen():{return "-";}
        default: throw "<sbpre> not seen ";
    }
}

public str toString(SubsequentPart subseqpart){
    switch(subseqpart){
        case id(Identifier id):{return "<toString(id)>";}
        case number(Expr lit):{return "<toString(lit)>";}
        default: throw "<subseqpart> not seen ";
    }
}

public str prettyExpAsVarOrStar(tableNameDotStar(TableName tblName, SelectExcept selectExcept)) = "<toString(tblName)>.*<toString(selectExcept)>";
public str prettyExpAsVarOrStar(tableNameDotStar(TableName tblName, list[SelectExcept] selectExceptOpt, SelectReplace selectreplace))
        = "<toString(tblName)>.*<intercalate("",[toString(se)|se<-selectExceptOpt])> <toString(selectreplace)>";
public str prettyExpAsVarOrStar(projectionStar(SelectExcept selectExcept)) = "* <toString(selectExcept)>";
public str prettyExpAsVarOrStar(projectionStar(list[SelectExcept] selectExceptOpt, SelectReplace selectreplace)) = "* <intercalate("",[toString(se)|se<-selectExceptOpt])> <toString(selectreplace)>";

public str toString(selectExcept(list[Identifier] idList)) = "EXCEPT (<intercalate(",",[toString(id)|id<-idList])>)";

public str toString(selectReplace(list[ExpAsVarStrict2] expAsVarList)) = "REPLACE (<intercalate(",",[toString(evl)|evl<-expAsVarList])>)";

public str toString(SelectClause selectcls){
    switch(selectcls){
        case selectClause(list[DiffPrivacyclause] diffPrivacyClsOpt,list[SetQuantifier] setQuantifierOpt, StructOrValue structOrVal, Projection proj):{
            return "SELECT <intercalate("",[toString(dpcls)|dpcls<-diffPrivacyClsOpt])> <intercalate("",[toString(sqo)|sqo<-setQuantifierOpt])> AS <toString(structOrVal)> <toString(proj)>";
        }
        case selectClauseDiffPrivacyclause(DiffPrivacyclause diffPrivacyCls,list[SetQuantifier] setQuantifierOpt, Projection proj):{
            return "SELECT <toString(diffPrivacyCls)> <intercalate("",[toString(sqo)|sqo<-setQuantifierOpt])> <toString(proj)>";
        }
        default: throw "<selectcls> not seen ";
    }
}

public str toString(diffPrivacyClause(PrivacyParams privParams)) = "WITH DIFFERENTIAL_PRIVACY OPTIONS (<toString(privParams)>)";

public str toString(privacyParams(Expr exp1, Expr exp2, list[OptionalParam] optionalParam, Identifier id))
        = "epsilon = <toString(exp1)>, delta = <toString(exp2)>, <intercalate("",[toString(optp)|optp<-optionalParam])> privacy_unit_column = <toString(id)>";

public str toString(optionalParam(Expr exp)) = "max_groups_contributed = <toString(exp)>,";

public str toString(StructOrValue structOrvalue){
    switch(structOrvalue){
        case struct():{
            return "STRUCT";
        }
        case  StructOrValue::\value():{
            return "VALUE";
        }
        default: throw "<structOrvalue> not seen ";
    }
}

public str toString(PivotUnpivot pivunpivot){
    switch(pivunpivot){
        case pivot(lrel[AggregateFunction aggfunc,list[str] pa] agg,ColList collist,lrel[ExpressionList explist,list[str] pa] exl):{
            return "PIVOT ( <intercalate(",",["<toString(agf.aggfunc)> "+(size(agf.pa)>0? " AS " : "")+"<intercalate("",[p|p<-agf.pa])>"|agf<-agg])> FOR <toString(collist)> IN (<intercalate(",",["<toString(ex.explist)>"+(size(ex.pa)>0? " AS " : "")+ "<intercalate("",[p|p<-ex.pa])>"|ex<-exl])>))";
        }
        case unpivot(list[IncludeorEx] incoex , ValueColumnUnpivot valcolun, list[str] pa):{
            return "UNPIVOT"+ "<(size(incoex)>0? "<intercalate("",[toString(i)|i<-incoex])> NULLS" : "")>"+ "( <toString(valcolun)> )"+ "<(size(pa)>0? "AS <intercalate("",[p|p<-pa])>" : "")>";
        }
        default: throw "<pivunpivot> not seen ";
    }
}

public str toString(valueColumnUnpivot(ColList collist, str nameVal,lrel[ExpressionList explist,list[str] pa] exl))
        = "<toString(collist)> FOR <nameVal> IN (<intercalate(",",["<toString(ex.explist)>"+(size(ex.pa)>0? " AS " : "")+ "<intercalate("",[p|p<-ex.pa])>"|ex<-exl])>)";

public str toString(ExpressionList exprlist){
    switch(exprlist){
        case singleExpr(str exp):{
            return "<exp>";
        }
        case multiple(list[Expr] exps):{
            return "(<intercalate(",",[toString(ex)|ex<-exps])>)";
        }
        default: throw "<exprlist> not seen ";
    }
}

public str toString(ColList colist){
    switch(colist){
        case singleCol(str id):{return "<id>";}
        case multiple(list[str] ids):{return "(<intercalate(",",[i|i<-ids])>)";}
        default: throw "<colist> not seen ";
    }
}

public str toString(IncludeorEx incoex){
    switch(incoex){
        case include():{return "INCLUDE";}
        case exclude():{return "EXCLUDE";}
        default: throw "<incoex> not seen ";
    }
}

public str toString(onUsingClause(Expr column_list)) = "USING ( <toString(column_list)> )";

public str toString(outerJoinClause(OuterType outerType, list[Outer] outerOpt, TableIdOrSubquery tblOrSubqry, list[JoinClause] joinclsOpt))
        = "<toString(outerType)> <intercalate("",[prettyOuter(outr)|outr<-outerOpt])> JOIN <toString(tblOrSubqry)> <intercalate("",[toString(jncls)|jncls<-joinclsOpt])>";

public str toString(GroupByClause groupby){
    switch(groupby){
        case groupSetSpecs(GroupSet groupSet):{
            return "GROUP BY <toString(groupSet)>";
        }
        case rollupSpecs(GroupRollup groupRollUp):{
            return "GROUP BY <toString(groupRollUp)>";
        }
        case cubeSpecs(GroupCube groupCube):{
            return "GROUP BY <toString(groupCube)>";;
        }
        case groupBracket():{
            return "GROUP BY ()";
        }
        default: throw "<groupby> not seen ";
    }
}

public str toString(groupSet(list[GroupList] grouplist)) = "GROUPING SETS (<intercalate(",",[toString(gl)|gl<-grouplist])>)";

public str toString(GroupList grouplist){
    switch(grouplist){
        case listrollup(GroupRollup groupRollUp):{
            return "<toString(groupRollUp)>";
        }
        case listCube(GroupCube groupCube):{
            return "<toString(groupCube)>";
        }
        case groupListItem(ExprOrComposite exprOrCompsite):{
            return "<toString(exprOrCompsite)>";
        }
        default: throw "<grouplist> not seen ";
    }
}

public str toString(groupRollup(list[Expr] expr)) = "ROLLUP (<intercalate(",",[toString(e)|e<-expr])>)";

public str toString(groupCube(list[ExprOrComposite] exprOrComposite)) = "CUBE (<intercalate(",",[toString(exc)|exc<-exprOrComposite])> )";

public str toString(OrderElem orderelem){
    switch(orderelem){
        case orderExprNullsOptions(Expr expr, NullsOptions nullOptions):{
            return "<toString(expr)> <toString(nullOptions)>";
        }
        case ascNullOptions(Expr expr, NullsOptions nullOptions):{
            return "<toString(expr)> ASC <toString(nullOptions)>";
        }
        case descNullsOptions(Expr expr, NullsOptions nullOptions):{
            return "<toString(expr)> DESC <toString(nullOptions)>";
        }

        default: throw "<orderelem> not seen ";
    }
}

public str toString(NullsOptions nulloption){
    switch(nulloption){
        case nullsfirst():{
            return "NULLS FIRST";
        }
        case nullslast():{
            return "NULLS LAST";
        }
        default: throw "<nulloption> not seen ";
    }
}

public str toString(withRecursiveClause()) = "WITH RECURSIVE";

public str toString(cteClauseNotQuery(Identifier id, Expr expr)) = "<toString(id)> AS (<toString(expr)>)";