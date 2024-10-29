module lang::snowflake::ast::SnowFlake
extend lang::basesql::ast::BaseSQL;

data Expr =  plusExp(Expr Expr)
            | functionCallExp(FunctionCall functionCall)
            | arrayAccess(Expr exp1, Expr exp2)
            | arrayExp(ArrayLiteral arrayLiteral)
            | jsonAccess(Expr exp1, Expr exp2)
            | jsonLiteral(JsonLiteral jsonLiteral)
            | expCollateString(Expr Expr, String string)
            | castExp(Expr Expr, DataType dataType)
            | overClauseExp(Expr Expr, OverClause overClause)
            | castExpr(Expr Expr, DataType dataType)
            | tryCastExp(TryCastExp tryCastExp)
            |null()
            | iffExp(IffExp iffExp)
            |boolean(Boolean bv)
            | expNotBetween(Expr exp1, Expr exp2)
            | expNotInList(Expr Expr,list[Not]not, ExpList expList)
            | expNotIlikeEscape(Expr exp1,list[Not] not, LikeIlike likeIlike, Expr exp2, list[EscapeExp] escapeExpList)
            | expNotRlike(Expr exp1,list[Not] not, Expr exp2)  
            ;

data JsonLiteral = jsonKvPair(list[KvPair] kvPair)
                    ;

data PropRef =propRef(list[Identifier] identifier);


data IffExp = iffExpression(Expr searchCondition, Expr exp1, Expr exp2);

data KvPair = kvPair(String string, Expr exp);

data LikeIlike = like()
                    | ilike()
                    ;

data FunctionCall = rankingWindowedFunc(RankingWindowedFunction rankingWindowedFunction)
                    | aggregateFunc(AggregateFunction aggregateFunction)
                    | listOpFunc(ListOperator listOperator, ExpList expList)
                    | binaryOrTernaryBuiltInFunc(BinaryOrTernaryBuiltInFunction binaryOrTernaryBuiltInFunction, ExpList expList)
                    ;

data RankingWindowedFunction = rankDenseRowNumberFunc(RankDenseRowNumber rankDenseRowNumber, OverClause overClause)
                                | ntileFunc(Expr Expr, OverClause overClause)
                                | leadOrLagFunc(LeadOrLag leadOrLag, list[ExpList] expList, list[IgnoreOrRepectNulls] ignoreOrRepectNullsList, OverClause overClause)
                                | firstValueOrLastValueFunc(FirstValueOrLastValue firstValueOrLastValue, Expr Expr, list[IgnoreOrRepectNulls] ignoreOrRepectNulls, OverClause overClause)
                                ;



data OverClause = overPartitionBy(list[PartitionByClause] partitionByOpt, list[OrderByClause] orderByClauseList)
                    ;
data ExpList = expList(list[Expr] expList);
data LeadOrLag = lead()
                | lag()
                ;

data AggregateFunction = idDistinct(PropRef fName, list[ExpList] expList)
                            | idStar(PropRef fName)
                            | idNoDistinct(PropRef fName, list[Expr] exprs)
                            | listOrArrayAggNoDistinct(ListAggOrArrayAgg listAggOrArrayAgg, list[Expr] exprs, list[WithinGroupOrder] withinGroupOrderList)
                            | listOrArrayAgg(ListAggOrArrayAgg listAggOrArrayAgg, list[Expr] exprs, list[WithinGroupOrder] withinGroupOrderList)
                            ;





data IdentifierType = identifierTypeOpt1(BinaryOrTernaryBuiltInFunction binaryOrTernaryBuiltInFunction)
                        | identifierTypeOpt2(PropRef name)
                        ;

data BinaryOrTernaryBuiltInFunction = ifNullBuiltInFunction() 
                                | nvlBuiltInFunction()
                                | getBuiltInFunction()
                                | leftBuiltInFunction()
                                | rightBuiltInFunction()
                                | datePartBuiltInFunction()
                                | splitBuiltInFunction()
                                | nullIfBuiltInFunction()
                                | equalNullBuiltInFunction()
                                | containsBuiltInFunction()
                                | collateBuiltInFunction()
                                | toDateBuiltInFunction()
                                | dateBuiltInFunction()
                                | charIndexBuiltInFunction()
                                | replaceBuiltInFunction()
                                | substringBuiltInFunction()
                                | substrBuiltInFunction()
                                | likeBuiltInFunction()
                                | ilikeBuiltInFunction()
                                ;


data AsAlias = asAlias(Identifier id);
data SnowFlakeBatch = snowFlakeBatch(list[Statement] sqlCommandList);

 data Statement = createTaskCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objectNameOrId, 
                     list[TaskParameters] taskParametersList, list[CommentClause] commentClauseList, list[CopyGrants] copyGrantsList,
                        list[AfterColumnList] afterColumnList, list[WhenSearchCondition] whenSearchCondition, Statement Statement
                      )
                        | createAlertCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef ids,
                                list[Property] props, AlertCondition alertCondition, Statement Statement
                        )
                     ;

                       
data Identifier=withDollar(Identifier id1, Identifier id2);
data AfterColumnList = afterColumnList(list[ColumnList] columnList);

data WhenSearchCondition = whenSearchCondition(Expr searchCondition);
                        
data TaskParameters = taskParam(list[Property] propsList);
data AlterAlert = alterAlertAction(list[IfExists] ifExistsList, Identifier id, Statement sqlCommand);

data Statement = explainCommand(list[UsingExplainOpts] usingExplainOptsList, Statement sqlCommand);

data UsingExplainOpts = usingExplainOpts(ExplainOpts explainOpts);

data ExplainOpts = tabularExplainOpt()
                    | jsonExplainOpt() 
                    | textExplainOpt()
                    ;


data Literal
            = boolean(Boolean boolVal)
            |null()
            ;

data Number
            = integer(str integer)
            | float(str floatingPoint)
            ;



data String = string(str stringConstant);


data OnSearchCondition = onSearchCondition(SearchCondition searchCondition);

data SearchCondition = searchCondition(Expr exp);

data UsingColumnList = usingColumnList(Columns columnList);

data AtBefore = atTimeStamp(Expr exp)
                | atOffset(Expr exp)
                | atStatement(String string)
                | atStream(String string)
                | beforeStatement(String string)
                ;

data Changes = changes(DefaultAppendOnly defaultAppendOnly, AtBefore atBefore, list[End] endList);

data DefaultAppendOnly = defaultNoAppendOnly()
                           | appendOnly()
                           ;

data End = endTimeStampString(String string)
            | endOffset(String string)
            | endStatement(Identifier id)
            ;
            
data PartitionBy = partitionBy(ExpList expList);


data AsOrDesc = asc()
                | desc()
                ;

data ExpAsAlias = expAsAlias(Expr exp, AsAlias asAlias);

data ExpAsAliasList = expAsAliasList(list[ExpAsAlias] expAsAliasList);



data OrderByClause = orderByClause(list[OrderItem] orderItemList);

data OrderItem = orderItem(Expr exp, list[AsOrDesc] asOrDescList, list[NullsFirstOrLast] nullsFirstOrLastList);

data NullsFirstOrLast = nullsFirstOrLast(FirstOrLast firstOrLast);

data FirstOrLast = firstOrLast1()
                    | firstOrLast2()
                    ;

data CommaString = commaString(String string);

data WithinGroupOrder = withinGroupOrder(OrderByClause orderByClause);

data IgnoreOrRepectNulls = ignoreOrRepectNulls(IgnoreOrRespect ignoreOrRespect);

data IgnoreOrRespect = ignore()
                        | respect()
                        ;

data FirstValueOrLastValue = firstValue()
                                | lastValue()
                                ;

data ExpListWithBrackets = expListWithBrackets(ExpList expList);

data VarAssign = varAssignString(list[VarAssignAs] assignOpt, String string);


data RankDenseRowNumber = rank()
                            | denseRank()
                            | rowNumber()
                            ;


data TableName = sfRef(Identifier id1,Identifier id2, list[Identifier] ids);

data ListAggOrArrayAgg = listAgg()
                            | arrayAgg()
                            ;

data ListOperator = concat()
                        | concatWS()
                        | coalesce()
                        ;


data DataType = 
                 numberAlias(NumberAlias numberAlias)
                | varCharAlias(VarCharAlias varCharAlias, list[DataTypeSize] dataTypeSizeList)
                | dateTimeDataType(list[DataTypeSize] dataTypeSizeList)
                | timeDataType(list[DataTypeSize] dataTypeSizeList)
                | timeStampDataType(list[DataTypeSize] dataTypeSizeList)
                | timeStamp_LTZ(list[DataTypeSize] dataTypeSizeList)
                | timeStampLTZ(list[DataTypeSize] dataTypeSizeList)
                | timeStamp_NTZ(list[DataTypeSize] dataTypeSizeList)
                | timeStampNTZ(list[DataTypeSize] dataTypeSizeList)
                | timeStamp_TZ(list[DataTypeSize] dataTypeSizeList)
                | timeStampTZ(list[DataTypeSize] dataTypeSizeList)
                | charAlias(CharAlias charAlias, list[DataTypeSize] dataTypeSizeList)
                | binaryAlias(BinaryAlias binaryAlias, list[DataTypeSize] dataTypeSizeList)
                | variantDataType()
                | objectDataType()
                | arrayDataType()
                | geographyDataType()
                | geometryDataType()
                ;

data DataTypeList = dataTypeList(list[DataType] dataType);

data PrimitiveType = 
                integerType() | realType()| float4Type()
                    | float8Type()
             
                | byteIntType()
               
                ;

data NumberAlias = numberType(list[ExpListWithBrackets] expListWithBrackets)
                    | numericType(list[ExpListWithBrackets] expListWithBrackets)
                    | decimalType(list[ExpListWithBrackets] expListWithBrackets)
                    ;

data FloatAlias = floatType()
                    
                    | doubleType()
                    | doublePrecisionType()
                   
                    ;

data VarCharAlias = charVarying()
                    | ncharVarying()
                    | nvarchar2()
                    | nvarchar()
                    | stringVarChar()
                    | textVarChar()
                    | varChar()
                    ;

data DataTypeSize = dataTypeSize(str integer);

data CharAlias =  ncharType()
                    | characterType()
                    ;

data BinaryAlias = binaryType()
                    | varBinaryType()
                    ;

