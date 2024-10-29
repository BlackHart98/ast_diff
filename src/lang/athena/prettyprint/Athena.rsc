module lang::athena::prettyprint::Athena


extend lang::athena::ast::Athena;
extend lang::basesql::prettyprint::BaseSQL;
import List;
import String;

public str toString(Athena::expression(Expr expr)) = "<toString(expr)>";
public str toString(Athena::simpleStatement(Statement stmt)) = "<toString(stmt)>";

public str toString(Athena::statements(list[StatementWithTerminator] stmts))
    = "<for (stmt <- stmts) {><trim(toString(stmt))>\n
        '<}>";

// Expression
public str toString(TableNameId::dqId(str doubleQ)) = "<doubleQ>"; 
public str toString(Expr::function(FunctionCall fCall)) = "<toString(fCall)>"; 
public str toString(FunctionCall::udf(list[PackageName] pkgName, str funcName, list[Expr] expr)) 
    = trim("<prettyOptional(pkgName, toString)> <funcName>(<intercalate(", ", [toString(exp) | exp <- expr])>)");

public str toString(CommentLiteral::comment(str strConst)) = "COMMENT <strConst>";

// Names
public str toString(Expr::questionMark()) = "?"; 


// DDL
public str toString(QueryExpr::queryAthena(Query qryExpr)) {
    return "<toString(qryExpr)>";
}

public str toString(
    Statement::createViewWithReplace(
        OrReplaceOrTemporary orReplaceOrTemporary
        , list[IfNotExists] ifNotExistsOpt
        , TableName viewId
        , QueryOrWith queryOrWith
    )
) = "CREATE <toString(orReplaceOrTemporary)>" + prettyOptional(ifNotExistsOpt, toString) + " VIEW <toString(viewId)>" +"\n"
    + "\t" + "AS <toString(queryOrWith)>"
    ;

public str toString(createTableAsWithExp(Identifier id, WithExpr withExpr, QueryOrWith qryOrWith, list[WithNoData] withNoDataOpt)) 
    = "CREATE TABLE <toString(id)>\n"
    + toString(withExpr)
    + "AS\n" + toString(qryOrWith) + "\n"
    + prettyOptional(withNoDataOpt, toString)
    ;

public str toString(
    Statement::createDb(
        DatabaseOrSchema dbOrSchema
        , list[IfNotExists] ifNotExOpt
        , Identifier id
        , list[CommentLiteral] commentLitOpt
        , list[LocationClause] locationOpt
        , list[WithDB] withDBOpt
        )
) = "CREATE <toString(dbOrSchema)>" + prettyOptional(ifNotExOpt, toString) + " <toString(id)>" + "\n"
    + prettyOptional(commentLitOpt, toString) + "\n"
    + prettyOptional(locationOpt, toString) + "\n"
    + prettyOptional(withDBOpt, toString)
    ;

public str toString(
    Statement::dropDb(
        DatabaseOrSchema databaseOrSchema
        , list[IfExists] ifExOpt
        , Identifier id
        , list[RestrictOrCascade] restrictOrCascade
    )
) = "DROP <toString(databaseOrSchema)>" + prettyOptional(ifExOpt, toString) + " <toString(id)>" + " <prettyOptional(restrictOrCascade, toString)>";


public str toString(Statement::msck(Identifier id)) = "MSCK REPAIR TABLE <toString(id)>";
public str toString(
    Statement::alterdb(AlterSelectors alterSelectors, Identifier identifier, SetStatement setStatement)
) = "ALTER <toString(alterSelectors)> <toString(identifier)> <toString(setStatement)>";

public str toString(AlterSelectors::schema()) = "SCHEMA";
public str toString(AlterSelectors::db()) = "DATABASE";
public str toString(AlterSelectors::namespace()) = "NAMESPACE";

public str toString(SetStatement::setProperty(list[PropertyType] propertyTypeOpt, lrel[str str1, str str2] propassignments)) 
    = "SET " + prettyOptional(propertyTypeOpt, toString) + "(" 
    + "<intercalate(", ", ["<p.str1> = <p.str2>" | p <- propassignments])>" + "\n"
    + ")";

public str toString(SetStatement::setLocation(str location)) 
    = "SET LOCATION <location>";

public str toString(PropertyType::dbprop()) = "DBPROPERTIES";
public str toString(PropertyType::prop()) = "PROPERTIES";

