module lang::basesql::ast::BaseSQL

extend lang::exprlang::ast::Expressions;


data StatementWithTerminator = statementWithTerminator(Statement stmt, list[Terminator] terminator);

data Terminator = terminator();

data StarOrExpr = aggExpr(Expr expr) | star();


// expression
data Expr 
  = propRef(list[Identifier] identifier)
  | illegalNull() 
  | \true() | \false()
  | mapLit(list[MapEntry] mapEnt)
  | date(str  strConst)
  | time(str  strConst)
  | timeStamp(str  strConst)
  | cast(Expr expr, DataType datatype)
  | like(Expr expr1, Expr expr2)
  | notlike(Expr expr1, Expr expr2)
  | between(Expr expr1, Expr exprCVE1, Expr exprCVE2)
  | isNull(Expr expr)
  | isNotNull(Expr expr)
  | not(Expr expr)
  | and(Expr expr1, Expr expr2)
  | or(Expr expr1, Expr expr2)
  | simpleCase(Expr expr, list[WhenClause] whenCls, list[ElseClause] elseClsOpt)
  | searchedCase(list[WhenClause] whenCls, list[ElseClause] elseCls)
  | interval(str strConst, Duration duration)
  | scalarSubquery(Subquery subquery)
  | exists(Subquery subquery)
  | inSubquery(Expr expr, list[Not] not, Subquery subquery)
  ;

data NamedStructEntry = namedStructEntry(str quotedId, Expr expr);

data ExpAsVarOrStar
  = projectionExpAsVar(ExpAsVar expAsVar)
  | tableNameDotStar(TableName tblName)
  | projectionStar()
  ;

data ExpAsVar 
  = expAsVar(Expr expr, list[VarAssign] varAssign)
  | namedStructExp(list[NamedStructEntry] namedStructEntry, list[VarAssign] varAssign)
  ;


data Boolean = \true() | \false();

data Duration = year() | month() | day() | hour() | minute() | second();

data Not = not();

data WhenClause = whenClause(Expr expr1, Expr expr2);

data ElseClause = elseClause(Expr expr);



data MapEntry = mapEntry(Expr expr1, Expr expr2);




  
data WindowSpecification 
  = windowSpecification(
        list[PartitionByClause] partitionByCls
        , list[OrderByClause] orderByCls
        , list[WindowFrameClause] windowFrameCls
    )
  | namedWindow(Identifier identifier)
  ;

data PartitionByClause = partitionByClause(list[Expr] expr);

data RowsOrRange = rows() | range();


data WindowFrameClause 
  = windowFrameClause(RowsOrRange rowOrRange , FrameStartOrBetween frameStartOrBetween)
  ;

data FrameStartOrBetween
  = frameStart(FrameStart frmStart)
  | frameBetween(FrameBetween frmBetween)
  ; 

data FrameBetween
  = frameBetweenUnboundedPreceding(UnboundedPreceding unboundedFollowing, FrameEndA frameEndA)
  | frameBetweenNumericPreceding(NumericPreceding numericPreceding, FrameEndA frameEndA)
  | frameBetweenCurrentRow(CurrentRow currentRow, FrameEndB frameEndB)
  | frameBetweenNumericFollowing(NumericFollowing numericFollowing, FrameEndC frameEndC)
  ;

data FrameStart
  = frameStartUnboundedPreceding(UnboundedPreceding unboundedPreceding)
  | frameStartNumericPreceding(NumericPreceding numericPreceding)
  | frameStartCurrentRow(CurrentRow currentRow)
  ;


data FrameEndA
  = frameEndANumericPreceding(NumericPreceding numericPreceding)
  | frameEndACurrentRow(CurrentRow currentRow)
  | frameEndANumericFollowing(NumericFollowing numericFollowing)
  | frameEndAUnboundedFollowing(UnboundedFollowing unboundedFollowing)
  ;