data TryCastExp = tryCastExpression(Expr exp, DataType dataType);



data EscapeExp = escapeExp(Expr exp);

 data NullNotNull = nullNotNull(list[Not] notOpt)
         ;


data ArrayLiteral = arrayExpList(list[ExpList] expList);

data QueryExpr
        = querySnowflake(QuerySnowflake querySnowflake)
        | queryExcept(QueryExpr qryexpr1, Except except, QueryExpr qryexpr2)
        | queryMinus(QueryExpr qryexpr1, Minus minus, QueryExpr qryexpr2)
        ;

data Except = except();
data Minus = minus();


data Expr = subQuery(QueryExpr query);

data QuerySnowflake = 
 query(
        SelectClause selectclause
        , list[IntoClause] intoclauseOpt
        , list[FromClause] fromOpt
        , list[JoinClause] joinList
        , list[WhereClause] whereOpt
        , list[GroupByClause] groupOpt
        , list[HavingClause] havingOpt
        , list[QualifyClause] qualifyOpt
        , list[OrderByClause] orderByOpt
        , list[LimitOffsetClauses] limitOpt)
;


data IntoClause =  intoClause(VarList varList);
data VarList = varList(list[Identifier] idList);

data Variable = variable(Identifier id);


data MatchRecognize = matchRecognize(list[PartitionBy] partitionByList, list[OrderElem] orderElemList, list[Measures] measuresList, list[RowMatch] rowMatchList, list[AfterMatch] afterMatchList, list[Pattern] patternList, list[Define] defineList);

data Measures = measures(ExpAsAliasList expAsAliasList);


data RowMatch = oneRow(list[MatchOptions] matchOptionsList)
                    | allRows(list[MatchOptions] matchOptionsList)
                    ;

data MatchOptions = showEmpty()
                    | omitEmpty()
                    | unmatchedRows()
                    ;

data AfterMatch = afterMatchLast()
                    | afterMatchNext()
                    | aftermatchSymbol(list[FirstOrLast] firstOrLastList, Symbol symbol)
                    ;

data Symbol = symbol();

data Pattern = pattern(String string);

data Define = define(SymbolList symbolList);

data SymbolList = symbolList(list[SymbolAsExp] symbolAsExpList);

data SymbolAsExp = symbolAsExp(Symbol symbol, Expr exp);

data PivotUnpivot = pivot(FunctionCall f1, Identifier id2, list[Literal] literalList)
                    | unpivot(Identifier id, Identifier id2, Columns columnList) 
                    ;

data AsColumnList = asColumnList(AsAlias asAlias, list[ColumnAliasList] columnAliasList);

data ColumnAliasList = columnAliasList(list[Identifier] idList);


data Sample = sample(list[SampleMethod] sampleMethodList, SampleOpts sampleOpts)
                | tableSample(list[SampleMethod] sampleMethodList, SampleOpts sampleOpts)
                ;

data SampleMethod = rowSamplMethod(RowSampling rowSampling)
                    | blockSampleMethod(BlockSampling blockSampling)
                    ;

data RowSampling = bernoulliSampling()
                    | rowSampling()
                    ;

data BlockSampling = systemSampling()
                        | blockSampling()
                        ;


data SampleOpts = sampleOpts(str integer, list[RepeatableSeed] repeatableSeedList)
                    | sampleOptNoRows(str integer, list[RepeatableSeed] repeatableSeedList)
                    ;

data RepeatableSeed = repeatableSeed1(str integer)
                        | repeatableSeed2(str integer)
                        ;

data PriorList = priorList(list[PriorItem] priorItemList);

data PriorItem = priorItemPriorEq(Identifier id1, Identifier id2)
                    | priorItemPriorEqPrior(Identifier id1, Identifier id2)
                    | priorItemNoPrior(Identifier id1, Identifier id2)
                    | priorItemEqPrior(Identifier id1, Identifier id2)
                    ;

data ValuesTable = valuesTableWithoutParenthesis(ValuesBuilder valuesBuilder, list[AsColumnAlias] asColumnAliasList)
                    | valuesTableWithParenthesis(ValuesBuilder valuesBuilder, list[AsColumnAlias] asColumnAliasList)
                    ;

data ValuesBuilder = valuesBuilder(list[ExpListWithBrackets] expListWithBrackets);

data AsColumnAlias = asColumnAlias(AsAlias asAlias, list[ColumnAliasList] columnAliasList);

data FlattenTable = flattenTable(list[InputAssociation] inputAssociationList, Expr exp, list[CommaFlattenTableOpt] commaFlattenTableOptList);

data InputAssociation = inputAssociation();

data CommaFlattenTableOpt = commaFlattenTableOpt(FlattenTableOpt flattenTableOpt);

data FlattenTableOpt = pathAssoc(String string)
                            | outerAssoc(Boolean boolVal)
                            | recursiveAssoc(Boolean boolVal)
                            | modeAssocArray()
                            | modeAssocObj()
                            | modeAssocBoth()
                            ;

data SplitedTable = splitedTable(ExpListWithBrackets expListWithBrackets);


data GroupByClause = groupByHaving(ExpList expList, list[HavingClause] havingClauseList)
                        | groupByCube(ExpListWithBrackets expListWithBrackets)
                        | groupBySets(ExpListWithBrackets expListWithBrackets)
                        | groupByRollup(ExpListWithBrackets expListWithBrackets)
                        | groupByAll()
                        ;


data QualifyClause = qualifyClause(Expr exp);


data TableIdOrSubquery = objectRefJoinClause(ObjectRef objectRef)
                                | bracketTableItemJoined(TableIdOrSubquery tableSource)
                                ;

data ObjectRef = objectRefMatchWithAlias(Identifier objNameOrId, list[IdParams] idparam)
                    | objectRefConnect(Identifier objNameOrId, Expr exp, list[PriorList] priorList)
                    | objectRefFuncCall(FunctionCall functionCall, list[PivotUnpivot] pivotUnpivotList, list[AsAlias] asAliasList, list[Sample] sampleList)
                    | objectRefValuesTable(ValuesTable valuesTable, list[Sample] sampleList)
                    | objectRefLateralSubQuery(QueryExpr query, list[PivotUnpivot] pivotUnpivotList, list[AsAlias] asAliasList)
                    | objectRefNoLateralSubQuery(QueryExpr query, list[PivotUnpivot] pivotUnpivotOpt, list[AsAlias] asAliasOpt)
                    | objectRefLateralFlatten(FlattenTable flattenTable, list[AsAlias] asAliasList)
                    | objectRefLateralSplitted(SplitedTable splitedTable, list[AsAlias] asAliasList)
                    ;

data IdParams = atBefore(AtBefore atBefore)| changes(Changes changes)| matchRec(MatchRecognize matchRecognize)| pivotUnpivot(PivotUnpivot pivotUnpivot)|asCol(AsColumnAlias asColumn)| sample(Sample sampleList);


 data Statement = insertDML(InsertStatement insertStatement)
            | insertMultiTableDML(InsertMultiTableStatement insertMultiTableStatement)
            | updateDML(UpdateStatement updateStatement)
            | deleteDML(DeleteStatement deleteStatement) 
            | mergeDML(MergeStatement mergeStatement)
            ;

 data InsertStatement = withQueryandBuilder(InsertWithQuery insertWithQ, ValuesBuilder valuesBuilder)
                       | withoutQuery(OverWriteOrInto overwriteInto,list[Table] tableOpt,TableName objNameOrId,list[PartitionPartWithOptionalValue] partitionWithOpt,list[IfNotExists] ifNotExOpt, list[ColumnSpecificationForInsert] columnOpt, list[ValuesBuilder] vbOpt)
                       ;

data InsertMultiTableStatement = insertMultiTableOverwriteAllInto(list[OverWriteOrInto] overwriteInto,FirstAll firstAll,IntoValuesList intoValuesList)
                                    | insertMultiTableOverwriteFirstWhen(list[OverWriteOrInto] overwriteInto,FirstAll firstAll,list[WhenPredicateThenValues] whenPredicateThenValues, list[ElseIntoValueslist] elseIntoValueslist, QueryExpr query)
                                    ;

data IntoValuesList = intoValuesList(TableName objNameOrId, list[Columns] columnListWithBrackets, list[ValuesBuilder] valuesList);





data FirstAll = first()|\all();
data WhenPredicateThenValues = whenPredicateThenValues(Expr exp, list[IntoValuesList] intoValuesList2);

data ElseIntoValueslist = elseIntoValuesList(IntoValuesList intoValuesList);

data UpdateStatement = updateStatement(TableName objNameOrId, list[AsAlias] asAliasList, SetObjNameList setObjNameList, list[FromClause] fromClauseList, list[WhereClause] whereClauseList);


data SetObjNameList = setObjNameList(list[Expr] expList);

data DeleteStatement = deleteStatement(TableName objNameOrId, list[AsAlias] asAliasList, list[UsingTableQueryList] usingTableQueryList, list[WhereClause] whereClauseList);



data UsingTableQueryList = usingTableQueryList(list[TableIdOrSubquery] usingTableQueryList);

data MergeStatement = mergeStatement(TableName objNameOrId, list[AsAlias] asAliasList, TableIdOrSubquery tableSource, Expr searchCondition, MergeMatches mergeMatches);

data MergeMatches = mergeMatches(list[WhenMatchedThen] whenMatchedThenList);


data WhenMatchedThen = whenMatchedThen(list[Not] notOpt,list[AndSearchCondition] andSearchConditionList, MergeUpdateOrDelete mergeUpdateOrDelete);

 data MergeUpdateOrDelete = mergeUpdate(SetObjNameList setObjNameList)
                          | mergeDelete()
                          |mergeInsert(list[ExpListWithBrackets] expList, ValuesBuilder vb)
                            ;


