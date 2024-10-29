module lang::bigquery::prettyprint::DDL

import List;
extend lang::bigquery::prettyprint::Query;

public str toString(createSchema(list[IfNotExists] ifNotExistsOpt,  TableName tblName, list[DefaultCollate] defaultCollate,  list[SchemaOptions] schemeOpt))
        = "CREATE SCHEMA <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> <intercalate("",[toString(dclt)|dclt<-defaultCollate])> <intercalate("",[toString(so)|so<-schemeOpt])>";

public str toString(createView(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt, TableName tblName, list[ViewColumnList] viewColList, list[SchemaOptions] schemaOpt, QueryOrWith qryOrWith))
        = "CREATE <intercalate("",[toString(orplace)|orplace<-orReplaceOpt])> VIEW <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> <intercalate("",[toString(vcl)|vcl<-viewColList])> <intercalate("",[toString(scmo)|scmo<-schemaOpt])> AS <toString(qryOrWith)>";

public str toString(createMaterialized(
                list[OrReplace] orReplaceOpt
                , list[IfNotExists] ifNotExistsOpt
                , TableName tblName
                , list[PartitionBy] partitionByOpt 
                , list[ClusterBy] clusterByOpt
                , list[SchemaOptions] schemaOpt
                , QueryOrWith qryOrWith
        )) = "CREATE <intercalate("",[toString(orplace)|orplace<-orReplaceOpt])> MATERIALIZED VIEW <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> <intercalate("",[toString(pby)|pby<-partitionByOpt])> <intercalate("",[toString(clby)|clby<-clusterByOpt])> <intercalate("",[toString(scmo)|scmo<-schemaOpt])> AS <toString(qryOrWith)>";

public str toString(createFunction(
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
        )) = "CREATE <intercalate("",[toString(orplace)|orplace<-orReplaceOpt])> <intercalate("",[toString(tvo)|tvo<-tempVariantOpt])> FUNCTION <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> <toString(bracketNameType)> <intercalate("",[toString(bnt)|bnt<-bracketNameTypeOpt])> <intercalate("",[toString(rdo)|rdo<-returnDatatypeOpt])>
                <intercalate("",[toString(rwc)|rwc<-remoteWithConnectionOpt])> <intercalate("",[toString(asbe)|asbe<-asBracketExpOpt])> <intercalate("",[toString(scmo)|scmo<-schemaOpt])>";

public str toString(createJsFunction(
                list[OrReplace] orReplaceOpt
                ,list[TemporaryTable] tempVariantOpt
                , list[IfNotExists] ifNotExistsOpt
                , TableName tblName
                , BracketNameType bracketNameType
                , ReturnDatatype returnDatatype
                , list[DeterminismSpecifier] determinismSpecOpts
                , list[SchemaOptions] schemaOpts
                , Expr expr
        )) = "CREATE <intercalate("",[toString(orplace)|orplace<-orReplaceOpt])> <intercalate("",[toString(tvo)|tvo<-tempVariantOpt])> FUNCTION <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> <toString(bracketNameType)> <toString(returnDatatype)> <intercalate("",[toString(dso)|dso<-determinismSpecOpts])> LANGUAGE js <intercalate("",[toString(scmo)|scmo<-schemaOpts])> AS <toString(expr)>";

public str toString(createTableFunction(
                list[OrReplace] orReplaceOpt
                , list[IfNotExists] ifNotExistsOpt
                , TableName tblName
                , list[FunctionParameter] funcParamOpt
                , list[ReturnTableType] returnTableTypeOpt
                , list[SchemaOptions] schemaOpts
                , list[QueryOrWith] qryOrWithOpt
        )) = "CREATE <intercalate("",[toString(orplace)|orplace<-orReplaceOpt])> TABLE FUNCTION <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> (<intercalate(",",[toString(fp)|fp<-funcParamOpt])>) <intercalate("",[toString(retTb)|retTb<-returnTableTypeOpt])> <intercalate("",[toString(scmo)|scmo<-schemaOpts])>"+ (size(qryOrWithOpt)>0 ? "AS <intercalate("",[toString(qow)|qow<-qryOrWithOpt])>" : "");

public str toString(defaultCollate(Expr exp)) = "DEFAULT COLLATE <toString(exp)>";

