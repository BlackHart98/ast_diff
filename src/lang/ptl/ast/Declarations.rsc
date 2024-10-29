module lang::ptl::ast::Declarations

extend lang::ptl::ast::Mapping;

extend lang::ptl::ast::SCD;



data Declaration
    = entity(
        list[ModelAnnotation] mda
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
        )
    | entityWithKey(
        list[ModelAnnotation] mda
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
        , str primaryKey
        )
    | entityExtends(
        list[Temporal] temporal
        , list[External] external
        , list[IfNotExists] ifNotExists
        , list[Drop] drop
        , str entityId
        , str baseId
        , list[Field] fields
        )
    | struct(str structId, list[StructField] structFields)
    | entityMapping(str mappingName, str tableName, list[MappingBody] mappingBody)
    | enum(str name, list[EnumField] enumFields)
    | viewAs(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , QualifiedIdentifier qid
        , list[ViewVariablesOrEmpty] viewVar
        , SubViewDecl subViewDecl
        )
    | viewWith(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , QualifiedIdentifier qid
        , list[ViewVariablesOrEmpty] viewVar
        , list[NamedSubViewDecl] names
        , SubViewDecl subViewDecl
        )
    | viewWithTransform2(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , QualifiedIdentifier qid
        , list[ViewVariablesOrEmpty] viewVar
        , list[NamedSubViewDecl] names

        , TransformDecl transformDecl
        )
    | viewWithTransform(
        list[ModelAnnotation] mda,
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , list[ViewVariablesOrEmpty] viewVar

        , list[NamedSubViewDecl] names
        , TransformDecl transformDecl
        )
    | view(list[ModelAnnotation] mda, ViewDecl viewDecl)
    | viewWithCTE(list[ModelAnnotation] mda, SubViewAsCTE subViewAsCTE, ViewDecl viewDecl)
    | transformDef(list[ModelAnnotation] mda, TransformDecl transformDecl)
    
    | schemaName(str name)
    | schemaVar(str name)
    | addFile(Url url)
    | renameEnt(RenameEntity rEntity)
    | function(list[FunctionAnnotation] functionAnnotations,FunctionDef functionDefintion) 
    ;

data SubViewAsCTE = subViewAsCTE(list[ViewDecl] viewDeclList);


data FunctionAnnotation =functionAnnotation(Annotation annotation);

data FunctionDef= funcdefwithexpr(str functionid, list[Params] parameters, Type ty, Expr expr)
                 | funcdef(str functionid, list[Params] parameters, Type ty)
                 | funcdefWithKW(str functionid, list[Params] parameters,list[KWParam] kwparams, Type ty)
                 | funcdefKWOnly(str functionid, list[KWParam] kwparams, Type ty)
                 ;


data FunctionData= fData(str functionName,list[FunctionAnnotation] annotations, Type returnType);

data Params 
    = params(str paramId, Type ty)
    | types(Type paramType)
    ;

data Annotation 
    = scalar()
    | aggregate()
    | table()
    | platform(list[str] platforms)
    | \alias(str name)
    ;

data PartitionedBy = partitionedBy(lrel[str id,list[Type] \type] prtByEntries);

data ClusteredBy = clusteredBy(list[str] clstEntries, str \int);

data RowFormat = rowFormat(FormatType fmtType);

data FormatType 
   = serDe(str serdeEntry)
   | delimitedFields(list[str] dlm, list[Lines] lines)
   ;

   
data Lines = lines(str terminator);

data StoredAs = storedAs(FileType fileType);

data Location = location(str locationEntry);

data TableProperties = tableProperties(list[TableProperty] tblPty);

data TableProperty = tableProperty(str e1, str e2);

data FileType =
   textFile()
   | orc()
   | parquet()
   | avro()
   | jsonFile()
   | rcFile()
   | sequenceFile()
   ;

data External = external();

data MaterializedAs = materializedAs(str identifier);

// Entity
data Field
    = derived(str identifier, Type \type, Expr expr)
    | field(str fieldId, Type \type, list[Constraints] constraints)
    | uniReference(str refId, Type \type)
    | biReference(str refId, Type \type, Reference ref, str identifier)
    ;