data AndSearchCondition = andSearchCondition(Expr searchCondition);





 data Statement = alterAccountCommand(AlterAccountOpts alterAccountOpts)
                    | alterSessionCommand(AlterSession alterSessionCmd)
                    | alterDatabaseCommand(AlterDatabase alterDatabaseCmd)
                    | alterConnectionCommand(AlterConnectionOptions alterConnectionOptions)
                    | alterAlertCommand(AlterAlert alterAlertCmd)
                    | alterUserCommand(list[IfExists] ifExistsList, Identifier id, AlterUserOptions alterUserOptions)
                    | alterTagCommand(list[IfExists] ifExistsList, Identifier id, AlterTagOptions alterTagOptions)
                    | alterSchemaCommand(AlterSchema alterSchemaCmd)
                    | alterRoleCommand(AlterRole alterRoleCmd)
                    | alterRowAccessPolicyCommand(AlterRowAccessPolicy alterRowAccessPolicyCmd)
                    | alterProcedureCommand(AlterProcedure alterProcedureCmd)
                    | alterNetworkPolicyCommand(AlterNetworkPolicyOpts alterNetworkPolicyOpts)
                    | alterApiIntegrationCommand(AlterApiIntegration alterApiIntegrationCmd)        
                    | alterDynamicTableCommand(Identifier id, AlterDynamicOpts alterDynamicOpts)
                    | alterFailoverGroupCommand(list[IfExists] ifExistsList, Identifier id,AlterFailoverGroup alterFailoverGroupCmd)
                    | alterFileFormatCommand(AlterFileFormat alterFileFormatCmd)
                    | alterWareHouseCommand(list[IfExists] ifExistsList, AlterWareHouseOptions alterWareHouseOptions)                
                    | alterFunctionCommand(list[IfExists] ifExOpt,Identifier id, list[DataTypeList] dtlOpt,AlterFunction alterFunctionCmd)
                    | alterViewCommand(AlterView alterViewCmd)
                    | alterMaskingPolicyCommand(AlterMaskingPolicy alterMaskingPolicyCmd)
                    | alterMaterializedViewCommand(Identifier id, AlterMaterializedViewOpts alterMaterializedViewOpts)
                    | alterPipeCommand(AlterPipe alterPipeCmd)
                    | alterNotificationIntegrationCommand(AlterNotificationIntegration alterNotificationIntegrationCmd)
                    | alterExternalTableCommand(AlterExternalTable alterExternalTableCmd)
                    | alterResourceMonitorCommand(list[IfExists] ifExistsList, Identifier id, list[SetUnset] setUnset, list[NotifyTriggers] notifyTriggersList)
                    | alterSequenceCommand(AlterSequence alterSequenceCmd)
                    ;

data AlterAccountOpts = setAccountOpts(list[Property] accountParamsOpt)
                        | unsetAccountOpts(list[Identifier] idList)
                        | resourceMonitorAccountOpts(Identifier id)
                        | setTagsAccountOpts(SetUnsetTags setTags)
                        | dropUrlAccountOpts(Identifier id)
                        | saveUrlAccountOpts(Identifier id1, Identifier id2, list[SaveOldUrl] saveOldUrlList)
                        ;



data SetUnset = \set(list[Property] props) | unset(list[Expr] expOpt,list[ExpListWithBrackets] withBraclOpt);
data SetUnsetTags = unsetTags(SetUnset setUnset, list[Expr] tagDeclList);



data TagDecl = tagDecl(Identifier objNameOrId, String string);

data SaveOldUrl = saveOldUrl(Boolean boolVal);

data AlterTable =  alterTableSetTags(list[IfExists] ifExistsList, TableName tableName, SetUnsetTags setTags)
                    | alterTableSwapWith(list[IfExists] ifExistsList, TableName tableName1, TableName tableName2)
                    | alterTableDropRow(list[IfExists] ifExistsList, TableName tableName1, Identifier id)
                    ;


data AlterSession = alterSessionSet(Property sessionParams)
                    | alterSessionUnset(list[Identifier] idList)
                    ;
data Property =property(Identifier id, AssignExpr asexpr);

data AlterDatabase = alterDatabaseRename(list[IfExists] ifExistsList, Identifier id1, Identifier id2)
                        | alterDatabaseSwap(list[IfExists] ifExistsList, Identifier id1, Identifier id2)
                        | alterDatabaseSetTags(Identifier id, SetUnsetTags setTags)
                        | alterDatabaseRefresh(Identifier id)
                        | alterDatabaseProperty(list[IfExists] ifExistsOpt, Identifier id, list[DatabaseOrSchemaProperty] databaseOrSchemaPropertyList)
                        ;

data DatabaseOrSchemaProperty = dataRetentionTimeProp(str integer) 
                                | maxDataExtentionTimeProp(str integer) 
                                | defaultDdlCollationProp(String string)
                                | commentDatabaseOrSchemaProperty()
                                ;


data AlterConnectionOptions = alterConnectionPrimary(Identifier id)
                                | alterConnectionSet(list[IfExists] ifExistsList, Identifier id,SetUnset setUnset, CommentClause commentClause)
                                ;

data CommentClause = commentClause(list[AssignExpr] assExprOpt);

data AssignExpr = assignExp(Expr exp) | assignList(list[ExpList] exptLOpt);

data AlterAlert =  alterAlterResumeSuspend(list[IfExists] ifExistsOpt, Identifier id, ResumeSuspend resumeSuspend)
                    | alterAlterSet(list[IfExists] ifExistsList, Identifier id,SetUnset setUnset, list[AlertSetClause] alertSetClauseList)
                    | alterAlterModify(list[IfExists] ifExistsList, Identifier id, AlertCondition alertCondition)
                    ;

data ResumeSuspend = resumeSuspendOpt1()
                        | resumeSuspendOpt2()
                        ;

data AlertSetClause = warehouseAlertSetClause(list[AssignExpr] assOpt)
                        | scheduleAlertSetClause(list[AssignExpr] assOpt)
                        | commentAlertSetClause(CommentClause commentClause)
                        ;


data AlertCondition = selectAlertCondition(QueryExpr selectStatement)
                       | showAlertCondition(Statement showCommand)
                       | callAlertCondition(Call call)
                       ;

data AlterUserOptions = renameToId(Identifier id)
                        | resetPassword()
                        | abortAllQueries()
                        | addDelegated(Identifier id1, Identifier id2)
                        | removeDelegated(AuthorizationType authorizationType, Identifier id)
                        | setTagAlterUserOpt(SetUnsetTags setTags)
                        
                        ;

data AuthorizationType = ofRoleAuthorizationType(Identifier id)
                            | authorizationsType()
                            ;

data AlterTagOptions = alterTagOptsRename(PropRef PropRef)
                        | alterTagOptsAddOrDrop(AddOrDrop addOrDrop, TagAllowedValues tagAllowedValues)
                        | alterTagOptsUnsetAllowed()
                        | alterTagOptsSetMasking( SetUnset setunset,MaskingPolicyIdList maskingPolicyIdList)
                        | alterTagOptsSetCommentClause(SetUnset setunset,CommentClause commentClause)
                    
                        ;

data AddOrDrop = add() 
                    | drop()
                    ;

data TagAllowedValues = tagAllowedValues(list[String] stringList);

data MaskingPolicyId = maskingPolicyId(Identifier id);

data MaskingPolicyIdList = maskingPolicyIdList(list[MaskingPolicyId] maskingPolIdList);

data AlterSchema = alterSchemaRenameTo(list[IfExists] ifExistsOpt, Identifier id1, Identifier id2)
                    | alterSchemaSwapWith(list[IfExists] ifExistsOpt, Identifier id1, Identifier id2)
                    | alterSchemaCommentClause(list[IfExists] ifExistsOpt, Identifier id, SetUnset setUnset,
                                list[DatabaseOrSchemaProperty] PropertyList)
                    | alterSchemaSetTags(list[IfExists] ifExistsOpt, Identifier id, SetUnsetTags setTags)
                    | alterSchemaEnableDisable(list[IfExists] ifExistsOpt, Identifier id, EnableDisable enableDisable)
                    ;

data EnableDisable = enable()
                    | disable()
                    ;

data AlterRole = alterRoleRenameTo(list[IfExists] ifExistsOpt, Identifier id1, Identifier id2)
                    | alterRoleSet(list[IfExists] ifExistsOpt, Identifier id,SetUnset setUnset, CommentClause commentClause)
                    | alterRoleSetTags(list[IfExists] ifExistsOpt, Identifier id, SetUnsetTags setTags)
                    ;

data AlterRowAccessPolicy = alterRowSetBody(list[IfExists] ifExistsOpt, Identifier id, Expr exp)
                            | alterRowRenameTo(list[IfExists] ifExistsOpt, Identifier id1, Identifier id2)
                            | alterRowSetComment(list[IfExists] ifExistsOpt, Identifier id, CommentClause commentClause)
                            ;

data AlterProcedure = alterProcedureRenameTo(list[IfExists] ifExistsOpt, Identifier id1, list[DataTypeList] dataTypeList, Identifier id2)
                        | alterProcedureSetComment(list[IfExists] ifExistsOpt, Identifier id, list[DataTypeList] dataTypeList,SetUnset setunset, CommentClause commentClause)
                        | alterProcedureExecute(list[IfExists] ifExistsOpt, Identifier id, list[DataTypeList] dataTypeList, CallerOwner callerOwner)
                        ;

data CallerOwner = caller()
                    | owner()
                    ;

data AlterNetworkPolicyOpts = alterNetworkIPList(list[IfExists] ifExistsList, Identifier id, SetUnset setunset,list[Property] proplist, list[CommentClause] commentClauseList)
                                | alterNetworkRenameTo(Identifier id1, Identifier id2)
                                ;



data AlterApiIntegration = alterApiArn(list[IfExists] ifExistsList, Identifier id,
                                         SetUnset setUnset,
                                        list[CommentClause] commentClauseList
                                    )   
                            | alterNoApiSetTags(list[str] api, Identifier id,
                                     SetUnsetTags  setUnsetTags
                                     )  
                              
                                |  alterNoApiUnset(list[str] api,list[IfExists] ifExistsOpt, Identifier id, ApiIntegrationPropertyList apiIntegrationPropertyList)
                                ;





data Enable = enableTrueOrFalse(Boolean boolVal); 



data ApiIntegrationPropertyList = apiIntegrationPropertyList(list[ApiIntegrationProperty] apiIntegrationPropList);

data ApiIntegrationProperty = apiKeyIntegrationProp()
                                | enabledIntegrationProp()
                                | blockedPrefixesIntegrationProp()
                                | commentIntegrationProp()
                                ;