public str toString(schemaOptions(list[TablenameEqExpr] tablenameExp)) = "OPTIONS(<intercalate(",", [toString(name) | name <- tablenameExp])>)";

public str toString(tablenameExpr(TableName tablename, Expr exp)) = "<toString(tablename)> = <toString(exp)>";

public str toString(orReplace()) = "OR REPLACE";

public str toString(createCapacity(TableName tblName, SchemaOptions schemasOpt))
                = "CREATE CAPACITY <toString(tblName)> <toString(schemasOpt)>";

public str toString(createReservation(TableName tblName, SchemaOptions schemasOpt))
                = "CREATE RESERVATION <toString(tblName)> <toString(schemasOpt)>";

public str toString(createAssignment(TableName tblName, SchemaOptions schemasOpt))
                = "CREATE ASSIGNMENT <toString(tblName)> <toString(schemasOpt)>";

public str toString(createSearchIndex(list[IfNotExists] ifNotExistsOpt, TableName tblName1, TableName tblName2, ColumnType colType, list[SchemaOptions] schemaOpts))
                = "CREATE SEARCH INDEX <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName1)> ON <toString(tblName2)>(<toString(colType)>) <intercalate("",[toString(scmo)|scmo<-schemaOpts])>";

public str toString(createTableBQ(list[OrReplace] orReplaceOpt, list[TemporaryTable] tempVariantOpt, list[IfNotExists] ifNotExistsOpt, TableName tblName, list[TableVariants] tableVariantsOpt, 
                        list[ListColumnOrConstraint] listColOrConstraintsOpt, list[DefaultCollate] defaultCollateOpt, list[PartitionBy] partitionByOpt, list[ClusterBy] clusterByOpt
                        , list[SchemaOptions] schemaOpts, list[CreateTableQuery] createTblQryOpt))
                = "CREATE <intercalate("",[toString(orplace)|orplace<-orReplaceOpt])> <intercalate("",[toString(tvo)|tvo<-tempVariantOpt])> TABLE <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> <intercalate("",[toString(tv)|tv<-tableVariantsOpt])>
                        <intercalate("",[toString(lcoc)|lcoc<-listColOrConstraintsOpt])> <intercalate("",[toString(dco)|dco<-defaultCollateOpt])> <intercalate("",[toString(pby)|pby<-partitionByOpt])> <intercalate("",[toString(clby)|clby<-clusterByOpt])> <intercalate("",[toString(scmo)|scmo<-schemaOpts])> <intercalate("",[toString(ctq)|ctq<-createTblQryOpt])>";

public str toString(createExtern(
                        list[OrReplace] orReplaceOpt
                        , ExternalTable externalTblKeyword
                        , list[IfNotExists] ifNotExistsOpt
                        , TableName tblName
                        , list[ListColumnOrConstraint] listColOrConstraintsOpt
                        , list[WithConnection] withConnectionOpt
                        , list[WithPartitionColumns] withPartitionColumnsOpt
                        , list[SchemaOptions] schemaOpts
                )) = "CREATE <intercalate("",[toString(orplace)|orplace<-orReplaceOpt])> <toString(externalTblKeyword)> TABLE <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> <intercalate("",[toString(lcoc)|lcoc<-listColOrConstraintsOpt])> <intercalate("",[toString(wco)|wco<-withConnectionOpt])> <intercalate("",[toString(wpc)|wpc<-withPartitionColumnsOpt])> <intercalate("",[toString(scmo)|scmo<-schemaOpts])>";
    
public str toString(createSnapshot(list[IfNotExists] ifNotExistsOpt, TableName tblName, TableName cloneTblName, list[FromTimestamp] fromTimestamp, list[SchemaOptions] schemaOpts))
                = "CREATE SNAPSHOT TABLE <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(tblName)> CLONE <toString(cloneTblName)> <intercalate("",[toString(fts)|fts<-fromTimestamp])> <intercalate("",[toString(scmo)|scmo<-schemaOpts])>";

public str toString(alterTable(AlterTable alterTbl)) = "<toString(alterTbl)>";

public str toString(renameTable(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2)) = "ALTER TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName1)> RENAME TO <toString(tblName2)>";

public str toString(addColumns(TableName tblName, list[AddColumn] addColumns)) = "ALTER TABLE <toString(tblName)> <intercalate(",",[toString(ac)|ac<-addColumns])>";

