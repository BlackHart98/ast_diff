module lang::athena::ast::Athena


extend lang::basesql::ast::BaseSQL;


data QueryExpr =queryAthena(Query qry);

// DDL
data Statement 
    = createViewWithReplace(
        OrReplaceOrTemporary orReplaceOrTemporary
        , list[IfNotExists] ifNotExists
        , TableName viewId
        , QueryOrWith queryOrWith
        )
    | createDb(
        DatabaseOrSchema dbOrSchema
        , list[IfNotExists] ifNotExOpt
        , Identifier id
        , list[CommentLiteral] commentListOpt
        , list[LocationClause] locationOpt
        , list[WithDB] WithDBOpt
        )
    | dropDb(DatabaseOrSchema, list[IfExists] ifExOpt, Identifier id, list[RestrictOrCascade] restrictOrCascade)
    | describeStatement(Describe desc)
    | msck(Identifier id)
    | alterdb(AlterSelectors alterSelectors, Identifier identifier, SetStatement setStatement)
    ;


data WithExpr = withExpr(list[PropValue] propValue);

data WithNoData = withNoData(No noKeyword);

data CreateTable = createTableAsWithExp(Identifier id, WithExpr withExp, QueryOrWith qryOrWith, list[WithNoData] withNODataOpt);


data PropValue = formatPropValue(Expr lit)
                 | partPropValue(list[Expr] litList)
                 | propValue(Identifier id, Expr lit)
                 | stringPropValue(str e1, Expr e2)
                 ;


data No = no();

data SetStatement
    = setProperty(list[PropertyType] propertyTypeOpt, lrel[str str1, str str2] propassignments)
    | setLocation(str location)
    | noValue(list[Output] outputOpt)
    | setStatementSpark(str expandedIdentifier, SetValue setValue)
    ;

data Output = v();
 
data PropertyType = dbprop() | prop();

data SetValue = unquotedSetValue(str unquotedSetValue);

data AlterSelectors
    = schema()
    | db()
    | namespace()
    ;

data WithDB 
    = withId(lrel[Identifier id, Expr e] params) 
    | withString(lrel[str id, Expr e] paramsWithStr)
    ;

data DatabaseOrSchema = database()| schemaKeyword()| databases() | schemasKeyword();

data RestrictOrCascade
    = restrict()
    | cascade()
    ;

data Athena 
    = expression(Expr expr)
    | statements(list[StatementWithTerminator] statementWithTerminatorList)
    | simpleStatement(Statement statement)
    ;


data AlterTable 
    = addPartitionNoComma(TableName tblName, list[IfNotExists] ifNotExOpt, PartitionClauseWithLocation partClsWithLoc, list[PartitionClauseWithLocation] partClsWithLocs)
    | setTableProperties (TableName tblName, list[PropValue] properties)
    | addColumn(TableName tableName , list[PartitionClause] partitionClauseOpt, lrel[Identifier identifier,list[DataType] datatypeOpt] cols)
    | renameColumn(TableName tableName, Identifier id1, Identifier id2)
    | replaceColumn(TableName tableName,list[PartitionClause] partitionClauseOpt,lrel[Identifier id ,DataType datatype] columns, list[CommentLiteral] commentLiteralOpt)
    | dropColumn(TableName tableName,ColumnKeyword columnKeyword,list[Identifier] identifierList)
    | unsetTableProperties(TableName tableName,list[str] keys)
    | setSerdeProp(TableName tableName, list[PartitionClause] partitionClauseOpt, list[PropValue] tblprops)
    | setSerdePropWith(TableName tableName, list[PartitionClause] partitionClauseOpt, str idStr, list[SerdePropertiesClause] serdePropertiesClauseOpt)
    | setFileFormat(TableName tableName, list[PartitionClause] partitionClauseOpt, StoredAsType storedAsType)
    | setLocation(TableName tableName, list[PartitionClause] partitionClauseOpt , str CharSeq)
    | recover(TableName tableName)
    ;


data OrReplaceOrTemporary 
    = orReplace()
    | temporary(TemporaryTable temporaryTable)
    | replaceTemporary(TemporaryTable temporaryTable)
    ;

data ColumnKeyword = col() | cols();



// Expression
data Expr 
    = function(FunctionCall funcCall)
    | questionMark()
    ;

data FunctionCall = udf(list[PackageName] pkgNameOpt, str funcName, list[Expr] exprList);

data Expr = inPredicate(Expr expr, list[Not] not, ArrayLiteral arrayLiteral);

data ArrayLiteral = array(list[Expr] expr);

data CommentLiteral = comment(str strConst);