data AlterDynamicOpts = resumeSuspendDynamicOpt(ResumeSuspend resumeSuspend)
                              | refreshDynamicOpt()
                              | setDynamicOpt(Identifier id)
                              ;
data ColumnList= columnList(list[PropRef] propref);
data AlterFailoverGroup
                = renameToFailoverGroup( Identifier id2)
                | setFailoverGroup( list[ObjectTypes] objectTypesList, list[Property] replicationScheduleList) 
                | addAllowedFailoverGroup( ColumnList columnList)
                | moveToFailoverGroup( ColumnList columnList, Identifier id2)
                | removeFromFailoverGroup( ColumnList columnList)
                | allowedSharesFailoverGroup( ColumnList columnList)
                | moveSharesFailoverGroup( ColumnList columnList, Identifier id2)
                | removeAllowedSharesFailoverGroup( ColumnList columnList)
                | allowedAccountsFailoverGroup( TableName tableName, list[IgnoreEditionCheck] ignoreEditionCheckList)
                | removeColumnFailoverGroup( TableName tableName)
                | failoverOptFailoverGroup( AlterFailoverOpts alterFailoverOpts)
                ;

data ObjectTypes = objectTypes(list[ObjectType] objTypeList);

data ObjectTypeList = objectTypeList(list[ObjectType] objTypeList);

data ObjectType = accountParamObjectType()
                    | databasesObjectType()
                    | integrationsObjectType()
                    | networkPoliciesObjectType()
                    | resourceMonitorsObjectType()
                    | rolesObjectType()
                    | sharesObjectType()
                    | usersObjectType()
                    | warehousesObjectType()
                    ;

data ReplicationSchedule = replicationSchedule(String string);

data IgnoreEditionCheck = ignoreEditionCheck();

data AlterFailoverOpts = refreshFailoverOpts()
                                | primaryFailoverOpts()
                                | suspendFailoverOpts()
                                | resumeFailoverOpts()
                                ;

data AlterFileFormat = alterFileRenameTo(list[IfExists] ifExistsList, Identifier id1, Identifier id2)
                        | alterFileSet(list[IfExists] ifExistsList, Identifier id, list[Property] formatTypeOptionsList, list[CommentClause] commentClauseList)
                        ;


data AlterWareHouseOptions = idSuspendIfAlterWhOpt(list[Expr] expList, SuspendResumeIf suspendResumeIf)
                                | idAbortAllAlterWhOpt(list[Expr] expList)
                                | idRenameToAlterWhOpt(Expr exp, Identifier id)
                                | idSetTagsAlterWhOpt(Expr exp, SetUnsetTags setTags)
                                | idUnSetColListAlterWhOpt(Expr exp, ColumnList columnList)
                                ;

data SuspendResumeIf = suspendResumeIfOpt1()
                        | suspendResumeIfOpt2(list[IfSuspended] ifSuspendedList)
                        ;

data IfSuspended = ifSuspended();

data AlterFunction = renameToAlterFunction( Identifier id)
                        | commentAlterFunction(SetUnset setunset,UnsetSecureOrComment unsetSecureOrComment)
                        
                        | compressionAlterFunction( SetUnset compression)
                        ;


data UnsetSecureOrComment = unsetSecure()
                        | unsetComment(CommentClause commentClause)
                        | setSecureOrComment()
                        ;



data AlterView = alterViewAlternative1(list[IfExists] ifExistsList, TableName tableName, TableName tableName2)
                        | alterViewAlternative2(list[IfExists] ifExistsList, TableName tableName,SetUnset setunset, CommentClause commentClause)
                        | alterViewAlternative4(TableName tableName,SetUnset setunset)
                        | alterViewAlternative6(list[IfExists] ifExistsList, TableName tableName, SetUnsetTags setTags)
                        | alterViewAlternative8(list[IfExists] ifExistsList, TableName tableName,AddOrDrop aod, Identifier id, list[Columns] columnList)
                        | alterViewAlternative10(list[IfExists] ifExistsList, TableName tableName, Identifier id1, Columns columnListWithBrackets, Identifier id2)
                        | alterViewAlternative11(list[IfExists] ifExistsList, TableName tableName)
                        | alterViewAlternative12(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id1, Identifier id2, list[UsingColumnList] usingColumnList)
                        | alterViewAlternative15(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id1, Identifier id2, list[UsingColumnList] usingColumnList)
                        | alterViewAlternative17(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id)
                        | alterViewAlternativeTags(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id, SetUnsetTags unsetTags)
                        ;

data AlterOrModify = alterOrModifyOpt1()
                        | alterOrModifyOpt2()
                        ;

data AlterMaskingPolicy = alterMaskingBody(list[IfExists] ifExistsList, Identifier id, Expr exp)
                                | alterMaskingRenameTo(list[IfExists] ifExistsList, Identifier id1, Identifier id2)
                                | alterMaskingSet(list[IfExists] ifExistsList, Identifier id, CommentClause commentClause)
                                ;

data AlterMaterializedViewOpts = alterMaterializedViewOpt1(Identifier id)
                                        | alterMaterializedViewOpt2(ExpListWithBrackets expListWithBrackets)
                                        | alterMaterializedViewOpt3()
                                        | alterMaterializedOptNoRecluster(ResumeSuspend resumeSuspend)
                                        | alterMaterializedOptRecluster(ResumeSuspend resumeSuspend)
                                        | alterMaterializedOptNoSecure(list[str] secure,list[CommentClause] commentClauseList)
                                        | alterMaterializedViewOpt7(list[UnsetSecureOrComment] unsetSecureOrCommentList)
                                        ;

data AlterPipe = alterPipeOpt1(list[IfExists] ifExistsList, Identifier id, list[Property] objectPropertiesList, list[CommentClause] commentClauseList)
                        | alterPipeOpt2(Identifier id, SetUnsetTags setTags)
                        | alterPipeOpt4(list[IfExists] ifExistsList, Identifier id, Boolean boolVal)
                        | alterPipeOpt5(list[IfExists] ifExistsList, Identifier id)
                        | alterPipeOpt6(list[IfExists] ifExistsList, Identifier id, list[Property] prefixStringList)
                        ;


                               
data AlterNotificationIntegration = alterNotificationIntegrationOpt2(list[str] notification,list[IfExists] ifExistsList, Identifier id,
                                                SetUnset setunset,
                                                CloudProviderParamsAuto cloudProviderParamsAuto,
                                                list[CommentClause] commentClauseList
                                                )
                                        | alterNotificationIntegrationOpt6(list[str] notification, Identifier id, SetUnsetTags setTags)
                                        ;

data CloudProviderParamsAuto
                                = googleCloudParamAuto(String string)
                                | microsoftAzureParamAuto(String string1, String string2)
                                ;

data CloudProviderParamsPush
                                = amazonAwsParamPush(String string1, String string2)
                                | googleCloudParamPush(String string)
                                | microsoftAzureParamPush(String string1, String string2)
                                ;

data AlterEnabledOrComment = alterEnabled()
                                | alterComment()
                                ;

data AlterExternalTable = alterExternalTableRefresh(list[IfExists] ifExistsOpt, TableName tableName, list[String] stringOpt)
                                | alterExternalTableAddFiles(list[IfExists] ifExistsList, TableName objNameOrId, ExpList expList)
                                | alterExternalTableRemoveFiles(list[IfExists] ifExistsList, TableName objNameOrId, ExpList expList)
                                | alterExternalTableSet(list[IfExists] ifExistsList, TableName objNameOrId,
                                        list[AutoRefresh] autoRefreshList, 
                                        list[TagDeclList] tagDeclList
                                        )
                                | alterExternalTableUnset(list[IfExists] ifExistsList, TableName objNameOrId, SetUnsetTags unsetTags)
                                | alterExternalTableAddPartition(TableName objNameOrId, list[IfExists] ifExistsList, ExpList expList, String string)
                                | alterExternalTableDropPartition(TableName objNameOrId, list[IfExists] ifExistsList, String string)
                                ;

data AutoRefresh = autoRefresh(Boolean boolVal);

data TagDeclList = tagDeclList(list[TagDecl] tagDeclList);



data FrequencyOpts = monthlyFrequency()
                        | dailyFrequency()
                        | weeklyFrequency()
                        | yearlyFrequency() 
                        | neverFrequency()
                        ;

data NotifyTriggers = notifyTriggers(NotifyUsers notifyUsers, list[Triggers] triggersList);

data NotifyUsers = notifyUsers(list[Identifier] idList);

data Triggers = triggers(list[TriggerDefinition] triggerDefinitionList);

data TriggerDefinition = triggerDefinition(str integer, SuspendType suspendType);

data SuspendType = suspendTypeOpt1()
                        | suspendTypeOpt2()
                        | suspendTypeOpt3()
                        ;

data AlterSequence = alterSequenceRenameTo(list[IfExists] ifExistsList, TableName t1, TableName t2)
                        | alterSequenceSetIncrementBy(list[IfExists] ifExistsList, TableName t,list[str] \set, list[IncrementBy] incrementByList)
                        | alterSequenceSetOrderComment(list[IfExists] ifExistsList, TableName t,SetUnset setUnset, OrderComment orderComment)
                        ;
                        
data IncrementBy = incrementByOpt1(str integer)
                    | incrementByOpt2(str integer)
                    | incrementByOpt3(str integer)
                    | incrementByOpt4(str integer)
                    ;
data ExpAsVarOrStar= objectNameColPosition(list[TableName] tableNameOpt, str integer, list[AsAlias] asAliasOpt);
 data OrderComment = orderCommentOpt1(list[OrderNoOrder] orderNoOrderList, CommentClause commentClauseList) 
                        | orderCommentOpt2(OrderNoOrder orderNoOrder)
                        ;

data OrderNoOrder = orderNoOrder1()
                    | orderNoOrder2()
                    ;

