module lang::spark::ast::Spark


extend lang::spark::ast::Expressions;


data Spark 
    = expression(Expr expr)
    | statements(list[StatementWithTerminator] statementWithTerminatorList)
    | simpleStatement(Statement statement)
    ;

data StatementWithTerminator = statementWithTerminator(Statement stmt, list[Terminator] terminator);

data Terminator = terminator();




// Statement
data Statement
    = alterview(AlterView alterView)
    | alterdb(AlterSelectors alterSelectors, Identifier identifier, SetStatement setStatement)
    | insertOverwriteDirectory(
        list[Local] localOpt
        , list[UsingClause] usingClauseOpt
        , list[StoredAs] storedAsOpt
        , Query query
        )
    | insertOverwriteDirectoryPath(
        list[Local] localOpt
        , DirectoryPath directoryPath
  		, UsingClause usingClause
  		, list[StoredAs] storedAsOpt,
  		Query query
        )
    | loadInto(list[Local] localOpt, str path, TableName tableName, list[PartitionClause] partitionClauseOpt)
    | loadOverwrite(list[Local] localOpt, str path, list[Expr] exprOpt, TableName tableName, list[PartitionClause] partitionClauseOpt)
    | createViewWithReplace(
        OrReplaceOrTemporary orReplaceOrTemporary
        , list[IfNotExists] ifNotExists
        , TableName viewId
        , list[CreateViewClause] createViewClauseList
        , QueryOrWith queryOrWith
        )
    | createDb(
        DatabaseOrSchema databaseOrSchema
        , list[IfNotExists] ifNotExistsOpt
        , Identifier identifier
        , list[CommentLiteral] commentLiteralOpt
        , list[LocationClause] location
        , list[WithDB] withDBOpt
        )
    | createFunction(
        list[OrReplaceOrTemporary] orReplaceOrTemporaryOpt
        , list[IfNotExists] ifNotExistsOpt
        , list[Identifier] identifierList
        , str string
        , list[ResourceLocation] resourceLocationOpt
        )
    | setStatement(SetStatement setStatement)
    | dropDb(DatabaseOrSchema databaseOrSchema,list[IfExists] ifExistsOpt,Identifier id, list[RestrictOrCascade] restrictOrCascade)
    | dropFunction(list[TemporaryOrGlobal] temporaryOrGlobalOpt,list[IfExists] ifExistsOpt,list[Identifier] idList)
    | dropView(list[IfExists] ifex,list[str] ids)
    | repair(TableName tableName, list[AddDropSync] addDropSync)
    | describeStatement(Describe desc)
    ;


data CreateTable = 
    fromSource(list[IfNotExists] ifNotExistsOpt, list[TableName] tableNameOpt
        , list[Columns] columnsOpt
        , UsingClause usingClause
        , list[PartitionedByClause] partitionedByClause
        , lrel[list[ClusteredByClause] clby,list[SortedByClause] sbcl, Expr lit] queryClusterByClauseOpt
        , list[LocationClause] locationClauseOpt
        , list[CommentLiteral] commentLiteralOpt
        , list[TablePropertiesClause] tblpOpt
        , list[AsSelect] asSelectOpt
        )
    ;


data ColumnSpecification = columnNoType(Expr expr);


data Describe
    = describeDb(Desc desc, list[Extended] extendedOpt, list[Identifier] identifier)
    | describeFunc(Desc desc, list[Extended] extendedOpt, list[Identifier] identifier)
    | describeQuery(Desc desc, list[DescribeStatement] describestmt)
    | describeTable(
        Desc desc
        , list[Table] tableOpt
        , list[Extended] extendedOpt
        , TableName tblName
        , list[PartitionClause] partClsOpt
        )
    | describeTableWithId(
        Desc desc
        , list[Table] tableOpt
        , list[Extended] extendedOpt
        , TableName tblName
        , PartitionClause partCls
        , list[Identifier] identifier
        )
    | listFile(File file, Url url)
    | listJar(Jar jar, Url url)
    | refresh(Url url)
    | refreshTable(list[Table] tableOpt, TableName tblName)
    | refreshFuntion(list[Identifier] ids)
    | reset(list[Identifier] identifier)
    | showColumns(ColumnKeyword colKeyword, FromOrIn formOrIn, list[FromOrIn] formOrInOpt)
    | showCreateTable(TableName tid, list[VarAssignAs] assign)
    | showDatabases(DatabaseOrSchema dos, list[Expr] exp)
    | showFunction(list[FunctionKind] fk,list[FromOrIn] formOrInOpt,list[Expr] exps)
    | showPartitions(TableName tid, list[PartitionClause] pclOpt)
    | showTables(list[FromOrIn] fromorIn,list[Expr] exps)
    | showTableProperties(TableName tid, UnquotedOrString uqos)
    | showViews(list[FromOrIn] fromorIn, list[Expr] exps)
    | uncache(list[IfExists] ifex, TableName tid)
    | showTableExtended(list[FromOrIn] fromorIn, Expr expr, list[PartitionClause] pclOpt)
    ;


