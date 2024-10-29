module lang::bigquery::ast::DDL

extend lang::bigquery::ast::Query;

// DDL 
data Statement
    = createSchema(list[IfNotExists] ifNotExistsOpt,  TableName tblName, list[DefaultCollate] defaultCollate,  list[SchemaOptions] schemeOpt)
    | createView(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt, TableName tblName, list[ViewColumnList] viewColList, list[SchemaOptions] schemaOpt, QueryOrWith qryOrWith)
    | createMaterialized(
        list[OrReplace] orReplaceOpt
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , list[PartitionBy] partitionByOpt 
        , list[ClusterBy] clusterByOpt
        , list[SchemaOptions] schemaOpt
        , QueryOrWith qryOrWith
        )
    | createFunction(
        list[OrReplace] orReplaceOpt
        , list[TemporaryTable] tempVariantOpt
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , BracketNameType bracketNameType
        , list[BracketNameType] bracketNameTypeOpt
        , list[ReturnDatatype] returnDatatypeOpt
        , list[RemoteWithConnection] remoteWithConnectionOpt
        , list[AsBracketExp] asBracketExpOpt
        , list[SchemaOptions] schemaOpt
        )
    | createJsFunction(
        list[OrReplace] orReplaceOpt
        ,list[TemporaryTable] tempVariantOpt
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , BracketNameType bracketNameType
        , ReturnDatatype returnDatatype
        , list[DeterminismSpecifier] determinismSpecOpts
        , list[SchemaOptions] schemaOpts
        , Expr expr
        )
    | createTableFunction(
        list[OrReplace] orReplaceOpt
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , list[FunctionParameter] funcParamOpt
        , list[ReturnTableType] returnTableTypeOpt
        , list[SchemaOptions] schemaOpts
        , list[QueryOrWith] qryOrWithOpt
        )
    | createCapacity(TableName tblName, SchemaOptions schemasOpt)
    | createReservation(TableName tblName, SchemaOptions schemasOpt)
    | createAssignment(TableName tblName, SchemaOptions schemasOpt)
    | createSearchIndex(list[IfNotExists] ifNotExistsOpt, TableName tblName1, TableName tblName2, ColumnType colType, list[SchemaOptions] schemaOpts)
    | createTableBQ(
        list[OrReplace] orReplaceOpt
        , list[TemporaryTable] tempVariantOpt
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , list[TableVariants] tableVariantsOpt
        , list[ListColumnOrConstraint] listColOrConstraintsOpt
        , list[DefaultCollate] defaultCollateOpt
        , list[PartitionBy] partitionByOpt
        , list[ClusterBy] clusterByOpt
        , list[SchemaOptions] schemaOpts
        , list[CreateTableQuery] createTblQryOpt
        )
    | createExtern(
        list[OrReplace] orReplaceOpt
        , ExternalTable externalTblKeyword
        , list[IfNotExists] ifNotExistsOpt
        , TableName tblName
        , list[ListColumnOrConstraint] listColOrConstraintsOpt
        , list[WithConnection] withConnectionOpt
        , list[WithPartitionColumns] withPartitionColumnsOpt
        , list[SchemaOptions] schemaOpts
        )
    | createSnapshot(list[IfNotExists] ifNotExistsOpt, TableName tblName, TableName cloneTblName, list[FromTimestamp] fromTimestamp, list[SchemaOptions] schemaOpts)
    | alterTable(AlterTable alterTbl)
    ;


data ViewColumnList = viewColumn(ExpList expList);
data ListColumnOrConstraint = colcons(list[ColumnOrConstraint] colcons);
data ColumnOrConstraint = col(Column col) | constraint(ConstraintDefinition constraint);
data WithPartitionColumns = withPartitionColumns(list[BracketNameType] bracketNameTypeOpt);
data DeterminismSpecifier = deterministic() | nonDeterministic();


data ConstraintDefinition
    = priKey(PrimaryKey priKey)
    | constraintFkey(list[ConstraintId] idOpt, list[ForeignKey] foreignKeyList)
    ;

data ConstraintId = constraintId(Identifier id);
data Column = column(Identifier id, ColumnSchema columnSchema);

data ColumnSchema 
    = columnSchema(
        ReqSchema reqSchema
        , list[Enforced] enforcedOpt
        , list[Default] defaultOpt
        , list[NotNull] notNullOpt
        , list[SchemaOptions] schemaOpts
        );

data ReqSchema 
    = typeSchema(SimpleType simpletype)
    | structSchema(list[FieldList] fieldList)
    | arraySchema(ArraySchema arrayschema)
    ; 

data Enforced = enforced()| enforcedRef(TableName tblName, Identifier id);


