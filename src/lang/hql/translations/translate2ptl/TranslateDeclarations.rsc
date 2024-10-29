module lang::hql::translations::translate2ptl::TranslateDeclarations
import lang::hql::prettyprint::HQL;
import List;
import ParseTree;
import Type;
import lang::hql::utils::Implode;

extend lang::hql::translations::translate2ptl::TranslateExpressions;

public Declaration toPTL(Statement::insertWithQuery(InsertWithQuery insQry)) = transformDef([], toPTL(insQry)); // modelannotation translation reuired

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



      return viewAs( [], //modelannotation translation required
        ifNotExi // IfNotExists
        , toPTL(toString(id)) // Drop
        , tempTable // Temporal
        , qualifiedIdentifier([ toPTL(id)]) // QualifiedIdentifier
        , viewVar // ViewVariablesOrEmpty
        , toPTL(qry) // SubViewDecl
      );
    }

public Declaration toPTL(CreateTable::withQuery(
      list[TemporaryTable] temporaryTbl 
      , list[ExternalTable] _
      , list[IfNotExists] ifNotExists 
      , TableName::name(_, TableNameId::tabId(Identifier id))
      , list[RowFormatClause] _ 
      , list[StorageClause] _
      , CreateTableQuery::createTableQuery(QueryOrWith::queryOrWithWith(_, list[CTEClause] cteCls, QueryExpr qry))
    )) {
      tempTable = [ toPTL(tmprl) | tmprl <- temporaryTbl ];
      ifNotExi = [ toPTL(ifNE) | ifNE <- ifNotExists ];



      return viewWith(  [], //modelannotation translation required
        ifNotExi // IfNotExists
        , toPTL(toString(id)) // Drop
        , tempTable // Temporal
        , qualifiedIdentifier([ toPTL(id)]) // QualifiedIdentifier
        , [] // ViewVariablesOrEmpty
        , [ toPTL(nsd) | nsd <- cteCls ] // NamedSubViewDecl
        , toPTL(qry) // SubViewDecl
      );
    }


// CreateView
public Declaration toPTL(createView(list[IfNotExists] ifNotExists, TableName tblName, QueryOrWith::queryOrWithQuery(
      QueryExpr::queryHQL(QueryHQL::query(
        SelectClause selectCls
        , list[FromClause] fromCls
        , list[LateralView] _
        , list[JoinClause] joinCls
        , list[WhereClause] whereCls
        , list[GroupByClause] groupCls 
        , list[HavingClause] havingCls
        , list[OrderByClause] orderByCls
        , list[WindowClause] windowClauseOpt
        , list[LimitOffsetClauses] _
        , list[QueryClusterByClause] _
    ))))) {

      groupingOrEmp = toPTL(groupCls, havingCls);

      list[JoinCondition] joinCl = toPTL(joinCls);
      list[JoinConditions] joinConds = [joinConditions(joinCl)];


      tblIdsOrSubqs = if ([] := fromCls) []; 
                      else head([ x | fromClause(x) <- fromCls ]);

      viewNamWildC = if ([] := tblIdsOrSubqs) name(sName(""), []); 
                     else head([ toPTL(tIdSub) | tIdSub <- tblIdsOrSubqs ]);


  return view( [], //modelannotation translation required
    viewDecl(
      [ toPTL(ifNeX) | ifNeX <- ifNotExists] // IfNotExists
      , toPTL(toString(tblName)) // Drop
      , [] // Temporal
      , toPTL(tblName) // NameOrTemplate
      , [] // Distinct
      , viewNamWildC // ViewNameOrWildcard
      , [] // MixinsOrEmpty
      , [] // TranspositionFunction
      , viewVar // ViewVariablesOrEmpty
      , [] // SubViewsOrEmpty
      , toPTL(selectCls) // ViewField
      , [ toPTL(whCl) | whCl <- whereCls ] // FilterOrEmpty
      , groupingOrEmp // GroupingOrEmpty
      , [ toPTL(ordCl) | ordCl <- orderByCls ] // OrderByClauseOpt
      , joinConds // JoinConditions  
    )
  );
}


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

public ViewVariablesOrEmpty getVars(Statement::setStatement(setStatementHive(list[HiveVar] _, str id, SetValue::unquotedSetValue(str unquotedSetValue)))) {
 
  val = loadHQL(unquotedSetValue);
  return variables([viewBindingInferredInit(id, toPTL(val.expr))]);
}

public NamedSubViewDecl toPTL(CTEClause::cteClause(Identifier id, QueryExpr qry)) {
  return namedSubViewDecl(toPTL(qry), mandatoryAlias(toString(id)));
}

public ViewNameOrWildcard toPTL(TableIdOrSubquery tIdOrSub) {
  switch(tIdOrSub) {
    case tableId(TableName tblName, list[Identifier] idOpt): return name(sName(toString(tblName)),  [ \alias(toString(id)) | id <- idOpt ]);
    case tableIdOrSubquerySubquery(QueryExpr qry, Identifier id): return wildcardWithAlias(toPTL(qry), \alias(toString(id)));
    default: throw TranslationException(" message: Unresolved table id",typeCast(#node,tIdOrSub).src);
  }
}

public SubViewDecl toPTL(QueryExpr::queryHQL(QueryHQL qry)) {
  switch(qry) {
    case query(
      SelectClause selectCls
        , list[FromClause] fromCls
        , list[LateralView] _
        , list[JoinClause] joinCls
        , list[WhereClause] whereCls
        , list[GroupByClause] groupCls 
        , list[HavingClause] havingCls
        , list[OrderByClause] orderByCls
        , list[WindowClause] _
        , list[LimitOffsetClauses] _
        , list[QueryClusterByClause] _ 
    ): {
      groupingOrEmp = toPTL(groupCls, havingCls);
      orderByCl = [ toPTL(ordCl) | ordCl <- orderByCls ];
      whereCl = [ toPTL(whCl) | whCl <- whereCls ];
      list[JoinCondition] joinCl = toPTL(joinCls);
      list[JoinConditions] joinConds = [joinConditions(joinCl)];

      tblIdsOrSubqs = if ([] := fromCls) []; 
                      else head([ x | fromClause(x) <- fromCls ]);
      viewNamWildC = [ toPTL(tbIdOrSub) | tbIdOrSub <- tblIdsOrSubqs ];

      return subViewDecl(
        getDist(selectCls)
        , viewNamWildC
        , toPTL(selectCls)
        , whereCl
        , groupingOrEmp
        , orderByCl
        , joinConds
      );
    }
    default: throw TranslationException("message: Unresolved Query",typeCast(#node,qry).src);
  }
}