public str toString(OrReplaceOrTemporary::orReplace()) = "OR REPLACE";
public str toString(OrReplaceOrTemporary::temporary(TemporaryTable temp)) = "<toString(temp)>";
public str toString(OrReplaceOrTemporary::replaceTemporary(TemporaryTable temp)) = "OR REPLACE <toString(temp)>";


public str toString(DatabaseOrSchema::database()) = "DATABASE";
public str toString(DatabaseOrSchema::schemaKeyword()) = "SCHEMA";
public str toString(DatabaseOrSchema::databases()) = "DATABASES";
public str toString(DatabaseOrSchema::schemasKeyword()) = "SCHEMAS";


public str toString(WithDB::withId(lrel[Identifier id, Expr expr] params)) 
    = "WITH DBPROPERTIES(" + "\n"
    + "<intercalate(", ", ["<toString(p.id)> = <toString(p.expr)>" | p <- params])>" + "\n"
    + ")"; 

public str toString(WithDB::withString(lrel[str idStr, Expr expr] params)) 
    = "WITH DBPROPERTIES(" + "\n"
    + "<intercalate(", ", ["<p.idStr> = <toString(p.expr)>" | p <- params])>" + "\n"
    + ")";


public str toString(
    AlterTable::addPartitionNoComma(TableName tblName, list[IfNotExists] ifNotExOpt, PartitionClauseWithLocation partClsWithLoc, list[PartitionClauseWithLocation] partClsWithLocs)
) = "ALTER TABLE <toString(tblName)> ADD " + prettyOptional(ifNotExOpt, toString) + " <toString(partClsWithLoc)>"
    + "<intercalate("\n\t", ["<toString(p)>" | p <- partClsWithLocs])>";

public str toString(Athena::setTableProperties (TableName tblName, list[PropValue] properties))
    = "ALTER TABLE <toString(tblName)> SET TBLPROPERTIES " 
    + "(" 
    + "<intercalate(", ", ["<toString(p)>" | p <- properties])>"
    + ")";

public str toString(AlterTable::addColumn(
    TableName tblName
    , list[PartitionClause] partitionClauseOpt
    , lrel[Identifier identifier,list[DataType] datatypeOpt] cols)
) = "ALTER TABLE <toString(tblName)> " + prettyOptional(partitionClauseOpt,  toString) + " ADD COLUMNS"
    + "(" 
    + "<intercalate(", ", ["<toString(c.identifier)> <prettyOptional(c.datatypeOpt, toString)>" | c <- cols])>"
    + ")";

public str toString(AlterTable::renameColumn(TableName tblName, Identifier id1, Identifier id2))
    = "ALTER TABLE <toString(tblName)> RENAME COLUMNS <toString(id1)> TO <toString(id2)>";

public str toString(
    AlterTable::replaceColumn(
        TableName tblName
        , list[PartitionClause] partitionClauseOpt
        , lrel[Identifier id, DataType datatype] columns
        , list[CommentLiteral] commentLiteralOpt)
    )
    = "ALTER TABLE <toString(tblName)> " + prettyOptional(partitionClauseOpt,  toString) + " REPLACE COLUMNS"
    + "(" 
    + "<intercalate(", ", ["<toString(c.id)> <toString(c.datatype)>" | c <- columns])>"
    + prettyOptional(commentLiteralOpt, toString)
    + ")"
    ;

public str toString(
    AlterTable::dropColumn(TableName tblName,ColumnKeyword columnKeyword,list[Identifier] identifierList)
) = "ALTER TABLE <toString(tblName)> <toString(columnKeyword)> " + "(<intercalate(", ", ["<toString(c)>" | c <- identifierList])>)";

public str toString(AlterTable::unsetTableProperties(TableName tblName,list[str] keys))
    = "ALTER TABLE <toString(tblName)> UNSET TBLPROPERTIES " + "(<intercalate(", ", ["<c>" | c <- keys])>)";

public str toString(AlterTable::setSerdeProp(TableName tblName, list[PartitionClause] partitionClauseOpt, list[PropValue] tblprops))
    = "ALTER TABLE <toString(tblName)> " + prettyOptional(partitionClauseOpt, toString)
    + " SET SERDEPROPERTIES " + "<intercalate(", ", ["<toString(p)>" | p <- tblprops])>";


public str toString(
    AlterTable::setSerdePropWith(TableName tblName, list[PartitionClause] partitionClauseOpt, str idStr, list[SerdePropertiesClause] serdePropertiesClauseOpt)
    ) = "ALTER TABLE <toString(tblName)> " + prettyOptional(partitionClauseOpt, toString) + " SET SERDE <idStr>"
    + " <prettyOptional(serdePropertiesClauseOpt, toString)>";


