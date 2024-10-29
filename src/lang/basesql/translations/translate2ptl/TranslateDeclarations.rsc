module lang::basesql::translations::translate2ptl::TranslateDeclarations
import Type;
import lang::basesql::ast::BaseSQL;
import lang::ptl::ast::PTL;
import lang::basesql::prettyprint::BaseSQL;
import List;
import String;

extend lang::basesql::translations::translate2ptl::TranslateExpressions;

public map[str, Drop] dict = (); 

public Declaration toPTL(Statement stmt) {
  switch(stmt) {
    case Statement::createTable(CreateTable cTab): return toPTL(cTab);
    default: throw TranslationException("message: Statement cannot be translated",typeCast(#node,stmt).src);
  }
}
// public list[Drop] toPTL(dropView(list[IfExists] ifExists, TableName tblName)){ 
//   return []:=ifExists?[drop()]:[dropIfExist()];
// }
// Drop
public list[Drop] toPTL(str tableName) {
  if (tableName in dict) return [ dict[tableName] ];
  else return [];
}

// CreateTable
public Declaration toPTL(CreateTable cTable) {
  switch(cTable) {
    case withColumns(
      list[TemporaryTable] temporaryTable
      , list[ExternalTable] externalTable
      , list[IfNotExists] ifNotExists 
      , TableName tblName
      , list[Columns] columns
      , _
      , list[PartitionedByClause] partitionByCls
      , list[ClusteredByClause] clusteredByCls
      , list[RowFormatClause] rowFormatCls
      , list[StorageClause] storageCls 
      , list[LocationClause] locationCls
      , list[TablePropertiesClause] tblPropertiesCls): 
      {

        list[ColumnSpecification] getColumnSpecs(list[Columns] cols) {
          if ([] := cols) return [];
          else return head([ x | Columns::columns(x) <- columns]);

        }
        str tbName = capitalize(toEntityId(tblName.tblNameId.id));
        list[ColumnSpecification] colSpecs = getColumnSpecs(columns);
        list[Field] fields = [ toPTL(col) | ColumnSpecification col <- colSpecs];
        list[ClusteredBy] clusteredBy = [ toPTL(clstByCls) | clstByCls <- clusteredByCls ];
        list[PartitionedBy] partitionedBy = [ toPTL(partByCls) | partByCls <- partitionByCls ];
        list[RowFormat] rowFormat = [ toPTL(rwFmtCls) | rwFmtCls <- rowFormatCls ];
        list[External] externalTab = [ toPTL(extnl) | extnl <- externalTable ];
        list[IfNotExists] ifNotExi = [ toPTL(ifNE) | ifNE <- ifNotExists ];
        list[Temporal] tempTable = [ toPTL(tmprl) | tmprl <- temporaryTable ];
        list[TableProperties] tblPropClause = [ toPTL(tbprpCl) | tbprpCl <- tblPropertiesCls ];
        list[Location] locClause = [ toPTL(locCls) | locCls <- locationCls ];
        list[StoredAs] strgeClause = [ toPTL(strgCls) | strgCls <- storageCls ];

        return entity([]
          , partitionedBy
          , clusteredBy
          , rowFormat
          , strgeClause
          , locClause
          , tblPropClause
          , []
          , tempTable
          , externalTab
          , ifNotExi
          , []
          , tbName
          , fields
        );
      } 
    case withLike(
      list[TemporaryTable] temporaryTbl
      , list[ExternalTable] externalTbl
      , list[IfNotExists] ifNotExists  
      , TableName tbl1
      , _
      , TableName tbl2
      , list[TablePropertiesClause] _
    ): 
    {
      list[Temporal] tempTable = [ toPTL(tmprl) | tmprl <- temporaryTbl ];
      list[External] externalTab = [ toPTL(extnl) | extnl <- externalTbl ];
      list[IfNotExists] ifNotExi = [ toPTL(ifNE) | ifNE <- ifNotExists ];

      return entityExtends(
        tempTable
        , externalTab
        , ifNotExi
        , []
        , capitalize(toString(tbl1))
        , capitalize(toString(tbl2))
        , []
      );
    }
    default: throw TranslationException("message:Unhandled Statement  ",typeCast(#node,cTable).src);
  }
}
public str toEntityId(Identifier id){
  switch(id){
    case regularIdentifier(str regularId): return regularId;
    case quotedIdentifier(str quotedId):{
      
      return replaceAll(quotedId,"`","");
    } 

    default: throw TranslationException("error",typeCast(#node,id).src);
  }
}
public lang::ptl::ast::PTL::IfNotExists toPTL(IfNotExists _) = ifNotExists();

public Field toPTL(ColumnSpecification::columnSpecification(Identifier id, DataType dt, _)) {
  return field(toString(id), toPTL(dt), []);
}

public PartitionedBy toPTL(PartitionedByClause::partitionedByClause(columns)) {
  lrel[str,list[Type]] column2ColumnSpecification(Columns::columns(colSpec)) {
    updColSpec = [ <toString(x),[toPTL(y)]> | ColumnSpecification::columnSpecification(x, y, _) <- colSpec];
    return updColSpec;
  }
  return partitionedBy(column2ColumnSpecification(columns));
}

public ClusteredBy toPTL(ClusteredByClause::clusteredByClause(list[Identifier] ids, _, str \int)) {
  clusteredIds = [ toString(id) | id <- ids];
  return clusteredBy(clusteredIds, \int);
}

public RowFormat toPTL(RowFormatClause::rowFormat(RowFormatType rfType)) = RowFormat::rowFormat(toPTL(rfType));

public FormatType toPTL(RowFormatType fType) {
  switch(fType) {
    case serde(str strConst, _): return serDe(toLowerCase(strConst));
    case delimited(
      list[FieldsTerminatedBy] fieldssTerminatedBy
      , list[CollectionItemsTerminatedBy] _
      , list[MapKeysTerminatedBy] _ 
      , list[LinesTerminatedBy] _ 
      , list[NullDefinedAs] _): {
        list[Lines] lines = [ toPTL(fieldTBy) | fieldTBy <- fieldssTerminatedBy ];
        str strConst = [ x | fieldsTerminatedBy(x, _) <- fieldssTerminatedBy][0]; // The first element
        return delimitedFields([toLowerCase(strConst)], lines);
      }
    default: throw TranslationException("message:Unresolved format Type ",typeCast(#node,fType).src);
  }
}

public Lines toPTL(FieldsTerminatedBy::fieldsTerminatedBy(str strConst, list[EscapedBy] _)) = lines(strConst);

public External toPTL(ExternalTable _) {
  return external();
}

public Temporal toPTL(TemporaryTable _) {
  return temporal();
}

public TableProperties toPTL(TablePropertiesClause tblPrpties) {
  tblProperties = [ toPTL(tblProp) | tblProp <- tblPrpties.tblProperty];
  return tableProperties(tblProperties);
}

public lang::ptl::ast::PTL::TableProperty toPTL(TableProperty::tableProperty(str e1, str e2)) {
  return tableProperty(e1, e2);
}

public Location toPTL(LocationClause::locationClause(str strConst)) {
  return location(strConst);
}

public lang::ptl::ast::PTL::StoredAs toPTL(StorageClause::storageClauseStoredAs(StoredAs::storedAs(StoredAsType storedAsType))) = storedAs(toPTL(storedAsType));


public FileType toPTL(StoredAsType storedAsType) {
  switch(storedAsType) {
    case StoredAsType::sequenceFile(): return sequenceFile();
    case StoredAsType::textFile(): return FileType::textFile();
    case StoredAsType::rcFile(): return rcFile();
    case StoredAsType::orc(): return orc();
    case StoredAsType::parquet(): return parquet();
    case StoredAsType::avro(): return avro();
    case StoredAsType::jsonFile(): return jsonFile();
    default: throw TranslationException("message:Unresolved storage type ",typeCast(#node,storedAsType).src);
  }
}

public lang::ptl::ast::PTL::Identifier toPTL(Identifier id) {
  switch(id) {
    case Identifier::varReference(str varRef): return varRefName(varRef);
    case Identifier::regularIdentifier(str regId): return regularIdentifier(regId);
    case Identifier::quotedIdentifier(str quotedId): return quotedIdentifier(quotedId);
    default: throw TranslationException("message: Unresolved Identifier",typeCast(#node,id).src);
  }
}

public NameOrTemplate toPTL(TableName tblName) = viewName(replaceAll(toString(tblName.tblNameId),"`",""));



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

public GroupByClauseOpt toPTL(GroupByClause::groupByClause(list[ExpAsVar] exprs)) {
  result = [toPTL(x) | expAsVar(x, _) <- exprs];
  return groupby(result);
}

public HavingClauseOpt toPTL(HavingClause::havingClause(Expr exp)) 
  = HavingClauseOpt::havingClause(toPTL(exp));

public OrderByClauseOpt toPTL(OrderByClause::orderByClause(list[OrderElem] ordElems)) 
  = OrderByClauseOpt::orderByClause([ toPTL(ordElem) | ordElem <- ordElems ]);

public OrderElement toPTL(OrderElem ordElem) {
  switch(ordElem) {
    case orderExpr(Expr exp): return orderElement(having(toPTL(exp)));
    case OrderElem::asc(Expr exp): return orderElement(AscOrDescOpt::asc(toPTL(exp)));
    case OrderElem::desc(Expr exp): return orderElement(AscOrDescOpt::desc(toPTL(exp)));
    default: throw TranslationException("message:Unresolved translation",typeCast(#node,ordElem).src);
  }
}

public FilterOrEmpty toPTL(WhereClause::whereClause(Expr exp)) = \filter(toPTL(exp));


// Join Conditions
public OnCondition toPTL(JoinCondition::joinCondition(Expr exp)) = onCondition(toPTL(exp));



list[JoinCondition] toPTL(list[JoinClause] jClauses) {
  // flatten the parameter each clause into a list of JoinClauses then 
  // perform the conversion on the outputted list.

  list[JoinClause] flattenJoinClauses(list[JoinClause] jClss) {
    result = [];
    for(joinCls <- jClss) {
      switch(joinCls) {
        case outerJoinClause(
          OuterType _
          , list[Outer] _
          , TableIdOrSubquery _
          , JoinCondition _
          , list[JoinClause] extraJCl
        ): { 
            result += joinCls;
            if (size(extraJCl) > 0) result += flattenJoinClauses(extraJCl);
          }
      }
    }
    return result;
  }

  JoinCondition getJoinCondtion(JoinClause jClause) {
    switch(jClause) {
      case innerJoinClause(        
        list[Inner] _
        , TableIdOrSubquery::tableId(TableName tblName, list[Identifier] idOpt)
        , list[JoinCondition] joinConditionOpt
        , list[JoinClause] _
      ): {
          return joinCondition(
              \join()
              , tName(replaceAll(toString(tblName),"`",""), [])
              , [ \alias(toString(id)) | id <- idOpt ] // Alias
              , [ toPTL(joinCond) | joinCond <- joinConditionOpt ] // OnCondition
            );
      }

      case JoinClause::outerJoinClause(
        OuterType outerType
        , list[Outer] outerOpt
        , TableIdOrSubquery::tableId(TableName tblName, list[Identifier] idOpt)
        , JoinCondition joinCond
        , list[JoinClause] _
      ):{ 
          return joinCondition(
              toPTL(outerType, outerOpt)
              , tName(replaceAll(toString(tblName),"`",""), [])
              , [ Alias::\alias(toString(id)) | id <- idOpt ] // Alias
              , [ toPTL(joinCond) ] // OnCondition
            );
        
        }
        default: throw TranslationException("message: Unresolved translation",jClause);
    }
  }

  return  [ getJoinCondtion(jCl) | jCl <- flattenJoinClauses(jClauses) ];

}

public JoinType toPTL(OuterType outerType, list[Outer] outr) {
  switch(outerType) {
    case OuterType::left(): return leftOuterJoin();
    case OuterType::right(): {
      if (isEmpty(outr)) return rightJoin();
      return rightOuterJoin();
    }
    case OuterType::full(): {
      if (isEmpty(outr)) return fullJoin();
      return fullOuterJoin();
    }
    default: throw TranslationException("message:Unresolved translation",typeCast(#node,outerType).src);
  }
}


public ViewNameOrWildcard toPTL(TableIdOrSubquery tIdOrSub) {

  switch(tIdOrSub) {
    case tableId(TableName tblName, list[Identifier] idOpt): return name(sName(replaceAll(toString(tblName),"`","")),  [ Alias::\alias(toString(id)) | id <- idOpt ]);
    case tableIdOrSubquerySubquery(QueryExpr qry, Identifier id): return wildcardWithAlias(toPTL(qry), Alias::\alias(toString(id)));
    default: throw TranslationException("Unresolved translation",tIdOrSub);
  }
}

public SubViewDecl toPTL(queryUnion(QueryExpr qryexpr1, union(list[SetQuantifier] setQuantifier), QueryExpr qryExpr2))=[]:=setQuantifier?nestedSubViewDecl(
       toPTL(qryexpr1)
        , union()
        ,toPTL(qryExpr2)
        ):nestedSubViewDecl(
       toPTL(qryexpr1)
        , unionAll()
        ,toPTL(qryExpr2)
        );
        
public SubViewDecl toPTL( queryIntersect(QueryExpr qryExpr1,Intersect intersect, QueryExpr qryExpr2))=nestedSubViewDecl(
       toPTL(qryExpr1)
        , ViewRelationshipType::intersect()
        ,toPTL(qryExpr2)
        );

public list[ViewField] toPTL(SelectClause::selectClause(list[SetQuantifier] _, Projection::expAsVars(list[ExpAsVarOrStar] exps))) {
  return [ toPTL(exp) | exp <- exps ];
}

public list[Distinct] getDist(SelectClause::selectClause(list[SetQuantifier] dist, Projection::expAsVars(list[ExpAsVarOrStar] _))) {
  return [ getDist(exp) | exp <- dist ];
}

public Distinct getDist(SetQuantifier::distinct())= Distinct::distinct();

public ViewField toPTL(ExpAsVarOrStar exp) {
  switch(exp) {
    case projectionStar(): return starAttribute();
    case tableNameDotStar(TableName tblName): return starAttributeWithQID(toString(tblName));
    case projectionExpAsVar(ExpAsVar::expAsVar(Expr exp, [VarAssign::varAssign(_, id)])): return inferredDerivedAttribute(toString(id), toPTL(exp));
    case projectionExpAsVar(ExpAsVar::expAsVar(Expr::propRef([x1]), [])): return ViewField::viewfieldqname(sName(toString(x1)));
    case projectionExpAsVar(ExpAsVar::expAsVar(Expr::propRef([x1, x2]), [])): return ViewField::viewfieldqname(qName(toString(x1), toString(x2)));
    case projectionExpAsVar(ExpAsVar::expAsVar(Expr e, [])): return ViewField::inferredDerivedAttribute("function", toPTL(e));
    default: throw TranslationException("message:Unresolved expression ",exp);
  }
}

// These are named so because the function signature clashes with ViewField and 
// causes these guys to not be seen
public list[TAttribute] getTAttrs(SelectClause::selectClause(list[SetQuantifier] _, Projection::expAsVars(list[ExpAsVarOrStar] exps))) {
  return [ getTAttr(exp) | exp <- exps ];
}

TAttribute getTAttr(ExpAsVarOrStar exp) {
  switch(exp) {
    case ExpAsVarOrStar::projectionStar(): return starTAttribute();
    case ExpAsVarOrStar::tableNameDotStar(TableName tblName): return starTAttributeWithQID(toString(tblName));
    case ExpAsVarOrStar::projectionExpAsVar(ExpAsVar::expAsVar(Expr exp, [VarAssign::varAssign(_, id)])): return TAttribute::inferredDerivedTAttribute(toString(id), toPTL(exp));
    case ExpAsVarOrStar::projectionExpAsVar(ExpAsVar::expAsVar(Expr::propRef([x1]), [])): return TAttribute::tattributeqname(sName(toString(x1)));
    case ExpAsVarOrStar::projectionExpAsVar(ExpAsVar::expAsVar(Expr::propRef([x1, x2]), [])): return TAttribute::tattributeqname(qName(toString(x1), toString(x2)));
    default: throw TranslationException("message:Unresolved expression ",typeCast(#node,exp).src);
  }
}

public ViewNameOrWildcard toPTL(fromClause(list[TableIdOrSubquery] tblIdOrSubquery))=toPTL(head(tblIdOrSubquery));