data FrameEndB
  = frameEndBCurrentRow(CurrentRow currentRow)
  | frameEndBNumericFollowing(NumericFollowing numericFollowing)
  | frameEndBUnboundedFollowing(UnboundedFollowing unboundedFollowing)
  ; 


data FrameEndC
  = frameEndCNumericFollowing(NumericFollowing numericFollowing)
  | frameEndCUnboundedFollowing(UnboundedFollowing unboundedFollowing)
  ; 


data UnboundedPreceding = unboundedPreceding(); 

data NumericPreceding = numericPreceding(str \int);

data UnboundedFollowing = unboundedFollowing();

data NumericFollowing = numericFollowing(str \int);

data CurrentRow = currentRow();

data WindowClause 
  = windowClause(
        Identifier identifier
        , list[PartitionByClause] partitionByCls
        , list[OrderByClause] orderByCls
        , list[WindowFrameClause] windowFrameCls
    )
  ;


// Data types
data DataType
  = primitiveType(PrimitiveType primType) 
  | arrayType(DataType datatype) 
  | mapType(PrimitiveType primType, DataType datatype) 
  | structType(list[StructTypeFieldSpec] structTypefieldSpeclist) 
  | unionType(list[DataType] datatypelist)
  ;


data PrimitiveType
  = intType()
  | smallIntType()
  | bigIntType()
  | tinyIntType()
  | booleanType()
  | floatType()
  | doubleType()
  | doubleWithPrecisionType()
  | stringType()
  | binaryType()
  | timestampType()
  | decimalType(list[TwoParameterSpec] twoParamSpec)
  | dateType()
  | varCharType(list[SingleParameterSpec] singleParamSpec)
  | charType(list[SingleParameterSpec] singleParamSpec)
  |intervalType()
  ;


data TwoParameterSpec = twoParameterSpec(str num1, str num2);


data SingleParameterSpec = singleParameterSpec(str num1);

data StructTypeFieldSpec = structTypefieldSpec(Identifier identifier, DataType datatype);

data Distinct = aggregateDistinct();

// Names
data VarAssign = varAssign(list[VarAssignAs] varAssignAs, Identifier identifier);

data VarAssignAs = as();

data Identifier
  = varReference(str varRef)
  | regularIdentifier(str regularId)
  | quotedIdentifier(str quotedId)
  ;


data TableName = name(list[SchemaNameDot] schemaNameDotOpt, TableNameId tblNameId);

data SchemaNameDot = schemaName(TableNameId tblNameId);


data TableNameId = tabId(Identifier id);


data Url
  = url(list[SchemePart] schemePt, list[DirectoryPart] directoryPt, FileNamePart filePt)
  | urlVarReference(str regularId)
  ;

data SchemePart
  = schemePart(Scheme schm)
  | noScheme()
  ;

data Scheme = hdfs();

data DirectoryPart = directoryPart(list[Identifier] identifierOpt);

data FileNamePart = fileNamePart(Identifier identifier1, Identifier identifier2);


// Statement
data Statement 
  = use(Identifier identifier)
  | addFile(Url url)
  | with(WithClause withCls, list[CTEClause] cteCls, CTEAction cteActn)
  | statementQuery(QueryExpr qryexpr)
  | insertOverwriteDirectory(
        list[Local] lcl
        , DirectoryPath directoryPath
        , list[RowFormatClause] rowFormatCls
        , list[StoredAs] storedAs
        , QueryExpr qryexpr
    )
  | truncateTable(list[Table] tbl, TableName tblName, list[PartitionClause] partitionCls)
  | insertWithQuery(InsertWithQuery insertWithQry)
  | createView(list[IfNotExists] ifNotExists, TableName tblName, QueryOrWith qryOrWith)
  | dropView(list[IfExists] ifExists, TableName tblName)
  | createTable(CreateTable createTbl)
  | dropTable(list[IfExists] ifExists, TableName tblName, list[Purge] purge)
  | alterTable(AlterTable alterTbl)
  | msckRepair(list[Repair] repair, TableName tblName
        , list[MsckRepairActionClause] msckRepairActionClause)
  | analyzeTable(
        TableName tblName
        , list[PartitionClause] partitionCls
        , list[ForColumns] forCol
        , list[CacheMetadata] cacheMetaData
        , list[NoScan] noScan
    )
  ;