public str toString(AlterTable::setFileFormat(TableName tblName, list[PartitionClause] partitionClauseOpt , StoredAsType storedAsType)) 
    = "ALTER TABLE <toString(tblName)> " + prettyOptional(partitionClauseOpt, toString)+ " SET FILEFORMAT "  + " <toString(storedAsType)>";

public str toString(AlterTable::setLocation(TableName tblName, list[PartitionClause] partitionClauseOpt , str CharSeq)) 
    = "ALTER TABLE <toString(tblName)> " + prettyOptional(partitionClauseOpt, toString) + " SET LOCATION <CharSeq>";


public str toString(RestrictOrCascade::restrict()) = "RESTRICT";
public str toString(RestrictOrCascade::cascade()) = "CASCADE";


public str toString(ColumnKeyword::col()) = "COLUMN";
public str toString(ColumnKeyword::cols()) = "COLUMNS";

public str toString(No::no()) = "NO";



public str toString(PropValue::formatPropValue(Expr lit)) = "FORMAT = <toString(lit)>";
public str toString(PropValue::partPropValue(list[Expr] litList)) = "PARTITIONED_BY = ARRAY[<intercalate(", ", ["<toString(p)>" | p <- litList])>]";
public str toString(PropValue::propValue(Identifier id, Expr lit)) = "<toString(id)> = <toString(lit)>";
public str toString(PropValue::stringPropValue(str e1, Expr e2)) = "<e1> = <toString(e2)>";

public str toString(WithExpr::withExpr(list[PropValue] propValue)) = "WITH (<intercalate(", ", ["<toString(p)>" | p <- propValue])>)";

// DML
public str toString(UnquotedOrString::unquote(str unquotedCharSeq)) = "<unquotedCharSeq>";

public str toString(
    InsertWithQuery::intoWithValue(
        list[Table] tableOpt
        , TableName tblName
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpecOpt
  	    , Value vl
        )
    ) = "INSERT INTO " + prettyOptional(tableOpt, toString) + " <toString(tblName)>" + " <prettyOptional(partitionOptCls,  toString)>"
    + " <prettyOptional(ifNotExists, toString)>" + " <prettyOptional(columnSpecOpt,  toString)>" + "\n"
    + toString(vl)
    ;


public str toString(
    InsertWithQuery::overwriteWithValue(
        list[Table] tableOpt
        , TableName tblName
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpecOpt
  	    , Value vl
        )
    ) = "INSERT INTO " + prettyOptional(tableOpt, toString) + " <toString(tblName)>" + " <prettyOptional(partitionOptCls,  toString)>"
    + " <prettyOptional(ifNotExists,  toString)>" + " <prettyOptional(columnSpecOpt,  toString)>" + "\n"
    + toString(vl);


public str toString(
    InsertWithQuery::intoWithValueFromTable(
        TableName tblName1
        , Table table
        , TableName tblName2
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpecOpt
  	    , Value vl
        )
    ) = "INSERT INTO <toString(tblName1)> " + toString(table) + " <toString(tblName2)>"  + " <prettyOptional(partitionOptCls,  toString)>"
    + " <prettyOptional(ifNotExists,  toString)>" + " <prettyOptional(columnSpecOpt,  toString)>" + "\n"
    + toString(vl);


public str toString(
    InsertWithQuery::overwriteWithValueFromTable(
        TableName tblName1
        , Table table
        , TableName tblName2
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpecOpt
  	    , Value vl
        )
    ) = "INSERT INTO <toString(tblName1)> " + toString(table) + " <toString(tblName2)>"  + " <prettyOptional(partitionOptCls,  toString)>"
    + " <prettyOptional(ifNotExists,  toString)>" + " <prettyOptional(columnSpecOpt,  toString)>" + "\n"
    + toString(vl);



public str toString(Value::valuesas(ValuesBuilder valBuilder, list[VarAssign] varAssignOpt)) 
    = "<toString(valBuilder)> " + prettyOptional(varAssignOpt, toString);

public str toString(ValuesBuilder::valuesBuilder(list[ValueSet] valueset)) = "VALUES <intercalate(", ", ["<toString(c)>" | c <- valueset])>";
public str toString(ValueSet::valset(list[Expr] expr))= "(" + intercalate(", ", ["<toString(c)>" | c <- expr]) + ")";


public str toString(Statement::deleteStatement(TableName tblName, list[WhereClause] whereClsOpt)) 
    = "DELETE FROM <toString(tblName)> " + prettyOptional(whereClsOpt, toString);