data Statement =  createViewCommand(CreateView createView)
                        | createTableCommand(list[OrReplace] orReplaceOpt, list[TableType] tableTypeOpt, list[IfNotExistsObjectName] ifNotExistsObjectNameList, list[CloneAtBefore] cloneAtBeforeList, list[CreateTableOrCommentClause] createTableOrCommentClauseList, list[QueryOrWith] query)
                        | createTableLikeCommand(CreateTableLike createTableLike)
                        | createDatabaseCommand(CreateDatabase createDatabase)
                        | createSchemaCommand(CreateSchema createSchema)
                        | createAccountCommand(Identifier id1, list[Property] propList, list[RegionGroup] regionGroupList,
                                list[SnowflakeRegion] snowflakeRegionList, list[CommentClause] commentClauseOpt
                                )
                   
                        | createUserCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, Identifier id, list[Property] objectPropertiesList)
                        | createConnectionCommand(list[IfNotExists] ifNotExistsList, Identifier id, list[AsReplicaOfObjectName] asReplicaOfObjectNameList, list[CommentClause] commentClauseOpt)
                        | createDynamicTableCommand(list[OrReplace] orReplaceList, Identifier id1, String string, Identifier id2, QueryExpr qry)
                        | createEventTableCommand(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsList, Identifier id,
                                list[ClusterBy] clusterByList, 
                               list[Property] props,
                                list[CopyGrants] copyGrantsList, 
                                list[WithRowAccessPolicy] withRowAccessPolicyList, 
                                list[WithTags] withTagsList, 
                                list[WithClause] withOpt,list[CommentClause] CommentClauseOpt
                                )
                        | createFailoverGroupCommand(CreateFailoverGroup createFailoverGroup)
                        | createManagedAccountCommand(Identifier id1, Identifier id2, String string, list[CommentClause] commaCommentClauseOpt)
                        | createNetworkPolicyCommand(list[OrReplace] orReplaceList, Identifier id, 
                                        list[Property] props,
                                        list[CommentClause] commentClauselist
                                )
                        | createApiIntegrationCommand(CreateApiIntegration createApiIntegration)
                        | createExternalFunctionCommand(CreateExternalFunction createExternalFunction)
                        | createExternalTableCommand(CreateExternalTable createExternalTable)
                        | createFunctionCommand(CreateFunction createFunction)
                        | createMaskingPolicyCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objNameOrId,
                                        list[ArgDataTypeList] argDataTypeList, DataType dt, Expr exp, list[CommentClause] commentClauseList
                                        )
                        | createNotificationIntegrationCommand(CreateNotificationIntegration createNotificationIntegration)
                        | createProcedureCommand(CreateProcedure createProcedure)
                        | createPipeCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objNameOrId,
                               list[Property] props,
                                list[CommentClause] commentClauseList,
                                CopyIntoTable copyIntoTable
                                )
                        | createObjectType(list[OrReplace] orReplaceList,ObjectTypeName objectType, list[IfNotExists] ifNotExistsOpt, Identifier id, list[WithTags] withTagsList,list[Property] propList, list[TagAllowedValues] tavOpt, list[CommentClause] commentClauseList)
                        | createRowAccessPolicyCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, Identifier id,
                                        list[ArgDataTypeList] argDataTypeList, Expr exp, list[CommentClause] commentClauseList
                                        )
                        | createReplicationGroupCommand(CreateReplicationGroup createReplicationGroup)
                        | createResourceMonitorCommand(list[OrReplace] orReplaceList, Identifier id,list[Property] propList, list[NotifyUsers] notifyUsersList, list[Triggers] triggersList
                                )
                        | createSequenceCommand(CreateSequence createSequence)
                    | createStageCommand(CreateStage createStage)
                        | createStorageIntegrationCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, Identifier id,
                             list[Property] propList, list[CommentClause] commentClauseList)
                        | createStreamCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList,
                                 TableName tbnOpt,
                             list[CopyGrants] copyGrantsOpt,CreateStream createStream)
                        | createObjectCloneCommand(list[OrReplace] orReplaceList, CreateCloneOpts createCloneOpts, list[IfNotExists] ifNotExistsList, PropRef objNameOrId1, PropRef objNameOrId2)
                        ;
data External = external();
data StreamType = table(list[External] ext)| stage()|view();
data CreateDatabase = createDatabase(list[OrReplace] orReplaceList,list[TableType] ttOpt, list[IfNotExists] ifNotExistsList, Identifier id,
                                        list[CloneAtBefore] cloneAtBeforeList,
                                        list[Property] propList,
                                        list[WithTags] withTagsOpt,
                                        list[CommentClause] commentClauseOpt)
                       
                        ;

data CreateStage = createStageParams(list[OrReplace] orReplaceList, list[Temporary] temporaryOpt, list[IfNotExists] ifNotExistsList, Expr exp, list[CloneAtBefore] cloneAtBeforeList,
                                list[ExternalStageParams] extParamsOpt,
                                list[StageEncryptionOptsInternal] stageEncryptionOptsInternalList,
                                list[DirectoryTableInternalParams] directoryTableInternalParamsList,
                                list[DirectoryTableExternalParams] directoryTableExternalParamsList,
                                list[FileFormat] fileFormatList,
                                list[CopyEqCopyOpts] copyEqCopyOptsList,
                                list[WithTags] withTagsList,
                                list[CommentClause] commentClauseList
                        )
                      
                        ;

data StageEncryptionOptsInternal = stageEncryptionOptsInternal(SnowFlakeFullSSE snowFlakeFullSSE);

data SnowFlakeFullSSE = snowflakeFull()
                        | snowflakeSSE()
                        ;

data DirectoryTableInternalParams = directoryTableInternalParams(EnableRefreshOnCreate enableRefreshOnCreate);

data EnableRefreshOnCreate = enableRefreshOnCreateOpt1(Enable enable, list[RefreshOnCreate] refreshOnCreateList)
                                | enableRefreshOnCreateOpt2(RefreshOnCreate refreshOnCreate, list[Enable] enableList)
                                ;

data CopyEqCopyOpts = copyEqCopyOpts(CopyOptions copyOptions);

data ExternalStageParams = externalStageAwsParam(S3OrGovAwsPath s3OrGovAwsPath, list[AwsCredentialEncryption] awsCredentialEncryptionList)
                                | externalStageGcpParam(str uri, list[GcpCredentialEncryption] gcpCredentialEncryptionList)
                                | externalStageAzureParam(str uri, list[AzCredentialEncryption] azCredentialEncryptionList)
                                ; 

data AzCredentialEncryption = azCredentialIntegration(AzCredentialOrStorageIntegration azCredentialOrStorageIntegration) 
                                | azCredentialEncryption(Property props, list[Property] propList)
                                ;

data AzCredentialOrStorageIntegration = azureStorageIntegrationId(Identifier id)
                                        |  azureSasToken(String string)
                                        ;

data AwsCredentialEncryption = awsCredentialIntegration(AwsCredentialOrStorageIntegration awsCredentialOrStorageIntegration)
                                | awsCredentialEncryption(list[Property] propList)
                                ;

data AwsCredentialOrStorageIntegration = awsStorageIntegration(Identifier id)
                                                |  awsCredential(list[Property] propList)
                                                ;


data GcpCredentialEncryption = gcpCredentialIntegration(Property prop)
                                | gcpCredentialEncryption(GcpEncryptionValue gcpEncryptionValue)
                                ;
                                 
data GcpEncryptionValue = typeGcsSseKmsKey(list[TypeGcsSseKms] typeGcsSseKmsList, String string)
                                | kmsTypeGcsSse(String string)
                                | typeNoneGcp()
                                ;

data TypeGcsSseKms = typeGcsSseKms();



data AzureEncryptionValue = masterKeyValue(list[TypeAzureCse] typeAzureCseList, String string)
                                | masterKeyType(String string)
                                | typeNoneAzure()
                                ;

data TypeAzureCse = typeAzureCse();                   

data DirectoryTableExternalParams = directoryTableExternalParams(Enable enable, list[RefreshOnCreateOrAutoRefresh] refreshOnCreateOrAutoRefreshList, list[NotificationIntegration] notificationIntegrationList);

data RefreshOnCreateOrAutoRefresh = refreshOnCreateOrAutoRefreshOpt1(AutoRefresh autoRefresh)
                                        | refreshOnCreateOrAutoRefreshOpt1(RefreshOnCreate refreshOnCreate)
                                        ;

data NotificationIntegration = notificationIntegration(String string);



data CreateCloneOpts = stageCloneOpt()
                        | fileFormatCloneOpt()
                        | sequenceCloneOpt() 
                        | streamCloneOpt()
                        | taskCloneOpt()
                        ;

data CreateStream = createStreamOnTable( StreamType stype,
                                TableName tblName, 
                                list[CloneOptional] cloneOptionalList,
                                list[AppendOnly] appendOnlyList,
                                list[InsertOnly] insetOpt,
                                list[ShowInitialRows] showInitialRowsOpt,
                                list[CommentClause] commentClausept

                        )

                        ;

data InsertOnly = insertOnly();

data AppendOnly = appendOnly(Boolean boolVal);

data ShowInitialRows = showInitialRows(Boolean boolVal);

data OrReplace = orReplace();


data CloneAtBefore = cloneAtBefore(TableName tableName, list[CloneOptional] cloneOptionalList);

data CloneOptional = cloneTimeStamp(AtOrBefore atOrBefore, String string)
                        | cloneOffset(AtOrBefore atOrBefore, String string)
                        | cloneStatement(AtOrBefore atOrBefore, Identifier id)
                        | cloneStream(AtOrBefore atOrBefore, String string)
                        ;

data AtOrBefore = atOrBeforeOpt1()
                    | atOrBeforeOpt2()
                    ;



data WithTags = withTags(list[WithClause] withOpt,list[TagDecl] tagDeclList)
              
                ;

data CreateSchema = createSchemaWithTransient(list[OrReplace] orReplaceList,list[TableType] ttypeOpt, list[IfExists] ifExistsList, TableName tblName,
                                list[CloneAtBefore] cloneAtBeforeList,
                                list[WithManagedAccess] withManagedAccessList,
                             list[Property] props,
                                list[WithTags] withTagsList,
                                list[CommentClause] commentClauseList)
                        
                        ;

data WithManagedAccess = withManagedAccess();

data FormatType = csv_()
                    | json_()
                    | avro_()
                    | orc_()
                    | parquet_()
                    | xml_()
                    | csv_q()
                    | json_q()
                    | avro_q()
                    | orc_q()
                    | parquet_q()
                    | xml_q()
                    ;

data CreateTableOrCommentClause = createTableOrCommentClauseOpt1(CreateTableClause createTableClause)
                                        | createTableOrCommentClauseOpt2(CommentClause commentClause)
                                        ;
                               