data FromOrIn 
    = from(list[Identifier] ids)
    | \in(list[Identifier] ids)
    ;


data Lazy = lazy();

data File 
    = files()
    ;

data Jar
    = jars()
    ;

data Url 
    = url(lrel[list[SchemePart] schemePt, DirectoryPart directoryPt, list[FileNamePart] filePt] urlprts)
    | stringlit(list[str] regularIdOpt)
    ;


data Desc 
    = desc()
    | describe()
    ;





data FunctionKind 
    = user()
    | system()
    | \all()
    ;


data Extended = extended();


data DescribeStatement = qow(QueryOrWith qow)| fromClause(FromClause fcl) | vas(Value va);


data UnquotedOrString = unquote(str unquotedChar);



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
    | intoFromTable(
        TableName tableName1
        , Table table
        , TableName tableName
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpec
  	    , list[Query] qryOpt
        )
    | overwriteFromTable(
        TableName tableName1
        , Table table
        , TableName tableName
        , list[PartitionWithOptionValueClause] partitionOptCls
        , list[IfNotExists] ifNotExists
        , list[ColumnSpecificationForInsert] columnSpec
  	    , list[Query] qryOpt
        )
    | intoWithReplace(
        list[Table] tableOpt
        , list[TableName] tableNameOpt
        , list[Columns] cols
        , Expr expr
  	    , QueryOrWith qryorwith
        )
    ;



data Value 
    = valuesas(ValuesBuilder valBuilder, list[VarAssign] varAssign)
    ; 

data ValuesBuilder = valuesBuilder(list[ValueSet] valueset);


data ValueSet = valset(list[Expr] expr);



data AddDropSync
    = add()
    | drop()
    | sync()
    ;


data AsSelect
    = withAs(QueryOrWith queryOrWith)
    | cte(QueryOrWith queryOrWith)
    ;

data ClusterBy = clusterby(list[Expr] exprs);

data RestrictOrCascade
    = restrict()
    | cascade()
    ;


data TemporaryOrGlobal
    = temporary()
    | global()
    ;


data TemporaryTable = globalTemporaryTable();



data CreateViewClause
    = columnLevel(lrel[Identifier id,list[CommentLiteral] commentLiteral] clevel)
    | viewLevel(CommentLiteral cl)
    | tbl(TablePropertiesClause tblp)
    ;


data TBLPROPERTIES = tbl(lrel[str str1,str str2] tblprops);


data OrReplaceOrTemporary 
    = orReplace()
    | temporary(TemporaryTable temporaryTable)
    | replaceTemporary(TemporaryTable temporaryTable)
    ;


data DatabaseOrSchema = database()| schemaKeyword()| databases();


data WithDB = with(lrel[str ids, Expr expr] props);

data ResourceLocation = rLoc(RType rType, str slit);


data RType = jar() | file() | archive();


data SetStatement
    = setProperty(list[PropertyType ] propertyTypeOpt, lrel[str str1, str str2] propassignments)
    | setLocation(str location)
    | noValue(list[Output] outputOpt)
    | setStatementSpark(str expandedIdentifier, SetValue setValue)
    ;

data Output = v();
 
data PropertyType = dbprop() | prop();

data SetValue = unquotedSetValue(str unquotedSetValue);


data UsingClause = usingClause(StoredAsType storedAs, list[Option] opt);

data StoredAsType = hive();


data Option = option(list[Options] optionList);

data Options = optionStr(str str1, str str2) | pair(str id, Expr e)| storageLevel(str strLit,Expr e);

data AlterTable
    = alterOrChange(
        TableName tableName
        , AlterOrChange alterOrChange
        , list[ColumnKeyword] columnKeywordOpt
        , Identifier column_name
        , list[Identifier] alterColumnActionOpt
        , CommentLiteral commentLiteral
        )
    | addColumn(TableName tableName ,lrel[Identifier identifier,list[DataType] datatype] cols)
    | renameColumn(TableName tableName, Identifier id1, Identifier id2)
    | replaceColumn(TableName tableName,list[PartitionClause] partitionClauseOpt,lrel[Identifier id ,DataType datatype] columns, CommentLiteral commentLiteral)
    | dropColumn(TableName tableName,ColumnKeyword columnKeyword,list[Identifier] identifierList)
    | setTableProperties(TableName tableName, lrel[str str1, str str2] tblprops)
    | unsetTableProperties(TableName tableName,list[str] keys)
    | setSerdeProp(TableName tableName, list[PartitionClause] partitionClauseOpt, lrel[str str1, str str2] tblprops)
    | setSerdePropWith(TableName tableName, list[PartitionClause] partitionClauseOpt, str id, list[SerdePropertiesClause] serdePropertiesClauseOpt)
    | setFileFormat(TableName tableName, list[PartitionClause] partitionClauseOpt, StoredAsType storedAsType)
    | setLocation(TableName tableName, list[PartitionClause] partitionClauseOpt , str CharSeq)
    | recover(TableName tableName)
    ;


data AlterOrChange 
    = alter()
    | change()
    ;