public str toString(
    update(TableName tblName, list[SetOptions] setOpts, list[WhereClause] whereClsOpt)
    ) = "UPDATE <toString(tblName)> SET " + intercalate(", ", [toString(s)|s <- setOpts]) + prettyOptional(whereClsOpt, toString);


public str toString(SetOptions::setOptions(Identifier id, Expr expr)) = "<toString(id)> = <toString(expr)>";



public str toString(
    Statement::mergeInto(
        Identifier id
        , list[VarAssign] varAssignOpt1
        , TableOrSelect tabOrSelect
        , list[VarAssign] varAssignOpt2 
        , Expr mergeBool 
        , WhenClauses whenCls)
    ) = "MERGE INTO <toString(id)> " + prettyOptional(varAssignOpt1, toString) +"\n" 
    + "USING <toString(tabOrSelect)> " + prettyOptional(varAssignOpt2, toString) + "\n"
    + "ON <toString(mergeBool)>"
    + toString(whenCls)
    ;

public str toString(TableOrSelect::tableMerge(TableName tblName)) = toString(tblName);
public str toString(TableOrSelect::queryMerge(QueryOrWith qryOrWith)) = toString(qryOrWith);
public str toString(
    WhenClauses::whenClauses(list[WhenMatchClause] whenMatchCls, list[WhenNotMatchClause] whenNotMatchCls)
    ) = intercalate("\n", [toString(whn) | whn <- whenMatchCls]) + "\n"
    + prettyOptional(whenNotMatchCls, toString);


public str toString(
    WhenMatchClause::whenMatchedAndClause(Expr expr, UpdateDelete upDel)
    ) = "WHEN MATCHED AND <toString(expr)> THEN <toString(upDel)>";

public str toString(
    WhenMatchClause::whenMatchedThenClause(UpdateDelete upDel)
    ) = "WHEN MATCHED THEN <toString(upDel)>";

public str toString(
    WhenNotMatchClause::whenNotMatchedAndClause(
        Expr expr
        , list[ColumnSpecificationForInsert] colList
        , list[Expr] exprlist
        )
    ) = "WHEN MATCHED AND <toString(expr)> THEN INSERT " + prettyOptional(colList, toString) + "\n"
    + "VALUES(<intercalate(", ", [toString(e) | e <- exprlist])>)";

public str toString(
    WhenNotMatchClause::whenNotMatchedClause(
        list[ColumnSpecificationForInsert] colList
        , list[Expr] exprList
        )
    ) = "WHEN MATCHED THEN" + "\n"
    + "VALUES(<intercalate(", ", [toString(e) | e <- exprList])>)";


public str toString(UpdateDelete::updateDelete(list[SetOptions] setOptsList)) 
    = "UPDATE SET <intercalate(", ", [toString(s) | s <- setOptsList])>";

public str toString(UpdateDelete::deleteUpdateDelete()) = "DELETE";

public str toString(unload(QueryOrWith slt, str strConst, WithExpr lst)) 
    = "UNLOAD (<toString(slt)>) TO <strConst> <toString(lst)>";

// Auxiliary
public str toString(Statement::describeStatement(Describe desc)) = toString(desc);

public str toString(ExtendedOrFormatted::extended()) = "EXTENDED";
public str toString(ExtendedOrFormatted::formatted()) = "FORMATTED";


public str toString(
    Describe::describe(list[ExtendedOrFormatted] extFmtd, TableName tblName, list[PartitionClause] partCls, list[Identifier] descIdOpt)
    ) = "DESCRIBE " + prettyOptional(extFmtd, toString) + " <toString(tblName)> " + prettyOptional(partCls, toString)
    + " <prettyOptional(descIdOpt, toString)>";


public str toString(
    Describe::showColumns(ColumnKeyword colKeyword, FromOrIn fromOrIn, list[FromOrIn] fromOrInOpt)
    ) = "SHOW <toString(colKeyword)> <toString(fromOrIn)> " + prettyOptional(fromOrInOpt, toString);


public str toString(
    Describe::showCreateTable(TableName tblName, list[VarAssignAs] assign)
    ) = "SHOW CREATE TABLE <toString(tblName)> " + prettyOptional(assign, toString) + " <assign := []? "" : "SERDE">";


public str toString(
    Describe::showDatabases(DatabaseOrSchema databaseOrSchema, list[Expr] expr)
    ) = "SHOW <toString(databaseOrSchema)> " + "<expr := []? "" : "LIKE"> "+ prettyOptional(expr, toString) ;