data EnumField
    = enumField(str fieldName)
    | labeledEnumField(str labeledFieldName, str \value)
    ;

data Constraints = constraints(list[Facet] facet);

data Facet 
    = required()
    | size(str \int)
    | masked()
    | redacted()
    ; 

//  Struct
data StructField = structField(str structId, Type \type);

// View
data IfNotExists =  ifNotExists();

data CastFunc 
  = castFunc(Expr exp, Type ty)
  ;

data IfExists = ifExists();

data Temporal = temporal(); 
  
data Drop = drop() | dropIfExist();

data NamedSubViewDecl 
    = namedSubViewDecl(SubViewDecl subViewDecl, MandatoryAlias mandatoryAlias)
    ;

data Alias = \alias(str name);

data QualifiedIdentifier
    = qualifiedIdentifier(list[Identifier] ids)
    ;

data Identifier
    = varRefName(str name)
    | regularIdentifier(str name)
    | quotedIdentifier(str name )
    ;
  
data VariableIdentifier
    = variableIdentifier(list[IdentifierVar] ids)
    ;

data IdentifierVar = identifierVar(str vname);

data Identification = identification(str name);

data ViewDecl 
    = viewFromTransform( 
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , NameOrWildcard nameOrWildcard
        , list[Distinct] distinct 
        , ViewNameOrWildcard viewNameOrWildcard
        , TransformWithFile transformWithFile
        , TransformAttributes transformAttribute
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions
        )

    | viewDecl(
        list[IfNotExists] ifNotExists
        , list[Drop] drop
        , list[Temporal] temp
        , NameOrTemplate nameOrTemplate 
        , list[Distinct] distinct 
        , ViewNameOrWildcard viewNameOrWildcard
        , list[MixinsOrEmpty] mixinsOrEmpty
        , list[TranspositionFunction] transpositionFunction
        , list[ViewVariablesOrEmpty] viewVarOrEmpty
        , list[SubViewsOrEmpty] subViewsOrEmpty
        , list[ViewField] viewFields
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions
        )
;


data TransformWithFile
  =  transformWithFile(list[QualifiedIdentifier] qid, str strLit)
;


data NameOrWildcard 
    = noWildcardOrName()
    | wildcardOrName(str name)
    ;
   

data ViewVariablesOrEmpty = variables(list[ViewBinding] views);

data ViewBinding
    = viewBinding(str oname, Type ty)
    | viewBindingInit(str oname, Type ty, Expr e)
    | viewBindingInferredInit(str oname, Expr e)
    ;


data FilterOrEmpty = \filter(Expr e);

data ViewRelationshipType
    = union() 
    | intersect()
    | unionAll()
    ;


data SubViewDecl
    = nestedSubViewDecl(
        SubViewDecl subView1
        , ViewRelationshipType viewRelType
        , SubViewDecl subView2
        )
    | subViewDecl(
        list[Distinct] distinct 
        , list[ViewNameOrWildcard] viewNameOrWildcard
        , list[ViewField] viewFields
        , list[FilterOrEmpty] filterOrEmpty
        , list[GroupingOrEmpty] groupingOrEmpty
        , list[OrderByClauseOpt] orderByClsOpt
        , list[JoinConditions] joinConditions
        )
    ;


data ViewNameOrWildcard
    = namedStructExp(list[NamedStructEntry] namedStructEntry, list[Alias] allist)
    | referenceName(str name1, str name2, list[Alias] allist)
    | templatedView(QualifiedNameOrShortName qid)
    | parentView(ViewDecl viewDecl)
    | wildcard(SubViewDecl subViewDecl)
    | wildcardWithAlias(SubViewDecl subViewDecl, Alias al)
    | name(QualifiedNameOrShortName qid, list[Alias] allist)
    ;

data NamedStructEntry = namedStructEntry(Identifier identifier, Expr e);


data NameOrTemplate
    = templatedName(str templName)
    | viewName(str name)
    ;

