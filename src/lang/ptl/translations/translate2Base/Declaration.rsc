module lang::ptl::translations::translate2Base::Declaration
import List;
extend lang::ptl::translations::translate2Base::Expression;
import Type;
import lang::ptl::ast::SCD;

public Statement toSQL(entity(list[ModelAnnotation] modelannotationOpt
        , list[PartitionedBy] prtBy
        , list[ClusteredBy] clstBy
        , list[RowFormat] rowFrmt
        , list[StoredAs] storedAs
        , list[Location] location
        , list[TableProperties] tblPropties
        , list[MaterializedAs] materializedAs
        , list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , list[Field] fields
        )){
          list[Columns] cols(){
            list[Columns] result = [];
            if (!isEmpty(modelannotationOpt)){
                  if (strategyValue(timestampStrategy()) <- modelannotationOpt[0].configKeyValue){
                   list[ColumnSpecification] timestampedFields = [toSQL(field) | field <- fields];
                    timestampedFields += columnSpecification(regularIdentifier("ptl_valid_from"), primitiveType(timestampType()), []);
                    timestampedFields += columnSpecification(regularIdentifier("ptl_valid_to"), primitiveType(timestampType()), []);
                    result += [columns(timestampedFields)];
                  }
                  else if(strategyValue(checkColumnStrategy()) <- modelannotationOpt[0].configKeyValue){
                    list[ColumnSpecification] checkFields = [toSQL(field) | field <- fields];
                    checkFields += columnSpecification(regularIdentifier("ptl_hash_diff"), primitiveType(varCharType([])), []);
                    checkFields += columnSpecification(regularIdentifier("ptl_valid_from"), primitiveType(timestampType()), []);
                    checkFields += columnSpecification(regularIdentifier("ptl_valid_to"), primitiveType(timestampType()), []);
                    result += [columns(checkFields)];
                  }
                  else{
                    return [];
                  }
            }
            else if(!isEmpty(fields)){
                    result += [columns([toSQL(field)|field<-fields])];
                  }
            else{
                    return [];
                  }
            return result;
        }
   return createTable(withColumns(
       [toSQL(temp)|temp<-temporal]
        , [toSQL(ext)|ext<-external]
        , [toSQL(ifNotExist)|ifNotExist<-ifNotExists]
        , toTableName(entityId)
        , cols()
        , [] //no translation for comment
        , [toSQL(part)|part<-prtBy]
        , [toSQL(clust)|clust<-clstBy]
        , [toSQL(row)|row<-rowFrmt]
        , [toSQL(store)|store<-storedAs]
        , [toSQL(locat)|locat<-location]
        , [toSQL(prop)|prop<-tblPropties]
    ));
}