// QueryExpr
data QueryExpr
  = queryUnion(QueryExpr qryexpr1,Union union, QueryExpr qryExpr2)
  | queryIntersect(QueryExpr qryExpr1,Intersect intersect, QueryExpr qryExpr2)
  ;



// Query
data Query
  = query(
        SelectClause selectCls
        , list[FromClause] fromCls
        , list[JoinClause] joinCls
        , list[WhereClause] whereCls
        , list[GroupByClause] groupCls 
        , list[HavingClause] havingCls
        , list[WindowClause] windowCls
        , list[OrderByClause] orderByCls 
        , list[LimitOffsetClauses] limitOffsetCls
        , list[QueryClusterByClause] queryClusterByCls
    )
  ;

data Union = union(list[SetQuantifier] setQuantifier);

data Intersect = intersect();

data Local = local();

data DirectoryPath
  = referenceOnly(str regularId)
  | directoryReference(str reqularId, Identifier identifier)
  | directoryPath(list[Identifier] identifierList)
  ;

data SetQuantifier
  = \all()
  | distinct()
  ;

data SelectClause
  = selectClause(list[SetQuantifier] setQuantifier, Projection proj)
  ;

data Projection = expAsVars(list[ExpAsVarOrStar] expAsVarOrStar);

data RecordReaderClause = recordReaderClause(str strConst);

data FromClause = fromClause(list[TableIdOrSubquery] tblIdOrSubquery);

data TableIdOrSubquery
  = tableId(TableName tblName, list[Identifier] identifierOpt)
  | tableIdOrSubquerySubquery(QueryExpr qryexpr, Identifier identifier)
  ;



data JoinClause
  = innerJoinClause(
        list[Inner] innerOpt
        , TableIdOrSubquery tblIdOrSubquery
        , list[JoinCondition] joinConditionOpt
        , list[JoinClause] joinClsOpt
    )
  | outerJoinClause(
        OuterType outerType
        , list[Outer] outerOpt
        , TableIdOrSubquery tblIdOrSubquery
        , JoinCondition joinCondition
        , list[JoinClause] joinClsOpt
    )
  | leftSemiJoinClause(
        LeftSemiJoin leftSemiJoin
        , TableIdOrSubquery tblIdOrSubquery
        , JoinCondition joinCondition
        , list[JoinClause] joinClsOpt
    )
  | crossJoinClause(
        CrossJoin crossjoin
        , TableIdOrSubquery tblIdOrSubquery
        , list[JoinCondition] joinConditionOpt
        , list[JoinClause] joinClsOpt
  )
  ;


data Inner = inner();

data Outer = outer();

data JoinCondition = joinCondition(Expr expr);

data OuterType = left() | right() | full();

data LeftSemiJoin = leftSemiJoin();

data CrossJoin = crossJoin();

data WhereClause = whereClause(Expr expr);

data QueryClusterByClause = insertWithClusterByClause(list[Identifier] identifierOpt);

data WithClause = withClause();

data CTEClause = cteClause(Identifier identifier, QueryExpr qryexpr);