data TranspositionFunction 
    = pivot(
        list[PivotExpression] pivotExpr
        , str name  
        , list[PivotAttribute] pivotAttr
        )
    | unpivot(
        list[IncludeNulls] includeNulls
        , str name
        , UnpivotAttribute unpivotAttr
        , Unpivot unpivot
        )
    | flatmap(str name, list[str] params, list[FilterOrEmpty] filterOrEmpty) 
    | flatten(list[str] params, Expr e)
    ;


data IncludeNulls = includeNulls();

data Unpivot
    = unpivotChild(
        str name
        , UnpivotAttribute unpivotAttr
    )
    ;

data PivotAttribute 
    = pivotAttribute(PivotColumn pc, list[PivotElement] el)
    ;

data UnpivotAttribute = unpivotAttribute(Expr e, PivotAlias p);

data PivotExpression 
    = pivotExpression(str name, Type t, Expr e)
    | inferredPivotValue(str name, Expr e)
    ;

data PivotElement = pivotElement(str name, list[Alias] a);

data PivotColumn 
    = mapAlias(str strLit)
    | pivotColumn(str name)
    ;

data PivotAlias 
    = mapAlias(str name, str k, str v)
    | listAlias(str name, str l)
    ;
 
data MandatoryAlias = mandatoryAlias(str name);


data GroupingOrEmpty = grouping(GroupByClauseOpt g, list[HavingClauseOpt] h);

data GroupByClauseOpt = groupby(list[Expr] el);



data HavingClauseOpt = havingClause(Expr e);

data ViewOrId 
    = fromView(ViewDecl v)
    | fromId(str name)
    ;


data MixinsOrEmpty = mixins(list[Trait] t);
  
data Trait  = trait(str name);

data TransformAttribute
    = typedTransformAttribute(str name, Type t)
    | transformAttribute(str oname)
    ;

data TransformAttributes
    = transformAttributes(
        list[TransformAttribute] attrs
        )
    ;


data ViewField
    = starAttribute() 
    | starAttributeWithQID(str name)
    | attributeWithAlias(Expr e, QualifiedIdentifier q)
    | derivedAttribute(str oname, Type ty, Expr e)
    | inferredDerivedAttribute(str oname, Expr e)
    | viewAttribute(str oname, SubViewDecl subViewDecl)
    | viewfieldqname(QualifiedNameOrShortName qshortname)
    | blackList(list[str] qid)
;



data QualifiedNameOrShortName  
    = sName(str name)
    | qName(str name, str projection)
    ;

data ViewOption
    = leftJoinOption(SubViewDecl subViewDecl)
    | joinOption(SubViewDecl subViewDecl)
    ;

data JoinForLeftOrOpposite
    = forJoin()
    | forLeft()
    ;


data TransformDecl
    = createAction( 
        NameOrVariableRef name
        , list[Distinct] distinct
        , ViewNameOrWildcard viewWild
        , list[TAttribute] entries
        , list[TPartition] tp
        , list[ConstraintsOrEmpty] constr
        , list[FilterOrEmpty] filterEty
        , list[GroupingOrEmpty] grpEty
        , list[OrderByClauseOpt] orderOpt
        , list[JoinConditions] joinCond
        )

    | updateAction(
        list[IfNotExists] ifNotExists
        , NameOrVariableRef name
        , list[Distinct] distinct
        , ViewNameOrWildcard viewWild
        , list[TAttribute] entries
        , list[TPartition] tp
        , list[ConstraintsOrEmpty] constr
        , list[FilterOrEmpty] filterEty
        , list[GroupingOrEmpty] grpEty
        , list[OrderByClauseOpt] orderOpt
        , list[JoinConditions] joinCond
        )

    | directoryUpdateAction( 
        list[IfNotExists] ifNotExists
        , LocalDirectory lclDir
        , Expr e
        , list[TAttribute] entries
        , list[TPartition] tp
        , list[ConstraintsOrEmpty] constr
        , list[JoinConditions] joinCond
        )

    | directoryCreateAction(
        LocalDirectory lclDir
        , Expr e
        , list[TAttribute] entries 
        , list[TPartition] tp
        , list[ConstraintsOrEmpty] constr
        , list[JoinConditions] joinCond
        )
        |addPart(AddPartition ap)
        | renameEnt(RenameEntity re)
        | dropPart(DropPartition dp)
        | renamePart(RenamePartition rp)
    ;