public str toString(renameColumns(list[IfExists] ifExistsOpt, TableName tblName, list[RenameColumn] renameColumns)) = "ALTER TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)> <intercalate(",",[toString(rnc)|rnc<-renameColumns])>";

public str toString(setSchemaOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt)) = "ALTER TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)> SET <toString(schemasOpt)>";

public str toString(columnDropDefault(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2)) = "ALTER TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt1])> <toString(tblName1)> ALTER COLUMN <intercalate("",[toString(ife)|ife<-ifExistsOpt2])> <toString(tblName2)> DROP DEFAULT";

public str toString(setDefault(TableName tblName, Expr expr)) = "ALTER TABLE <toString(tblName)> SET DEFAULT COLLATE <toString(expr)>";

public str toString(columnSetDefault(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, Expr expr)) = "ALTER TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt1])> <toString(tblName1)> ALTER COLUMN <intercalate("",[toString(ife)|ife<-ifExistsOpt2])> <toString(tblName2)> SET DEFAULT <toString(expr)>";

public str toString(columnSetDataType(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, DataType dataType)) = "ALTER TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt1])> <toString(tblName1)> ALTER COLUMN <intercalate("",[toString(ife)|ife<-ifExistsOpt2])> <toString(tblName2)> SET DATA TYPE <toString(dataType)>";

public str toString(dropPrimaryKey( TableName tblName, list[IfExists] ifExistsOpt)) = "ALTER TABLE <toString(tblName)> DROP PRIMARY KEY <intercalate("",[toString(ife)|ife<-ifExistsOpt])>";

public str toString(addKeys(TableName tblName, list[AddConstraintDef] addConstrDefList)) = "ALTER TABLE <toString(tblName)> <intercalate(",",[toString(acd)|acd<-addConstrDefList])>";

public str toString(dropConstraints(TableName tblName, list[DropConstraint] dropList)) = "ALTER TABLE <toString(tblName)> <intercalate(",",[toString(dl)|dl<-dropList])>";

public str toString(tableColumnSet(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, SchemaOptions schemasOpt)) = "ALTER TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt1])> <toString(tblName1)> ALTER COLUMN <intercalate("",[toString(ife)|ife<-ifExistsOpt2])> <toString(tblName2)> SET <toString(schemasOpt)>";


public str toString(addColumn(list[IfNotExists] ifNotExistsOpt, Column col))
        = "ADD COLUMN <intercalate("",[toString(ine)|ine<-ifNotExistsOpt])> <toString(col)>";

public str toString(renameColumn(list[IfExists] ifExistsOpt, Identifier id1, Identifier id2))
        = "RENAME COLUMN <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(id1)> TO <toString(id2)>";

public str toString(dropConstraint(list[IfExists] ifExistsOpt, TableName tblName))
        = "DROP CONSTRAINT <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)>";

public str toString(addConstraintDef(ConstraintDefinition constraintDef))
        = "ADD <toString(constraintDef)>";

public str toString(colName(list[Identifier] id)) = "<intercalate(",",[toString(i)|i<-id])>";

public str toString(allCols()) = "ALL COLUMNS";

public str toString(tempTable()) = "TEMP";

public str toString(functionParameter(TableName tblName, DataType dataType) ) = "<toString(tblName)> <toString(dataType)>";

public str toString(anyType(TableName tblName)) = "<toString(tblName)> ANY TYPE";

public str toString(returnTableType(list[NameType] nameType)) = "RETURNS TABLE \< <intercalate(",",[toString(nt)|nt<-nameType])> \>";

public str toString(partitionBy(Expr expr)) = "PARTITION BY <toString(expr)>";

public str toString(clusterBy(list[Expr] exprList)) = "CLUSTER BY <intercalate(",",[toString(expl)|expl<-exprList])>";

public str toString(bracketNameType(list[NameType] nameTypeList)) = "(<intercalate(",",[toString(ntl)|ntl<-nameTypeList])>)";

public str toString(nameType(TableName tblName, DataType dataType)) = "<toString(tblName)> <toString(dataType)>";

public str toString(returnDatatype(DataType dataType)) = "RETURNS <toString(dataType)>";

public str toString(remoteWithConnection(WithConnection withConnection)) = "REMOTE <toString(withConnection)>";