data CreateTableClause = createTableClause(ColumnDeclItemListWithBrackets columnDeclItemListWithBrackets,
                                        list[ClusterBy] clusterByList,
                                        list[StageFileFormat] stageFileFormatList,
                                        list[StageCopyEqCopyOptions] stageCopyEqCopyOptionsList,
                                        list[Property] propList,
                                        list[CopyGrants] copyGrantsList,
                                        list[WithRowAccessPolicy] withRowAccessPolicyList,
                                        list[WithTags] withTagsList
                        );

data ColumnDeclItem = fullColItem(FullColDecl fullColDecl)
                        | outOfLineConstraintItem(OutOfLineConstraint outOfLineConstraint)
                        ;
                        
data ColumnDeclItemList = columnDeclItemList(list[ColumnDeclItem] colDeclItemList);

data ColumnDeclItemListWithBrackets = columnDeclItemListWithBrackets(ColumnDeclItemList columnDeclarationItemList);

data FullColDecl = fullColDecl(ColDecl colDecl, list[FullColDeclOptionals] fullColDeclOptionalsList, list[WithMaskingPolicy] withMaskingPolicyList, list[WithTags] withTagsList, list[CommentString] commentStringList);

data OutOfLineConstraint = outOfLineConstraint(list[ConstraintId] constraintIdList, OutOfLineConstraintOptionals outOfLineConstraintOptionals);

data ColDecl = colDecl(IdentifierType idType, DataType dataType);

data FullColDeclOptionals = fullColDeclOptCollate(String string)
                            | fullColDeclOptInline(InlineConstraint inlineConstraint)
                            | fullColDeclOptDefault(DefaultValue defaultValue)
                            | fullColDeclOptNullNotNull(NullNotNull nullNotNull)
                            ;

data InlineConstraint = inlineConstraintUnique(list[ConstraintId] constraintIdList, UniquePrimaryKey uniquePrimaryKey, list[CommonConstraintProperties] commonConstraintPropertiesList)
                        | inlineConstraintForeign(list[NullNotNull] nullNotNullList, list[ConstraintId] constraintIdList, Expr exp, ConstraintProperties constraintProperties)
                        ;

data ConstraintId = constraintId(Identifier id);

data UniquePrimaryKey = uniquePrimaryKeyOpt1()
                        | uniquePrimaryKeyOpt2()
                        ;

data CommonConstraintProperties = enforcedConstraintProp(EnforcedNotEnforced enforcedNotEnforced, list[ValidateNoValidate] validateNoValidateList)
                                    | defferableConstraintProp(DeferrableNotDeferrable deferrableNotDeferrable)
                                    | initiallyConstraintProp(InitiallyDeferredOrImmediate initiallyDeferredOrImmediate)
                                    | enableConstraintProp(EnableDisable enableDisable, list[ValidateNoValidate] validateNoValidateList)
                                    | relyConstraintProp()
                                    | norelyConstraintProp()
                                    ;


 data EnforcedNotEnforced = enforcedNotEnforced(list[Not] notOpt)
                             ;

data DeferrableNotDeferrable = deferrableNotDeferrable(list[Not] notOpt)
                               
                                ;

data ValidateNoValidate = validateNoValidateOpt1() 
                            | validateNoValidateOpt2()
                            ;

data InitiallyDeferredOrImmediate = initiallyDeferred() 
                                    | initiallyImmediate()
                                    ;


data ConstraintProperties = constraintPropStar(list[CommonConstraintProperties] commonConstraintPropertiesList)
                            | constraintPropForeign(list[ForeignKeyOnActionToggle] foreignKeyOnActionToggleList)
                            ;

data ForeignKeyOnActionToggle = foreignKeyOnActionToggleOpt1(ForeignKeyMatch foreignKeyMatch) 
                                | foreignKeyOnActionToggleOpt2(OnAction onAction) 
                                | foreignKeyOnActionToggleOpt3(OnAction onAction)
                                ;

data ForeignKeyMatch = matchFull()
                        | matchPartial()
                        | matchSimple()
                        ;

data OnAction = cascadeAction(CascadeRestrict cascadeRestrict)
                | setNullAction() 
                | setDefaultAction()
                | restrictAction()
                | noAction()
                ;


 data DefaultValue = defaultExpVal(Expr exp)
                    | autoIncrementVal(list[StartWithIncrementBy] startWithIncrementByList, list[OrderNoOrder] orderNoOrderList)
                    | identityVal(list[StartWithIncrementBy] startWithIncrementByList, list[OrderNoOrder] orderNoOrderList)
                    ;

data StartWithIncrementBy = startWithIncrementByOpt1(ExpListWithBrackets expListWithBrackets) 
                            | startWithIncrementByOpt2(StartWith startWith) 
                            | startWithIncrementByOpt3(IncrementBy incrementBy) 
                            | startWithIncrementByOpt4(StartWith startWith, IncrementBy incrementBy)
                            ;

data StartWith = startWithOpt1(str integer)
                    | startWithOpt2(str integer)
                    | startWithOpt3(str integer)
                    | startWithOpt4(str integer)
                    ;

data WithMaskingPolicy = withMaskingPolicy(list[WithClause] withOpt,Identifier id, list[UsingColumnList] usingColumnList)
                            ;

data CommentString = commentString(String string);

data OutOfLineConstraintOptionals = outOfLineConstraintUnique(UniquePrimaryKey uniquePrimaryKey, ExpListWithBrackets columnListWithBrackets, list[CommonConstraintProperties] commonConstraintPropertiesList)
                                    | outOfLineConstraintForeign(ExpListWithBrackets columnListWithBrackets1, Expr exp, ConstraintProperties constraintProperties)
                                    ;

data ClusterBy = clusterBy(ExpListWithBrackets expListWithBrackets);

data StageFileFormat = stageFileFormatOpt1(String string)
                        | stageFileFormatOpt2(FormatType formatType, list[Property] propList)
                        ;

data StageCopyEqCopyOptions = stageCopyEqCopyOptions(CopyOptions copyOptions);

data CopyOptions = onErrorOpts(OnErrorAction onErrorAction)
                |prop(Property prop)
                    ;

data OnErrorAction = continueAction()
                        | skipFile()
                        | skipFileInt(str integer)
                        | skipFileAbort(str integer)
                        ;



data CopyGrants = copyGrants();

data WithRowAccessPolicy = withRowAccessPolicy(list[WithClause] withOpt,Identifier id, list[Identifier] objNameOrIdList)
                            ;

data TableType = volatileType(list[LocalGlobal] localGlobalOpt)
                    | temporaryType(list[LocalGlobal] localGlobalOpt, Temporary temporary)
                    | transientType()
                    ;

data LocalGlobal = local()
                    | global()
                    ;

data Temporary = temp()
                    | temporary()
                    ;

data IfNotExistsObjectName = ifNotExistsObjectName(list[IfNotExists] ifNotExistsList, PropRef objNameOrId)
                                | objectNameIfNotExists(PropRef objNameOrId, IfNotExists ifNotExists)
                                ;

data InternalOrExternalStage = stageAtId(Identifier id)
                                | stageAtIdNoSlash(Identifier id)
                                | externallocation(ExternalLocation externalLocation)
                                ;

data ExternalLocation = externalLocationOpt1(S3OrGovAwsPath s3OrGovAwsPath)
                        | externalLocationOpt2(str uri)
                        | externalLocationOpt3(str uri)
                        ;

data S3OrGovAwsPath = s3Path(str uri)
                        | s3govPath(str uri)
                        ;

data FileFormat = fileFormat(list[Property] propList);


data BracketColumnListWithComment = bracketColumnListWithComment(ColumnListWithComment colListWithComment);
data Column = columnStr();
data ColumnListWithComment = columnListWithComment(list[ColumnNameWithComment] columnNameWithCommentList);

data ColumnNameWithComment = columnNameWithComment(PropRef objNameOrId, list[CommentString] commentStringList);

data ViewCol = viewCol(PropRef objNameOrId, WithMaskingPolicy withMaskingPolicy, WithTags withTags);

data Materialized = material();
data CopyIntoTable = copyIntoTableFromStage(PropRef objNameOrId, list[InternalOrExternalStage] internalOrExternalStageOpt,
                                list[Files] filesList, list[Pattern] patternOpt,
                                list[FileFormat] fileFormatOpt,
                                list[CopyOptions] copyOptionsList,
                                list[ValidationMode] validationModeOpt
                        )
                        ;

data Files = fileEq(list[String] stringList);

data ValidationMode = validationMode(ReturnValidationType returnValidationType);

data ReturnValidationType = returnValidationTypeOpt1(str integer) 
                            | returnValidationTypeOpt2()
                            | returnValidationTypeOpt3()
                            ;

data CreateTableLike = createTableLike(list[OrReplace] orReplaceOpt,list[TableType] ttype, TableName t1, TableName t2,
                                list[ClusterBy] clusterByList, list[CopyGrants] copyGrantsList
                        )
                       
                        ;
data Secure = secure();
data CreateView = createViewSF(list[OrReplace] orReplaceList,list[Secure] secureOpt,list[Materialized] materializedOpt, list[IfNotExists] ifNotExistsList, TableName tableName,
                                list[BracketColumnListWithComment] bracketColumnListWithComment, list[ViewCol] viewColList,
                                list[WithRowAccessPolicy] withRowAccessPolicyOpt, list[WithTags] withTagsOpt,
                                list[CopyGrants] copyGrantsOpt, list[CommentClause] commentClauseOpt,list[ClusterBy] clusterOpt,
                                QueryOrWith query
                        )
                  
                       ;



data RegionGroup = regionGroup(Identifier id);

data SnowflakeRegion = snowflakeRegion(Identifier id);


data AsReplicaOfObjectName = asReplicaOfObjectName(PropRef objNameOrId);



data CreateFailoverGroup = createFailoverGroupAsReplica(list[IfNotExists] ifNotExistsList, Identifier id, AsReplicaOfObjectName asReplicaOfObjectName)
                                | createFailoverGroupObjectTypes(list[IfNotExists] ifNotExistsOpt, Identifier id, 
                                        ObjectTypeList objectTypeList,
                                        list[AllowedDatabases] allowedDatabasesList,
                                        list[AllowedShares] allowedSharesList, 
                                        list[AllowedIntegrationTypes] allowedIntegrationTypesList,
                                        PropRef objNameOrId, 
                                        list[IgnoreEditionCheck] ignoreEditionCheckList, 
                                        list[Property] props
                                );