public str toString(
    Describe::showPartitions(TableName tblName, list[PartitionClause] partitionClauseOpt)
    ) = "SHOW PARTITIONS <toString(tblName)> " + prettyOptional(partitionClauseOpt, toString);


public str toString(
    Describe::showTableExtended(list[FromOrIn] fromorIn, Expr expr, list[PartitionClause] pclOpt)
    ) = "SHOW TABLE EXTENDED " + prettyOptional(fromorIn, toString) + " <toString(expr)> " + prettyOptional(pclOpt, toString);


public str toString(
    Describe::showCreateView(list[FromOrIn] fromorIn, list[Expr] expr)
    ) = "SHOW CREATE VIEW <prettyOptional(fromorIn, toString)> "+ prettyOptional(expr, toString);


public str toString(
    Describe::showTableProperties(TableName tblName, list[UnquotedOrString] unquotedOrString)
    ) = "SHOW TBLPROPERTIES <toString(tblName)>"+ "<unquotedOrString := []? "":"(<prettyOptional(unquotedOrString, toString)>)">";


public str toString(
    Describe::showViews(list[FromOrIn] fromorInOpt, list[Expr] exps)
    ) = "SHOW VIEWS "+ prettyOptional(fromorInOpt, toString)+ "<exps := []? "":" LIKE <prettyOptional(exps, toString)>">";


public str toString(
    Describe::showTables(list[FromOrIn] fromorIn, list[Expr] exprOpt)
    ) = "SHOW TABLES "+ prettyOptional(fromorIn, toString)+ " <prettyOptional(exprOpt, toString)>";



public str toString(
    Statement::optimizeStatement(TableName tblName, list[WhereClause] whereClsOpt)
    ) = "OPTIMIZE <toString(tblName)> REWRITE DATA USING BIN_PACK" + prettyOptional(whereClsOpt, toString);

public str toString(explainStmt(list[ExplainOptions] explainOpts, Statement stmt)) 
    = "EXPLAIN " + prettyOptional(explainOpts, toString) + "\n"
    + toString(stmt);

public str toString(Statement::explainAnalyze(list[ExplainAnalyzeFormat] explainAnalyzeFormatOpt, Statement stmt)) 
    = "EXPLAIN ANALYZE " + prettyOptional(explainAnalyzeFormatOpt, toString) + "\n"
    + toString(stmt);


public str toString(SelectClause::selectOnly()) = "SELECT";

public str toString(ExplainAnalyzeFormat::formatText()) = "(FORMAT TEXT)";
public str toString(ExplainAnalyzeFormat::formatJson()) = "(FORMAT JSON)";


public str toString(ExplainOption::explainFormat(ExplainOptionFormat explainOptionFormat)) 
    = "(FORMAT <toString(explainOptionFormat)>)";

public str toString(ExplainOption::explainType(ExplainOptionType explainType)) 
    = "(TYPE <toString(explainType)>)";

public str toString(ExplainOptions::explainOptions(list[ExplainOption] explainOptionList)) 
    = intercalate(",", [toString(e)|e <- explainOptionList]);

public str toString(ExplainOptionType::logical()) = "LOGICAL";
public str toString(ExplainOptionType::distributed()) = "DISTRIBUTED";
public str toString(ExplainOptionType::validate()) = "VALIDATE";
public str toString(ExplainOptionType::io()) = "IO";

public str toString(ExplainOptionFormat::fmtText()) = "TEXT";
public str toString(ExplainOptionFormat::fmtGraphviz(Graphviz graphviz)) = toString(graphviz);
public str toString(ExplainOptionFormat::fmtJson()) = "JSON";

public str toString(Statement::prepare(Identifier id, Statement stmt)) = "PREPARE <toString(id)> FROM <toString(stmt)>";
public str toString(Statement::execute(Identifier id, list[UsingClause] usingClauseOpt)) 
    = "EXECUTE <toString(id)> " + prettyOptional(usingClauseOpt, toString);

public str toString(usingClause(list[Expr] usingLits)) = "USING <intercalate(", ", [toString(e) | e <- usingLits])>";
public str toString(Graphviz::graphviz()) = "GRAPHVIZ";
public str toString(Statement::deallocate(Identifier id)) = "DEALLOCATE PREPARE <toString(id)>";


public str toString(FromOrIn::from(list[Identifier] idList)) = "FROM <intercalate(".", [toString(e) | e <- idList])>";
public str toString(FromOrIn::\in(list[Identifier] idList)) = "IN <intercalate(".", [toString(e) | e <- idList])>";