data Default = \default(Expr expr);

data SimpleType
    = simpleDataType(DataType simpleDataType)
    | stringCollate(Expr expr)
    ;

data FieldList 
    = fieldList(
        Identifier id
        , ReqSchema reqSchema
        , list[Enforced] enforcedOpt
        , list[Default] defaultOpt
        , list[NotNull] notNullOpt
        , list[SchemaOptions] schemaOpts
    );


data PrimaryKey = primaryKey(list[Identifier]);
data ForeignKey = foreignKey(list[Identifier], ForeignReference);
data ForeignReference = foreignRef(Identifier, list[Identifier]);

data ArraySchema 
    = simpleArraySchema(SimpleType simpletype, list[NotNull] notnull)
    | structArraySchema(FieldList field, list[NotNull] notnull)
    ;

data NotNull = notnull();

data TableVariants
    = tableLike(TableName tablename)
    | tableCopy(TableName tablename)
    | tableClone(TableName tablename)
    ;



data ColumnType = colName(list[Identifier]) | allCols();
data TemporaryTable = tempTable();
data FunctionParameter = functionParameter(TableName tblName, DataType dataType) | anyType(TableName tblName);
data ReturnTableType = returnTableType(list[NameType] nameType);
data PartitionBy = partitionBy(Expr expr);
data ClusterBy = clusterBy(list[Expr] exprList);
data DefaultCollate = defaultCollate(Expr e);
data SchemaOptions = schemaOptions(list[TablenameEqExpr] keywordParamList);
data TablenameEqExpr = tablenameExpr(TableName tblName, Expr expr);
data OrReplace = orReplace();
data BracketNameType = bracketNameType(list[NameType] nameTypeList);
data NameType = nameType(TableName tblName, DataType dataType);
data ReturnDatatype = returnDatatype(DataType dataType);
data RemoteWithConnection = remoteWithConnection(WithConnection withConnection);
data WithConnection = withConnection(TableName tblName);
data AsBracketExp = asBracketExp(Expr expr);



data AlterTable
    = renameTable(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2)
    | addColumns(TableName tblName, list[AddColumn] addColumns)
    | renameColumns(list[IfExists] ifExistsOpt, TableName tblName, list[RenameColumn] renameColumns)
    | setSchemaOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt)
    | columnDropDefault(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2)
    | setDefault(TableName tblName, Expr expr)
    | columnSetDefault(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, Expr expr)
    | columnSetDataType(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, DataType dataType)
    | dropPrimaryKey( TableName tblName, list[IfExists] ifExistsOpt)
    | addKeys(TableName tblName, list[AddConstraintDef] addConstrDefList)
    | dropConstraints(TableName tblName, list[DropConstraint] dropList)
    | tableColumnSet(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, SchemaOptions schemasOpt)
    ;


data AddColumn = addColumn(list[IfNotExists] ifNotExistsOpt, Column col);
data RenameColumn = renameColumn(list[IfExists] ifExistsOpt, Identifier id1, Identifier id2);


data DropConstraint = dropConstraint(list[IfExists] ifExistsOpt, TableName tblName);
data AddConstraintDef = addConstraintDef(ConstraintDefinition constraintDef);


data Statement 
    = alterSchemaSetDefault(list[IfExists] ifExistsOpt, TableName tblName, Expr expr)
    | alterSchemaSetOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt)
    | alterSchemaAddReplica(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2, list[SchemaOptions] schemaOpts)
    | alterSchemaDropReplica(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2,  list[SchemaOptions] schemaOpts)
    | alterViewSetOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt)
    | alterVaterializedViewSetOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt)
    | alterSetorganization(SchemaOptions schemasOpt)
    | alterSetProject(TableName tblName, SchemaOptions schemasOpt)
    | alterSetBiCapacity(TableName tblName, SchemaOptions schemasOpt)
    | alterSetCapacity(TableName tblName, SchemaOptions schemasOpt)
    | alterSetReservation(TableName tblName, SchemaOptions schemasOpt)
    | alterViewColumnSet(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, SchemaOptions schemasOpt)
    ;


data Statement
    = dropMaterializedView(list[IfExists] ifExistsOpt, TableName tblName)
    | dropFunction(list[IfExists] ifExistsOpt, TableName tblName)
    | dropTableFunction(list[IfExists] ifExistsOpt, TableName tblName)
    | dropExternalTable(list[IfExists] ifExistsOpt, TableName tblName)
    | dropSearchIndex(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2)
    | dropRowAccessPolicy(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2)
    | dropSnapshot(list[IfExists] ifExistsOpt, TableName tblName)
    ;