data ColumnKeyword = col() | cols();


data AlterSelectors
    = schema()
    | db()
    | namespace()
    ;


data AlterView
    = rename(TableName viewId1, TableName viewId2)
    | setView(TableName viewId, lrel[str ids ,str strings] props)
    | unsetView(TableName viewId, list[IfExists] ifExistsOpt, list[str] strings)
    | selectView(TableName vid, QueryOrWith queryorwith)
    ;


 
// Query
data QueryExpr
    = querySpark(QuerySpark querySpark)
    | queryIntersectSetQuantifier(QueryExpr queryExpr1, IntersectWithSetQuantifier intersectWithSet, QueryExpr queryExpr2)
    | queryExceptDistinct(QueryExpr queryExpr1, ExceptDistinct exceptDistinct, QueryExpr queryExpr2)
    | queryMinusSetquantifier(QueryExpr queryExpr1, MinusSetQuantifier minusSetQuantifier, QueryExpr queryExpr2)
    ;

data IntersectWithSetQuantifier = intersectWithSetQuantifier(SetQuantifier setQuantifier);
data ExceptDistinct = exceptDistinct(list[SetQuantifier] setQuantifier);
data MinusSetQuantifier = minusSetQuantifier(list[SetQuantifier] setQuantifier);


data QuerySpark
    = query(
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
        )
    ;

data CTEClause = cteClauseWithParam(Identifier id, list[Identifier] idList, QueryOrWith queryOrWith)
                | cteClauseNoParam(Identifier id, NestedWith nestedWith);

data NestedWith = nestedWith(WithClause withClause, list[CTEClause] cteClauseList, Query qry);

data Subquery = subqueryWithNested(NestedWith nestedWith);

    
data TableIdOrSubquery
    = tableIdWithAs(TableName tableId, Identifier id)
    | tableIdSubqueryWithAs(QueryExpr qryExp, Identifier id)
    | tableId(TableName tblName, list[Identifier] idList, TableSample tblSample)
    | tableIdAsExpr(Function funcCall, list[VarAssign] varAssignList, list[TableSample] tblSampleList)
    | tableIdWithValue(Value val)
    | tableIdLateralSubquery(Query qry, list[VarAssign] varAssignList)
    | tableIdOrSubqueryNestedWith(NestedWith nestedWith)
    ;

data TableSample = tableSample(SampleQuantifier sampleQuant);

data SampleQuantifier = exprPercent(Expr expr)
                        | exprRows(Expr expr)
                        | exprBucket(Expr expr1, Expr expr2)
                        ;


data PivotUnpivot 
    = pivot(lrel[Function aggfunc, list[PivotAlias] pivotAliasList] agg,ColList collist,lrel[ExpressionList explist,list[PivotAlias] pivotAliasList] exl)
    | unpivot( list[IncludeorEx] incoex , ValueColumnUnpivot valcolun, list[PivotAlias] pivotAliasList)
    ;

data PivotAlias = pivotAs(str id);

data LateralView
    = lateralView(list[Outer] outerOpt, Function functionCall, Identifier identifier,  list[Identifier] idList)
    | lateralViewNoId(list[Outer] outerOpt, Function functionCall, list[Identifier] idList)
    ;


data ValueColumnUnpivot = valueColumnUnpivot(ColList collist, str name, lrel[ExpressionList explist, list[PivotAlias] pivotAliasList] exl);

data ExpressionList = singleExpr(str exp) | multipleExpr(list[Expr] exps);


data ColList = singleCol(str id) | multipleCol(list[str] ids);

data IncludeorEx = include()| exclude();


data GroupByClause 
    = groupByClauseGroupingSets(list[ExpAsVar] expAsVarList, GroupingSets groupingSets, list[WithOption] withOptionList)
    | groupByClauseWithOption(list[ExpAsVar] expAsVarList, WithOption withOption)
    ;

data WithOption = rollupWith()
                | cubeWith()
                ;
data GroupingSets = groupingSets(list[GroupingSet] groupingSetList);

data GroupingSet = group(list[Expr] exprList);

data JoinClause = semiJoinClause(SemiJoin semiJoin, TableIdOrSubquery tableIdOrSubquery, JoinCondition joinCond, list[JoinClause] joinClauseList); 

data SemiJoin = semiJoin();

data LimitClause = limitClauseAll();

data SortedByClause = sortByCls(list[str] openingBracket, list[SortedByElem] sortedByElemList, list[str] closingBracket);

data SortedByElem = sortByElemExpr(Expr expr, list[SortedByDirection] sortedByDirectionList, list[NullFirstOrLast] nullFirstOrLastList);

data SelectClause = selectClauseWithTranform(list[SetQuantifier] setQuantifierList, TransformClause transfrmCls); 

data TransformClause =  transform(list[Expr] exprList, list[RowFormatClause] rowFormatClsList1, list[str] strConstList,
                        str strConst, list[TAlias] tAliasList, list[RowFormatClause] rowFormatClsList2, list[str] strConstList2
                        );

data TAlias= tAlias(list[ColumnSpecification] cols);