data LocalDirectory
    = local()
    | nonLocal()
    ;

data RenameEntity 
    = renameEntity(QualifiedIdentifier q1, QualifiedIdentifier q2)
    ;

data AddPartition 
    = addPartition(
        list[IfNotExists] ifNotExists
        , QualifiedIdentifier q
        , list[PartitionClauseWithLocation] entries
        )
    ;
  
data RenamePartition 
    = renamePartition(QualifiedIdentifier q, PartitionClause p, PartitionClause pc)
    ;

data DropPartition 
    = dropPartition(
        IgnoreProtection i
        , Drop d 
        , list[Purge] p
        , QualifiedIdentifier q
        , list[PartitionClause] entries
        )
;

data TPartitionValue
    = tPartitionValue(Expr e)
    ;

 data TPartition
    = tPartition(list[TPartitionOn] tPartitionOn)
    ;

data TPartitionOn
    = tPartitionOn(str name, TPartitionValue p)
    ;

data IgnoreProtection
    = ignoreProtection()
    ;

data ConstraintsOrEmpty = transformConstraints(Expr e);



// Add File
data Url 
    = url(list[SchemePart] schemePart, DirectoryPart dirPart, FileNamePart filePart)
    | urlVarReference(str varRef)
    ;


data SchemePart = hdfs();


data FileNamePart = fileNamePart(str file, str ext);


data DirectoryPart = directoryPart(list[DirectoryPath] dirPath);


data DirectoryPath 
  = directoryName(str dirName)
  | aSubstitutedText(str subText)
  ;

data SubViewsOrEmpty = subViews(list[ViewDecl] views);

data TAttribute
    = starTAttribute() 
    | starTAttributeWithQID(str name)
    | tAttributeWithAlias(Expr e, QualifiedIdentifier q)
    | derivedTAttribute(str oname, Type ty, Expr e)
    | inferredDerivedTAttribute(str oname, Expr e)
    | viewTAttribute(str oname, SubViewDecl subViewDecl)
    | tattributeqname(QualifiedNameOrShortName qshortname)
    | blackList(list[str] qid)
;

data Purge = purge();

data JoinType
    = \join()
    |inner()
    | leftOuterJoin()
    | rightJoin()
    | rightOuterJoin()
    | fullJoin()
    | fullOuterJoin()
    | crossJoin()
    | semiJoin()
    | leftSemiJoin()
    ;

data JoinCondition
    = joinCondition(JoinType jt, NameOrVariableRef nam, list[Alias] a, list[OnCondition] cond)
    | viewJoinCondition(JoinType jt, SubViewDecl sub, MandatoryAlias m, Expr expr)
    ;

data OnCondition = onCondition(Expr e);

data JoinConditions = joinConditions(list[JoinCondition] conds);

data NameOrVariableRef
    = refName(str name, list[Path] paths)
    | tName(str name, list[Path] paths)
    ;

data Path = path(str name);


data PartitionClause = partitionClause(list[PartitionPart] entries);

data PartitionPart
    = partitionPart(str name, PartitionPartValue v)
    ;

data PartitionPartWithOptionalValue
    = partitionPartWithOptionalValue(str name, PartitionPartValue v)
    |  partitionPartWithOptionalValue2(str name)
    ;

data PartitionPartValue = partitionPartValue(Expr e);

data PartitionWithOptionValueClause
    = partitionWithOptionValueClause(list[PartitionPartWithOptionalValue] partitionPartWithOptlVal)
    ;

data PartitionClauseWithLocation
    = partitionClauseWithLocation(PartitionClause partCls, PLocation pLocation)
    ;

data PLocation = pLocation(str strLit);