// Auxiliary
data Describe 
    = describe(list[ExtendedOrFormatted] extFmtd, TableName tblName, list[PartitionClause] partCls, list[Identifier] descIdOpt)
    | showColumns(ColumnKeyword colKeyword, FromOrIn formOrIn, list[FromOrIn] formOrInOpt)
    | showCreateTable(TableName tid, list[VarAssignAs] assign)
    | showDatabases(DatabaseOrSchema dos, list[Expr] exp)
    | showPartitions(TableName tid, list[PartitionClause] pclOpt)
    | showTables(list[FromOrIn] fromorIn,list[Expr] exps)
    | showTableProperties(TableName tid, list[UnquotedOrString] uqosOpt)
    | showViews(list[FromOrIn] fromorIn, list[Expr] exps)
    | uncache(list[IfExists] ifex, TableName tid)
    | showTableExtended(list[FromOrIn] fromorIn, Expr expr, list[PartitionClause] pclOpt)
    | showCreateView(list[FromOrIn] fromorIn, list[Expr] expOpt)
    ;

data UnquotedOrString = unquote(str unquotedChar);

data FromOrIn 
    = from(list[Identifier] ids)
    | \in(list[Identifier] ids)
    ;



data ExtendedOrFormatted = extended() | formatted();


// Names
data TableNameId = dqId(str doubleQ);


// DML
data InsertWithQuery
    = intoWithValue(
        list[Table] tableOpt
        , TableName tableName
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpec
  	    , Value vl
        )
    | overwriteWithValue(
        list[Table] tableOpt
        , TableName tableName
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpec
  	    , Value vl
        )
    | intoWithValueFromTable(
        TableName tableName1
        , Table table
        , TableName tableName2
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpec
  	    , Value vl
        )
    | overwriteWithValueFromTable(
        TableName tableName1
        , Table table
        , TableName tableName2
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpec
  	    , Value vl
        )

    ;



data Value 
    = valuesas(ValuesBuilder valBuilder, list[VarAssign] varAssignOpt)
    ; 

data ValuesBuilder = valuesBuilder(list[ValueSet] valueset);


data ValueSet = valset(list[Expr] expr);


data Statement 
    = deleteStatement(TableName tblName, list[WhereClause] whereClsOpt)
    | update(TableName tblName, list[SetOptions] setOpts, list[WhereClause] whereClsOpt)
    ;


data SetOptions = setOptions(Identifier id, Expr expr);



data TableOrSelect = tableMerge(TableName tblName) 
                   | queryMerge(QueryOrWith qryMerge)
                   ;

data WhenClauses = whenClauses(list[WhenMatchClause] whenMatchCls, list[WhenNotMatchClause] whenNotMatchCls);

data WhenMatchClause = whenMatchedAndClause(Expr exp, UpdateDelete upDel)
                     | whenMatchedThenClause(UpdateDelete upDel)
                     ;

data WhenNotMatchClause 
    = whenNotMatchedAndClause(Expr andExp, list[ColumnSpecificationForInsert] colList, list[Expr] exps)
    | whenNotMatchedClause(list[ColumnSpecificationForInsert] colList, list[Expr] exps);

data Statement = mergeInto(
                  Identifier id
                  , list[VarAssign] asAlis
                  , TableOrSelect tabOrSelect
                  , list[VarAssign] aliasAs 
                  , Expr mergeBool 
                  , WhenClauses whenCls);


data UpdateDelete = updateDelete(list[SetOptions] opts)
                  | deleteUpdateDelete()
                  ;



data Statement = optimizeStatement(TableName tblName, list[WhereClause] whereCls);


data Statement 
    = explainStmt(list[ExplainOptions] explainOpts, Statement stmt)
    | explainAnalyze(list[ExplainAnalyzeFormat] explainAnlyFmt, Statement stmt)
    ;




data ExplainAnalyzeFormat 
    = formatText()
    | formatJson()
    ;


data ExplainOption 
    = explainFormat(ExplainOptionFormat explainOptFmt)
    | explainType(ExplainOptionType explainOptType)
    ;

data ExplainOptions = explainOptions(list[ExplainOption] explainOptList); 

data ExplainOptionType = logical()
                         | distributed()
                         | validate()
                         | io()
                         ;

data ExplainOptionFormat = fmtText()
                           | fmtGraphviz(Graphviz graphviz)
                           | fmtJson()
                           ;


data Statement = unload(QueryOrWith slt, str strConst, WithExpr lst);

data Graphviz = graphviz();


data SelectClause = selectOnly();


data Statement = prepare(Identifier id, Statement stmt);

data Statement = execute(Identifier id, list[UsingClause] usingClsOpt);

data UsingClause = usingClause(list[Expr] usingLits);

data Statement = deallocate(Identifier stmt_name);