public Statement toSQL(view(list[ModelAnnotation] mda, ViewDecl v)){
    
    switch(v){
        case viewDecl(
        list[IfNotExists] ifNotExists
        , list[Drop] _
        , list[Temporal] _
        , NameOrTemplate nameOrTemplate 
        , list[Distinct] distinct 
        , ViewNameOrWildcard viewNameOrWildcard
        , list[MixinsOrEmpty] _
        , list[TranspositionFunction] _
        , list[ViewVariablesOrEmpty] _
        , list[SubViewsOrEmpty] _
        , list[ViewField] viewFields
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions
        ) : {
            private list[ViewField] addCheckField(){
              list[ViewField] checkFields = [];
              if(size(mda) > 0 && strategyValue(checkColumnStrategy()) <- mda[0].configKeyValue){
                ViewField checkField = inferredDerivedAttribute("hash_diff", Expr::identifier(["CheckFields"]));
                checkFields += checkField;
              }
              return checkFields;
            }
            viewFields += addCheckField(); 
            
            return createView(ifNotExists,toSQL(nameOrTemplate),queryOrWithQuery(toSQL(subViewDecl(
            distinct
            , [viewNameOrWildcard]
            , viewFields
            , filterOrEmpty
            , groupingOrEmpty
            ,  orderByClsOpt
            , joinConditions
            ))
            ));
            }
        default: throw TranslationException("message: view declaration not resolved",typeCast(#node,v).src);
    }
   
}


public Statement toSQL(transformDef(list[ModelAnnotation] mda,TransformDecl transformDecl)){
   switch(transformDecl){
    case updateAction(
        list[IfNotExists] ifNotExists
        , NameOrVariableRef nam
        , list[Distinct] ds
        , ViewNameOrWildcard viewWild
        , list[TAttribute] entries
        , list[TPartition] _
        , list[ConstraintsOrEmpty] _
        , list[FilterOrEmpty] filterEty
        , list[GroupingOrEmpty] grpEty
        , list[OrderByClauseOpt] orderOpt
        , list[JoinConditions] joinCond
        ):{
            fc= toSQL(viewWild);
        
            jcs = [toSQL(jc)|jc<-joinCond];
          

          list[ViewField]  eavs= [toSQL(en)|en<-entries];
             return insertWithQuery(overwrite(
               [Table::table()]
                ,toTableName(nam.name)
                ,[]
               ,ifNotExists,
               [],
               toSQL(subViewDecl(
                    ds
                    , [viewWild]
                    , eavs
                    , filterEty
                    , grpEty
                    ,  orderOpt
                    , joinCond
                ))
        ));
        }
        default : throw TranslationException("message: Unresolved signature",typeCast(#node,transformDecl).src);
   }
}

public TableName toTableName(str tn)=name([] , tabId(toSQL(tn)));

public ExpAsVarOrStar toSQL(ViewField vf){
  switch(vf){
    case starAttribute():  return  projectionStar();
    case starAttributeWithQID(str name): return tableNameDotStar(name([],regularIdentifier(name))) ;
    case attributeWithAlias(Expr e, QualifiedIdentifier q):return projectionExpAsVar(expAsVar(toSQL(e),[varAssign([as()],toSQL(q.ids[0].name))]));
    case inferredDerivedAttribute(str oname, Expr e):{
       
         return projectionExpAsVar(expAsVar(toSQL(e),[varAssign([as()],regularIdentifier(oname))]));
    }
    case viewfieldqname(qName(str e1, str e2)): return  projectionExpAsVar(expAsVar(propRef([regularIdentifier(e1),regularIdentifier(e2)]),[]));
    case viewfieldqname(sName(str e1)): return projectionExpAsVar(expAsVar(propRef([regularIdentifier(e1)]),[]));
        default: throw TranslationException("message: View Field  not resolved",typeCast(#node,vf).src);

  }
}

public ViewField toSQL(TAttribute ta){
    switch(ta){
    case starTAttribute():  return  starAttribute();
    case starTAttributeWithQID(str name): return starAttributeWithQID(name);
    case tAttributeWithAlias(Expr e, QualifiedIdentifier q):return attributeWithAlias( e,  q);
    case inferredDerivedTAttribute(str oname, Expr e):return  inferredDerivedAttribute( oname,  e);
    case qName(str e1, str e2): return  viewfieldqname(QualifiedNameOrShortName::qName(e1,e2));
    case sName(str e1): return  viewfieldqname(QualifiedNameOrShortName::sName(e1));
    default: throw  TranslationException("message: Unresolved expression",typeCast(#node,ta).src);

  }
}
public TableName toSQL(viewName(str nam))=toTableName(nam);

public LocationClause toSQL(location(str locationEntry))=locationClause( locationEntry);

public TablePropertiesClause toSQL(tableProperties(list[TableProperty] tblPty))=tablePropertiesClause([toSQL(prop)|prop<-tblPty]);

public StorageClause toSQL(storedAs(FileType fileType))=storageClauseStoredAs(lang::basesql::ast::BaseSQL::storedAs(toSQL(fileType)));


public StoredAsType toSQL(FileType ft){
    switch(ft){
        case textFile():return StoredAsType::textFile();
        case orc():return StoredAsType::orc();
        case parquet():return StoredAsType::parquet();
        case avro():return StoredAsType::avro();
        case jsonFile():return StoredAsType::jsonFile();
        case rcFile():return StoredAsType::rcFile();
        case sequenceFile():return StoredAsType::sequenceFile();

        default: throw TranslationException("message: Unresolved File Type",typeCast(#node,ft).src);
    }
}
public RowFormatClause toSQL(rowFormat(FormatType fmtType))=rowFormat(toSQL(fmtType));

public RowFormatType toSQL(serDe(str serdeEntry))= serde(serdeEntry, [] );//not complete;

public RowFormatType toSQL(delimitedFields(list[str] dlm, list[Lines] lines))=delimited(
        [fieldsTerminatedBy(string, [])|string<-dlm]
        , []
        , []
        , [linesTerminatedBy( terminator)|lines(str terminator) <-lines]
        , []
    );
public TemporaryTable toSQL(temporal())=temporaryTable();

public ExternalTable toSQL(external()) = externalTable();

public ClusteredByClause toSQL(clusteredBy(list[str] clstEntries, str \int))= clusteredByClause([toSQL(ent)|ent<-clstEntries],[],\int);//no sorted clause

public lang::basesql::ast::BaseSQL::IfNotExists toSQL(ifNotExists())= ifNotExists();

public ColumnSpecification toSQL(Field f){
  switch(f){
     case field(str fieldId, Type \type, list[Constraints] _):return columnSpecification(toSQL(fieldId) ,  toSQL(\type), []); //constraints and comment need translation
     case uniReference(str refId, Type \type):return columnSpecification(toSQL(refId) ,  toSQL(\type), []);
     default: throw TranslationException("message:Unresolved field type ",typeCast(#node,f).src);
  }

}

public lang::basesql::ast::BaseSQL::TableProperty toSQL(tableProperty(str e1, str e2))=lang::basesql::ast::BaseSQL::tableProperty(e1,e2);

public PartitionedByClause toSQL(partitionedBy(lrel[str id,list[Type] \type] prtByEntries)) {

  
  if ([] != prtByEntries.\type[0]) {
    return partitionedByClause(
        columns([
          columnSpecification(
          regularIdentifier(head(prtByEntries.id))
        , toSQL(head(prtByEntries.\type[0]))
        , []
    )]));
  }
  else {
    return partitionedByClause(
        columns([
          columnSpecification(
          regularIdentifier(head(prtByEntries.id))
        , primitiveType(PrimitiveType::stringType()) 
        , []
    )]));
  }
}

public Statement toSQL(entityExtends(
        list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , str baseId
        , list[Field] fields
        )){
            return createTable(
         withLike(
               [toSQL(temp)|temp<-temporal]
        ,  [toSQL(ext)|ext<-external]
        , [toSQL(ifNotExist)|ifNotExist<-ifNotExists]
        , toTableName(entityId)
        ,  like()
        , toTableName(baseId)
        , []
    )
            );
        }

public Statement toSQL(viewAs(
        list[ModelAnnotation] mda,
         list[IfNotExists] ifNotExists
         , list[Drop] drop
         , list[Temporal] temp
         , QualifiedIdentifier qid
         , list[ViewVariablesOrEmpty] viewVar
         , SubViewDecl subViewDecl
         )){
          return createTable(withQuery(
               [toSQL(temporal)|temporal<-temp] 
                , []
                , [toSQL(ifNotExist)|ifNotExist<-ifNotExists]
                , toTableName(qid.ids[0].name)
                , []
                , []
                , createTableQuery(queryOrWithQuery(toSQL(subViewDecl)))
          ));
}


public QueryExpr toSQL(nestedSubViewDecl(
         SubViewDecl subView1
        , ViewRelationshipType viewRelType
        , SubViewDecl subView2
)){
            switch(viewRelType){
            case union():return queryUnion(toSQL(subView1),union([] ),toSQL(subView2));
            case intersect(): return queryIntersect(toSQL(subView1), intersect(), toSQL(subView2));
            case unionAll():return queryUnion(toSQL(subView1),union([SetQuantifier::\all()] ),toSQL(subView2));

            default:throw TranslationException("message: Unresolved translation",typeCast(#node,viewRelType).src);
            } 
        }

public WhereClause toSQL(\filter(Expr e)){
    return whereClause(toSQL(e));
}

public list[JoinClause] toSQL(joinConditions(list[JoinCondition] conds)){
   if(size(conds)>0)
  return [toSQL(conds[0],joinConditions(remove(conds,0)))];
  else return [];
}



public TableIdOrSubquery toSQL(tName(str name, list[Path] paths),list[Alias] a)=tableId(toTableName(name), [toSQL(id)|\alias(str id)<-a]);
public JoinClause toSQL(joinCondition(JoinType jt, NameOrVariableRef nameOrVarRef, list[Alias] a, list[OnCondition] cond),JoinConditions jcs){
     
     switch(jt){
      case \join():return innerJoinClause(
        []
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond]
        , toSQL(jcs)
    );
      case inner():return return innerJoinClause(
        [inner()]
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond]
        , toSQL(jcs)
    );
      case leftOuterJoin():return outerJoinClause(
       left()
        , [outer()]
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond][0]
        ,  toSQL(jcs)
    );
      case rightJoin():return outerJoinClause(
       right()
        , []
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond][0]
        ,  toSQL(jcs)
    );
      case  rightOuterJoin():return outerJoinClause(
       right()
        , [outer()]
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond][0]
        ,  toSQL(jcs)
    );
      case  fullJoin():return outerJoinClause(
       full()
        , []
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond][0]
        ,  toSQL(jcs)
    );
      case  fullOuterJoin():return outerJoinClause(
       full()
        , [outer()]
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond][0]
        ,  toSQL(jcs)
    );
      case  crossJoin():return crossJoinClause(
       CrossJoin::crossJoin()
        , toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond]
        ,  toSQL(jcs)
  );
      // case  semiJoin():return;
      case  leftSemiJoin():return leftSemiJoinClause(
         LeftSemiJoin::leftSemiJoin()
        ,  toSQL(nameOrVarRef,a)
        , [JoinCondition::joinCondition(toSQL(e))|onCondition(Expr e)<-cond][0]
        ,  toSQL(jcs)
    );

      default: throw TranslationException("message: Unresolved join type ",typeCast(#node,jt).src);
     }

}


public FromClause toSQL(ViewNameOrWildcard vn){
    switch(vn){
    
    case wildcardWithAlias(SubViewDecl subViewDecl, Alias al):return fromClause([tableIdOrSubquerySubquery(toSQL(subViewDecl),regularIdentifier(al.name))]);
    case name(QualifiedNameOrShortName qid, list[Alias] allist): return fromClause([tableId(toTableName(qid.name),[toSQL(id)|\alias(str id)<-allist] )]);
    default: throw TranslationException("message:Unresolved View Name",typeCast(#node,vn).src);

    }
}

public OrderByClause toSQL(OrderByClauseOpt::orderByClause(list[OrderElement] orderEl))=OrderByClause::orderByClause([toSQL(el)|el<-orderEl]);

public OrderElem toSQL(orderElement(AscOrDescOpt ascdesc)){
   switch(ascdesc){
      case ascending(Expr e): return asc(toSQL(e));
      case asc(Expr e):return asc(toSQL(e));
      case descending(Expr e):return desc(toSQL(e));
      case desc(Expr e):return desc(toSQL(e));
      default : throw TranslationException("message: Unhandled oder element ",typeCast(#node,ascdesc).src);
   }
}

public GroupByClause toSQL(groupby(list[Expr] el))=groupByClause([expAsVar(toSQL(e),[])|e<-el]);
public list[HavingClause] toSQL(list[HavingClauseOpt] h)=[toSQL(hv)|hv<-h];

public HavingClause toSQL(HavingClauseOpt::havingClause(Expr e))=HavingClause::havingClause(toSQL(e));






public AggParam toSQL(DistinctOrAll::distinct())=setQuantifier(distinct());
public AggParam toSQL(DistinctOrAll::\all())=setQuantifier(\all());

public AnalyticFunctionClause toSQL(analyticFunctionClause(WindowSpecification windowSpec))=analyticFunctionClause(toSQL(windowSpec));

public WindowSpecification toSQL(windowSpecification(
    list[PartitionByClause] partitionByCls
    , list[OrderByClauseOpt] orderByCls
    , list[WindowFrameClause] windowFrameCls
    ))= windowSpecification(
        [toSQL(partitionByCl)|partitionByCl<-partitionByCls]
        , [toSQL(orderByCl)|orderByCl<-orderByCls]
        , [toSQL(windowFrameCl)|windowFrameCl<-windowFrameCls]
    );

public WindowFrameClause  toSQL(windowFrameClause(RowsOrRange rowOrRange, FrameStartOrBetween frameStartOrBetween))=windowFrameClause( toSQL(rowOrRange) , toSQL(frameStartOrBetween) );
public PartitionByClause toSQL(partitionByClause(list[Expr] exp))=  partitionByClause([toSQL(e)|e<-exp]);  
public WindowSpecification toSQL(namedWindow(str identifier))= namedWindow( quotedIdentifier(identifier));

public RowsOrRange toSQL(rows())=rows();
public RowsOrRange toSQL(range())=range();

public FrameStartOrBetween toSQL(frameStart(FrameStart frameStart))
    = FrameStartOrBetween::frameStart(toSQL(frameStart));
public FrameStartOrBetween toSQL(frameBetween(FrameBetween frameBetween))=FrameStartOrBetween::frameBetween(toSQL(frameBetween))
    ; 

public FrameBetween toSQL(frameBetweenUnboundedPreceding(UnboundedPreceding unboundedPreceding, FrameEndA frameEndA))
    = frameBetweenUnboundedPreceding(toSQL(unboundedPreceding), toSQL(frameEndA));

public FrameBetween toSQL(frameBetweenNumericPreceding(NumericPreceding numericPreceding, FrameEndA frameEndA))=frameBetweenNumericPreceding(toSQL(numericPreceding),toSQL(frameEndA));
public FrameBetween toSQL(frameBetweenCurrentRow(CurrentRow currentRow, FrameEndB frameEndB))=frameBetweenCurrentRow(toSQL(currentRow),toSQL(frameEndB));
public FrameBetween toSQL(frameBetweenNumericFollowing(NumericFollowing numericFollowing, FrameEndC frameEndC))=frameBetweenNumericFollowing(toSQL(numericFollowing),toSQL(frameEndC))
    ;

public FrameStart toSQL(frameStartUnboundedPreceding(UnboundedPreceding unboundedPreceding))
    = frameStartUnboundedPreceding(toSQL(unboundedPreceding) );
public FrameStart toSQL(frameStartNumericPreceding(NumericPreceding numericPreceding))=frameStartNumericPreceding( toSQL(numericPreceding));
public FrameStart toSQL(frameStartCurrentRow(CurrentRow currentRow))=frameStartCurrentRow( toSQL(currentRow));
    


public FrameEndA toSQL(frameEndANumericPreceding(NumericPreceding numericPreceding))
    = frameEndANumericPreceding( toSQL(numericPreceding));
public FrameEndA toSQL(frameEndACurrentRow(CurrentRow currentRow))=frameEndACurrentRow(toSQL(currentRow));
public FrameEndA toSQL(frameEndANumericFollowing(NumericFollowing numericFollowing))=frameEndANumericFollowing(toSQL(numericFollowing));
public FrameEndA toSQL(frameEndAUnboundedFollowing(UnboundedFollowing unboundedFollowing))=frameEndAUnboundedFollowing( toSQL(unboundedFollowing))
    ;


public FrameEndB toSQL(frameEndBCurrentRow(CurrentRow currentRow))=frameEndBCurrentRow(toSQL(currentRow));
public FrameEndB toSQL(frameEndBNumericFollowing(NumericFollowing numericFollowing))=frameEndBNumericFollowing(toSQL(numericFollowing));
public FrameEndB toSQL(frameEndBUnboundedFollowing(UnboundedFollowing unboundedFollowing))=frameEndBUnboundedFollowing(toSQL(unboundedFollowing));
    


public FrameEndC toSQL(frameEndCNumericFollowing(NumericFollowing numericFollowing))= frameEndCNumericFollowing( toSQL(numericFollowing));
public FrameEndC toSQL(frameEndCUnboundedFollowing(UnboundedFollowing unboundedFollowing))=frameEndCUnboundedFollowing(toSQL(unboundedFollowing))
  ; 


public UnboundedPreceding toSQL(unboundedPreceding()) = unboundedPreceding(); 

public NumericFollowing toSQL( numericFollowing(str \int)) =  numericFollowing(\int); 

public NumericPreceding toSQL( numericPreceding(str \int)) =  numericPreceding(\int); 

public UnboundedFollowing toSQL(unboundedFollowing()) = unboundedFollowing(); 

public CurrentRow toSQL(currentRow()) = currentRow(); 

public ColumnSpecification toSQLCols(ViewField f){
  switch(f){
    
      case field(str fieldId, Type \type, list[Constraints] _):return columnSpecification(toSQL(fieldId) ,  toSQL(\type), []);
      case uniReference(str refId, Type \type):return columnSpecification(toSQL(refId) ,  toSQL(\type), []);
      case inferredDerivedAttribute(str oname, Expr e):return columnSpecification( toSQL(oname), toSQL(e.\type), []);
      
    
     default: throw TranslationException("message:Unresolved field type ",typeCast(#node,f).src);
  }

}