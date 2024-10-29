module lang::spark::translations::Spark
import lang::spark::prettyprint::Spark;
extend lang::spark::translations::Expressions;
import lang::spark::ast::Spark;
import List;
import Type;
import IO;
import String;

public Program toPTL(Spark::expression(Expr exp)){
   return lang::ptl::ast::PTL::expression(toPTL(exp));
}
public Program toPTL(Spark spark, str moduleName="") {
 
  // filter through the statements and store the drops to a 
  // map  

  switch(spark) {
    case statements(list[StatementWithTerminator] stmts): {
      temp = [ stmt | statementWithTerminator(stmt, _) <- stmts, Statement::dropTable(_, _, _) := stmt||Statement::dropView( _, _) := stmt ];
      dIfExist = (toString(y) : Drop::dropIfExist() | Statement::dropTable(list[IfExists] ifExists, y, _) <- temp, size(ifExists) == 1);
      dIfNExist = (toString(y) : Drop::drop() | Statement::dropTable(list[IfExists] ifExists, y, _) <- temp, size(ifExists) == 0);
      
      dIfExist =dIfExist+ (replaceAll(toString(y.tblNameId.id),"`","") : Drop::dropIfExist() | Statement::dropView(list[IfExists] ifExists, y) <- temp, size(ifExists) == 1);
      dIfNExist =dIfNExist+ (replaceAll(toString(y.tblNameId.id),"`","") : Drop::drop() | Statement::dropView(list[IfExists] ifExists, y ) <- temp, size(ifExists) == 0);
      dict += dIfExist + dIfNExist;
      return \module("<moduleName == "" ? "Spark" : moduleName>", [], [ toPTL(stmt) | statementWithTerminator(stmt, _) <- stmts, Statement::dropTable(_, _, _) !:= stmt && Statement::setStatement(_) !:= stmt &&Statement::dropView( _, _) !:= stmt ]);
    }
    case simpleStatement(Statement statement): return \module("spark file", [], [ toPTL(statement)]);
    default: throw TranslationException("message:Unresolved spark start",typeCast(#node,spark).src);
  }
}



public list[Drop] toPTL(str tableName) {
  if (tableName in dict) {
    return [ dict[tableName] ];}
  else return [];
}



public ViewVariablesOrEmpty toPTL(setStatement(SetStatement setStm)){
    switch(setStm){
        case setProperty(list[PropertyType ] _, lrel[str str1, str str2] propassignments): {
            return variables([viewBindingInferredInit(x.str1, identifier([x.str2])) | x<-propassignments]);
        }
        default: throw TranslationException("message: Unresolved set Statement",typeCast(#node,setStm).src);
    }
}





public TableProperties toPTL(tbl(lrel[str str1,str str2] tblprops)){
    list[TableProperty] transformedProps = [tableProperty(t.str1, t.str2) | t <- tblprops];
    return tableProperties(transformedProps);
}




public Purge toPTL(purge()) {
  return purge();
}





public lang::ptl::ast::Declarations::IfNotExists toPTL(lang::spark::ast::Spark::IfNotExists ine) {
  return IfNotExists::ifNotExists(); 
}

public lang::ptl::ast::Declarations::IfExists toPTL(lang::spark::ast::Spark::IfExists ie){
    return ie;
}

public SubViewDecl toPTL(AsSelect asselect){
    switch(asselect){
        case withAs(QueryOrWith qow): {
            return toPTL(qow);
        }

        case cte(QueryOrWith qow):{
            return toPTL(qow);
        }
        
        default :
            throw TranslationException("message: Unresolved translation",typeCast(#node,asselect).src);
    }
}


public SubViewDecl toPTL(QueryOrWith qow){
    switch(qow){
        case queryOrWithQuery(QueryExpr q) :return toPTL(q);
        default: throw TranslationException("message: Unresolved query expression",typeCast(#node,qow).src);
    }
}

public SubViewDecl toPTL(querySpark(QuerySpark query) ){
    switch(query){
        case query(
        SelectClause selectCls,
        list[FromClause] fromCl,
        list[Distributed] distcls,
        list[SortedByClause] sbcls,
       _,
        list[LateralView] latview
        , list[JoinClause] joinCls
        , list[WhereClause] whereCls
        , list[GroupByClause] groupCls 
        , list[HavingClause] havingCls , list[WindowClause] _
        , list[OrderByClause] orderByCls 
        
        , list[LimitOffsetClauses] limitOffsetCls
        , list[QueryClusterByClause] queryClusterByCls
    ) :{ 
        fcl= [toPTL(f)|f<-fromCl];

        list[JoinCondition] joinCl = toPTL(joinCls);
      list[JoinConditions] joinConds = [joinConditions(joinCl)];
        return subViewDecl(
           getDist(selectCls)
        , fcl
        , toPTL(selectCls)
        , [toPTL(whereCl)|whereCl<-whereCls]
        , toPTL( groupCls,havingCls)
        , [toPTL(whereCl)|whereCl<-orderByCls]
        , joinConds
        );
    }

        default: throw  TranslationException("message: Unresolved query expression",typeCast(#node,query).src);
    }
}

public Declaration toPTL(Statement::insertWithQuery(InsertWithQuery insQry)) = transformDef([],toPTL(insQry));


public JoinCondition getJoinCondtion(semiJoinClause(SemiJoin semiJoin, TableIdOrSubquery::tableId(TableName tblName, list[Identifier] idOpt), joinCondition(Expr expr), list[JoinClause] joinClauseList)       
    ){
        JoinType jt =  JoinType::semiJoin();
       
        list[OnCondition] oc= [onCondition(toPTL(expr))]; 
       
       return joinCondition(
              jt
              , tName(toString(tblName), [])
              , [ \alias(toString(id)) | id <- idOpt ] // Alias
              , [ onCondition(toPTL(expr)) ] // OnCondition
            );
    }







public OrderByClauseOpt toPTL(orderByClause(list[OrderElem] orderElems))= orderByClause([toPTL(el)|el<- orderElems]);

public Declaration toPTL(createView(list[IfNotExists] ifNotExists, TableName tblName, QueryOrWith::queryOrWithQuery(
      QueryExpr::querySpark(QuerySpark::query(
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
    ))))) {

      groupingOrEmp = toPTL(groupByClauseOpt, havingClauseOpt);

   


      tblIdsOrSubqs = if ([] := fromClauseOpt) []; 
                      else head([ x | fromClause(x) <- fromClauseOpt ]);

      viewNamWildC = if ([] := tblIdsOrSubqs) name(sName(""), []); 
                     else head([ toPTL(tIdSub) | tIdSub <- tblIdsOrSubqs ]);

      list[JoinCondition] joinCl = toPTL(joinClause);
      list[JoinConditions] joinConds = [joinConditions(joinCl)];
  return view([],
    viewDecl(
      [ toPTL(ifNeX) | ifNeX <- ifNotExists] // IfNotExists
      , toPTL(replaceAll(toString(tblName.tblNameId),"`","")) // Drop
      , [] // Temporal
      , toPTL(tblName) // NameOrTemplate
      , [] // Distinct
      , viewNamWildC // ViewNameOrWildcard
      , [] // MixinsOrEmpty
      , [] // TranspositionFunction
      , [] // ViewVariablesOrEmpty
      , [] // SubViewsOrEmpty
      , toPTL(selectClause) // ViewField
      , [ toPTL(whCl) | whCl <- whereClauseOpt ] // FilterOrEmpty
      , groupingOrEmp // GroupingOrEmpty
      , [ toPTL(ordCl) | ordCl <- orderByClauseOpt ] // OrderByClauseOpt
      ,joinConds // JoinConditions  
    )
  );
}




public list[GroupingOrEmpty] toPTL(list[GroupByClause] groupCls, list[HavingClause] havingCls) {
   if (!isEmpty(groupCls) && !isEmpty(havingCls)) {
    grpHead = head(groupCls); 
    return [ toPTL(grpHead, havingCls) ];
  } else if (!isEmpty(groupCls) && [] := havingCls) {
    grpHead = head(groupCls); 
    return [ toPTL(grpHead, []) ];
  } else return [];
}

public GroupingOrEmpty toPTL(GroupByClause groupCls, list[HavingClause] havingCls) {
  return grouping(toPTL(groupCls), [toPTL(havingCl) | havingCl <- havingCls ]);
}



public HavingClauseOpt toPTL(HavingClause::havingClause(Expr exp)) 
  = HavingClauseOpt::havingClause(toPTL(exp));


TransformDecl toPTL(InsertWithQuery insQry) {
  

  switch(insQry) {
    case into(
        list[Table] tbl
        , TableName tblName
        , list[PartitionWithOptionValueClause] partitionWithOptValCls
  	    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
  	    , QueryExpr qryexpr
    ) : {
      
      return createAction( 
        tName(toString(tblName),[])
        , []
        , wildcard(toPTL(qryexpr))
        , []
        , []
        , []
        , []
        , []
        , []
        , []
        );
    }
    case overwrite( 
        list[Table] tbl
        , TableName tblName
        , list[PartitionWithOptionValueClause] partitionWithOptValCls 
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpecificationForInsert
  		, QueryExpr qryexpr
    )
      : {
        vnw= toPTL(qryexpr);
     

      return updateAction(
        [ toPTL(ifNE) | ifNE <- ifNotExists ] // IfNotExists
        , tName(toString(tblName), []) // NameOrVariableRef
        , [] // Distinct
        , wildcard(vnw) // ViewNameOrWildcard
        , [] // TAttribute
        , [] // TPartition
        , [] // ConstraintsOrEmpty
        , [] // FilterOrEmpty
        , [] // GroupingOrEmpty
        , []  // OrderByClauseOpt
        , [] // JoinConditions
      );
      
    }
   
    default: throw TranslationException("message: Unresolved Translations",typeCast(#node,insQry).src);
  }
}


public Declaration toPTL(CreateTable::withQuery(
      list[TemporaryTable] temporaryTbl 
      , list[ExternalTable] _
      , list[IfNotExists] ifNotExists 
      , TableName::name(_, TableNameId::tabId(Identifier id))
      , list[RowFormatClause] _ 
      , list[StorageClause] _
      , CreateTableQuery::createTableQuery(QueryOrWith::queryOrWithQuery(QueryExpr qry))
    )) {
      tempTable = [ toPTL(tmprl) | tmprl <- temporaryTbl ];
      ifNotExi = [ toPTL(ifNE) | ifNE <- ifNotExists ];



      return viewAs(
        []
        , ifNotExi // IfNotExists
        , toPTL(toString(id)) // Drop
        , tempTable // Temporal
        , QualifiedIdentifier::qualifiedIdentifier([ toPTL(id)]) // QualifiedIdentifier
        , [] // ViewVariablesOrEmpty
        , toPTL(qry) // SubViewDecl
      );
    }

public ViewNameOrWildcard toPTL(tableIdWithAs(name(list[SchemaNameDot] schemaNameDotOpt, tabId(Identifier tablename)), regularIdentifier(str regularId))) {
  if([]:=schemaNameDotOpt){
    return ViewNameOrWildcard::name(sName(tablename.regularId), [Alias::\alias(regularId)]);
  }
  else return ViewNameOrWildcard::name(qName(schemaNameDotOpt[0].tblNameId.id.regularId, tablename.regularId),[Alias::\alias(regularId)]);
}

public ViewNameOrWildcard toPTL(tableIdSubqueryWithAs(QueryExpr qry, Identifier id)) {
  return wildcardWithAlias(toPTL(qry), Alias::\alias(id.regularId));
}