data CTEAction
  = selectAction(QueryExpr qryexpr)
  | fromAction(TableName tblName, SelectClause selectCls)
  | cteActionInsertWithSelect(
        TableName tblName1
        , OverWriteOrInto overwriteOrInto
        , TableName tblName2
        , list[PartitionWithOptionValueClause] partitionWithOptValClsOpt
        , SelectClause selectCls
    )
  | cteActionInsertWithQuery(
        OverWriteOrInto overwriteOrInto
        , TableName tblName
        , list[PartitionWithOptionValueClause] partitionWithOptValClsOpt
        , list[ColumnSpecificationForInsert] colSpecForInsertOpt
        , QueryExpr qryexpr
    )
  ;
 
 data OverWriteOrInto
  = overWriteOrIntoOverwrite(list[Table] tblOpt)
  | overWriteOrIntoInto(list[Table] tblOpt)
  ; 

data ColumnSpecificationForInsert = columnSpecificationForInsert(list[Identifier] identifier);

data InsertWithQuery
  = overwrite( 
        list[Table] tbl
        , TableName tblName
        , list[PartitionWithOptionValueClause] partitionWithOptValCls 
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpecificationForInsert
  		, QueryExpr qryexpr
    )
  | into(
        list[Table] tbl
        , TableName tblName
        , list[PartitionWithOptionValueClause] partitionWithOptValCls
  	    , list[ColumnSpecificationForInsert] columnSpecificationForInsert
  	    , QueryExpr qryexpr
    )  
  ;

// TODO: missing ADT for Expr and QueryExpr

data Subquery = subquery(QueryExpr qryexpr);


// SolutionModifiers
data GroupByClause = groupByClause(list[ExpAsVar] expAsVar);

data HavingClause = havingClause(Expr expr);

data OrderByClause = orderByClause(list[OrderElem] orderElem);

data OrderElem = orderExpr(Expr expr) | asc(Expr expr) | desc(Expr expr);

data LimitOffsetClauses
  = limitOffsetClauses(LimitClause limitCls, list[OffsetClause] offsetCls)
  | offsetLimitClauses(OffsetClause offsetCls1, list[LimitClause] offsetCls2)
  ;

data LimitClause = limitClause(Expr expr);

data OffsetClause = offsetClause(Expr expr);



// DDL
data TablePropertiesClause = tablePropertiesClause(list[TableProperty]  tblProperty);

data CreateTable
  = withColumns(
        list[TemporaryTable] temporaryTable
        , list[ExternalTable] externalTable
        , list[IfNotExists] ifNotExists 
        , TableName tblName
        , list[Columns] columns
        , list[Comment] comment
        , list[PartitionedByClause] partitionByCls
        , list[ClusteredByClause] clusteredByCls
        , list[RowFormatClause] rowFormatCls
        , list[StorageClause] storageCls 
        , list[LocationClause] locationCls
        , list[TablePropertiesClause] tblPropertiesCls
    )
  | withQuery(
        list[TemporaryTable] temporaryTbl 
        , list[ExternalTable] externalTbl
        , list[IfNotExists] ifNotExists 
        , TableName tblName
        , list[RowFormatClause] rowFormatCls 
        , list[StorageClause] storageCls
        , CreateTableQuery createTblQry
    )
  | withLike(
        list[TemporaryTable] temporaryTbl
        , list[ExternalTable] externalTbl
        , list[IfNotExists] ifNotExists  
        , TableName tbl1
        , Like like
        , TableName tbl2
        , list[TablePropertiesClause] tblPropertiesCls
    )
  ;

data Like = like();

data CreateTableQuery = createTableQuery(QueryOrWith qryOrWith);

data QueryOrWith
  = queryOrWithQuery(QueryExpr qryexpr)
  | queryOrWithWith(WithClause withCls, list[CTEClause] cteCls,  QueryExpr qryexpr)
  ;

data Purge = purge();

data TemporaryTable = temporaryTable();

data ExternalTable = externalTable();

data Columns = columns(list[ColumnSpecification] colSpecificationList);

data PartitionedByClause = partitionedByClause(Columns columns);

data ClusteredByClause 
  = clusteredByClause(list[Identifier] identifier, list[SortedByClause] sortedByCls, str \int);