data AllowedDatabases = allowedDatabases(list[Identifier] idList);

data AllowedShares = allowedShares(list[Identifier] idList);

data AllowedIntegrationTypes = allowedIntegrationTypes(list[IntegrationTypeName] integrationTypeNameList);

data IntegrationTypeName =  securityIntegrations()
                                | apiIntegrations()
                                ;


 data CreateApiIntegration = apiAwsRole(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsList,Identifier identifier, list[Property] propList,
list[CommentClause] commentClauseOpt )      
                               ;

data CreateExternalFunction = createExternalFunction(list[OrReplace] orReplaceList,list[Secure] secureOpt, TableName tablename, list[ArgDataTypeList] argDataTypeList,
                                        DataType dataType, list[NullNotNull] nullNotNullList, list[CalledReturnsOrStrict] calledReturnsOrStrictOpt,
                                        list[VolatileOrImmutable] volatileOrImmutableList, list[CommentClause] commentClauselist, list[Property] propList, String string
                                        )
                                ;


data ArgDataTypeList = argDataTypeList(lrel[Identifier id, DataType dt] argDataTypeList);


data VolatileOrImmutable = volatileOpt()
                                | immutableOpt()
                                ;






data CreateExternalTable = createExternalTableAuto(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt, 
                                        TableName tableName, ExternalTableColumnDeclList externalTableColumnDeclList, 
                                        list[Property] propOpt, list[PartitionByClause] partitionByList, 
                                        LocationEqInternalOrExternalStage locationEqInternalOrExternalStage, list[RefreshOnCreate] refreshOnCreateList, 
                                        list[AutoRefresh] autoRefreshList, list[Pattern] patternList, FileFormat fileFormat, list[Property] awsSNSTopOpt, 
                                        list[CopyGrants] copyGrantsOpt, list[WithRowAccessPolicy] withRowAccessPolicyList, list[WithTags] withTagsList, list[CommentClause] commentClauseOpt
                                        )
                               
                                | createExternalTableDeltaLake(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt, 
                                        TableName tableName, ExternalTableColumnDeclList externalTableColumnDeclList, 
                                        list[Property] propOpt, list[PartitionByClause] partitionByList, 
                                        LocationEqInternalOrExternalStage locationEqInternalOrExternalStage,
                                        FileFormat FileFormat, 
                                        list[TableFormatEqDelta] tableFormatEqDeltaList, 
                                        list[CopyGrants] copyGrantsList,
                                        list[WithRowAccessPolicy] withRowAccessPolicyList, list[WithTags] withTagsList, list[CommentClause] commentClauseList
                                );


data ExternalTableColumnDeclList = externalTableColumnDeclList(list[ExternalTableColumnDecl] externalTableColumnDeclList);

data ExternalTableColumnDecl = externalTableColumnDecl(PropRef objNameOrId, DataType dataType, Expr exp, list[InlineConstraint] inlineConstraintOPT);




data LocationEqInternalOrExternalStage = withLocation(list[WithClause] withOpt,InternalOrExternalStage prop)
                                                ;

data RefreshOnCreate = refreshOnCreate(Boolean boolVal); 


data TableFormatEqDelta = tableFormatEqDelta();


data CreateNotificationIntegration = createNotification(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsList, Identifier id,
                                        list[Property] props, list[CloudProviderParamsPush] cloudProviderParamsPushOpt, list[CommentClause] commentClauseOpt
                                        )
                               ;

data CreateProcedure = createProcedureLang(list[OrReplace] orReplaceOpt,list[Secure] secureOpt, PropRef objNameOrId, list[ArgDataTypeList] argDataTypeListOpt,
                                ReturnsType returnsType, list[NullNotNull] nullNotNullOpt,Lang lang, list[CalledReturnsOrStrict] calledReturnsOrStrictList,
                                list[VolatileOrImmutable] volatileOrImmutableOpt, list[CommentClause] commentClauseOpt,
                                list[ExecuteAs] executeAsOpt, String string
                                )
   
                        ;
data Lang = sql() |js();
data ExecuteAs = executeAs(CallerOwner callerOwner);




data CreateReplicationGroup = replicationGroupAllowed(list[IfNotExists] ifNotExistsList, Identifier id, ObjectTypes objectTypes,
                                        list[AllowedDatabases] allowedDatabasesList, list[AllowedShares] allowedSharesList, list[AllowedIntegrationTypes] allowedIntegrationTypesList,
                                        PropRef objNameOrId, list[IgnoreEditionCheck] ignoreEditionCheckList, list[Property] replicationScheduleList
                                        )
                                | replicationGroupReplica(list[IfNotExists] ifNotExistsList, Identifier id, AsReplicaOfObjectName asReplicaOfObjectName
                                        );

data CreateSequence =  createSequence(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objNameOrId, list[WithClause] withOpt,
                                list[StartWith] startWithList, list[IncrementBy] incrementByList, list[OrderNoOrder] orderNoOrderList, list[CommentClause] commentClauseList
                                );



data CreateFunction = createFunction(list[OrReplace] orReplaceOpt,list[Secure] secureOpt, TableName objNameOrId, list[ArgDataTypeList] argDataTypeListOpt,
                                ReturnsType returnsType, list[NullNotNull] nullNotNullList,list[Lang] lngOpt, list[CalledReturnsOrStrict] calledReturnsOrStrictList,
                                list[VolatileOrImmutable] volatileOrImmutableList,list[str] memOpt, list[CommentClause] commentClauseOpt,  String string
                                )
 ;

data ReturnsType = returnsDataType(DataType dataType) 
                        | returnsTable(list[ColDeclList] colDeclOpt)
                        ;

data CalledReturnsOrStrict = calledOnNull()
                                | returnsNull()
                                | returnsStrict()
                                ;

data ColDeclList = colDeclList(list[ColDecl] colDeclList);


data Call = callClause(PropRef objNameOrId, list[ExpList] expListList);

data Statement =  dropAlertCommand(Identifier id)
                    | dropConnectionCommand(list[IfExists] ifExistsOpt, Identifier id)
                    | dropObjectCommand(list[ObjectType] objectTypeOpt,list[ObjectTypeName] objectTypeNameOpt, list[IfExists] ifExists, IdentifierType idType, list[CascadeRestrict] cascadeRestrictList)
                    | dropTableWithCascade(list[IfExists] ifExistsList, TableName tableName, list[CascadeRestrict] cascadeRestrictList)
                    | dropDynamicTableCommand(Identifier id)
                    | dropExternalTableCommand(list[IfExists] ifExistsList, TableName tablename, list[CascadeRestrict] cascadeRestrictList)
                    | dropFailoverGroupCommand(list[IfExists] ifExistsList, Identifier id)
                    | dropFunctionCommand(list[IfExists] ifExistsList, TableName tablename, ArgTypes argTypes)
                    | dropManagedAccountCommand(Identifier id)
                    | dropMaterializedViewsCommand(list[IfExists] ifExistsList, TableName tablename)
                    | dropReplicationGroupCommand(list[IfExists] ifExistsList, Identifier id)
                    | dropResourceMonitorCommand(Identifier id)
                    | dropShareCommand(Identifier id)
                    | dropProcedureCommand(list[IfExists] ifExistsList, TableName tableName, ArgTypes argTypes)
               ;

data ArgTypes = argTypes(list[DataTypeList] dataTypeList);

data CascadeRestrict = cascadeRestrictOpt1()
                        | cascadeRestrictOpt2()
                        ;


data IntegrationsOptionals = apiIntegrationsOpt()
                                    | notificationIntegrationsOpt() 
                                    | securityIntegrationsOpt()
                                    | storageIntegrationsOpt()
                                    ;

data Statement = undropObjectCommand(ObjectTypeName objType,PropRef idname)
                   
                        ;

 data Statement =       copyIntoTableCommand(CopyIntoTable copyIntoTable)
                    | beginTransactionCommand(BeginTransaction beginTransaction,list[WorkOrTransaction] wotOpt,list[NameId] nidOpt)
                    | copyIntoLocationCommand(CopyIntoLocation copyIntoLocation)
                    | commentCommand(Comment comment)
                    | commitCommand(Commit commit) 
                    | executeImmediateCommand(Expr exp, list[UsingColumnList] usingColumnList)
                    | executeTaskCommand(PropRef objNameOrId)
                    | getDMLCommand(InternalOrExternalStage internalOrExternalStage, FilePath filePath, list[Property] parallelList, list[Pattern] patternList)
                    | listCommand(InternalOrExternalStage internalOrExternalStage, list[Pattern] patternList)
                    | removeCommand(InternalOrExternalStage internalOrExternalStage, list[Pattern] patternList)
                    | setCommand(SetUnset setCom)
               
                    | truncateMaterializedViewCommand(PropRef objNameOrId)
                    | revokeRoleCommand(RoleName roleName, RoleOrUser roleOrUser)
                    | callCommand(Call call)
                    | putCommand(FilePath filePath, InternalOrExternalStage internalOrExternalStage,
                        list[Property] propList
                        )
                    | rollbackCommand(Rollback rollback)
                    ;

data FailOrRep = failover()
                | replication()
                ;