public str toString(withConnection(TableName tblName)) = "WITH CONNECTION <toString(tblName)>";

public str toString(asBracketExp(Expr expr)) = "AS (<toString(expr)>)";

public str toString(alterSchemaSetDefault(list[IfExists] ifExistsOpt, TableName tblName, Expr expr))
        = "ALTER SCHEMA <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)> SET DEFAULT COLLATE <toString(expr)>";

public str toString(alterSchemaSetOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt))
        = "ALTER SCHEMA <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)> SET <toString(schemasOpt)>";

public str toString(alterSchemaAddReplica(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2, list[SchemaOptions] schemaOpts))
        = "ALTER SCHEMA <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName1)> ADD REPLICA <toString(tblName2)> <intercalate("",[toString(scmo)|scmo<-schemaOpts])>";
    
public str toString(alterSchemaDropReplica(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2,  list[SchemaOptions] schemaOpts))
        = "ALTER SCHEMA <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName1)> DROP REPLICA <toString(tblName2)> <intercalate("",[toString(scmo)|scmo<-schemaOpts])>";
   
public str toString(alterViewSetOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt))
        = "ALTER VIEW <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)> SET <toString(schemasOpt)>";
    
public str toString(alterVaterializedViewSetOptions(list[IfExists] ifExistsOpt, TableName tblName, SchemaOptions schemasOpt))
        = "ALTER MATERIALIZED VIEW <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)> SET <toString(schemasOpt)>";
    
public str toString(alterSetorganization(SchemaOptions schemasOpt)) = "ALTER ORGANIZATION SET <toString(schemasOpt)>";
    
public str toString(alterSetProject(TableName tblName, SchemaOptions schemasOpt)) = "ALTER PROJECT <toString(tblName)> SET <toString(schemasOpt)>";
    
public str toString(alterSetBiCapacity(TableName tblName, SchemaOptions schemasOpt)) = "ALTER BI_CAPACITY <toString(tblName)> SET <toString(schemasOpt)>";
    
public str toString(alterSetCapacity(TableName tblName, SchemaOptions schemasOpt)) = "ALTER CAPACITY <toString(tblName)> SET <toString(schemasOpt)>";
    
public str toString(alterSetReservation(TableName tblName, SchemaOptions schemasOpt)) = "ALTER RESERVATION <toString(tblName)> SET <toString(schemasOpt)>";
    
public str toString(alterViewColumnSet(list[IfExists] ifExistsOpt1, TableName tblName1, list[IfExists] ifExistsOpt2, TableName tblName2, SchemaOptions schemasOpt)) 
        = "ALTER VIEW <intercalate("",[toString(ife)|ife<-ifExistsOpt1])> <toString(tblName1)> ALTER COLUMN <intercalate("",[toString(ife)|ife<-ifExistsOpt2])> <toString(tblName2)> SET <toString(schemasOpt)>";

public str toString(dropMaterializedView(list[IfExists] ifExistsOpt, TableName tblName)) = "DROP MATERIALIZED VIEW <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)>";
    
public str toString(dropFunction(list[IfExists] ifExistsOpt, TableName tblName)) = "DROP FUNCTION <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)>";

public str toString(dropTableFunction(list[IfExists] ifExistsOpt, TableName tblName)) = "DROP TABLE FUNCTION <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)>";

public str toString(dropExternalTable(list[IfExists] ifExistsOpt, TableName tblName)) = "DROP EXTERNAL TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)>";

public str toString(dropSearchIndex(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2)) = "DROP SEARCH INDEX <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName1)> ON <toString(tblName2)>";
    
public str toString(dropRowAccessPolicy(list[IfExists] ifExistsOpt, TableName tblName1, TableName tblName2)) = "DROP ROW ACCESS POLICY <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName1)> ON <toString(tblName2)>";
    
public str toString(dropSnapshot(list[IfExists] ifExistsOpt, TableName tblName)) = "DROP SNAPSHOT TABLE <intercalate("",[toString(ife)|ife<-ifExistsOpt])> <toString(tblName)>";

public str toString(viewColumn(ExpList expList)) = "(<toString(expList)>)";

public str toString(colcons(list[ColumnOrConstraint] colcons)) = "(<intercalate(",",[toString(clc)|clc<-colcons])>)";