data SortedByElem = sortByElem(Identifier identifier, list[SortedByDirection] sortedByDirection);

data SortedByDirection = asc() | desc(); 

data SortedByClause = sortBy(list[SortedByElem] sortByElem);

data LocationClause = locationClause(str strConst);

data AlterTable
  = renameTable(TableName tbl1, TableName tbl2)
  | addPartition(TableName tbl, list[IfNotExists] ifNotExistsOpt, list[PartitionClauseWithLocation] partitionClsWithLocation)
  | renamePartition(TableName tbl, PartitionClause partitionCls1, PartitionClause partitionCls2)
  | dropPartition(TableName tbl, list[IfExists] ifExistsOpt, list[PartitionClause] partitionCls
    , list[IgnoreProtection] ignoreProtectionOpt, list[Purge] purgeOpt)
  ;

data PartitionClauseWithLocation = partitionClauseWithLocation(PartitionClause partitionCls, list[LocationClause] locationCls);

data IgnoreProtection = ignoreProtection();

data Repair = repair();

data MsckRepairActionClause = msckRepairActionClause(RepairPartitionAction repairPartitionAction);

data RepairPartitionAction
  = repairPartitionAddAction()
  | repairPartitionDropAction()
  | repairPartitionsyncAction()
  ;

data ForColumns = forColumns();

data CacheMetadata = cacheMetadata();

data NoScan = noScan();


// Common
data IfNotExists = ifNotExists();

data IfExists = ifExists();

data PartitionClause = partitionClause(list[PartitionPart] partitionPart);

data PartitionPart = partitionPart(Identifier identifier, PartitionPartValue partitionPartVal);

data PartitionPartValue = partitionPartValue(Expr expr);

data PartitionPartWithOptionalValue = partitionPartWithOptionalValue(Identifier identifier, list[PartitionPartValue] partitionPartVal);

data PartitionWithOptionValueClause 
  = partitionWithOptionValueClause(list[PartitionPartWithOptionalValue] partitionPartWithOptVal);

data Table = table();

data TableProperty = tableProperty(str strConst1, str strConst2);

data PackageName = packageName(str regularId);

data ColumnSpecification = columnSpecification(Identifier identifier, DataType datatype, list[Comment] comment);

data Comment = comment(str strConst);

data RowFormatClause = rowFormat(RowFormatType rowFormatType);

data RowFormatType 
  = delimited(
        list[FieldsTerminatedBy] fieldsTerminatedBy
        , list[CollectionItemsTerminatedBy] collectionItemsTerminatedBy
        , list[MapKeysTerminatedBy] mapKeysTerminatedBy 
        , list[LinesTerminatedBy] linesTerminatedByOpt 
        , list[NullDefinedAs] nullDefinedAs
    )
  | serde(str strConst, list[SerdePropertiesClause] serdePropertiesCls)
  ;

data FieldsTerminatedBy = fieldsTerminatedBy(str strConst, list[EscapedBy] escapedBy);


data EscapedBy = escapedBy();

data CollectionItemsTerminatedBy = collectionItemsTerminatedBy(str strConst);

data MapKeysTerminatedBy = mapKeysTerminatedBy(str strConst);


data LinesTerminatedBy = linesTerminatedBy(str strConst);

data NullDefinedAs = nullDefinedAs(str strConst);


data SerdePropertiesClause = serdePropertiesClause(list[TableProperty] tblProperty);


data StorageClause
  = storageClauseStoredAs(StoredAs storedAs)
  | storageClauseStoredBy(str strConst, list[SerdePropertiesClause] serdePropertiesCls)
  ;

data StoredAs = storedAs(StoredAsType storedAsType);

data StoredAsType 
  = sequenceFile() 
  | textFile() 
  | rcFile() 
  | orc() 
  | parquet()
  | avro() 
  | jsonFile()
  | custom(str strConst1, str strConst2)
  ;