data Statement = showAlertsCommand(ShowAlerts showAlerts)
                    | showChannelsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showColumnsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showConnectionsCommand(list[LikePattern] likePatternOpt)
                    | showDatabasesCommand(ShowDatabases showDatabases)
                    | showDatabasesInFailoverGroupCommand(FailOrRep failorrep,Identifier id)
                    | showDatabasesInReplicationGroupCommand(Identifier id)
                    | showDelegatedAuthorizationsCommand(list[ShowDelegatedAuthorizations] showDelegatedAuthorizations,list[Identifier] idOpt)
                    | showDynamicTablesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)
                    | showEventTablesCommand(ShowEventTables showEventTables)
                    | showExternalFunctionsCommand(list[LikePattern] likePatternOpt)
                    | showExternalTablesCommand(ShowExternalTables showExternalTables)
                    | showFailoverGroupsCommand(list[InShowOptionals] inShowOptionalsList)
                    | showFileFormatsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showFunctionsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showGlobalAccountsCommand(list[LikePattern] likePatternOpt)
                    | showGrantsCommand(ShowGrants showGrants)
                    | showIntegrationsCommand(list[IntegrationsOptionals] integrationsOptionalsList, list[LikePattern] likePatternOpt)
                    | showLocksCommand(list[InAccount] inAccountList)
                    | showManagedAccountsCommand(list[LikePattern] likePatternOpt)
                    | showMaskingPoliciesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showMaterializedViewsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showNetworkPoliciesCommand()
                    | showObjectsCommand(list[LikePattern] likePatternOpt, list[ShowOptionals] showOptionalsList)
                    | showOrganizationAccountsCommand(list[LikePattern] likePatternOpt)
                    | showParametersCommand(list[LikePattern] likePatternOpt, list[InOrForShowParameter] inOrForShowParameterList)
                    | showPipesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showPrimaryKeysCommand(ShowPrimaryKeys showPrimaryKeys)
                    | showProceduresCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showRegionsCommand(list[LikePattern] likePatternOpt)
                    | showReplicationAccountsCommand(list[LikePattern] likePatternOpt)
                    | showReplicationDatabasesCommand(list[LikePattern] likePatternOpt, list[WithPrimaryColName] withPrimaryColNameList)
                    | showReplicationGroupsCommand(list[InShowOptionals] inShowOptionalsList)
                    | showResourceMonitorsCommand(list[LikePattern] likePatternOpt)
                    | showRolesCommand(list[LikePattern] likePatternOpt)
                    | showRowAccessPoliciesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showSchemasCommand(ShowSchemas showSchemas)
                    | showSequencesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showSessionPoliciesCommand()
                    | showSharesCommand(list[LikePattern] likePatternOpt)
                    | showSharesInFailoverGroupCommand(FailOrRep forep,Identifier id)
                    | showSharesInReplicationGroupCommand(Identifier id)
                    | showStagesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showStreamsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showTablesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showTagsCommand(list[LikePattern] likePatternOpt, list[ShowTagsOptionals] showTagsOptionalsList)
                    | showTasksCommand(ShowTasks showTasks)
                    | showTransactionsCommand(list[InAccount] inAccountList)
                    | showUserFunctionsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)
                    | showUsersCommand(ShowUsers showUsers)
                    | showVariablesCommand(list[LikePattern] likePatternOpt)
                    | showViewsCommand(ShowViews showViews)
                    | showWareHousesCommand(list[LikePattern] likePatternOpt)
                    ;

data ShowAlerts = showAlerts(list[Terse] terseOpt,list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList);

data LikePattern = likePattern(String string);

data Terse = terse();
data InShowOptionals = inShowOptionals(ShowOptionals showOptionals);

data ShowOptionals = accountIdShowOpt(list[Identifier] idList)
                            | databaseIdShowOpt(list[Identifier] idList)
                            | tableNameShowOpt(list[PropRef] objNameOrIdList)
                            | viewNameShowOpt(list[PropRef] objNameOrIdList)
                            | schemaNameShowOpt(list[PropRef] objNameOrIdList)
                            | objNameShowOpt(PropRef objNameOrId)
                            ;

data StartsWith = startsWith(String string);

data LimitRows = limitRows(str integer, list[String] stringList);

// data FromString = fromString(String string);

data ShowDatabases = showDatabasesOpt1(list[Terse] terse, list[str] hist,list[LikePattern] likePatternList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)
                       ;

data ShowDelegatedAuthorizations = 
                                     showDelegatedAuthorizationsByUser()
                                    | showDelegatedAuthorizationsToSecurity()
                                    ;

data ShowEventTables = showEventTables(list[Terse] terse, list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList);

data ShowExternalTables = showExternalTables(list[Terse] terseOpt,list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)
                                ;

data ShowGrants = showGrantsOptionals(list[ShowGrantOptionals] showGrantOptionalsList)
                    | showGrantsInSchema(PropRef objNameOrId)
                    | showGrantsInDatabase(Identifier id)
                    ;

data ShowGrantOptionals = onAccountShowGrantOpt()
                            | onObjectNameShowGrantOpt(ObjectType objectType, PropRef objNameOrId)
                            | toRoleShareShowGrantOpt(RoleUserOrShareId roleUserOrShareId)
                            | ofRoleShowGrantOpt(Identifier id)
                            | ofShareShowGrantOpt(Identifier id)
                            ;

data RoleUserOrShareId = roleId(ObjectTypeName objectTypeName, Identifier id);

data InAccount = inAccount();

data InOrForShowParameter = inOrForShowParameter(InOrFor inOrFor, ShowParameterOptionals showParameterOptionals);

data InOrFor = inOrForOpt1()
                | inOrForOpt2()
                ;
 
data ShowParameterOptionals = sessionShowParameterOpt()
                                | accountShowParameterOpt()
                                | userIdShowParameterOpt(list[Identifier] idList)
                                | paramObjShowParameterOpt(ShowParameterObjects showParameterObjects) 
                                | tableNameShowParameterOpt(PropRef objNameOrId)
                                ;

data ShowParameterObjects = warehouseIdShowParameterObj(list[Identifier] idList)
                                | databaseidShowParameterObj(list[Identifier] idList)
                                | schemaIdShowParameterObj(list[Identifier] idList)
                                | taskIdShowParameterObj(list[Identifier] idList)
                                ;

data ShowPrimaryKeys = showPrimaryKeys(list[Terse] terseOpt,list[InShowOptionals] inShowOptionalsList)
                        ;

data WithPrimaryColName = withPrimaryColName(PropRef objNameOrId);

data ShowSchemas = showSchemasOpt1(list[Terse] terseOpt,list[str] histOpt,list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)
                      ;

data ShowTagsOptionals = inAccountShowTagsOpt(InAccount inAccount)
                            | databaseIdShowTagsOpt(list[Identifier] idList)
                            | schemaIdShowTagsOpt(list[Identifier] idList)
                            | idShowTagsOpt(Identifier id)
                            ;

data ShowTasks = showTasks(list[Terse] terseOpt,list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)
                        ;

data ShowUsers = showUsers(list[Terse] terseOpt,list[LikePattern] likePatternList, list[StartsWith] startsWithList, list[LimitInt] limitIntList, list[String] stringList)
                        ;

data LimitInt = limitInt(str integer);

data ShowViews = showViews(list[Terse] terse,list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)
                        ;

data Statement = useObjectCommand(ObjectTypeName objType, Expr exp)
                   
                    | useSecondaryRolesCommand(AllOrNone allOrNone)
            
                    ;


data AllOrNone = allOrNoneOpt1()
                | allOrNoneOpt2()
                ;

data Statement = describeAlertCommand(Describe desc, Identifier id)
                        | describeDynamicTableCommand(Describe describe, Identifier id)
                        | describeEventTableCommand(Describe describe, Identifier id)
                        | describeExternalTableCommand(Describe describe, TableName tableName, list[DescribeTableType] describeTableTypeOpt)
                        | describeMaterializedViewCommand(Describe describe, TableName tableName)
                         | describeResultCommand(DescribeResult describeResult)
                        | describeSearchOptimizationCommand(Describe describe, TableName tableName)
                        | describeTransactionCommand(Describe describe, str integer)
                        | describeObjectCommand(Describe describe,ObjectTypeName object,Expr exp, list[DescribeTableType] dtt,list[ArgTypes] atypes)
                         ;

data Describe = describeOpt1()
                | describeOpt2()
                ;

data DescribeTableType = describeTypeColumns()
                            | describeTypeStage()
                            ;

data DescribeResult = describeResultStr(Describe describe, String string)
                        | describeResultLastQuery(Describe describe)
                        ;

data BeginTransaction = beginTransaction()
                        | startTransaction()
                        ;

data WorkOrTransaction = workOrTransactionOpt1()
                            | workOrTransactionOpt2()
                            ;

data NameId = nameId(Identifier id);

data CopyIntoLocation = copyIntoLocation(InternalOrExternalStage internalOrExternalStage,
                                ObjectNameOrQuery objectNameOrQuery, list[PartitionByClause] partitionByOpt,
                                list[FileFormat] fileFormatOpt, list[CopyOptions] copyOptionOpt,
                                list[ValidationMode] validationModeMode,list[str] headerOpt
                        )

                        ;

data ObjectNameOrQuery = objectNameOrQueryOpt1(PropRef objNameOrId)
                            | objectNameOrQueryOpt2(QueryExpr query)
                            ;

data Comment = commentFuncSignature(list[IfExists] ifExistsOpt, ObjectTypeName objectTypeName, PropRef objNameOrId, list[ArgTypes] argTypesOpt, String string)
                | commentColumn(list[IfExists] ifExistsList, PropRef objNameOrId, String string)
                ;

data ObjectTypeName = roleObjectTypeName()
                        | userObjectTypeName()
                        |shareObjectTypeName()
                        | warehouseObjectTypeName()
                        | integrationObjectTypeName(list[IntegrationsOptionals] intOpt)
                        | networkObjectTypeName()
                        | sessionObjectTypeName()
                        | databaseObjectTypeName()
                        | schemaObjectTypeName()
                        | tableObjectTypeName()
                        | viewObjectTypeName()
                        | stageObjectTypeName()
                        | fileFormatObjectTypeName()
                        | streamObjectTypeName()
                        | taskObjectTypeName()
                        | maskingObjectTypeName()
                        | rowAccessObjectTypeName()
                        | tagObjectTypeName()
                        | pipeObjectTypeName()
                        | functionObjectTypeName()
                        | procedureObjectTypeName()
                        | sequenceObjectTypeName()
                        ;

data Commit = commitClause()
                | commitClauseNoWork()
                ;





data RoleName = idRoleName(Identifier id)
                ;

data RoleOrUser = roleOrUserOpt1(ObjectTypeName objectName ,RoleName roleName)
                    ;

data SystemDefinedRole = orgAdminDefinedRole()
                            | accountAdminDefinedRole()
                            | securityAdminDefinedRole()
                            | userAdminDefinedRole()
                            | sysAdminDefinedRole()
                            | publicDefinedRole()
                            ;




data FilePath = filePath1(str uri)
                | filePath2(str windowsPath)
                ;

data Literal = integer(str integer)
                | long(str long)
                | decimal(str unsigneddecimal)
                | string(str string)
                ;

data Rollback = rollback(list[str] work)
               
                ;