public str toString(col(Column colm)) = "<toString(colm)>";

public str toString(constraint(ConstraintDefinition constraint)) = "<toString(constraint)>";

public str toString(withPartitionColumns(list[BracketNameType] bracketNameTypeOpt))
        = "WITH PARTITION COLUMNS <intercalate("",[toString(bnt)|bnt<-bracketNameTypeOpt])>";

public str toString(deterministic()) = "DETERMINISTIC";

public str toString(nonDeterministic()) = "NOT DETERMINISTIC";

public str toString(priKey(PrimaryKey priKey)) = "<toString(priKey)>";

public str toString(constraintFkey(list[ConstraintId] idOpt, list[ForeignKey] foreignKeyList)) = "<intercalate(",",[toString(io)|io<-idOpt])> <intercalate(",",[toString(fkl)|fkl<-foreignKeyList])>";

public str toString(constraintId(Identifier id)) = "CONSTRAINT <toString(id)>";

public str toString(column(Identifier id, ColumnSchema columnSchema)) = "<toString(id)> <toString(columnSchema)>";

public str toString(columnSchema(ReqSchema reqSchema,list[Enforced] enforcedOpt, list[Default] defaultOpt, list[NotNull] notNullOpt, list[SchemaOptions] schemaOpts))
        = "<toString(reqSchema)> <intercalate("",[toString(efo)|efo<-enforcedOpt])> <intercalate("",[toString(dfo)|dfo<-defaultOpt])> <intercalate("",[toString(nno)|nno<-notNullOpt])> <intercalate("",[toString(sco)|sco<-schemaOpts])>";

public str toString(typeSchema(SimpleType simpletype)) = "<toString(simpletype)>";

public str toString(structSchema(list[FieldList] fieldList)) = "STRUCT\<<intercalate(",",[toString(fl)|fl<-fieldList])>\>";

public str toString(arraySchema(ArraySchema arrayschema)) = "ARRAY\<<toString(arrayschema)>\>";

public str toString(enforced()) = "PRIMARY KEY NOT ENFORCED";

public str toString(enforcedRef(TableName tblName, Identifier id)) = "REFERENCES <toString(tblName)> (<toString(id)>) NOT ENFORCED";

public str toString(\default(Expr expr)) = "DEFAULT <toString(expr)>";

public str toString(simpleDataType(DataType simpldtype)) = "<toString(simpldtype)>";

public str toString(stringCollate(Expr expr)) = "STRING COLLATE <toString(expr)>";

public str toString(fieldList(Identifier id, ReqSchema reqSchema, list[Enforced] enforcedOpt, list[Default] defaultOpt, list[NotNull] notNullOpt, list[SchemaOptions] schemaOpts))
        = "<toString(id)> <toString(reqSchema)> <intercalate("",[toString(efo)|efo<-enforcedOpt])> <intercalate("",[toString(dfo)|dfo<-defaultOpt])> <intercalate("",[toString(nno)|nno<-notNullOpt])> <intercalate("",[toString(sco)|sco<-schemaOpts])>";

public str toString(primaryKey(list[Identifier] ids)) = "PRIMARY KEY (<intercalate(",",[toString(i)|i<-ids])>) NOT ENFORCED";

public str toString(foreignKey(list[Identifier] ids, ForeignReference foreignref)) = "FOREIGN KEY (<intercalate(",",[toString(i)|i<-ids])>) <toString(foreignref)>";

public str toString(foreignRef(Identifier id, list[Identifier] ids)) = "REFERENCES <toString(id)> (<intercalate(",",[toString(i)|i<-ids])>) NOT ENFORCED";

public str toString(simpleArraySchema(SimpleType simpletype, list[NotNull] notnull)) = "<toString(simpletype)> <intercalate("",[toString(nn)|nn<-notnull])>";

public str toString(structArraySchema(FieldList field, list[NotNull] notnull)) = "STRUCT \<<toString(field)>\> <intercalate("",[toString(nn)|nn<-notnull])>";

public str toString(notnull()) = "NOT NULL";

public str toString(tableLike(TableName tablename)) = "LIKE <toString(tablename)>";

public str toString(tableCopy(TableName tablename)) = "COPY <toString(tablename)>";

public str toString(tableClone(TableName tablename)) = "CLONE <toString(tablename)>";
