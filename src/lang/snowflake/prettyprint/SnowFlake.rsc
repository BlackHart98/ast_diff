module lang::snowflake::prettyprint::SnowFlake

import lang::snowflake::ast::SnowFlake;
extend lang::basesql::prettyprint::BaseSQL;
import List;
import String;

public str toString(Expr::plusExp(Expr Expr)) = "+ <toString(Expr)>";
public str toString(Expr::functionCallExp(FunctionCall functionCall)) = "<toString(functionCall)>";
public str toString(Expr::arrayAccess(Expr exp1, Expr exp2)) = "<toString(exp1)> [ <toString(exp2)> ]";
public str toString(Expr::arrayExp(ArrayLiteral arrayLiteral)) = "<toString(arrayLiteral)>";
public str toString(Expr::jsonAccess(Expr exp1, Expr exp2)) = "<toString(exp1)> : <toString(exp2)>";
public str toString(Expr::jsonLiteral(JsonLiteral jsonLiteral)) = "<toString(jsonLiteral)>";
public str toString(Expr::expCollateString(Expr Expr, String string)) = "<toString(Expr)> COLLATE <toString(string)>";
public str toString(Expr::castExp(Expr Expr, DataType dataType)) = "<toString(Expr)> :: <toString(dataType)>";
public str toString(Expr::overClauseExp(Expr Expr, OverClause overClause)) = "<toString(Expr)> <toString(overClause)>";
public str toString(Expr::tryCastExp(TryCastExp tryCastExp)) = "<toString(tryCastExp)>";
public str toString(Expr::iffExp(IffExp iffExp)) = "<toString(iffExp)>";
public str toString(Expr::expNotBetween(Expr exp1, Expr exp2)) = "<toString(exp1)> NOT BETWEEN <toString(exp2)>";
public str toString(Expr::expNotInList(Expr Expr,list[Not]not, ExpList expList)) = "<toString(Expr)> <intercalate("", [ toString(notWrd) | notWrd <- not ])> IN ( <toString(expList)> )";
public str toString(Expr::expNotIlikeEscape(Expr exp1,list[Not] not, LikeIlike likeIlike, Expr exp2, list[EscapeExp] escapeExpList)) = "<toString(exp1)> <intercalate("", [ toString(notWrd) | notWrd <- not ])>  <toString(likeIlike)> <toString(exp2)> <intercalate("", [ toString(escapeExp) | escapeExp <- escapeExpList ])>";
public str toString(Expr:: expNotRlike(Expr exp1,list[Not] not, Expr exp2)) = "<toString(exp1)> <intercalate("", [ toString(notWrd) | notWrd <- not ])> RLIKE <toString(exp2)>";

public str toString(JsonLiteral::jsonKvPair(list[KvPair] kvPair)) = "{ <intercalate(", ", [ toString(kv) | kv <- kvPair ])> }";

public str toString(IffExp::iffExpression(Expr searchCondition, Expr exp1, Expr exp2)) = "IFF ( <toString(searchCondition)>, <toString(exp1)>, <toString(exp2)> )";

public str toString(KvPair::kvPair(String string, Expr exp)) = "<toString(string)> : <toString(exp)>";

public str toString(LikeIlike::like()) = "LIKE";
public str toString(LikeIlike::ilike()) = "ILIKE";

public str toString(FunctionCall::rankingWindowedFunc(RankingWindowedFunction rankingWindowedFunction)) = "<toString(rankingWindowedFunction)>";
public str toString(FunctionCall::aggregateFunc(AggregateFunction aggregateFunction)) = "<toString(aggregateFunction)>";
public str toString(FunctionCall::listOpFunc(ListOperator listOperator, ExpList expList)) = "<toString(listOperator)> ( <toString(expList)> )";
public str toString(FunctionCall::binaryOrTernaryBuiltInFunc(BinaryOrTernaryBuiltInFunction binaryOrTernaryBuiltInFunction, ExpList expList)) = "<toString(binaryOrTernaryBuiltInFunction)> ( <toString(expList)> )";

public str toString(RankingWindowedFunction::rankDenseRowNumberFunc(RankDenseRowNumber rankDenseRowNumber, OverClause overClause)) = "<toString(rankDenseRowNumber)> () <toString(overClause)>";
public str toString(RankingWindowedFunction::ntileFunc(Expr Expr, OverClause overClause)) = "NTILE ( <toString(Expr)> ) <toString(overClause)>";
public str toString(RankingWindowedFunction::leadOrLagFunc(LeadOrLag leadOrLag, list[ExpList] expList, list[IgnoreOrRepectNulls] ignoreOrRepectNullsList, OverClause overClause)) = "<toString(leadOrLag)> ( <intercalate("", [ toString(exp) | exp <- expList ])> ) <intercalate("", [ toString(ignoreOrRepectNulls) | ignoreOrRepectNulls <- ignoreOrRepectNullsList ])> <toString(overClause)>";
public str toString(RankingWindowedFunction::firstValueOrLastValueFunc(FirstValueOrLastValue firstValueOrLastValue, Expr Expr, list[IgnoreOrRepectNulls] ignoreOrRepectNulls, OverClause overClause)) = "<toString(firstValueOrLastValue)> ( <toString(Expr)> ) <intercalate("", [ toString(ignoreOrRepect) | ignoreOrRepect <- ignoreOrRepectNulls ])> <toString(overClause)>";

public str toString(OverClause::overPartitionBy(list[PartitionByClause] partitionByOpt, list[OrderByClause] orderByClauseList)) = "OVER ( <intercalate("", [ toString(partitionBy) | partitionBy <- partitionByOpt ])> <intercalate("", [ toString(orderByClause) | orderByClause <- orderByClauseList ])> )";

public str toString(ExpList::expList(list[Expr] expList)) = "<intercalate(", ", [ toString(exp) | exp <- expList ])>";

public str toString(LeadOrLag::lead()) = "LEAD";
public str toString(LeadOrLag::lag()) = "LAG";

public str toString(AggregateFunction::idDistinct(PropRef fName, list[ExpList] expList)) = "<toString(fName)> ( DISTINCT <intercalate("", [ toString(exp) | exp <- expList ])> )";
public str toString(AggregateFunction::idStar(PropRef fName)) = "<toString(fName)> ( * )";
public str toString(AggregateFunction::idNoDistinct(PropRef fName, list[Expr] exprs)) = "<toString(fName)> ( <intercalate(", ", [ toString(exp) | exp <- exprs ])> )";
public str toString(AggregateFunction::listOrArrayAggNoDistinct(ListAggOrArrayAgg listAggOrArrayAgg, list[Expr] exprs, list[WithinGroupOrder] withinGroupOrderList)) = "<toString(listAggOrArrayAgg)> ( <intercalate(", ", [ toString(exp) | exp <- exprs ])> ) <intercalate("", [ toString(withinGroupOrder) | withinGroupOrder <- withinGroupOrderList ])>";
public str toString(AggregateFunction::listOrArrayAgg(ListAggOrArrayAgg listAggOrArrayAgg, list[Expr] exprs, list[WithinGroupOrder] withinGroupOrderList)) = "<toString(listAggOrArrayAgg)> ( DISTINCT <intercalate(", ", [ toString(exp) | exp <- exprs ])> ) <intercalate("", [ toString(withinGroupOrder) | withinGroupOrder <- withinGroupOrderList ])>";

public str toString(IdentifierType::identifierTypeOpt1(BinaryOrTernaryBuiltInFunction binaryOrTernaryBuiltInFunction)) = "<toString(binaryOrTernaryBuiltInFunction)>";
public str toString(IdentifierType::identifierTypeOpt2(PropRef name)) = "<toString(name)>";

public str toString(BinaryOrTernaryBuiltInFunction::ifNullBuiltInFunction()) = "IFNULL";
public str toString(BinaryOrTernaryBuiltInFunction::nvlBuiltInFunction()) = "NVL";
public str toString(BinaryOrTernaryBuiltInFunction::getBuiltInFunction()) = "GET";
public str toString(BinaryOrTernaryBuiltInFunction::leftBuiltInFunction()) = "LEFT";
public str toString(BinaryOrTernaryBuiltInFunction::rightBuiltInFunction()) = "RIGHT";
public str toString(BinaryOrTernaryBuiltInFunction::datePartBuiltInFunction()) = "DATE_PART";
public str toString(BinaryOrTernaryBuiltInFunction::splitBuiltInFunction()) = "SPLIT";
public str toString(BinaryOrTernaryBuiltInFunction::nullIfBuiltInFunction()) = "NULLIF";
public str toString(BinaryOrTernaryBuiltInFunction::equalNullBuiltInFunction()) = "EQUAL_NULL";
public str toString(BinaryOrTernaryBuiltInFunction::containsBuiltInFunction()) = "CONTAINS";
public str toString(BinaryOrTernaryBuiltInFunction::collateBuiltInFunction()) = "COLLATE";
public str toString(BinaryOrTernaryBuiltInFunction::toDateBuiltInFunction()) = "TO_DATE";
public str toString(BinaryOrTernaryBuiltInFunction::dateBuiltInFunction()) = "DATE";
public str toString(BinaryOrTernaryBuiltInFunction::charIndexBuiltInFunction()) = "CHARINDEX";
public str toString(BinaryOrTernaryBuiltInFunction::replaceBuiltInFunction()) = "REPLACE";
public str toString(BinaryOrTernaryBuiltInFunction::substringBuiltInFunction()) = "SUBSTRING";
public str toString(BinaryOrTernaryBuiltInFunction::substrBuiltInFunction()) = "SUBSTR";
public str toString(BinaryOrTernaryBuiltInFunction::likeBuiltInFunction()) = "LIKE";
public str toString(BinaryOrTernaryBuiltInFunction::ilikeBuiltInFunction()) = "ILIKE";

public str toString(AsAlias::asAlias(Identifier id)) = "AS <toString(id)>";

public str toString(SnowFlakeBatch::snowFlakeBatch(list[Statement] sqlCommandList)) = "<intercalate(";\n", [ toString(sqlCommand) | sqlCommand <- sqlCommandList ])>;";

public str toString(Statement::createTaskCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objectNameOrId, 
                     list[TaskParameters] taskParametersList, list[CommentClause] commentClauseList, list[CopyGrants] copyGrantsList,
                        list[AfterColumnList] afterColumnList, list[WhenSearchCondition] whenSearchCondition, Statement Statement
                      )) 
                    = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> TASK <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(objectNameOrId)> <for(taskParameters <- taskParametersList) {><toString(taskParameters)> <}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}> <for(copyGrants <- copyGrantsList) {><toString(copyGrants)><}> <for(afterColumn <- afterColumnList) {><toString(afterColumn)><}> <for(whenSearchCond <- whenSearchCondition) {><toString(whenSearchCond)><}> AS <toString(Statement)>";

public str toString(Statement::createAlertCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef ids,
                                list[Property] props, AlertCondition alertCondition, Statement Statement
                        )) 
                    = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> ALERT <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(ids)> <intercalate(" ", [ toString(prop) | prop <- props ])> IF ( EXISTS ( <toString(alertCondition)> ) ) THEN <toString(Statement)>";

public str toString(Identifier::withDollar(Identifier id1, Identifier id2)) = "<toString(id1)> $ <toString(id2)>";

public str toString(AfterColumnList::afterColumnList(list[ColumnList] columnList)) = "AFTER <intercalate(" ", [ toString(column) | column <- columnList ])>";

public str toString(WhenSearchCondition::whenSearchCondition(Expr searchCondition)) = "WHEN <toString(searchCondition)>";

public str toString(TaskParameters::taskParam(list[Property] propsList)) = "<intercalate(", ", [ toString(props) | props <- propsList ])>";

public str toString(AlterAlert::alterAlertAction(list[IfExists] ifExistsList, Identifier id, Statement sqlCommand)) = "ALTER ALERT <intercalate("", [ toString(ifExists) | ifExists <- ifExistsList ])> <toString(id)> MODIFY ACTION <toString(sqlCommand)>";

public str toString(Statement::explainCommand(list[UsingExplainOpts] usingExplainOptsList, Statement sqlCommand)) = "EXPLAIN <intercalate("", [ toString(usingExplainOpts) | usingExplainOpts <- usingExplainOptsList ])> <toString(sqlCommand)>";

public str toString(UsingExplainOpts::usingExplainOpts(ExplainOpts explainOpts)) = "USING <toString(explainOpts)>";

public str toString(ExplainOpts::tabularExplainOpt()) = "TABULAR";
public str toString(ExplainOpts::jsonExplainOpt()) = "JSON";
public str toString(ExplainOpts::textExplainOpt()) = "TEXT";

public str toString(Literal::boolean(Boolean boolVal)) = "<toString(boolVal)>";
public str toString(Literal::null()) = "NULL";

public str toString(Expr::boolean(Boolean boolVal)) = "<toString(boolVal)>";
public str toString(Expr::null()) = "NULL";

public str toString(UsingColumnList::usingColumnList(Columns columnList)) = "USING <toString(columnList)>";

public str toString(AtBefore::atTimeStamp(Expr exp)) = "AT( TIMESTAMP =\>  <toString(exp)> )";
public str toString(AtBefore::atOffset(Expr exp)) = "AT( OFFSET =\>  <toString(exp)> )";
public str toString(AtBefore::atStatement(String string)) = "AT( STATEMENT =\>  <toString(string)> )";
public str toString(AtBefore::atStream(String string)) = "AT( STREAM =\>  <toString(string)> )";
public str toString(AtBefore::beforeStatement(String string)) = "BEFORE( STATEMENT =\> <toString(string)> )";

public str toString(Changes::changes(DefaultAppendOnly defaultAppendOnly, AtBefore atBefore, list[End] endList)) = "CHANGES( INFORMATION =\> <toString(defaultAppendOnly)> ) <toString(atBefore)> <for(endIn <- endList) {> <toString(endIn)> <}>";

public str toString(DefaultAppendOnly::defaultNoAppendOnly()) = "DEFAULT";

public str toString(DefaultAppendOnly::appendOnly()) = "APPEND ONLY";

public str toString(End::endTimeStampString(String string)) = "END( TIMESTAMP -\> <toString(string)> )";

public str toString(End::endOffset(String string)) = "END( OFFSET -\> <toString(string)> )";
public str toString(End::endStatement(Identifier id)) = "END( STATEMENT -\> <toString(id)> )";

public str toString(PartitionBy::partitionBy(ExpList expList)) = "PARTITION BY <toString(expList)>";

public str toString(ExpAsAlias::expAsAlias(Expr exp, AsAlias asAlias)) = "<toString(exp)> <toString(asAlias)>";

public str toString(ExpAsAliasList::expAsAliasList(list[ExpAsAlias] expAsAliasList)) = "<intercalate(", ", [ toString(expAsAlias) | expAsAlias <- expAsAliasList ])>";

public str toString(WithinGroupOrder::withinGroupOrder(OrderByClause orderByClause)) = "WITHIN GROUP ( <toString(orderByClause)> )";


public str toString(IgnoreOrRepectNulls::ignoreOrRepectNulls(IgnoreOrRespect ignoreOrRespect)) = "<toString(ignoreOrRespect)> NULLS";

public str toString(IgnoreOrRespect::ignore()) = "IGNORE";

public str toString(IgnoreOrRespect::respect()) = "RESPECT";

public str toString(FirstValueOrLastValue::firstValue()) = "FIRST_VALUE";
public str toString(FirstValueOrLastValue::lastValue()) = "LAST_VALUE";

public str toString(ExpListWithBrackets::expListWithBrackets(ExpList expList)) = "( <toString(expList)> )";

public str toString(RankDenseRowNumber::rank()) = "RANK";
public str toString(RankDenseRowNumber::denseRank()) = "DENSE_RANK";
public str toString(RankDenseRowNumber::rowNumber()) = "ROW_NUMBER";

public str toString(TableName::sfRef(Identifier id1,Identifier id2, list[Identifier] ids)) = "<toString(id1)>.<toString(id2)>.<intercalate(".", [ toString(id) | id <- ids ])>";

public str toString(ListAggOrArrayAgg::listAgg()) = "LISTAGG";
public str toString(ListAggOrArrayAgg::arrayAgg()) = "ARRAY_AGG";

public str toString(ListOperator::concat()) = "CONCAT";
public str toString(ListOperator::concatWS()) = "CONCAT_WS";
public str toString(ListOperator::coalesce()) = "COALESCE";

public str toString(DataType::numberAlias(NumberAlias numberAlias)) = "<toString(numberAlias)>";
public str toString(DataType::varCharAlias(VarCharAlias varCharAlias, list[DataTypeSize] dataTypeSizeList)) = "<toString(varCharAlias)> <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::dateTimeDataType(list[DataTypeSize] dataTypeSizeList)) = "DATETIME <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeDataType(list[DataTypeSize] dataTypeSizeList)) = "TIME <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeStampDataType(list[DataTypeSize] dataTypeSizeList)) = "TIMESTAMP <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeStamp_LTZ(list[DataTypeSize] dataTypeSizeList)) = "TIMESTAMP_LTZ <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeStampLTZ(list[DataTypeSize] dataTypeSizeList)) = "TIMESTAMPLTZ <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeStamp_NTZ(list[DataTypeSize] dataTypeSizeList)) = "TIMESTAMP_NTZ <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeStampNTZ(list[DataTypeSize] dataTypeSizeList)) = "TIMESTAMPNTZ <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeStamp_TZ(list[DataTypeSize] dataTypeSizeList)) = "TIMESTAMP_TZ <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::timeStampTZ(list[DataTypeSize] dataTypeSizeList)) = "TIMESTAMPTZ <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::charAlias(CharAlias charAlias, list[DataTypeSize] dataTypeSizeList)) = "<toString(charAlias)> <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::binaryAlias(BinaryAlias binaryAlias, list[DataTypeSize] dataTypeSizeList)) = "<toString(binaryAlias)> <for(dataTypeSize <- dataTypeSizeList) {> <toString(dataTypeSize)><}>";
public str toString(DataType::variantDataType()) = "VARIANT";
public str toString(DataType::objectDataType()) = "OBJECT";
public str toString(DataType::arrayDataType()) = "ARRAY";
public str toString(DataType::geographyDataType()) = "GEOGRAPHY";
public str toString(DataType::geometryDataType()) = "GEOMETRY";

public str toString(DataTypeList::dataTypeList(list[DataType] dataType)) = "<intercalate(", ", [ toString(dataTp) | dataTp <- dataType ])>";

public str toString(PrimitiveType::integerType()) = "INTEGER";
public str toString(PrimitiveType::realType()) = "REAL";
public str toString(PrimitiveType::float4Type()) = "FLOAT4";
public str toString(PrimitiveType::float8Type()) = "FLOAT8";
public str toString(PrimitiveType::byteIntType()) = "BYTEINT";

public str toString(NumberAlias::numberType(list[ExpListWithBrackets] expListWithBrackets)) = "NUMBER <for(intWithBracket <- expListWithBrackets) {> <toString(intWithBracket)><}>";
public str toString(NumberAlias::numericType(list[ExpListWithBrackets] expListWithBrackets)) = "NUMERIC <for(intWithBracket <- expListWithBrackets) {> <toString(intWithBracket)><}>";
public str toString(NumberAlias::decimalType(list[ExpListWithBrackets] expListWithBrackets)) = "DECIMAL <for(intWithBracket <- expListWithBrackets) {> <toString(intWithBracket)><}>";

public str toString(VarCharAlias::charVarying()) = "CHAR VARYING";
public str toString(VarCharAlias::ncharVarying()) = "NCHAR VARYING";
public str toString(VarCharAlias::nvarchar2()) = "NVARCHAR2";
public str toString(VarCharAlias::nvarchar()) = "NVARCHAR";
public str toString(VarCharAlias::stringVarChar()) = "STRING";
public str toString(VarCharAlias::textVarChar()) = "TEXT";

public str toString(DataTypeSize::dataTypeSize(str integer)) = "( <integer> )";

public str toString(CharAlias::ncharType()) = "NCHAR";

public str toString(CharAlias::characterType()) = "CHARACTER";

public str toString(BinaryAlias::binaryType()) = "BINARY";

public str toString(BinaryAlias::varBinaryType()) = "VARBINARY";

public str toString(TryCastExp::tryCastExpression(Expr exp, DataType dataType)) = "TRY_CAST( <toString(exp)> AS <toString(dataType)> )";

public str toString(EscapeExp::escapeExp(Expr exp)) = "ESCAPE <toString(exp)>";

public str toString(NullNotNull::nullNotNull(list[Not] notOpt)) = "<intercalate("", [ toString(not) | not <- notOpt ])> NULL";

public str toString(ArrayLiteral::arrayExpList(list[ExpList] expList)) = "[ <intercalate(", ", [ toString(exp) | exp <- expList ])> ]";

public str toString(QueryExpr::querySnowflake(QuerySnowflake querySnowflake)) = "<toString(querySnowflake)>";
public str toString(QueryExpr::queryExcept(QueryExpr qryexpr1, Except except, QueryExpr qryexpr2)) = "<toString(qryexpr1)> <toString(except)> <toString(qryexpr2)>";
public str toString(QueryExpr::queryMinus(QueryExpr qryexpr1, Minus minus, QueryExpr qryexpr2)) = "<toString(qryexpr1)> <toString(minus)> <toString(qryexpr2)>";

public str toString(Except::except()) = "EXCEPT";

public str toString(Minus::minus()) = "MINUS";

public str toString(Expr::subQuery(QueryExpr query)) = "<toString(query)>";

public str toString(QuerySnowflake::query(
        SelectClause selectclause
        , list[IntoClause] intoclauseOpt
        , list[FromClause] fromOpt
        , list[JoinClause] joinList
        , list[WhereClause] whereOpt
        , list[GroupByClause] groupOpt
        , list[HavingClause] havingOpt
        , list[QualifyClause] qualifyOpt
        , list[OrderByClause] orderByOpt
        , list[LimitOffsetClauses] limitOpt)) 
        = "<toString(selectclause)> <for(intoClause <- intoclauseOpt) {><toString(intoClause)><}> <for(fromClause <- fromOpt) {><toString(fromClause)><}> <intercalate(" ", [ toString(joinCls) | joinCls <- joinList ])> <for(whereClause <- whereOpt) {><toString(whereClause)><}> <for(groupByClause <- groupOpt) {><toString(groupByClause)><}> <intercalate("", [ toString(havingCls) | havingCls <- havingOpt ])> <for(qualifyClause <- qualifyOpt) {><toString(qualifyClause)><}> <for(orderByClause <- orderByOpt) {><toString(orderByClause)><}> <for(limitClause <- limitOpt) {><toString(limitClause)><}>";

public str toString(IntoClause::intoClause(VarList varList)) = "INTO <toString(varList)>";

public str toString(VarList::varList(list[Identifier] idList)) = "<for(id <- idList) {>:<toString(id)>, <}>";

public str toString(MatchRecognize::matchRecognize(list[PartitionBy] partitionByList, list[OrderElem] orderElemList, list[Measures] measuresList, 
                        list[RowMatch] rowMatchList, list[AfterMatch] afterMatchList, list[Pattern] patternList, list[Define] defineList)) 
                        = "MATCH_RECOGNIZE ( <for(partitionBy <- partitionByList) {><toString(partitionBy)><}> <for(orderElem <- orderElemList) {><toString(orderElem)><}> <for(measures <- measuresList) {><toString(measures)><}> <for(rowMatch <- rowMatchList) {><toString(rowMatch)><}> <for(afterMatch <- afterMatchList) {><toString(afterMatch)><}> <for(pattern <- patternList) {><toString(pattern)><}> <for(define <- defineList) {><toString(define)><}> )";

public str toString(Measures::measures(ExpAsAliasList expAsAliasList)) = "MEASURES <toString(expAsAliasList)>";

public str toString(RowMatch::oneRow(list[MatchOptions] matchOptionsList)) = "ONE ROW PER MATCH <for(matchOptions <- matchOptionsList) {><toString(matchOptions)><}>";

public str toString(RowMatch::allRows(list[MatchOptions] matchOptionsList)) = "ALL ROWS PER MATCH <for(matchOptions <- matchOptionsList) {><toString(matchOptions)><}>";

public str toString(MatchOptions::showEmpty()) = "SHOW EMPTY MATCHES";

public str toString(MatchOptions::omitEmpty()) = "OMIT EMPTY MATCHES";

public str toString(MatchOptions::unmatchedRows()) = "WITH UNMATCHED ROWS";

public str toString(AfterMatch::afterMatchLast()) = "AFTER MATCH SKIP PAST LAST ROW";

public str toString(AfterMatch::afterMatchNext()) = "AFTER MATCH SKIP TO NEXT ROW";

public str toString(AfterMatch::aftermatchSymbol(list[FirstOrLast] firstOrLastList, Symbol symbol)) = "AFTER MATCH SKIP TO <for(firstOrLast <- firstOrLastList) {><toString(firstOrLast)><}> <toString(symbol)>";

public str toString(Symbol::symbol()) = "SYMBOL";

public str toString(Pattern::pattern(String string)) = "PATTERN = <toString(string)>";

public str toString(Define::define(SymbolList symbolList)) = "DEFINE <toString(symbolList)>";

public str toString(SymbolList::symbolList(list[SymbolAsExp] symbolAsExpList)) = "<intercalate(", ", [ toString(symbolAsExp) | symbolAsExp <- symbolAsExpList ])>";

public str toString(SymbolAsExp::symbolAsExp(Symbol symbol, Expr exp)) = "<toString(symbol)> AS <toString(exp)>";

public str toString(PivotUnpivot::pivot(FunctionCall f1, Identifier id2, list[Literal] literalList)) = "PIVOT ( <toString(f1)> FOR <toString(id2)> IN ( <intercalate(", ", [ toString(literal) | literal <- literalList ])> ) )";

public str toString(PivotUnpivot::unpivot(Identifier id, Identifier id2, Columns columnList)) = "UNPIVOT ( <toString(id)> FOR <toString(id2)> IN <toString(columnList)> )";

public str toString(String::string(str stringConstant)) = "<stringConstant>";

public str toString(Literal::integer(str integer)) = "<integer>";
public str toString(Literal::long(str long)) = "<long>";
public str toString(Literal::decimal(str unsigneddecimal)) = "<unsigneddecimal>";
public str toString(Literal::string(str string)) = "<string>";

public str toString(Expr::integer(str integer)) = "<integer>";
public str toString(Expr::long(str long)) = "<long>";
public str toString(Expr::decimal(str unsigneddecimal)) = "<unsigneddecimal>";
public str toString(Expr::string(str string)) = "<string>";

public str toString(Not::not()) = "NOT";

public str toString(PropRef::propRef(list[Identifier] identifier)) = "<intercalate(".", [ toString(id) | id <- identifier ])>";

public str toString(OrReplace::orReplace()) = "OR REPLACE";

public str toString(CommentClause::commentClause(list[AssignExpr] assExprOpt)) = "COMMENT <intercalate("", [ toString(assExpr) | assExpr <- assExprOpt ])>";

public str toString(CopyGrants::copyGrants()) = "COPY GRANTS";

public str toString(Property::property(Identifier id, AssignExpr asexpr)) = "<toString(id)> <toString(asexpr)>";

public str toString(AlertCondition::selectAlertCondition(QueryExpr selectStatement)) = "<toString(selectStatement)>";
public str toString(AlertCondition::showAlertCondition(Statement Statement)) = "<toString(Statement)>";
public str toString(AlertCondition::callAlertCondition(Call call)) = "<toString(call)>";

public str toString(Sample::sample(list[SampleMethod] sampleMethodList, SampleOpts sampleOpts)) 
  = "SAMPLE <for(sampleMethod <- sampleMethodList) {><toString(sampleMethod)><}> <toString(sampleOpts)>";
public str toString(Sample::tableSample(list[SampleMethod] sampleMethodList, SampleOpts sampleOpts)) 
  = "TABLESAMPLE <for(sampleMethod <- sampleMethodList) {><toString(sampleMethod)><}> <toString(sampleOpts)>";

public str toString(RowSampling::bernoulliSampling()) = "BERNOULLI";
public str toString(RowSampling::rowSampling()) = "ROW";

public str toString(BlockSampling::systemSampling()) = "SYSTEM";
public str toString(BlockSampling::blockSampling()) = "BLOCK";

public str toString(SampleOpts::sampleOpts(str integer, list[RepeatableSeed] repeatableSeedList)) = "( <integer> ROWS ) <for(repeatableSeed <- repeatableSeedList) {><toString(repeatableSeed)><}>";
public str toString(SampleOpts::sampleOptNoRows(str integer, list[RepeatableSeed] repeatableSeedList)) = "( <integer> ) <for(repeatableSeed <- repeatableSeedList) {><toString(repeatableSeed)><}>";
public str toString(RepeatableSeed::repeatableSeed1(str integer)) = "REPEATABLE ( <integer> )";
public str toString(RepeatableSeed::repeatableSeed2(str integer)) = "SEED ( <integer> )";

public str toString(PriorList::priorList(list[PriorItem] priorItemList)) = "<intercalate(", ", [ toString(priorItem) | priorItem <- priorItemList ])>";
public str toString(PriorItem::priorItemPriorEq(Identifier id1, Identifier id2)) = "PRIOR <toString(id1)> = <toString(id2)>";
public str toString(PriorItem::priorItemPriorEqPrior(Identifier id1, Identifier id2)) = "PRIOR <toString(id1)> = PRIOR <toString(id2)>";

public str toString(PriorItem::priorItemNoPrior(Identifier id1, Identifier id2)) = "<toString(id1)> = <toString(id2)>";
public str toString(PriorItem::priorItemEqPrior(Identifier id1, Identifier id2)) = "<toString(id1)> = PRIOR <toString(id2)>";

public str toString(ValuesTable::valuesTableWithoutParenthesis(ValuesBuilder valuesBuilder, list[AsColumnAlias] asColumnAliasList)) = "<toString(valuesBuilder)> <for(asColumnAlias <- asColumnAliasList) {><toString(asColumnAlias)><}>";
public str toString(ValuesTable::valuesTableWithParenthesis(ValuesBuilder valuesBuilder, list[AsColumnAlias] asColumnAliasList)) = "<toString(valuesBuilder)> ( <for(asColumnAlias <- asColumnAliasList) {><toString(asColumnAlias)><}> )";

public str toString(ValuesBuilder::valuesBuilder(list[ExpListWithBrackets] expListWithBrackets)) = "VALUES <intercalate(", ", [ toString(expWithBrackets) | expWithBrackets <- expListWithBrackets ])>";

public str toString(AsColumnAlias::asColumnAlias(AsAlias asAlias, list[ColumnAliasList] columnAliasList)) = "<toString(asAlias)> <for(columnAlias <- columnAliasList) {><toString(columnAlias)><}>";

public str toString(FlattenTable::flattenTable(list[InputAssociation] inputAssociationList, Expr exp, list[CommaFlattenTableOpt] commaFlattenTableOptList)) = "FLATTEN( <for(inputAssociation <- inputAssociationList) {><toString(inputAssociation)><}> <toString(exp)> <for(commaFlattenTableOpt <- commaFlattenTableOptList) {><toString(commaFlattenTableOpt)><}> )";

public str toString(InputAssociation::inputAssociation()) = "INPUT =\>";

public str toString(CommaFlattenTableOpt::commaFlattenTableOpt(FlattenTableOpt flattenTableOpt)) = ", <toString(flattenTableOpt)>";
public str toString(FlattenTableOpt::pathAssoc(String string)) = "PATH =\> <toString(string)>";
public str toString(FlattenTableOpt::outerAssoc(Boolean boolVal)) = "OUTER =\> <toString(boolVal)>";
public str toString(FlattenTableOpt::recursiveAssoc(Boolean boolVal)) = "RECURSIVE =\> <toString(boolVal)>";
public str toString(FlattenTableOpt::modeAssocArray()) = "MODE =\> \'ARRAY\'";
public str toString(FlattenTableOpt::modeAssocObj()) = "MODE =\> \'OBJECT\'";
public str toString(FlattenTableOpt::modeAssocBoth()) = "MODE =\> \'BOTH\'";

public str toString(SplitedTable::splitedTable(ExpListWithBrackets expListWithBrackets)) = "SPLIT_TO_TABLE <toString(expListWithBrackets)>";

public str toString(GroupByClause::groupByCube(ExpListWithBrackets expListWithBrackets)) = "GROUP BY CUBE <toString(expListWithBrackets)>";
public str toString(GroupByClause::groupBySets(ExpListWithBrackets expListWithBrackets)) = "GROUP BY GROUPING SETS <toString(expListWithBrackets)>";
public str toString(GroupByClause::groupByRollup(ExpListWithBrackets expListWithBrackets)) = "GROUP BY ROLLUP <toString(expListWithBrackets)>";
public str toString(GroupByClause::groupByAll()) = "GROUP BY ALL";

public str toString(QualifyClause::qualifyClause(Expr exp)) = "QUALIFY <toString(exp)>";

public str toString(TableIdOrSubquery::objectRefJoinClause(ObjectRef objectRef)) = "<toString(objectRef)>";
public str toString(TableIdOrSubquery::bracketTableItemJoined(TableIdOrSubquery tableSource)) = "( <toString(tableSource)> )";

public str toString(ObjectRef::objectRefMatchWithAlias(Identifier objNameOrId, list[IdParams] idparam)) = "<toString(objNameOrId)> <intercalate(" ", [ toString(id) | id <- idparam ])>";
public str toString(ObjectRef::objectRefConnect(Identifier objNameOrId, Expr exp, list[PriorList] priorList)) 
  = "<toString(objNameOrId)> START WITH <toString(exp)> CONNECT BY <for(prior <- priorList) {><toString(prior)><}>";
public str toString(ObjectRef::objectRefFuncCall(FunctionCall functionCall, list[PivotUnpivot] pivotUnpivotList, list[AsAlias] asAliasList, list[Sample] sampleList)) 
  = "TABLE ( <toString(functionCall)> ) <for(pivotUnpivot <- pivotUnpivotList) {><toString(pivotUnpivot)><}> <for(asAlias <- asAliasList) {><toString(asAlias)><}> <for(sample <- sampleList) {><toString(sample)><}>";

public str toString(ObjectRef::objectRefValuesTable(ValuesTable valuesTable, list[Sample] sampleList)) 
= "<toString(valuesTable)> <for(sample <- sampleList) {><toString(sample)><}>";

public str toString(ObjectRef::objectRefLateralSubQuery(QueryExpr query, list[PivotUnpivot] pivotUnpivotList, list[AsAlias] asAliasList)) 
= "LATERAL (<toString(query)>) <for(pivotUnpivot <- pivotUnpivotList) {><toString(pivotUnpivot)><}> <for(asAlias <- asAliasList) {><toString(asAlias)><}>";

public str toString(ObjectRef::objectRefNoLateralSubQuery(QueryExpr query, list[PivotUnpivot] pivotUnpivotList, list[AsAlias] asAliasList)) 
= "(<toString(query)>) <for(pivotUnpivot <- pivotUnpivotList) {><toString(pivotUnpivot)><}> <for(asAlias <- asAliasList) {><toString(asAlias)><}>";

public str toString(ObjectRef::objectRefLateralFlatten(FlattenTable flattenTable, list[AsAlias] asAliasList)) 
= "LATERAL <toString(flattenTable)> <for(asAlias <- asAliasList) {><toString(asAlias)><}>";

public str toString(ObjectRef::objectRefLateralSplitted(SplitedTable splitedTable, list[AsAlias] asAliasList)) 
= "LATERAL <toString(splitedTable)> <for(asAlias <- asAliasList) {><toString(asAlias)><}>";

public str toString(IdParams::atBefore(AtBefore atBefore)) = "<toString(atBefore)>";
public str toString(IdParams::changes(Changes changes)) = "<toString(changes)>";
public str toString(IdParams::matchRec(MatchRecognize matchRecognize)) = "<toString(matchRecognize)>";
public str toString(IdParams::pivotUnpivot(PivotUnpivot pivotUnpivot)) = "<toString(pivotUnpivot)>";
public str toString(IdParams::asCol(AsColumnAlias asColumn)) = "<toString(asColumn)>";
public str toString(IdParams::sample(Sample sampleList)) = "<toString(sampleList)>";

public str toString(Statement::insertDML(InsertStatement insertStatement)) = "<toString(insertStatement)>";
public str toString(Statement::insertMultiTableDML(InsertMultiTableStatement insertMultiTableStatement)) = "<toString(insertMultiTableStatement)>";
public str toString(Statement::updateDML(UpdateStatement updateStatement)) = "<toString(updateStatement)>";
public str toString(Statement::deleteDML(DeleteStatement deleteStatement)) = "<toString(deleteStatement)>";
public str toString(Statement::mergeDML(MergeStatement mergeStatement)) = "<toString(mergeStatement)>";

public str toString(InsertStatement::withQueryandBuilder(InsertWithQuery insertWithQ, ValuesBuilder valuesBuilder)) = "<toString(insertWithQ)> <toString(valuesBuilder)>";
public str toString(InsertStatement::withoutQuery(OverWriteOrInto overwriteInto,list[Table] tableOpt,TableName objNameOrId,list[PartitionPartWithOptionalValue] partitionWithOpt,list[IfNotExists] ifNotExOpt, list[ColumnSpecificationForInsert] columnOpt, list[ValuesBuilder] vbOpt)) 
  = "INSERT <toString(overwriteInto)> <intercalate("", [ toString(table) | table <- tableOpt ])> <toString(objNameOrId)> <intercalate("", [ toString(partitionWith) | partitionWith <- partitionWithOpt ])> <intercalate("", [ toString(ifNotEx) | ifNotEx <- ifNotExOpt ])> <intercalate("", [ toString(column) | column <- columnOpt ])> <intercalate("", [ toString(vb) | vb <- vbOpt ])>";

public str toString(InsertMultiTableStatement::insertMultiTableOverwriteAllInto(list[OverWriteOrInto] overwriteInto,FirstAll firstAll,IntoValuesList intoValuesList)) 
= "INSERT <toString(overwriteInto)> <toString(firstAll)> <toString(intoValuesList)>";
public str toString(InsertMultiTableStatement::insertMultiTableOverwriteFirstWhen(list[OverWriteOrInto] overwriteInto,FirstAll firstAll,list[WhenPredicateThenValues] whenPredicateThenValues, list[ElseIntoValueslist] elseIntoValueslist, QueryExpr query)) 
= "INSERT <toString(overwriteInto)> <toString(firstAll)> <intercalate(" ", [ toString(whenPredicate) | whenPredicate <- whenPredicateThenValues ])> <intercalate("", [ toString(elseInto) | elseInto <- elseIntoValueslist ])> <toString(query)>";

public str toString(IntoValuesList::intoValuesList(TableName objNameOrId, list[Columns] columnListWithBrackets, list[ValuesBuilder] valuesList)) 
  = "INTO <toString(objNameOrId)> <intercalate("", [ toString(column) | column <- columnListWithBrackets ])> <intercalate("", [ toString(values) | values <- valuesList ])>";

public str toString(FirstAll::first()) = "FIRST";
public str toString(FirstAll::\all()) = "ALL";

public str toString(WhenPredicateThenValues::whenPredicateThenValues(Expr exp, list[IntoValuesList] intoValuesList2)) = "WHEN <toString(exp)> THEN <intercalate(" ", [ toString(intoValues) | intoValues <- intoValuesList2 ])>";

public str toString(ElseIntoValueslist::elseIntoValuesList(IntoValuesList intoValuesList)) = "ELSE <toString(intoValuesList)>";

public str toString(UpdateStatement::updateStatement(TableName objNameOrId, list[AsAlias] asAliasList, SetObjNameList setObjNameList, 
                                            list[FromClause] fromClauseList, list[WhereClause] whereClauseList)) 
                                            = "UPDATE <toString(objNameOrId)> <for(asAlias <- asAliasList) {><toString(asAlias)><}> SET <toString(setObjNameList)> <for(fromClause <- fromClauseList) {><toString(fromClause)><}> <for(whereClause <- whereClauseList) {><toString(whereClause)><}>";

public str toString(SetObjNameList::setObjNameList(list[Expr] expList)) = "<intercalate(", ", [ toString(exp) | exp <- expList ])>";

public str toString(DeleteStatement::deleteStatement(TableName objNameOrId, list[AsAlias] asAliasList, list[UsingTableQueryList] usingTableQueryList, list[WhereClause] whereClauseList)) 
                                            = "DELETE FROM <toString(objNameOrId)> <for(asAlias <- asAliasList) {><toString(asAlias)><}> <for(usingTableQuery <- usingTableQueryList) {><toString(usingTableQuery)><}> <for(whereClause <- whereClauseList) {><toString(whereClause)><}>";

public str toString(UsingTableQueryList::usingTableQueryList(list[TableIdOrSubquery] usingTableQueryList)) = "<intercalate(", ", [ <"USING">, toString(usingTableQuery) | usingTableQuery <- usingTableQueryList ])>";

public str toString(MergeStatement::mergeStatement(TableName objNameOrId, list[AsAlias] asAliasList, TableIdOrSubquery tableSource, Expr searchCondition, MergeMatches mergeMatches)) 
                                        = "MERGE INTO <toString(objNameOrId)> <for(asAlias <- asAliasList) {><toString(asAlias)><}> USING <toString(tableSource)> ON <toString(searchCondition)> <toString(mergeMatches)>";

public str toString(MergeMatches::mergeMatches(list[WhenMatchedThen] whenMatchedThenList)) = "<for(whenMatchedThen <- whenMatchedThenList) {><toString(whenMatchedThen)> <}>";

public str toString(WhenMatchedThen::whenMatchedThen(list[Not] notOpt, list[AndSearchCondition] andSearchConditionList, MergeUpdateOrDelete mergeUpdateOrDelete)) = "WHEN <intercalate("", [ toString(notWord) | notWord <- notOpt ])> MATCHED <for(andSearchCondition <- andSearchConditionList) {><toString(andSearchCondition)><}> THEN <toString(mergeUpdateOrDelete)>";

public str toString(MergeUpdateOrDelete::mergeUpdate(SetObjNameList setObjNameList)) = "UPDATE SET <toString(setObjNameList)>";

public str toString(MergeUpdateOrDelete::mergeDelete()) = "DELETE";

public str toString(MergeUpdateOrDelete::mergeInsert(list[ExpListWithBrackets] expList, ValuesBuilder vb)) = "INSERT <for(exp <- expList) {><toString(exp)><}> <toString(vb)>";

public str toString(AndSearchCondition::andSearchCondition(Expr searchCondition)) = "AND <toString(searchCondition)>";

public str toString(Statement::alterAccountCommand(AlterAccountOpts alterAccountOpts)) = "ALTER ACCOUNT <toString(alterAccountOpts)>";
public str toString(Statement::alterSessionCommand(AlterSession alterSessionCmd)) = "<toString(alterSessionCmd)>";
public str toString(Statement::alterDatabaseCommand(AlterDatabase alterDatabaseCmd)) = "<toString(alterDatabaseCmd)>";
public str toString(Statement::alterConnectionCommand(AlterConnectionOptions alterConnectionOptions)) = "ALTER CONNECTION <toString(alterConnectionOptions)>";
public str toString(Statement::alterAlertCommand(AlterAlert alterAlertCmd)) = "<toString(alterAlertCmd)>";
public str toString(Statement::alterUserCommand(list[IfExists] ifExistsList, Identifier id, AlterUserOptions alterUserOptions)) = "ALTER USER <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(alterUserOptions)>";
public str toString(Statement::alterTagCommand(list[IfExists] ifExistsList, Identifier id, AlterTagOptions alterTagOptions)) = "ALTER TAG <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(alterTagOptions)>";
public str toString(Statement::alterSchemaCommand(AlterSchema alterSchemaCmd)) = "<toString(alterSchemaCmd)>";
public str toString(Statement::alterRoleCommand(AlterRole alterRoleCmd)) = "<toString(alterRoleCmd)>";
public str toString(Statement::alterRowAccessPolicyCommand(AlterRowAccessPolicy alterRowAccessPolicyCmd)) = "<toString(alterRowAccessPolicyCmd)>";
public str toString(Statement::alterProcedureCommand(AlterProcedure alterProcedureCmd)) = "<toString(alterProcedureCmd)>";
public str toString(Statement::alterNetworkPolicyCommand(AlterNetworkPolicyOpts alterNetworkPolicyOpts)) = "ALTER NETWORK POLICY <toString(alterNetworkPolicyOpts)>";
public str toString(Statement::alterApiIntegrationCommand(AlterApiIntegration alterApiIntegrationCmd)) = "<toString(alterApiIntegrationCmd)>";
public str toString(Statement::alterDynamicTableCommand(Identifier id, AlterDynamicOpts alterDynamicOpts)) = "ALTER DYNAMIC TABLE <toString(id)> <toString(alterDynamicOpts)>";
public str toString(Statement::alterFailoverGroupCommand(list[IfExists] ifExistsList, Identifier id,AlterFailoverGroup alterFailoverGroupCmd)) 
  = "ALTER FAILOVER GROUP <intercalate("", [ toString(ifExists) | ifExists <- ifExistsList ])> <toString(id)> <toString(alterFailoverGroupCmd)>";
public str toString(Statement:alterFileFormatCommand(AlterFileFormat alterFileFormatCmd)) = "<toString(alterFileFormatCmd)>";
public str toString(Statement::alterWareHouseCommand(list[IfExists] ifExistsList, AlterWareHouseOptions alterWareHouseOptions)) = "ALTER WAREHOUSE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(alterWareHouseOptions)>";
public str toString(Statement::alterFunctionCommand(list[IfExists] ifExOpt,Identifier id, list[DataTypeList] dtlOpt,AlterFunction alterFunctionCmd)) = "ALTER FUNCTION <for(ifExists <- ifExOpt) {><toString(ifExists)><}> <toString(id)> ( <for(dtl <- dtlOpt) {><toString(dtl)><}> ) <toString(alterFunctionCmd)>";
public str toString(Statement::alterViewCommand(AlterView alterViewCmd)) = "<toString(alterViewCmd)>";
public str toString(Statement::alterMaskingPolicyCommand(AlterMaskingPolicy alterMaskingPolicyCmd)) = "<toString(alterMaskingPolicyCmd)>";
public str toString(Statement::alterMaterializedViewCommand(Identifier id, AlterMaterializedViewOpts alterMaterializedViewOpts)) = "ALTER MATERIALIZED VIEW <toString(id)> <toString(alterMaterializedViewOpts)>";
public str toString(Statement::alterPipeCommand(AlterPipe alterPipeCmd)) = "<toString(alterPipeCmd)>";
public str toString(Statement::alterNotificationIntegrationCommand(AlterNotificationIntegration alterNotificationIntegrationCmd)) = "<toString(alterNotificationIntegrationCmd)>";
public str toString(Statement::alterExternalTableCommand(AlterExternalTable alterExternalTableCmd)) = "<toString(alterExternalTableCmd)>";
public str toString(Statement::alterResourceMonitorCommand(list[IfExists] ifExistsList, Identifier id, list[SetUnset] setUnset, list[NotifyTriggers] notifyTriggersList)) = "ALTER RESOURCE MONITOR <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <for(setResource <- setUnset) {><toString(setResource)><}> <for(notifyTriggers <- notifyTriggersList) {><toString(notifyTriggers)><}>";
public str toString(Statement::alterSequenceCommand(AlterSequence alterSequenceCmd)) = "<toString(alterSequenceCmd)>";

public str toString(AlterAccountOpts::setAccountOpts(list[Property] accountParamsOpt)) = "SET <for(accountParams <- accountParamsOpt) {><toString(accountParams)> <}>";
public str toString(AlterAccountOpts::unsetAccountOpts(list[Identifier] idList)) = "UNSET <intercalate(", ", [ toString(id) | id <- idList ])>";
public str toString(AlterAccountOpts::resourceMonitorAccountOpts(Identifier id)) = "SET RESOURCE_MONITOR = <toString(id)>";
public str toString(AlterAccountOpts::setTagsAccountOpts(SetUnsetTags setTags)) = "<toString(setTags)>";
public str toString(AlterAccountOpts::dropUrlAccountOpts(Identifier id)) = "<toString(id)> DROP OLD URL";
public str toString(AlterAccountOpts::saveUrlAccountOpts(Identifier id1, Identifier id2, list[SaveOldUrl] saveOldUrlList)) = "<toString(id1)> RENAME TO <toString(id2)> <for(saveOldUrl <- saveOldUrlList) {><toString(saveOldUrl)><}>";

public str toString(SetUnset::\set(list[Property] props)) = "SET <intercalate("", [ toString(prop) | prop <- props ])>";
public str toString(SetUnset::unset(list[Expr] expOpt,list[ExpListWithBrackets] withBraclOpt)) = "UNSET <intercalate("", [ toString(exp) | exp <- expOpt ])> <intercalate("", [ toString(withBrac) | withBrac <- withBraclOpt ])>";

public str toString(TagDecl::tagDecl(Identifier objNameOrId, String string)) = "<toString(objNameOrId)> = <toString(string)>";

public str toString(SaveOldUrl::saveOldUrl(Boolean boolVal)) = "SAVE_OLD_URL = <toString(boolVal)>";

public str toString(AlterTable::alterTableSetTags(list[IfExists] ifExistsList, TableName tableName, SetUnsetTags setTags)) 
= "ALTER TABLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName)> <toString(setTags)>";
public str toString(AlterTable::alterTableSwapWith(list[IfExists] ifExistsList, TableName tableName1, TableName tableName2)) 
= "ALTER TABLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName1)> SWAP WITH <toString(tableName2)>";
public str toString(AlterTable::alterTableDropRow(list[IfExists] ifExistsList, TableName tableName1, Identifier id)) 
 = "ALTER TABLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName1)> DROP ROW ACCESS POLICY <toString(id)>";

public str toString(AlterSession::alterSessionSet(Property sessionParams)) = "ALTER SESSION SET <toString(sessionParams)>";
public str toString(AlterSession::alterSessionUnset(list[Identifier] idList)) = "ALTER SESSION UNSET <intercalate(", ", [ toString(id) | id <- idList ])>";

public str toString(AlterDatabase::alterDatabaseRename(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER DATABASE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> RENAME TO <toString(id2)>";
public str toString(AlterDatabase::alterDatabaseSwap(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER DATABASE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> SWAP WITH <toString(id2)>";
public str toString(AlterDatabase::alterDatabaseSetTags(Identifier id, SetUnsetTags setTags)) = "ALTER DATABASE <toString(id)> <toString(setTags)>";
public str toString(AlterDatabase::alterDatabaseRefresh(Identifier id)) = "ALTER DATABASE <toString(id)> REFRESH";
public str toString(AlterDatabase::alterDatabaseProperty(list[IfExists] ifExistsList, Identifier id, list[DatabaseOrSchemaProperty] databaseOrSchemaPropertyList)) = "ALTER DATABASE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> UNSET <intercalate(", ", [ toString(databaseOrSchemaProperty) | databaseOrSchemaProperty <- databaseOrSchemaPropertyList ])>";

public str toString(DatabaseOrSchemaProperty::dataRetentionTimeProp(str integer)) = "DATA_RETENTION_TIME_IN_DAYS = <integer>";
public str toString(DatabaseOrSchemaProperty::maxDataExtentionTimeProp(str integer)) = "MAX_DATA_EXTENSION_TIME_IN_DAYS = <integer>";
public str toString(DatabaseOrSchemaProperty::defaultDdlCollationProp(String string)) = "DEFAULT_DDL_COLLATION = <toString(string)>";
public str toString(DatabaseOrSchemaProperty::commentDatabaseOrSchemaProperty()) = "COMMENT";

public str toString(AlterConnectionOptions::alterConnectionPrimary(Identifier id)) = "<toString(id)> PRIMARY";
public str toString(AlterConnectionOptions::alterConnectionSet(list[IfExists] ifExistsList, Identifier id, SetUnset setUnset, CommentClause commentClause)) = "<for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setUnset)> <toString(commentClause)>";

public str toString(CommentClause::commentClause(list[AssignExpr] assExprOpt)) = "COMMENT <intercalate("", [ toString(assExpr) | assExpr <- assExprOpt ])>";

public str toString(AssignExpr::assignExp(Expr exp)) = "= <toString(exp)>";
public str toString(AssignExpr::assignList(list[ExpList] exptLOpt)) = "= ( <intercalate("", [ toString(exp) | exp <- exptLOpt ])> )";

public str toString(AlterAlert::alterAlterResumeSuspend(list[IfExists] ifExistsList, Identifier id, ResumeSuspend resumeSuspend)) = "ALTER ALERT <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(resumeSuspend)>";
public str toString(AlterAlert::alterAlterSet(list[IfExists] ifExistsList, Identifier id, SetUnset setUnset, list[AlertSetClause] alertSetClauseList)) = "ALTER ALERT <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setUnset)> <for(alertSetClause <- alertSetClauseList) {><toString(alertSetClause)> <}>";
public str toString(AlterAlert::alterAlterModify(list[IfExists] ifExistsList, Identifier id, AlertCondition alertCondition)) = "ALTER ALERT <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> MODIFY CONDITION EXISTS ( <toString(alertCondition)> )";

public str toString(ResumeSuspend::resumeSuspendOpt1()) = "RESUME";
public str toString(ResumeSuspend::resumeSuspendOpt2()) = "SUSPEND";

public str toString(AlertSetClause::warehouseAlertSetClause(list[AssignExpr] assOpt)) = "WAREHOUSE <intercalate("", [ toString(ass) | ass <- assOpt ])>";
public str toString(AlertSetClause::scheduleAlertSetClause(list[AssignExpr] assOpt)) = "SCHEDULE <intercalate("", [ toString(ass) | ass <- assOpt ])>";
public str toString(AlertSetClause::commentAlertSetClause(CommentClause commentClause)) = "<toString(commentClause)>";

public str toString(AlterUserOptions::renameToId(Identifier id)) = "RENAME TO <toString(id)>";
public str toString(AlterUserOptions::resetPassword()) = "RESET PASSWORD";
public str toString(AlterUserOptions::abortAllQueries()) = "ABORT ALL QUERIES";
public str toString(AlterUserOptions::addDelegated(Identifier id1, Identifier id2)) = "ADD DELEGATED AUTHORIZATION OF ROLE <toString(id1)> TO SECURITY INTEGRATION <toString(id2)>";
public str toString(AlterUserOptions::removeDelegated(AuthorizationType authorizationType, Identifier id)) = "REMOVE DELEGATED <toString(authorizationType)> FROM SECURITY INTEGRATION <toString(id)>";
public str toString(AlterUserOptions::setTagAlterUserOpt(SetUnsetTags setTags)) = "<toString(setTags)>";

public str toString(AuthorizationType::ofRoleAuthorizationType(Identifier id)) = "AUTHORIZATION OF ROLE <toString(id)>";
public str toString(AuthorizationType::authorizationsType()) = "AUTHORIZATIONS";

public str toString(AlterTagOptions::alterTagOptsRename(PropRef PropRef)) = "RENAME TO <toString(PropRef)>";
public str toString(AlterTagOptions::alterTagOptsAddOrDrop(AddOrDrop addOrDrop, TagAllowedValues tagAllowedValues)) = "<toString(addOrDrop)> <toString(tagAllowedValues)>";
public str toString(AlterTagOptions::alterTagOptsUnsetAllowed()) = "UNSET ALLOWED_VALUES";
public str toString(AlterTagOptions::alterTagOptsSetMasking(SetUnset setunset, MaskingPolicyIdList maskingPolicyIdList)) = "<toString(setunset)> <toString(maskingPolicyIdList)>";
public str toString(AlterTagOptions::alterTagOptsSetCommentClause(SetUnset setunset, CommentClause commentClause)) = "<toString(setunset)> <toString(commentClause)>";

public str toString(AddOrDrop::add()) = "ADD";
public str toString(AddOrDrop::drop()) = "DROP";

public str toString(TagAllowedValues::tagAllowedValues(list[String] stringList)) = "ALLOWED_VALUES <intercalate(", ", [ toString(string) | string <- stringList ])>";

public str toString(MaskingPolicyId::maskingPolicyId(Identifier id)) = "MASKING POLICY <toString(id)>";

public str toString(MaskingPolicyIdList::maskingPolicyIdList(list[MaskingPolicyId] maskingPolIdList)) = "<intercalate(", ", [ toString(maskingPolId) | maskingPolId <- maskingPolIdList ])>";

public str toString(AlterSchema::alterSchemaRenameTo(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER SCHEMA <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> RENAME TO <toString(id2)>";
public str toString(AlterSchema::alterSchemaSwapWith(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER SCHEMA <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> SWAP WITH <toString(id2)>";
public str toString(AlterSchema:: alterSchemaCommentClause(list[IfExists] ifExistsOpt, Identifier id, SetUnset setUnset,
                                list[DatabaseOrSchemaProperty] PropertyList)) 
                                = "ALTER SCHEMA <for(ifExists <- ifExistsOpt) {><toString(ifExists)><}> <toString(id)> <toString(setUnset)> <intercalate(", ", [ toString(prop) | prop <- PropertyList ])>";
public str toString(AlterSchema::alterSchemaSetTags(list[IfExists] ifExistsList, Identifier id, SetUnsetTags setTags)) = "ALTER SCHEMA <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setTags)>";
public str toString(AlterSchema::alterSchemaEnableDisable(list[IfExists] ifExistsList, Identifier id, EnableDisable enableDisable)) = "ALTER SCHEMA <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(enableDisable)> MANAGED ACCESS";

public str toString(EnableDisable::enable()) = "ENABLE";
public str toString(EnableDisable::disable()) = "DISABLE";

public str toString(AlterRole::alterRoleRenameTo(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER ROLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> RENAME TO <toString(id2)>";
public str toString(AlterRole::alterRoleSet(list[IfExists] ifExistsList, Identifier id, SetUnset setUnset, CommentClause commentClause)) = "ALTER ROLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setUnset)> <toString(commentClause)>";
public str toString(AlterRole::alterRoleSetTags(list[IfExists] ifExistsList, Identifier id, SetUnsetTags setTags)) = "ALTER ROLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setTags)>";

public str toString(AlterRowAccessPolicy::alterRowSetBody(list[IfExists] ifExistsList, Identifier id, Expr exp)) = "ALTER ROW ACCESS POLICY <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> SET BODY -\> <toString(exp)>";
public str toString(AlterRowAccessPolicy::alterRowRenameTo(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER ROW ACCESS POLICY <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> RENAME TO <toString(id2)>";
public str toString(AlterRowAccessPolicy::alterRowSetComment(list[IfExists] ifExistsList, Identifier id, CommentClause commentClause)) = "ALTER ROW ACCESS POLICY <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> SET <toString(commentClause)>";

public str toString(AlterProcedure::alterProcedureRenameTo(list[IfExists] ifExistsList, Identifier id1, list[DataTypeList] dataTypeList, Identifier id2)) = "ALTER PROCEDURE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> ( <for(dataType <- dataTypeList) {><toString(dataType)><}> ) RENAME TO <toString(id2)>";
public str toString(AlterProcedure::alterProcedureSetComment(list[IfExists] ifExistsList, Identifier id, list[DataTypeList] dataTypeList, SetUnset setunset, CommentClause commentClause)) = "ALTER PROCEDURE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> ( <for(dataType <- dataTypeList) {><toString(dataType)><}> ) <toString(setunset)> <toString(commentClause)>";
public str toString(AlterProcedure::alterProcedureExecute(list[IfExists] ifExistsList, Identifier id, list[DataTypeList] dataTypeList, CallerOwner callerOwner)) = "ALTER PROCEDURE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> ( <for(dataType <- dataTypeList) {><toString(dataType)><}> ) EXECUTE AS <toString(callerOwner)>";

public str toString(CallerOwner::caller()) = "CALLER";
public str toString(CallerOwner::owner()) = "OWNER";

public str toString(AlterNetworkPolicyOpts::alterNetworkIPList(list[IfExists] ifExistsList, Identifier id, SetUnset setunset,list[Property] proplist, list[CommentClause] commentClauseList)) 
  = "<for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setunset)> <for(prop <- proplist) {><toString(prop)> <}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";
public str toString(AlterNetworkPolicyOpts::alterNetworkRenameTo(Identifier id1, Identifier id2)) = "<toString(id1)> RENAME TO <toString(id2)>";

public str toString(AlterApiIntegration::alterApiArn(list[IfExists] ifExistsList, Identifier id,
                                         SetUnset setUnset,
                                        list[CommentClause] commentClauseList
                                    )) 
          = "ALTER API INTEGRATION <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setUnset)> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";

public str toString(AlterApiIntegration::alterNoApiSetTags(list[str] api, Identifier id,
                                     SetUnsetTags  setUnsetTags
                                     )) 
  = "ALTER <intercalate("", [ <apiStr> | apiStr <- api ])> INTEGRATION <toString(id)> <toString(setUnsetTags)>";
public str toString(AlterApiIntegration::alterNoApiUnset(list[str] api,list[IfExists] ifExistsOpt, Identifier id, ApiIntegrationPropertyList apiIntegrationPropertyList)) 
  = "ALTER <intercalate("", [ <apiStr> | apiStr <- api ])> INTEGRATION <for(ifExists <- ifExistsOpt) {><toString(ifExists)><}> <toString(id)> UNSET <toString(apiIntegrationPropertyList)>";

public str toString(Enable::enableTrueOrFalse(Boolean boolVal)) = "ENABLE = <toString(boolVal)>"; 

public str toString(ApiIntegrationPropertyList::apiIntegrationPropertyList(list[ApiIntegrationProperty] apiIntegrationPropList)) = "<intercalate(", ", [ toString(apiIntegrationProp) | apiIntegrationProp <- apiIntegrationPropList ])>";

public str toString(ApiIntegrationProperty::apiKeyIntegrationProp()) = "API_KEY";
public str toString(ApiIntegrationProperty::enabledIntegrationProp()) = "ENABLED";
public str toString(ApiIntegrationProperty::blockedPrefixesIntegrationProp()) = "API_BLOCKED_PREFIXES";
public str toString(ApiIntegrationProperty::commentIntegrationProp()) = "COMMENT";

public str toString(AlterDynamicOpts::resumeSuspendDynamicOpt(ResumeSuspend resumeSuspend)) = "<toString(resumeSuspend)>";
public str toString(AlterDynamicOpts::refreshDynamicOpt()) = "REFRESH";
public str toString(AlterDynamicOpts::setDynamicOpt(Identifier id)) = "SET WAREHOUSE = <toString(id)>";

public str toString(ColumnList::columnList(list[PropRef] propref)) = "<intercalate(", ", [ toString(ref) | ref <- propref ])>";

public str toString(AlterFailoverGroup::renameToFailoverGroup( Identifier id2)) = "RENAME TO <toString(id2)>";
public str toString(AlterFailoverGroup::setFailoverGroup(list[ObjectTypes] objectTypesList, list[Property] replicationScheduleList) ) = "SET <for(objectTypes <- objectTypesList) {><toString(objectTypes)><}> <for(replicationSchedule <- replicationScheduleList) {><toString(replicationSchedule)><}>";
public str toString(AlterFailoverGroup::addAllowedFailoverGroup( ColumnList columnList)) = "ADD <toString(columnList)> TO ALLOWED_DATABASES";
public str toString(AlterFailoverGroup::moveToFailoverGroup( ColumnList columnList, Identifier id2)) = "MOVE DATABASES <toString(columnList)> TO FAILOVER GROUP <toString(id2)>";
public str toString(AlterFailoverGroup::removeFromFailoverGroup( ColumnList columnList)) = "REMOVE <toString(columnList)> FROM ALLOWED_DATABASES";
public str toString(AlterFailoverGroup::allowedSharesFailoverGroup( ColumnList columnList)) = "ADD <toString(columnList)> TO ALLOWED_SHARES";
public str toString(AlterFailoverGroup::moveSharesFailoverGroup( ColumnList columnList, Identifier id2)) = "MOVE SHARES <toString(columnList)> TO FAILOVER GROUP <toString(id2)>";
public str toString(AlterFailoverGroup::removeAllowedSharesFailoverGroup( ColumnList columnList)) = "REMOVE <toString(columnList)> FROM ALLOWED_SHARES";
public str toString(AlterFailoverGroup::allowedAccountsFailoverGroup( TableName tableName, list[IgnoreEditionCheck] ignoreEditionCheckList)) = "ADD <toString(tableName)> TO ALLOWED_ACCOUNTS <for(ignoreEditionCheck <- ignoreEditionCheckList) {><toString(ignoreEditionCheck)><}>";
public str toString(AlterFailoverGroup::removeColumnFailoverGroup( TableName tableName)) = "REMOVE <toString(tableName)> FROM ALLOWED_ACCOUNTS";
public str toString(AlterFailoverGroup::failoverOptFailoverGroup( AlterFailoverOpts alterFailoverOpts)) = "<toString(alterFailoverOpts)>";

public str toString(ObjectTypes::objectTypes(list[ObjectType] objTypeList)) = "OBJECT_TYPES = <intercalate(", ", [ toString(objType) | objType <- objTypeList ])>";
public str toString(ObjectTypeList::objectTypeList(list[ObjectType] objTypeList)) = "<intercalate(", ", [ toString(objType) | objType <- objTypeList ])>";

public str toString(ObjectType::accountParamObjectType()) = "ACCOUNT PARAMETERS";
public str toString(ObjectType::databasesObjectType()) = "DATABASES";
public str toString(ObjectType::integrationsObjectType()) = "INTEGRATIONS";
public str toString(ObjectType::networkPoliciesObjectType()) = "NETWORK POLICIES";
public str toString(ObjectType::resourceMonitorsObjectType()) = "RESOURCE MONITORS";
public str toString(ObjectType::rolesObjectType()) = "ROLES";
public str toString(ObjectType::sharesObjectType()) = "SHARES";
public str toString(ObjectType::usersObjectType()) = "USERS";
public str toString(ObjectType::warehousesObjectType()) = "WAREHOUSES";

public str toString(IgnoreEditionCheck::ignoreEditionCheck()) = "IGNORE EDITION CHECK";

public str toString(AlterFailoverOpts::refreshFailoverOpts()) = "REFRESH";

public str toString(AlterFailoverOpts::primaryFailoverOpts()) = "PRIMARY";

public str toString(AlterFailoverOpts::suspendFailoverOpts()) = "SUSPEND";

public str toString(AlterFailoverOpts::resumeFailoverOpts()) = "RESUME";

public str toString(AlterFileFormat::alterFileRenameTo(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER FILE FORMAT <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> RENAME TO <toString(id2)>";

public str toString(AlterFileFormat::alterFileSet(list[IfExists] ifExistsList, Identifier id, list[Property] formatTypeOptionsList, list[CommentClause] commentClauseList)) = "ALTER FAILOVER GROUP <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> SET <for(formatTypeOptions <- formatTypeOptionsList) {><toString(formatTypeOptions)> <}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";

public str toString(AlterWareHouseOptions::idSuspendIfAlterWhOpt(list[Expr] expList, SuspendResumeIf suspendResumeIf)) = "<for(exp <- expList) {><toString(exp)><}> <toString(suspendResumeIf)>";
public str toString(AlterWareHouseOptions::idAbortAllAlterWhOpt(list[Expr] expList)) = "<for(exp <- expList) {><toString(exp)><}> ABORT ALL QUERIES";
public str toString(AlterWareHouseOptions::idRenameToAlterWhOpt(Expr exp, Identifier id)) = "<toString(exp)> RENAME TO <toString(id)>";
public str toString(AlterWareHouseOptions::idSetTagsAlterWhOpt(Expr exp, SetUnsetTags setTags)) = "<toString(exp)> <toString(setTags)>";
public str toString(AlterWareHouseOptions::idUnSetColListAlterWhOpt(Expr exp, ColumnList columnList)) = "<toString(exp)> UNSET <toString(columnList)>";

public str toString(SuspendResumeIf::suspendResumeIfOpt1()) = "SUSPEND";
public str toString(SuspendResumeIf::suspendResumeIfOpt2(list[IfSuspended] ifSuspendedList)) = "RESUME <for(ifSuspended <- ifSuspendedList) {><toString(ifSuspended)><}>";

public str toString(IfSuspended::ifSuspended()) = "IF SUSPENDED";

public str toString(AlterFunction::renameToAlterFunction( Identifier id)) = "RENAME TO <toString(id)>";
public str toString(AlterFunction::commentAlterFunction(SetUnset setunset,UnsetSecureOrComment unsetSecureOrComment)) = "<toString(setunset)> <toString(unsetSecureOrComment)>";
public str toString(AlterFunction::compressionAlterFunction( SetUnset compression)) = "<toString(compression)>";

public str toString(UnsetSecureOrComment::unsetSecure()) = "SECURE";
public str toString(UnsetSecureOrComment::unsetComment(CommentClause commentClause)) = "<toString(commentClause)>";
public str toString(UnsetSecureOrComment::setSecureOrComment()) = "SET";


public str toString(AlterView::alterViewAlternative1(list[IfExists] ifExistsList, TableName tableName1, TableName tableName2)) = "ALTER VIEW <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName1)> RENAME TO <toString(tableName2)>";

public str toString(AlterView::alterViewAlternative2(list[IfExists] ifExistsList, TableName tableName, SetUnset setunset, CommentClause commentClause)) = "ALTER VIEW <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName)> <toString(setunset)> <toString(commentClause)>";

public str toString(AlterView::alterViewAlternative4(TableName tableName, SetUnset setunset)) = "ALTER VIEW <toString(tableName)> <toString(setunset)> SECURE";

public str toString(AlterView::alterViewAlternative6(list[IfExists] ifExistsList, TableName tableName, SetUnsetTags setTags)) = "ALTER VIEW <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName)> <toString(setTags)>";

public str toString(AlterView::alterViewAlternative8(list[IfExists] ifExistsList, TableName tableName,AddOrDrop aod, Identifier id, list[Columns] columnList)) = "ALTER VIEW <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName)> <toString(aod)> ROW ACCESS POLICY <toString(id)> <for(column <- columnList) {>ON <toString(column)><}>";

public str toString(AlterView::alterViewAlternative10(list[IfExists] ifExistsList, TableName tableName, Identifier id1, Columns columnListWithBrackets, Identifier id2)) = "ALTER VIEW <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName)> ADD ROW ACCESS POLICY <toString(id1)> ON <toString(columnListWithBrackets)> , DROP ROW ACCESS POLICY <toString(id2)>";

public str toString(AlterView::alterViewAlternative11(list[IfExists] ifExistsList, TableName tableName)) = "ALTER VIEW <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName)> DROP ALL ROW ACCESS POLICIES";

public str toString(AlterView::alterViewAlternative12(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id1, Identifier id2, list[UsingColumnList] usingColumnList)) = "ALTER VIEW <toString(tableName)> <toString(alterOrModify)> <for(column <- columnStr) {><toString(column)><}> <toString(id1)> SET MASKING POLICY <toString(id2)> <for(usingColumn <- usingColumnList) {><toString(usingColumn)><}>";

public str toString(AlterView::alterViewAlternative15(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id1, Identifier id2, list[UsingColumnList] usingColumnList)) = "ALTER VIEW <toString(tableName)> <toString(alterOrModify)> <for(column <- columnStr) {><toString(column)><}> <toString(id1)> SET MASKING POLICY <toString(id2)> <for(usingColumn <- usingColumnList) {><toString(usingColumn)><}> FORCE";

public str toString(AlterView::alterViewAlternative17(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id)) = "ALTER VIEW <toString(tableName)> <toString(alterOrModify)> <for(column <- columnStr) {><toString(column)><}> <toString(id)> UNSET MASKING POLICY";

public str toString(AlterView::alterViewAlternativeTags(TableName tableName, AlterOrModify alterOrModify, list[Column] columnStr, Identifier id, SetUnsetTags unsetTags)) = "ALTER VIEW <toString(tableName)> <toString(alterOrModify)> <for(column <- columnStr) {><toString(column)><}> <toString(id)> <toString(unsetTags)>";

public str toString(Column::columnStr()) = "COLUMN";

public str toString(AlterOrModify::alterOrModifyOpt1()) = "ALTER";
public str toString(AlterOrModify::alterOrModifyOpt2()) = "MODIFY";

public str toString(AlterMaskingPolicy::alterMaskingBody(list[IfExists] ifExistsList, Identifier id, Expr exp)) = "ALTER MASKING POLICY <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> SET BODY -\> <toString(exp)>";
public str toString(AlterMaskingPolicy::alterMaskingRenameTo(list[IfExists] ifExistsList, Identifier id1, Identifier id2)) = "ALTER MASKING POLICY <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id1)> RENAME TO <toString(id2)>";
public str toString(AlterMaskingPolicy::alterMaskingSet(list[IfExists] ifExistsList, Identifier id, CommentClause commentClause)) = "ALTER MASKING POLICY <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> SET <toString(commentClause)>";

public str toString(AlterMaterializedViewOpts::alterMaterializedViewOpt1(Identifier id)) = "RENAME TO <toString(id)>";
public str toString(AlterMaterializedViewOpts::alterMaterializedViewOpt2(ExpListWithBrackets expListWithBrackets)) = "CLUSTER BY <toString(expListWithBrackets)>";
public str toString(AlterMaterializedViewOpts::alterMaterializedViewOpt3()) = "DROP CLUSTERING KEY";
public str toString(AlterMaterializedViewOpts::alterMaterializedOptNoRecluster(ResumeSuspend resumeSuspend)) = "<toString(resumeSuspend)>";
public str toString(AlterMaterializedViewOpts::alterMaterializedOptRecluster(ResumeSuspend resumeSuspend)) = "<toString(resumeSuspend)> RECLUSTER";
public str toString(AlterMaterializedViewOpts::alterMaterializedOptNoSecure(list[str] secure, list[CommentClause] commentClauseList)) = "SET <for(secureStr <- secure) {><secureStr><}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";
public str toString(AlterMaterializedViewOpts::alterMaterializedViewOpt7(list[UnsetSecureOrComment] unsetSecureOrCommentList)) = "<for(unsetSecureOrComment <- unsetSecureOrCommentList) {><toString(unsetSecureOrComment)> <}>";

public str toString(AlterPipe::alterPipeOpt1(list[IfExists] ifExistsList, Identifier id, list[Property] objectPropertiesList, list[CommentClause] commentClauseList)) 
                                = "ALTER PIPE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> SET <for(objectProperties <- objectPropertiesList) {><toString(objectProperties)><}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";
public str toString(AlterPipe::alterPipeOpt2(Identifier id, SetUnsetTags setTags)) = "ALTER PIPE <toString(id)> <toString(setTags)>";
public str toString(AlterPipe::alterPipeOpt4(list[IfExists] ifExistsList, Identifier id, Boolean boolVal)) = "ALTER PIPE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> UNSET PIPE_EXECUTION_PAUSED = <toString(boolVal)>";
public str toString(AlterPipe::alterPipeOpt5(list[IfExists] ifExistsList, Identifier id)) = "ALTER PIPE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> UNSET COMMENT";
public str toString(AlterPipe::alterPipeOpt6(list[IfExists] ifExistsList, Identifier id, list[Property] prefixStringList)) = "ALTER PIPE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> REFRESH <for(prefixString <- prefixStringList) {><toString(prefixString)> <}>";

public str toString(AlterNotificationIntegration::alterNotificationIntegrationOpt2(list[str] notification,list[IfExists] ifExistsList, Identifier id,
                                                SetUnset setunset,
                                                CloudProviderParamsAuto cloudProviderParamsAuto,
                                                list[CommentClause] commentClauseList
                                                )) 
  = "ALTER <intercalate("", [ <notWrd> | notWrd <- notification ])> INTEGRATION <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)> <toString(setunset)> <toString(cloudProviderParamsAuto)> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";
public str toString(AlterNotificationIntegration::alterNotificationIntegrationOpt6(list[str] notification, Identifier id, SetUnsetTags setTags)) 
  = "ALTER <intercalate("", [ <notWrd> | notWrd <- notification ])> INTEGRATION <toString(id)> <toString(setTags)>";

public str toString(CloudProviderParamsAuto::googleCloudParamAuto(String string)) = "NOTIFICATION_PROVIDER = GCP_PUBSUB GCP_PUBSUB_SUBSCRIPTION_NAME = <toString(string)>";
public str toString(CloudProviderParamsAuto::microsoftAzureParamAuto(String string1, String string2)) = "NOTIFICATION_PROVIDER = AZURE_EVENT_GRID AZURE_STORAGE_QUEUE_PRIMARY_URI = <toString(string1)> AZURE_TENANT_ID = <toString(string2)>";
public str toString(CloudProviderParamsPush::amazonAwsParamPush(String string1, String string2)) = "NOTIFICATION_PROVIDER = AWS_SNS AWS_SNS_TOPIC_ARN = <toString(string1)> AWS_SNS_ROLE_ARN = <toString(string2)>";
public str toString(CloudProviderParamsPush::googleCloudParamPush(String string)) = "NOTIFICATION_PROVIDER = GCP_PUBSUB GCP_PUBSUB_TOPIC_NAME = <toString(string)>";
public str toString(CloudProviderParamsPush::microsoftAzureParamPush(String string1, String string2)) = "NOTIFICATION_PROVIDER = AZURE_EVENT_GRID AZURE_EVENT_GRID_TOPIC_ENDPOINT = <toString(string1)> AZURE_TENANT_ID = <toString(string2)>";

public str toString(AlterEnabledOrComment::alterEnabled()) = "ENABLED";
public str toString(AlterEnabledOrComment::alterComment()) = "COMMENT";

public str toString(AlterExternalTable::alterExternalTableRefresh(list[IfExists] ifExistsOpt, TableName tableName, list[String] stringOpt)) 
  = "ALTER EXTERNAL TABLE <intercalate("", [ toString(ifExists) | ifExists <- ifExistsOpt ])> <toString(tableName)> REFRESH <intercalate("", [ toString(string) | string <- stringOpt ])>";
public str toString(AlterExternalTable::alterExternalTableAddFiles(list[IfExists] ifExistsList, TableName objNameOrId, ExpList expList)) 
  = "ALTER EXTERNAL TABLE <intercalate("", [ toString(ifExists) | ifExists <- ifExistsList ])> <toString(objNameOrId)> ADD FILES ( <toString(expList)> )";
public str toString(AlterExternalTable::alterExternalTableRemoveFiles(list[IfExists] ifExistsList, TableName objNameOrId, ExpList expList)) 
  = "ALTER EXTERNAL TABLE <intercalate("", [ toString(ifExists) | ifExists <- ifExistsList ])> <toString(objNameOrId)> REMOVE FILES ( <toString(expList)> )";
public str toString(AlterExternalTable::alterExternalTableSet(list[IfExists] ifExistsList, TableName objNameOrId,
                                        list[AutoRefresh] autoRefreshList, 
                                        list[TagDeclList] tagDeclList
                                        )) 
  = "ALTER EXTERNAL TABLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(objNameOrId)> SET <for(autoRefresh <- autoRefreshList) {><toString(autoRefresh)><}> <for(tagDecl <- tagDeclList) {><toString(tagDecl)><}>";

public str toString(AlterExternalTable::alterExternalTableUnset(list[IfExists] ifExistsList, TableName objNameOrId, SetUnsetTags unsetTags)) 
  = "ALTER EXTERNAL TABLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(objNameOrId)> <toString(unsetTags)>";
public str toString(AlterExternalTable::alterExternalTableAddPartition(TableName objNameOrId, list[IfExists] ifExistsList, ExpList expList, String string)) 
  = "ALTER EXTERNAL TABLE <toString(objNameOrId)> <for(ifExists <- ifExistsList) {><toString(ifExists)><}> ADD PARTITION ( <toString(expList)> ) LOCATION <toString(string)>";
public str toString(AlterExternalTable::alterExternalTableDropPartition(TableName objNameOrId, list[IfExists] ifExistsList, String string)) 
  = "ALTER EXTERNAL TABLE <toString(objNameOrId)> <for(ifExists <- ifExistsList) {><toString(ifExists)><}> DROP PARTITION LOCATION <toString(string)>";

public str toString(AutoRefresh::autoRefresh(Boolean boolVal)) = "AUTO_REFRESH = <toString(boolVal)>";

public str toString(TagDeclList::tagDeclList(list[TagDecl] tagDeclList)) = "TAG <intercalate(", ", [ toString(tagDecl) | tagDecl <- tagDeclList ])>";

public str toString(NotifyTriggers::notifyTriggers(NotifyUsers notifyUsers, list[Triggers] triggersList)) = "<toString(notifyUsers)> <for(triggers <- triggersList) {><toString(triggers)><}>";

public str toString(NotifyUsers::notifyUsers(list[Identifier] idList)) = "NOTIFY_USERS = ( <intercalate(", ", [ toString(id) | id <- idList ])> )";

public str toString(Triggers::triggers(list[TriggerDefinition] triggerDefinitionList)) = "TRIGGERS <for(triggerDefinition <- triggerDefinitionList) {><toString(triggerDefinition)> <}>";

public str toString(TriggerDefinition::triggerDefinition(str integer, SuspendType suspendType)) = "ON <integer> PERCENT DO <toString(suspendType)>";

public str toString(SuspendType::suspendTypeOpt1()) = "SUSPEND";

public str toString(SuspendType::suspendTypeOpt2()) = "SUSPEND_IMMEDIATE";

public str toString(SuspendType::suspendTypeOpt3()) = "NOTIFY";

public str toString(AlterSequence::alterSequenceRenameTo(list[IfExists] ifExistsList, TableName t1, TableName t2)) 
  = "ALTER SEQUENCE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(t1)> RENAME TO <toString(t2)>";

public str toString(AlterSequence::alterSequenceSetIncrementBy(list[IfExists] ifExistsList, TableName t,list[str] \set, list[IncrementBy] incrementByList)) 
  = "ALTER SEQUENCE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(t)> <intercalate("", [ <setWord> | setWord <- \set ])> <for(incrementBy <- incrementByList) {><toString(incrementBy)><}>";

public str toString(AlterSequence::alterSequenceSetOrderComment(list[IfExists] ifExistsList, TableName t,SetUnset setUnset, OrderComment orderComment)) 
  = "ALTER SEQUENCE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(t)> <toString(setUnset)> <toString(orderComment)>";

public str toString(IncrementBy::incrementByOpt1(str integer)) = "INCREMENT = <integer>";

public str toString(IncrementBy::incrementByOpt2(str integer)) = "INCREMENT BY = <integer>";

public str toString(IncrementBy::incrementByOpt3(str integer)) = "INCREMENT <integer>";

public str toString(IncrementBy::incrementByOpt4(str integer)) = "INCREMENT BY <integer>";

public str toString(ExpAsVarOrStar::objectNameColPosition(list[TableName] tableNameOpt, str integer, list[AsAlias] asAliasOpt)) 
  = "<for(tableName <- tableNameOpt) {><toString(tableName)>.<}> $ <integer> <for(asAlias <- asAliasOpt) {><toString(asAlias)><}>";

public str toString(OrderComment::orderCommentOpt1(list[OrderNoOrder] orderNoOrderList, CommentClause commentClauseList)) = "<for(orderNoOrder <- orderNoOrderList) {><toString(orderNoOrder)><}> <toString(commentClauseList)>";

public str toString(OrderComment::orderCommentOpt2(OrderNoOrder orderNoOrder)) = "<toString(orderNoOrder)>";

public str toString(OrderNoOrder::orderNoOrder1()) = "ORDER";

public str toString(OrderNoOrder::orderNoOrder2()) = "NOORDER";

public str toString(Statement::createViewCommand(CreateView createView)) = "<toString(createView)>";

public str toString(Statement::createTableCommand(list[OrReplace] orReplaceList, list[TableType] tableTypeList, list[IfNotExistsObjectName] ifNotExistsObjectNameList, list[CloneAtBefore] cloneAtBeforeList, list[CreateTableOrCommentClause] createTableOrCommentClauseList, list[QueryOrWith] query)) 
                            = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <for(tableType <- tableTypeList) {><toString(tableType)><}> TABLE <for(ifNotExistsObjectName <- ifNotExistsObjectNameList) {><toString(ifNotExistsObjectName)><}> <for(cloneAtBefore <- cloneAtBeforeList) {><toString(cloneAtBefore)><}> <for(createTableOrCommentClause <- createTableOrCommentClauseList) {><toString(createTableOrCommentClause)><}> <for(qry <- query) {>AS <toString(qry)><}>";

public str toString(Statement::createTableLikeCommand(CreateTableLike createTableLike)) = "<toString(createTableLike)>";

public str toString(Statement::createDatabaseCommand(CreateDatabase createDatabase)) = "<toString(createDatabase)>";

public str toString(Statement::createSchemaCommand(CreateSchema createSchema)) = "<toString(createSchema)>";

public str toString(Statement::createAccountCommand(Identifier id1, list[Property] propList, list[RegionGroup] regionGroupList,
                                list[SnowflakeRegion] snowflakeRegionList, list[CommentClause] commentClauseOpt
                                ))
                        = "CREATE ACCOUNT <toString(id1)> <for(prop <- propList) {><toString(prop)> <}> <for(regionGroup <- regionGroupList) {><toString(regionGroup)><}> <for(snowflakeRegion <- snowflakeRegionList) {><toString(snowflakeRegion)><}> <for(commentClause <- commentClauseOpt) {><toString(commentClause)><}>";

public str toString(Statement::createUserCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, Identifier id, list[Property] objectPropertiesList)) 
                        = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> USER <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> <for(objectProperties <- objectPropertiesList) {><toString(objectProperties)> <}>";

public str toString(Statement::createConnectionCommand(list[IfNotExists] ifNotExistsList, Identifier id, list[AsReplicaOfObjectName] asReplicaOfObjectNameList, list[CommentClause] commentClauseList)) 
                        = "CREATE CONNECTION <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> <for(asReplicaOfObjectName <- asReplicaOfObjectNameList) {><toString(asReplicaOfObjectName)> <}> <for(commentClause <- commentClauseList) {><toString(commentClause)> <}>";

public str toString(Statement::createDynamicTableCommand(list[OrReplace] orReplaceList, Identifier id1, String string, Identifier id2, QueryExpr qry)) 
                        = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> DYNAMIC TABLE <toString(id1)> TARGET_LAG = <toString(string)> WAREHOUSE = <toString(id2)> AS <toString(qry)>";

public str toString(Statement::createEventTableCommand(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsList, Identifier id,
                                list[ClusterBy] clusterByList, 
                               list[Property] props,
                                list[CopyGrants] copyGrantsList, 
                                list[WithRowAccessPolicy] withRowAccessPolicyList, 
                                list[WithTags] withTagsList, 
                                list[WithClause] withOpt,list[CommentClause] CommentClauseOpt
                                )) 
                        = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> EVENT TABLE <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> <for(clusterBy <- clusterByList) {><toString(clusterBy)> <}> <intercalate(" ", [ toString(prop) | prop <- props ])> <for(copyGrants <- copyGrantsList) {><toString(copyGrants)><}> <for(withRowAccessPolicy <- withRowAccessPolicyList) {><toString(withRowAccessPolicy)><}> <for(withTags <- withTagsList) {><toString(withTags)><}> <intercalate("", [ toString(with) | with <- withOpt ])> <for(commentClause <- CommentClauseOpt) {><toString(commentClause)><}>";
public str toString(Statement::createFailoverGroupCommand(CreateFailoverGroup createFailoverGroup)) = "<toString(createFailoverGroup)>";

public str toString(Statement::createManagedAccountCommand(Identifier id1, Identifier id2, String string, list[CommentClause] commaCommentClauselist)) 
                        = "CREATE MANAGED ACCOUNT <toString(id1)> ADMIN_NAME = <toString(id2)>, ADMIN_PASSWORD = <toString(string)>, TYPE = READER <for(commaCommentClause <- commaCommentClauselist) {><toString(commaCommentClause)><}>";

public str toString(Statement::createNetworkPolicyCommand(list[OrReplace] orReplaceList, Identifier id, 
                                        list[Property] props,
                                        list[CommentClause] commentClauselist
                                )) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> NETWORK POLICY <toString(id)> <intercalate(" ", [ toString(prop) | prop <- props ])> <intercalate("", [ toString(commentClause) | commentClause <- commentClauselist ])>";

public str toString(Statement::createApiIntegrationCommand(CreateApiIntegration createApiIntegration)) = "<toString(createApiIntegration)>";

public str toString(Statement::createExternalFunctionCommand(CreateExternalFunction createExternalFunction)) = "<toString(createExternalFunction)>";

public str toString(Statement::createExternalTableCommand(CreateExternalTable createExternalTable)) = "<toString(createExternalTable)>";

public str toString(Statement::createFunctionCommand(CreateFunction createFunction)) = "<toString(createFunction)>";

public str toString(Statement::createMaskingPolicyCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objNameOrId,
                                        list[ArgDataTypeList] argDataTypeList, DataType dt, Expr exp, list[CommentClause] commentClauseList
                                        )) 
                                        = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> MASKING POLICY <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(objNameOrId)> AS ( <for(argDataType <- argDataTypeList) {><toString(argDataType)><}> ) RETURNS <toString(dt)> -\> <toString(exp)> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";
public str toString(Statement::createNotificationIntegrationCommand(CreateNotificationIntegration createNotificationIntegration)) = "<toString(createNotificationIntegration)>";

public str toString(Statement::createProcedureCommand(CreateProcedure createProcedure)) = "<toString(createProcedure)>";

public str toString(Statement::createPipeCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objNameOrId,
                               list[Property] props,
                                list[CommentClause] commentClauseList,
                                CopyIntoTable copyIntoTable
                                )) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> PIPE <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(objNameOrId)> <intercalate(" ", [ toString(prop) | prop <- props ])> <intercalate("", [ toString(commentClause) | commentClause <- commentClauseList ])> AS <toString(copyIntoTable)>";

public str toString(Statement::createObjectType(list[OrReplace] orReplaceList,ObjectTypeName objectType, list[IfNotExists] ifNotExistsOpt, Identifier id, list[WithTags] withTagsList,list[Property] propList, list[TagAllowedValues] tavOpt, list[CommentClause] commentClauseList)) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <toString(objectType)> <for(ifNotExists <- ifNotExistsOpt) {><toString(ifNotExists)><}> <toString(id)> <intercalate("", [ toString(withTags) | withTags <- withTagsList ])> <intercalate(" ", [ toString(prop) | prop <- propList ])> <intercalate("", [ toString(tav) | tav <- tavOpt ])> <intercalate("", [ toString(commentClause) | commentClause <- commentClauseList ])>";

public str toString(Statement::createRowAccessPolicyCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, Identifier id,
                                        list[ArgDataTypeList] argDataTypeList, Expr exp, list[CommentClause] commentClauseList
                                        )) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> ROW ACCESS POLICY <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> AS ( <for(argDataType <- argDataTypeList) {><toString(argDataType)><}> ) RETURNS BOOLEAN -\> <toString(exp)> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";

public str toString(Statement::createReplicationGroupCommand(CreateReplicationGroup createReplicationGroup)) = "<toString(createReplicationGroup)>";

public str toString(Statement::createResourceMonitorCommand(list[OrReplace] orReplaceList, Identifier id,list[Property] propList, list[NotifyUsers] notifyUsersList, list[Triggers] triggersList
                                )) 
  ="CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> RESOURCE MONITOR <toString(id)> WITH <intercalate(" ", [ toString(prop) | prop <- propList ])> <intercalate("", [ toString(notifyUsers) | notifyUsers <- notifyUsersList ])> <intercalate("", [ toString(triggers) | triggers <- triggersList ])>";

public str toString(Statement::createSequenceCommand(CreateSequence createSequence)) = "<toString(createSequence)>";

public str toString(Statement::createStageCommand(CreateStage createStage)) = "<toString(createStage)>";

public str toString(Statement::createStorageIntegrationCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, Identifier id,
                             list[Property] propList, list[CommentClause] commentClauseList)) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> STORAGE INTEGRATION <intercalate("", [ toString(ifNotExists) | ifNotExists <- ifNotExistsList ])> <toString(id)> TYPE = EXTERNAL_STAGE <intercalate(" ", [ toString(prop) | prop <- propList ])> <intercalate("", [ toString(commentClause) | commentClause <- commentClauseList ])>";

public str toString(Statement::createStreamCommand(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList,
                                 TableName tbnOpt, list[CopyGrants] copyGrantsOpt,CreateStream createStream)) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> STREAM <intercalate("", [ toString(ifNotExists) | ifNotExists <- ifNotExistsList ])> <toString(tbnOpt)> <intercalate("", [ toString(copyGrants) | copyGrants <- copyGrantsOpt ])> <toString(createStream)>";

public str toString(Statement::createObjectCloneCommand(list[OrReplace] orReplaceList, CreateCloneOpts createCloneOpts, list[IfNotExists] ifNotExistsList, PropRef objNameOrId1, PropRef objNameOrId2)) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <toString(createCloneOpts)> <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(objNameOrId1)> CLONE <toString(objNameOrId2)>";


public str toString(External::external()) = "EXTERNAL";

public str toString(StreamType::table(list[External] ext)) = "<intercalate("", [ toString(external) | external <- ext ])> TABLE";
public str toString(StreamType::stage()) = "STAGE";
public str toString(StreamType::view()) = "VIEW";

public str toString(CreateDatabase::createDatabase(list[OrReplace] orReplaceList,list[TableType] ttOpt, list[IfNotExists] ifNotExistsList, Identifier id,
                                        list[CloneAtBefore] cloneAtBeforeList,
                                        list[Property] propList,
                                        list[WithTags] withTagsOpt,
                                        list[CommentClause] commentClauseOpt)) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <intercalate("", [ toString(tt) | tt <- ttOpt ])> DATABASE <intercalate("", [ toString(ifNotExists) | ifNotExists <- ifNotExistsList ])> <toString(id)> <intercalate("", [ toString(cloneAtBefore) | cloneAtBefore <- cloneAtBeforeList ])> <intercalate(" ", [ toString(prop) | prop <- propList ])> <intercalate("", [ toString(withtag) | withtag <- withTagsOpt ])> <intercalate("", [ toString(commentClause) | commentClause <- commentClauseOpt ])>";

public str toString(CreateStage::createStageParams(list[OrReplace] orReplaceList, list[Temporary] temporaryOpt, list[IfNotExists] ifNotExistsList, Expr exp, list[CloneAtBefore] cloneAtBeforeList,
                                list[ExternalStageParams] extParamsOpt,
                                list[StageEncryptionOptsInternal] stageEncryptionOptsInternalList,
                                list[DirectoryTableInternalParams] directoryTableInternalParamsList,
                                list[DirectoryTableExternalParams] directoryTableExternalParamsList,
                                list[FileFormat] fileFormatList,
                                list[CopyEqCopyOpts] copyEqCopyOptsList,
                                list[WithTags] withTagsList,
                                list[CommentClause] commentClauseList
                        )) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <for(temporary <- temporaryOpt) {><toString(temporary)><}> STAGE <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(exp)> <for(cloneAtBefore <- cloneAtBeforeList) {><toString(cloneAtBefore)><}> <intercalate("", [ toString(extParams) | extParams <- extParamsOpt ])> <intercalate("", [ toString(stageEncryption) | stageEncryption <- stageEncryptionOptsInternalList ])> <intercalate("", [ toString(directoryTable) | directoryTable <- directoryTableInternalParamsList ])> <for(directoryTableExternalParams <- directoryTableExternalParamsList) {><toString(directoryTableExternalParams)><}> <for(fileFormat <- fileFormatList) {><toString(fileFormat)><}> <for(copyEqCopyOpts <- copyEqCopyOptsList) {><toString(copyEqCopyOpts)><}> <for(withTags <- withTagsList) {><toString(withTags)><}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";

public str toString(StageEncryptionOptsInternal::stageEncryptionOptsInternal(SnowFlakeFullSSE snowFlakeFullSSE)) = "ENCRYPTION = ( TYPE = <toString(snowFlakeFullSSE)> )";

public str toString(SnowFlakeFullSSE::snowflakeFull()) = "SNOWFLAKE_FULL";

public str toString(SnowFlakeFullSSE::snowflakeSSE()) = "SNOWFLAKE_SSE";

public str toString(DirectoryTableInternalParams::directoryTableInternalParams(EnableRefreshOnCreate enableRefreshOnCreate)) = "DIRECTORY = ( <toString(enableRefreshOnCreate)> )";

public str toString(EnableRefreshOnCreate::enableRefreshOnCreateOpt1(Enable enable, list[RefreshOnCreate] refreshOnCreateList)) = "<toString(enable)> <for(refreshOnCreate <- refreshOnCreateList) {><toString(refreshOnCreate)><}>";

public str toString(EnableRefreshOnCreate::enableRefreshOnCreateOpt2(RefreshOnCreate refreshOnCreate, list[Enable] enableList)) = "<toString(refreshOnCreate)> <for(enable <- enableList) {><toString(enable)><}>";

public str toString(CopyEqCopyOpts::copyEqCopyOpts(CopyOptions copyOptions)) = "COPY_OPTIONS = ( <toString(copyOptions)> )";

public str toString(ExternalStageParams::externalStageAwsParam(S3OrGovAwsPath s3OrGovAwsPath, list[AwsCredentialEncryption] awsCredentialEncryptionList)) = "URL = <toString(s3OrGovAwsPath)> <for(awsCredentialEncryption <- awsCredentialEncryptionList) {><toString(awsCredentialEncryption)> <}>";

public str toString(ExternalStageParams::externalStageGcpParam(str uri, list[GcpCredentialEncryption] gcpCredentialEncryptionList)) = "URL = \'gcs:// <uri>\' <for(gcpCredentialEncryption <- gcpCredentialEncryptionList) {><toString(gcpCredentialEncryption)> <}>";

public str toString(ExternalStageParams::externalStageAzureParam(str uri, list[AzCredentialEncryption] azCredentialEncryptionList)) = "URL = \'azure:// <uri>\' <for(azCredentialEncryption <- azCredentialEncryptionList) {><toString(azCredentialEncryption)> <}>";

public str toString(AzCredentialEncryption::azCredentialIntegration(AzCredentialOrStorageIntegration azCredentialOrStorageIntegration)) = "<toString(azCredentialOrStorageIntegration)>";

public str toString(AzCredentialEncryption::azCredentialEncryption(Property props, list[Property] propList)) = "ENCRYPTION = ( <toString(props)> <intercalate("", [ toString(prop) | prop <- propList ])> )";

public str toString(AzCredentialOrStorageIntegration::azureStorageIntegrationId(Identifier id)) = "STORAGE_INTEGRATION = <toString(id)>";

public str toString(AzCredentialOrStorageIntegration::azureSasToken(String string)) = "CREDENTIALS = ( AZURE_SAS_TOKEN = <toString(string)> )";

public str toString(AwsCredentialEncryption::awsCredentialIntegration(AwsCredentialOrStorageIntegration awsCredentialOrStorageIntegration)) = "<toString(awsCredentialOrStorageIntegration)>";

public str toString(AwsCredentialEncryption::awsCredentialEncryption(list[Property] propList)) = "ENCRYPTION = ( <intercalate(" ", [ toString(prop) | prop <- propList ])> )";

public str toString(AwsCredentialOrStorageIntegration::awsStorageIntegration(Identifier id)) = "STORAGE_INTEGRATION = <toString(id)>";

public str toString(AwsCredentialOrStorageIntegration::awsCredential(list[Property] propList)) = "CREDENTIALS = ( <intercalate(" ", [ toString(prop) | prop <- propList ])> )";

public str toString(GcpCredentialEncryption::gcpCredentialIntegration(Property prop)) = "<toString(prop)>";

public str toString(GcpCredentialEncryption::gcpCredentialEncryption(GcpEncryptionValue gcpEncryptionValue)) = "ENCRYPTION = ( <toString(gcpEncryptionValue)> )";

public str toString(GcpEncryptionValue::typeGcsSseKmsKey(list[TypeGcsSseKms] typeGcsSseKmsList, String string)) = "<for(typeGcsSseKms <- typeGcsSseKmsList) {><toString(typeGcsSseKms)><}> KMS_KEY_ID = <toString(string)>";

public str toString(GcpEncryptionValue::kmsTypeGcsSse(String string)) = "KMS_KEY_ID = <toString(string)> TYPE = \'GCS_SSE_KMS\'";

public str toString(GcpEncryptionValue::typeNoneGcp()) = "TYPE = \'NONE\'";

public str toString(TypeGcsSseKms::typeGcsSseKms()) = "TYPE = \'GCS_SSE_KMS\'";

public str toString(DirectoryTableExternalParams::directoryTableExternalParams(Enable enable, list[RefreshOnCreateOrAutoRefresh] refreshOnCreateOrAutoRefreshList, list[NotificationIntegration] notificationIntegrationList)) 
= "DIRECTORY = ( <toString(enable)> <for(refreshOnCreateOrAutoRefresh <- refreshOnCreateOrAutoRefreshList) {><toString(refreshOnCreateOrAutoRefresh)> <}> <for(notificationIntegration <- notificationIntegrationList) {><toString(notificationIntegration)><}> )";

public str toString(RefreshOnCreateOrAutoRefresh::refreshOnCreateOrAutoRefreshOpt1(AutoRefresh autoRefresh)) = "<toString(autoRefresh)>";
public str toString(RefreshOnCreateOrAutoRefresh::refreshOnCreateOrAutoRefreshOpt1(RefreshOnCreate refreshOnCreate)) = "<toString(refreshOnCreate)>";

public str toString(NotificationIntegration::notificationIntegration(String string)) = "NOTIFICATION_INTEGRATION = <toString(string)>";

public str toString(CreateCloneOpts::stageCloneOpt()) = "STAGE";
public str toString(CreateCloneOpts::fileFormatCloneOpt()) = "FILE FORMAT";
public str toString(CreateCloneOpts::sequenceCloneOpt()) = "SEQUENCE";
public str toString(CreateCloneOpts::streamCloneOpt()) = "STREAM";
public str toString(CreateCloneOpts::taskCloneOpt()) = "TASK";

public str toString(CreateStream::createStreamOnTable( StreamType stype,
                                TableName tblName, 
                                list[CloneOptional] cloneOptionalList,
                                list[AppendOnly] appendOnlyList,
                                list[InsertOnly] insetOpt,
                                list[ShowInitialRows] showInitialRowsOpt,
                                list[CommentClause] commentClausept

                        )) 
  = "ON <toString(stype)> <toString(tblName)> <for(cloneOptional <- cloneOptionalList) {><toString(cloneOptional)><}> <for(appendOnly <- appendOnlyList) {><toString(appendOnly)><}> <for(insertOnly <- insetOpt) {><toString(insertOnly)><}> <for(showInitialRows <- showInitialRowsOpt) {><toString(showInitialRows)><}> <for(commentClause <- commentClausept) {><toString(commentClause)><}>";

public str toString(InsertOnly::insertOnly()) = "INSERT_ONLY = TRUE";

public str toString(AppendOnly::appendOnly(Boolean boolVal)) = "APPEND_ONLY = <toString(boolVal)>";

public str toString(ShowInitialRows::showInitialRows(Boolean boolVal)) = "SHOW_INITIAL_ROWS = <toString(boolVal)>";

public str toString(CloneAtBefore::cloneAtBefore(TableName tableName, list[CloneOptional] cloneOptionalList)) = "CLONE <toString(tableName)> <for(cloneOptional <- cloneOptionalList) {><toString(cloneOptional)><}>";
public str toString(CloneOptional::cloneTimeStamp(AtOrBefore atOrBefore, String string)) = "<toString(atOrBefore)>( TIMESTAMP =\> <toString(string)> )";
public str toString(CloneOptional::cloneOffset(AtOrBefore atOrBefore, String string)) = "<toString(atOrBefore)>( OFFSET =\> <toString(string)> )";
public str toString(CloneOptional::cloneStatement(AtOrBefore atOrBefore, Identifier id)) = "<toString(atOrBefore)>( STATEMENT =\> <toString(id)> )";
public str toString(CloneOptional::cloneStream(AtOrBefore atOrBefore, String string)) = "<toString(atOrBefore)>( STREAM =\> <toString(string)> )";


public str toString(AtOrBefore::atOrBeforeOpt1()) = "AT";
public str toString(AtOrBefore::atOrBeforeOpt2()) = "BEFORE";


public str toString(WithTags::withTags(list[WithClause] withOpt, list[TagDecl] tagDeclList)) = "<intercalate("", [ toString(with) | with <- withOpt ])> TAG ( <intercalate(", ", [ toString(tagDecl) | tagDecl <- tagDeclList ])> )";

public str toString(CreateSchema::createSchemaWithTransient(list[OrReplace] orReplaceList,list[TableType] ttypeOpt, list[IfExists] ifExistsList, TableName tblName,
                                list[CloneAtBefore] cloneAtBeforeList,
                                list[WithManagedAccess] withManagedAccessList,
                             list[Property] props,
                                list[WithTags] withTagsList,
                                list[CommentClause] commentClauseList)) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <intercalate("", [ toString(ttype) | ttype <- ttypeOpt ])> SCHEMA <intercalate("", [ toString(ifExists) | ifExists <- ifExistsList ])> <toString(tblName)> <intercalate("", [ toString(cloneAtBefore) | cloneAtBefore <- cloneAtBeforeList ])> <intercalate("", [ toString(withManagedAccess) | withManagedAccess <- withManagedAccessList ])> <intercalate(" ", [ toString(prop) | prop <- props ])> <intercalate("", [ toString(withTags) | withTags <- withTagsList ])> <intercalate("", [ toString(commentClause) | commentClause <- commentClauseList ])>";

public str toString(WithManagedAccess::withManagedAccess()) = "WITH MANAGED ACCESS";

public str toString(FormatType::csv_()) = "CSV";

public str toString(FormatType::json_()) = "JSON";

public str toString(FormatType::avro_()) = "AVRO";

public str toString(FormatType::orc_()) = "ORC";

public str toString(FormatType::parquet_()) = "PARQUET";

public str toString(FormatType::xml_()) = "XML";

public str toString(FormatType::csv_q()) = "\'CSV\'";

public str toString(FormatType::json_q()) = "\'JSON\'";

public str toString(FormatType::avro_q()) = "\'AVRO\'";

public str toString(FormatType::orc_q()) = "\'ORC\'";

public str toString(FormatType::parquet_q()) = "\'PARQUET\'";

public str toString(FormatType::xml_q()) = "\'XML\'";

public str toString(CreateTableOrCommentClause::createTableOrCommentClauseOpt1(CreateTableClause createTableClause)) = "<toString(createTableClause)>";

public str toString(CreateTableOrCommentClause::createTableOrCommentClauseOpt2(CommentClause commentClause)) = "<toString(commentClause)>";

public str toString(CreateTableClause::createTableClause(ColumnDeclItemListWithBrackets columnDeclItemListWithBrackets,
                                        list[ClusterBy] clusterByList,
                                        list[StageFileFormat] stageFileFormatList,
                                        list[StageCopyEqCopyOptions] stageCopyEqCopyOptionsList,
                                        list[Property] propList,
                                        list[CopyGrants] copyGrantsList,
                                        list[WithRowAccessPolicy] withRowAccessPolicyList,
                                        list[WithTags] withTagsList
                        )) 
  = "<toString(columnDeclItemListWithBrackets)> <intercalate("", [ toString(clusterBy) | clusterBy <- clusterByList ])> <intercalate("", [ toString(stageFileFormat) | stageFileFormat <- stageFileFormatList ])> <intercalate("", [ toString(stageCopyEqCopy) | stageCopyEqCopy <- stageCopyEqCopyOptionsList ])> <intercalate(" ", [ toString(prop) | prop <- propList ])> <intercalate("", [ toString(copyGrants) | copyGrants <- copyGrantsList ])> <intercalate("", [ toString(withRowAccessPolicy) | withRowAccessPolicy <- withRowAccessPolicyList ])> <intercalate("", [ toString(withTags) | withTags <- withTagsList ])>";

public str toString(ColumnDeclItem::fullColItem(FullColDecl fullColDecl)) = "<toString(fullColDecl)>";

public str toString(ColumnDeclItem::outOfLineConstraintItem(OutOfLineConstraint outOfLineConstraint)) = "<toString(outOfLineConstraint)>";

public str toString(ColumnDeclItemList::columnDeclItemList(list[ColumnDeclItem] colDeclItemList)) = "<intercalate(", ", [ toString(colDeclItem) | colDeclItem <- colDeclItemList ])>";

public str toString(ColumnDeclItemListWithBrackets::columnDeclItemListWithBrackets(ColumnDeclItemList columnDeclarationItemList)) = "( <toString(columnDeclarationItemList)> )";

public str toString(FullColDecl::fullColDecl(ColDecl colDecl, list[FullColDeclOptionals] fullColDeclOptionalsList, list[WithMaskingPolicy] withMaskingPolicyList, list[WithTags] withTagsList, list[CommentString] commentStringList)) = "<toString(colDecl)> <for(fullColDeclOptionals <- fullColDeclOptionalsList) {><toString(fullColDeclOptionals)> <}> <for(withMaskingPolicy <- withMaskingPolicyList) {><toString(withMaskingPolicy)><}> <for(withTags <- withTagsList) {><toString(withTags)><}> <for(commentString <- commentStringList) {><toString(commentString)><}>";

public str toString(OutOfLineConstraint::outOfLineConstraint(list[ConstraintId] constraintIdList, OutOfLineConstraintOptionals outOfLineConstraintOptionals)) = "<for(constraintId <- constraintIdList) {><toString(constraintId)><}> <toString(outOfLineConstraintOptionals)>";

public str toString(ColDecl::colDecl(IdentifierType idType, DataType dataType)) = "<toString(idType)> <toString(dataType)>";

public str toString(FullColDeclOptionals::fullColDeclOptCollate(String string)) = "COLLATE <toString(string)>";

public str toString(FullColDeclOptionals::fullColDeclOptInline(InlineConstraint inlineConstraint)) = "<toString(inlineConstraint)>";

public str toString(FullColDeclOptionals::fullColDeclOptDefault(DefaultValue defaultValue)) = "<toString(defaultValue)>";

public str toString(FullColDeclOptionals::fullColDeclOptNullNotNull(NullNotNull nullNotNull)) = "<toString(nullNotNull)>";

public str toString(InlineConstraint::inlineConstraintUnique(list[ConstraintId] constraintIdList, UniquePrimaryKey uniquePrimaryKey, list[CommonConstraintProperties] commonConstraintPropertiesList)) = "<for(constraintId <- constraintIdList) {><toString(constraintId)><}> <toString(uniquePrimaryKey)> <for(commonConstraintProperties <- commonConstraintPropertiesList) {><toString(commonConstraintProperties)> <}>";

public str toString(InlineConstraint::inlineConstraintForeign(list[NullNotNull] nullNotNullList, list[ConstraintId] constraintIdList, Expr exp, ConstraintProperties constraintProperties)) = "<for(nullNotNull <- nullNotNullList) {><toString(nullNotNull)><}> <for(constraintId <- constraintIdList) {><toString(constraintId)><}> FOREIGN KEY REFERENCES <toString(exp)> <toString(constraintProperties)>";

public str toString(ConstraintId::constraintId(Identifier id)) = "CONSTRAINT <toString(id)>";

public str toString(UniquePrimaryKey::uniquePrimaryKeyOpt1()) = "UNIQUE";

public str toString(UniquePrimaryKey::uniquePrimaryKeyOpt2()) = "PRIMARY KEY";

public str toString(CommonConstraintProperties::enforcedConstraintProp(EnforcedNotEnforced enforcedNotEnforced, list[ValidateNoValidate] validateNoValidateList)) = "<toString(enforcedNotEnforced)> <for(validateNoValidate <- validateNoValidateList) {><toString(validateNoValidate)><}>";

public str toString(CommonConstraintProperties::defferableConstraintProp(DeferrableNotDeferrable deferrableNotDeferrable)) = "<toString(deferrableNotDeferrable)>";

public str toString(CommonConstraintProperties::initiallyConstraintProp(InitiallyDeferredOrImmediate initiallyDeferredOrImmediate)) = "<toString(initiallyDeferredOrImmediate)>";

public str toString(CommonConstraintProperties::enableConstraintProp(EnableDisable enableDisable, list[ValidateNoValidate] validateNoValidateList)) = "<toString(enableDisable)> <for(validateNoValidate <- validateNoValidateList) {><toString(validateNoValidate)><}>";

public str toString(CommonConstraintProperties::relyConstraintProp()) = "RELY";

public str toString(CommonConstraintProperties::norelyConstraintProp()) = "NORELY";

public str toString(EnforcedNotEnforced::enforcedNotEnforced(list[Not] notOpt)) = "<intercalate("", [ toString(notWord) | notWord <- notOpt ])> ENFORCED";

public str toString(DeferrableNotDeferrable::deferrableNotDeferrable(list[Not] notOpt)) = "<intercalate("", [ toString(notWord) | notWord <- notOpt ])> DEFERRABLE";

public str toString(ValidateNoValidate::validateNoValidateOpt1()) = "VALIDATE";

public str toString(ValidateNoValidate::validateNoValidateOpt2()) = "NOVALIDATE";

public str toString(InitiallyDeferredOrImmediate::initiallyDeferred()) = "INITIALLY DEFERRED";

public str toString(InitiallyDeferredOrImmediate::initiallyImmediate()) = "INITIALLY IMMEDIATE";

public str toString(ConstraintProperties::constraintPropStar(list[CommonConstraintProperties] commonConstraintPropertiesList)) = "<for(commonConstraintProperties <- commonConstraintPropertiesList) {><toString(commonConstraintProperties)> <}>";

public str toString(ConstraintProperties::constraintPropForeign(list[ForeignKeyOnActionToggle] foreignKeyOnActionToggleList)) = "<for(foreignKeyOnActionToggle <- foreignKeyOnActionToggleList) {><toString(foreignKeyOnActionToggle)> <}>";

public str toString(ForeignKeyOnActionToggle::foreignKeyOnActionToggleOpt1(ForeignKeyMatch foreignKeyMatch)) = "<toString(foreignKeyMatch)>";

public str toString(ForeignKeyOnActionToggle::foreignKeyOnActionToggleOpt2(OnAction onAction)) = "ON UPDATE <toString(onAction)>";

public str toString(ForeignKeyOnActionToggle::foreignKeyOnActionToggleOpt3(OnAction onAction)) = "ON DELETE <toString(onAction)>";

public str toString(ForeignKeyMatch::matchFull()) = "MATCH FULL";

public str toString(ForeignKeyMatch::matchPartial()) = "MATCH PARTIAL";

public str toString(ForeignKeyMatch::matchSimple()) = "MATCH SIMPLE";

public str toString(OnAction::cascadeAction(CascadeRestrict cascadeRestrict)) = "<toString(cascadeRestrict)>";

public str toString(OnAction::setNullAction()) = "SET NULL";

public str toString(OnAction::setDefaultAction()) = "SET DEFAULT";

public str toString(OnAction::restrictAction()) = "RESTRICT";

public str toString(OnAction::noAction()) = "NO ACTION";

public str toString(DefaultValue::defaultExpVal(Expr exp)) = "DEFAULT <toString(exp)>";

public str toString(DefaultValue::autoIncrementVal(list[StartWithIncrementBy] startWithIncrementByList, list[OrderNoOrder] orderNoOrderList)) = "AUTOINCREMENT <for(startWithIncrementBy <- startWithIncrementByList) {><toString(startWithIncrementBy)><}> <for(orderNoOrder <- orderNoOrderList) {><toString(orderNoOrder)><}>";

public str toString(DefaultValue::identityVal(list[StartWithIncrementBy] startWithIncrementByList, list[OrderNoOrder] orderNoOrderList)) = "IDENTITY <for(startWithIncrementBy <- startWithIncrementByList) {><toString(startWithIncrementBy)><}> <for(orderNoOrder <- orderNoOrderList) {><toString(orderNoOrder)><}>";

public str toString(StartWithIncrementBy::startWithIncrementByOpt1(ExpListWithBrackets expListWithBrackets)) = "<toString(expListWithBrackets)>";

public str toString(StartWithIncrementBy::startWithIncrementByOpt2(StartWith startWith)) = "<toString(startWith)>";

public str toString(StartWithIncrementBy::startWithIncrementByOpt3(IncrementBy incrementBy)) = "<toString(incrementBy)>";

public str toString(StartWithIncrementBy::startWithIncrementByOpt4(StartWith startWith, IncrementBy incrementBy)) = "<toString(startWith)> <toString(incrementBy)>";

public str toString(StartWith::startWithOpt1(str integer)) = "START <integer>";

public str toString(StartWith::startWithOpt2(str integer)) = "START WITH = <integer>";

public str toString(StartWith::startWithOpt3(str integer)) = "START = <integer>";

public str toString(StartWith::startWithOpt4(str integer)) = "START WITH <integer>";

public str toString(WithMaskingPolicy::withMaskingPolicy(list[WithClause] withOpt, Identifier id, list[UsingColumnList] usingColumnList)) = "<intercalate(", ", [ toString(with) | with <- withOpt ])> MASKING POLICY <toString(id)> <for(usingColumn <- usingColumnList) {><toString(usingColumn)><}>";

public str toString(CommentString::commentString(String string)) = "COMMENT <toString(string)>";

public str toString(OutOfLineConstraintOptionals::outOfLineConstraintUnique(UniquePrimaryKey uniquePrimaryKey, ExpListWithBrackets columnListWithBrackets, list[CommonConstraintProperties] commonConstraintPropertiesList)) = "<toString(uniquePrimaryKey)> <toString(columnListWithBrackets)> <for(commonConstraintProperties <- commonConstraintPropertiesList) {><toString(commonConstraintProperties)> <}>";

public str toString(OutOfLineConstraintOptionals::outOfLineConstraintForeign(ExpListWithBrackets columnListWithBrackets1, Expr exp, ConstraintProperties constraintProperties)) = "FOREIGN KEY <toString(columnListWithBrackets1)> REFERENCES <toString(exp)> <toString(constraintProperties)>";

public str toString(ClusterBy::clusterBy(ExpListWithBrackets expListWithBrackets)) = "CLUSTER BY <toString(expListWithBrackets)>";

public str toString(StageFileFormat::stageFileFormatOpt1(String string)) = "STAGE_FILE_FORMAT = ( FORMAT_NAME = <toString(string)> )";

public str toString(StageFileFormat::stageFileFormatOpt2(FormatType formatType, list[Property] propList)) = "STAGE_FILE_FORMAT = ( TYPE = <toString(formatType)> <for(prop <- propList) {><toString(prop)> <}> )";

public str toString(StageCopyEqCopyOptions::stageCopyEqCopyOptions(CopyOptions copyOptions)) = "STAGE_COPY_OPTIONS = ( <toString(copyOptions)> )";

public str toString(CopyOptions::onErrorOpts(OnErrorAction onErrorAction)) = "ON_ERROR = <toString(onErrorAction)>";

public str toString(CopyOptions::prop(Property prop)) = "<toString(prop)>";

public str toString(OnErrorAction::continueAction()) = "CONTINUE";

public str toString(OnErrorAction::skipFile()) = "SKIP_FILE";

public str toString(OnErrorAction::skipFileInt(str integer)) = "SKIP_FILE_<integer>";

public str toString(OnErrorAction::skipFileAbort(str integer)) = "SKIP_FILE_<integer> ABORT_STATEMENT";

public str toString(TableType::volatileType(list[LocalGlobal] localGlobalList)) = "<for(localGlobal <- localGlobalList) {><toString(localGlobal)><}> VOLATILE";

public str toString(TableType::temporaryType(list[LocalGlobal] localGlobalList, Temporary temporary)) = "<for(localGlobal <- localGlobalList) {><toString(localGlobal)><}> <toString(temporary)>";

public str toString(TableType::transientType()) = "TRANSIENT";

public str toString(LocalGlobal::local()) = "LOCAL";

public str toString(LocalGlobal::global()) = "GLOBAL";

public str toString(Temporary::temp()) = "TEMP";

public str toString(Temporary::temporary()) = "TEMPORARY";

public str toString(IfNotExistsObjectName::ifNotExistsObjectName(list[IfNotExists] ifNotExistsList, PropRef objNameOrId)) = "<for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(objNameOrId)>";

public str toString(IfNotExistsObjectName::objectNameIfNotExists(PropRef objNameOrId, IfNotExists ifNotExists)) = "<toString(objNameOrId)> <toString(ifNotExists)>";

public str toString(InternalOrExternalStage::stageAtId(Identifier id)) = "@<toString(id)>/";

public str toString(InternalOrExternalStage::stageAtIdNoSlash(Identifier id)) = "@<toString(id)>";

public str toString(InternalOrExternalStage::externallocation(ExternalLocation externalLocation)) = "<toString(externalLocation)>";

public str toString(ExternalLocation::externalLocationOpt1(S3OrGovAwsPath s3OrGovAwsPath)) = "<toString(s3OrGovAwsPath)>";

public str toString(ExternalLocation::externalLocationOpt2(str uri)) = "\'gcs://<uri>\'";

public str toString(ExternalLocation::externalLocationOpt3(str uri)) = "\'azure://<uri>\'";

public str toString(S3OrGovAwsPath::s3Path(str uri)) = "\'s3://<uri>\'";

public str toString(S3OrGovAwsPath::s3govPath(str uri)) = "\'s3gov://<uri>\'";

public str toString(FileFormat::fileFormat(list[Property] propList)) = "FILE_FORMAT = ( <for(prop <- propList) {><toString(prop)> <}> )";

public str toString(BracketColumnListWithComment::bracketColumnListWithComment(ColumnListWithComment colListWithComment)) = "( <toString(colListWithComment)> )";

public str toString(ColumnListWithComment::columnListWithComment(list[ColumnNameWithComment] columnNameWithCommentList)) = "<intercalate(", ", [ toString(columnNameWithComment) | columnNameWithComment <- columnNameWithCommentList ])>";

public str toString(ColumnNameWithComment::columnNameWithComment(PropRef objNameOrId, list[CommentString] commentStringList)) = "<toString(objNameOrId)> <for(commentString <- commentStringList) {><toString(commentString)><}>";

public str toString(ViewCol::viewCol(PropRef objNameOrId, WithMaskingPolicy withMaskingPolicy, WithTags withTags)) = "<toString(objNameOrId)> <toString(withMaskingPolicy)> <toString(withTags)>";

public str toString(CopyIntoTable::copyIntoTableFromStage(PropRef objNameOrId, list[InternalOrExternalStage] internalOrExternalStageOpt,
                                list[Files] filesList, list[Pattern] patternList,
                                list[FileFormat] fileFormatList,
                                list[CopyOptions] copyOptionsList,
                                list[ValidationMode] validationModeList
                        )) 
                        = "COPY INTO <toString(objNameOrId)> <for(internalOrExternalStage <- internalOrExternalStageOpt) {>FROM <toString(internalOrExternalStage)><}> <for(files <- filesList) {><toString(files)><}> <for(pattern <- patternList) {><toString(pattern)><}> <for(fileFormat <- fileFormatList) {><toString(fileFormat)><}> <for(copyOptions <- copyOptionsList) {><toString(copyOptions)> <}> <for(validationMode <- validationModeList) {><toString(validationMode)><}>";

public str toString(Files::fileEq(list[String] stringList)) = "FILES = (  <intercalate(", ", [ toString(string) | string <- stringList ])> )";

public str toString(ValidationMode::validationMode(ReturnValidationType returnValidationType)) = "VALIDATION_MODE = <toString(returnValidationType)>";

public str toString(ReturnValidationType::returnValidationTypeOpt1(str integer)) = "RETURN_<integer>_ROWS";

public str toString(ReturnValidationType::returnValidationTypeOpt2()) = "RETURN_ERRORS";

public str toString(ReturnValidationType::returnValidationTypeOpt3()) = "RETURN_ALL_ERRORS";

public str toString(CreateTableLike::createTableLike(list[OrReplace] orReplaceOpt,list[TableType] ttype, TableName t1, TableName t2,
                                list[ClusterBy] clusterByList, list[CopyGrants] copyGrantsList
                        )) 
                        = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> <for(tableType <- ttype) {><toString(tableType)><}> TABLE <toString(t1)> LIKE <toString(t2)> <for(clusterBy <- clusterByList) {><toString(clusterBy)><}> <for(copyGrants <- copyGrantsList) {><toString(copyGrants)><}>";

public str toString(Secure::secure()) = "SECURE";

public str toString(Materialized::material()) = "MATERIALIZED";

public str toString(CreateView::createViewSF(list[OrReplace] orReplaceList,list[Secure] secureOpt,list[Materialized] materializedOpt, list[IfNotExists] ifNotExistsList, TableName tableName,
                                list[BracketColumnListWithComment] bracketColumnListWithComment, list[ViewCol] viewColList,
                                list[WithRowAccessPolicy] withRowAccessPolicyOpt, list[WithTags] withTagsOpt,
                                list[CopyGrants] copyGrantsOpt, list[CommentClause] commentClauseOpt,list[ClusterBy] clusterOpt,
                                QueryOrWith query
                        )) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <intercalate("", [ toString(secure) | secure <- secureOpt ])> <intercalate("", [ toString(materialized) | materialized <- materializedOpt ])> VIEW <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(tableName)> <for(bracketColumnListWith <- bracketColumnListWithComment) {><toString(bracketColumnListWith)><}> <for(viewCol <- viewColList) {><toString(viewCol)> <}> <for(withRowAccessPolicy <- withRowAccessPolicyOpt) {><toString(withRowAccessPolicy)><}> <for(withTags <- withTagsOpt) {><toString(withTags)><}> <intercalate("", [ toString(copyGrants) | copyGrants <- copyGrantsOpt ])> <for(commentClause <- commentClauseOpt) {><toString(commentClause)><}> <intercalate("", [ toString(clusterBy) | clusterBy <- clusterOpt ])> AS <toString(query)>";

public str toString(RegionGroup::regionGroup(Identifier id)) = "REGION_GROUP = <toString(id)>";

public str toString(SnowflakeRegion::snowflakeRegion(Identifier id)) = "REGION = <toString(id)>";

public str toString(AsReplicaOfObjectName::asReplicaOfObjectName(PropRef objNameOrId)) = "AS REPLICA OF <toString(objNameOrId)>";

public str toString(CreateFailoverGroup::createFailoverGroupAsReplica(list[IfNotExists] ifNotExistsList, Identifier id, AsReplicaOfObjectName asReplicaOfObjectName))
                        = "CREATE FAILOVER GROUP <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> <toString(asReplicaOfObjectName)>";

public str toString(CreateFailoverGroup::createFailoverGroupObjectTypes(list[IfNotExists] ifNotExistsList, Identifier id, 
                                        ObjectTypeList objectTypeList,
                                        list[AllowedDatabases] allowedDatabasesList,
                                        list[AllowedShares] allowedSharesList, 
                                        list[AllowedIntegrationTypes] allowedIntegrationTypesList,
                                        PropRef objNameOrId, 
                                        list[IgnoreEditionCheck] ignoreEditionCheckList, 
                                        list[Property] props
                                ))
                        = "CREATE FAILOVER GROUP <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> OBJECT_TYPES = <toString(objectTypeList)> <for(allowedDatabases <- allowedDatabasesList) {><toString(allowedDatabases)> <}> <for(allowedShares <- allowedSharesList) {><toString(allowedShares)><}> <for(allowedIntegrationTypes <- allowedIntegrationTypesList) {><toString(allowedIntegrationTypes)><}> ALLOWED_ACCOUNTS = <toString(objNameOrId)> <for(ignoreEditionCheck <- ignoreEditionCheckList) {><toString(ignoreEditionCheck)><}> <for(prop <- props) {><toString(prop)><}>";

public str toString(AllowedDatabases::allowedDatabases(list[Identifier] idList)) = "ALLOWED_DATABASES = <intercalate(", ", [ toString(id) | id <- idList ])>";

public str toString(AllowedShares::allowedShares(list[Identifier] idList)) = "ALLOWED_SHARES = <intercalate(", ", [ toString(id) | id <- idList ])>";

public str toString(AllowedIntegrationTypes::allowedIntegrationTypes(list[IntegrationTypeName] integrationTypeNameList)) = "ALLOWED_INTEGRATION_TYPES =  <intercalate(", ", [ toString(integrationTypeName) | integrationTypeName <- integrationTypeNameList ])>";

public str toString(IntegrationTypeName::securityIntegrations()) = "SECURITY INTEGRATIONS";

public str toString(IntegrationTypeName::apiIntegrations()) = "API INTEGRATIONS";

public str toString(CreateApiIntegration::apiAwsRole(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsList,Identifier identifier, list[Property] propList,
                          list[CommentClause] commentClauseOpt ))
  = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> API INTEGRATION <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(identifier)> <for(prop <- propList) {><toString(prop)> <}> <for(commentClause <- commentClauseOpt) {><toString(commentClause)><}>";

public str toString(CreateExternalFunction::createExternalFunction(list[OrReplace] orReplaceList,list[Secure] secureOpt, TableName tablename, list[ArgDataTypeList] argDataTypeList,
                                        DataType dataType, list[NullNotNull] nullNotNullList, list[CalledReturnsOrStrict] calledReturnsOrStrictOpt,
                                        list[VolatileOrImmutable] volatileOrImmutableList, list[CommentClause] commentClauselist, list[Property] propList, String string
                                        )) 
  = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> <for(secure <- secureOpt) {><toString(secure)><}> EXTERNAL FUNCTION <toString(tablename)> ( <for(argDataType <- argDataTypeList) {><toString(argDataType)><}> ) RETURNS <toString(dataType)> <for(nullNotNull <- nullNotNullList) {><toString(nullNotNull)><}> <for(calledReturnsOrStrict <- calledReturnsOrStrictOpt) {><toString(calledReturnsOrStrict)><}> <for(volatileOrImmutable <- volatileOrImmutableList) {><toString(volatileOrImmutable)><}> <for(commentClause <- commentClauselist) {><toString(commentClause)><}> <for(prop <- propList) {><toString(prop)> <}> AS <toString(string)>";

public str toString(ArgDataTypeList::argDataTypeList(lrel[Identifier id, DataType dt] argDataTypeList)) 
  = "<for(argDataType <- argDataTypeList) {> <toString(argDataType.id)> <toString(argDataType.dt)> <if (argDataType != argDataTypeList[-1]) {>, <}><}>";

public str toString(VolatileOrImmutable::volatileOpt()) = "VOLATILE";

public str toString(VolatileOrImmutable::immutableOpt()) = "IMMUTABLE";

public str toString(CreateExternalTable::createExternalTableAuto(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt, 
                                        TableName tableName, ExternalTableColumnDeclList externalTableColumnDeclList, 
                                        list[Property] propOpt, list[PartitionByClause] partitionByList, 
                                        LocationEqInternalOrExternalStage locationEqInternalOrExternalStage, list[RefreshOnCreate] refreshOnCreateList, 
                                        list[AutoRefresh] autoRefreshList, list[Pattern] patternList, FileFormat fileFormat, list[Property] awsSNSTopOpt, 
                                        list[CopyGrants] copyGrantsOpt, list[WithRowAccessPolicy] withRowAccessPolicyList, list[WithTags] withTagsList, list[CommentClause] commentClauseOpt
                                        )) 
  = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> EXTERNAL TABLE <for(ifNotExists <- ifNotExistsOpt) {><toString(ifNotExists)><}> <toString(tableName)> ( <toString(externalTableColumnDeclList)> ) <intercalate(" ", [ toString(prop) | prop <- propOpt ])> <for(partitionBy <- partitionByList) {><toString(partitionBy)><}> <toString(locationEqInternalOrExternalStage)> <for(refreshOnCreate <- refreshOnCreateList) {><toString(refreshOnCreate)><}> <for(autoRefresh <- autoRefreshList) {><toString(autoRefresh)><}> <for(pattern <- patternList) {><toString(pattern)><}> <toString(fileFormat)> <for(awsSNSTopic <- awsSNSTopOpt) {><toString(awsSNSTopic)><}> <for(copyGrants <- copyGrantsOpt) {><toString(copyGrants)><}> <for(withRowAccessPolicy <- withRowAccessPolicyList) {><toString(withRowAccessPolicy)><}> <for(withTags <- withTagsList) {><toString(withTags)><}> <for(commentClause <- commentClauseOpt) {><toString(commentClause)><}>";

public str toString(CreateExternalTable::createExternalTableDeltaLake(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsOpt, 
                                        TableName tableName, ExternalTableColumnDeclList externalTableColumnDeclList, 
                                        list[Property] propOpt, list[PartitionByClause] partitionByList, 
                                        LocationEqInternalOrExternalStage locationEqInternalOrExternalStage,
                                        FileFormat FileFormat, 
                                        list[TableFormatEqDelta] tableFormatEqDeltaList, 
                                        list[CopyGrants] copyGrantsList,
                                        list[WithRowAccessPolicy] withRowAccessPolicyList, list[WithTags] withTagsList, list[CommentClause] commentClauseList
                                )) 
  = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> EXTERNAL TABLE <for(ifNotExists <- ifNotExistsOpt) {><toString(ifNotExists)><}> <toString(tableName)> ( <toString(externalTableColumnDeclList)> ) <for(prop <- propOpt) {><toString(prop)> <}> <for(partitionBy <- partitionByList) {><toString(partitionBy)><}> <toString(locationEqInternalOrExternalStage)> PARTITION_TYPE = USER_SPECIFIED <toString(fileFormat)> <for(tableFormatEqDelta <- tableFormatEqDeltaList) {><toString(tableFormatEqDelta)><}>  <for(copyGrants <- copyGrantsList) {><toString(copyGrants)><}> <for(withRowAccessPolicy <- withRowAccessPolicyList) {><toString(withRowAccessPolicy)><}> <for(withTags <- withTagsList) {><toString(withTags)><}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";

public str toString(ExternalTableColumnDeclList::externalTableColumnDeclList(list[ExternalTableColumnDecl] externalTableColumnDeclList)) = "<intercalate(", ", [ toString(externalTableColumnDecl) | externalTableColumnDecl <- externalTableColumnDeclList ])>";

public str toString(ExternalTableColumnDecl::externalTableColumnDecl(PropRef objNameOrId, DataType dataType, Expr exp, list[InlineConstraint] inlineConstraintOPT)) = "<toString(objNameOrId)> <toString(dataType)> AS <toString(exp)> <for(inlineConstraint <- inlineConstraintOPT) {><toString(inlineConstraint)><}>";

public str toString(LocationEqInternalOrExternalStage::withLocation(list[WithClause] withOpt, InternalOrExternalStage internalOrExternalStage)) = "<intercalate(", ", [ toString(with) | with <- withOpt ])> LOCATION = <toString(internalOrExternalStage)>";

public str toString(RefreshOnCreate::refreshOnCreate(Boolean boolVal)) = "REFRESH_ON_CREATE = <toString(boolVal)>";

public str toString(TableFormatEqDelta::tableFormatEqDelta()) = "TABLE_FORMAT = DELTA";

public str toString(CreateNotificationIntegration::createNotification(list[OrReplace] orReplaceOpt, list[IfNotExists] ifNotExistsList, Identifier id,
                                        list[Property] props, list[CloudProviderParamsPush] cloudProviderParamsPushOpt, list[CommentClause] commentClauseOpt
                                        )) 
  = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> NOTIFICATION INTEGRATION <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> <intercalate(" ", [ toString(prop) | prop <- props ])> <intercalate("", [ toString(cloudProviderParamsPush) | cloudProviderParamsPush <- cloudProviderParamsPushOpt ])> <intercalate("", [ toString(commentClause) | commentClause <- commentClauseOpt ])>";

public str toString(CreateProcedure::createProcedureLang(list[OrReplace] orReplaceOpt,list[Secure] secureOpt, PropRef objNameOrId, list[ArgDataTypeList] argDataTypeListOpt,
                                ReturnsType returnsType, list[NullNotNull] nullNotNullOpt,Lang lang, list[CalledReturnsOrStrict] calledReturnsOrStrictList,
                                list[VolatileOrImmutable] volatileOrImmutableOpt, list[CommentClause] commentClauseOpt,
                                list[ExecuteAs] executeAsOpt, String string
                                )) 
  = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> <intercalate("", [ toString(secure) | secure <- secureOpt ])> PROCEDURE <toString(objNameOrId)> ( <for(argDataType <- argDataTypeListOpt) {><toString(argDataType)><}> ) RETURNS <toString(returnsType)> <for(nullNotNull <- nullNotNullOpt) {><toString(nullNotNull)><}> LANGUAGE <toString(lang)> <for(calledReturnsOrStrict <- calledReturnsOrStrictList) {><toString(calledReturnsOrStrict)><}> <for(volatileOrImmutable <- volatileOrImmutableOpt) {><toString(volatileOrImmutable)><}> <for(commentClause <- commentClauseOpt) {><toString(commentClause)><}> <for(executeAs <- executeAsOpt) {><toString(executeAs)><}> AS <toString(string)>";

public str toString(Lang::sql()) = "SQL";
public str toString(Lang::js()) = "Javascript";

public str toString(ExecuteAs::executeAs(CallerOwner callerOwner)) = "EXECUTE AS <toString(callerOwner)>";

public str toString(CreateReplicationGroup::replicationGroupAllowed(list[IfNotExists] ifNotExistsList, Identifier id, ObjectTypes objectTypes,
                                        list[AllowedDatabases] allowedDatabasesList, list[AllowedShares] allowedSharesList, list[AllowedIntegrationTypes] allowedIntegrationTypesList,
                                        PropRef objNameOrId, list[IgnoreEditionCheck] ignoreEditionCheckList, list[Property] replicationScheduleList
                                        )) 
  = "CREATE REPLICATION GROUP <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> <toString(objectTypes)> <for(allowedDatabases <- allowedDatabasesList) {><toString(allowedDatabases)><}> <for(allowedShares <- allowedSharesList) {><toString(allowedShares)><}> <for(allowedIntegrationTypes <- allowedIntegrationTypesList) {><toString(allowedIntegrationTypes)><}> <for(allowedIntegrationTypes <- allowedIntegrationTypesList) {><toString(allowedIntegrationTypes)><}> ALLOWED_ACCOUNTS = <toString(objNameOrId)> <for(ignoreEditionCheck <- ignoreEditionCheckList) {><toString(ignoreEditionCheck)><}> <for(replicationSchedule <- replicationScheduleList) {><toString(replicationSchedule)><}>";

public str toString(CreateReplicationGroup::replicationGroupReplica(list[IfNotExists] ifNotExistsList, Identifier id, AsReplicaOfObjectName asReplicaOfObjectName
                                        )) 
  = "CREATE REPLICATION GROUP <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(id)> <toString(asReplicaOfObjectName)>";

public str toString(CreateSequence::createSequence(list[OrReplace] orReplaceList, list[IfNotExists] ifNotExistsList, PropRef objNameOrId, list[WithClause] withOpt,
                                list[StartWith] startWithList, list[IncrementBy] incrementByList, list[OrderNoOrder] orderNoOrderList, list[CommentClause] commentClauseList
                                )) 
                                        = "CREATE <for(orReplace <- orReplaceList) {><toString(orReplace)><}> SEQUENCE <for(ifNotExists <- ifNotExistsList) {><toString(ifNotExists)><}> <toString(objNameOrId)> <for(with <- withOpt) {><toString(with)><}> <for(startWith <- startWithList) {><toString(startWith)><}> <for(incrementBy <- incrementByList) {><toString(incrementBy)><}> <for(orderNoOrder <- orderNoOrderList) {><toString(orderNoOrder)><}> <for(commentClause <- commentClauseList) {><toString(commentClause)><}>";

public str toString(CreateFunction::createFunction(list[OrReplace] orReplaceOpt,list[Secure] secureOpt, TableName objNameOrId, list[ArgDataTypeList] argDataTypeListOpt,
                                ReturnsType returnsType, list[NullNotNull] nullNotNullList,list[Lang] lngOpt, list[CalledReturnsOrStrict] calledReturnsOrStrictList,
                                list[VolatileOrImmutable] volatileOrImmutableList,list[str] memOpt, list[CommentClause] commentClauseOpt,  String string
                                )) 
  = "CREATE <for(orReplace <- orReplaceOpt) {><toString(orReplace)><}> <intercalate("", [ toString(secure) | secure <- secureOpt ])> FUNCTION <toString(objNameOrId)> ( <intercalate("", [ toString(argDataType) | argDataType <- argDataTypeListOpt ])> ) RETURNS <toString(returnsType)> <intercalate("", [ toString(nullNotNull) | nullNotNull <- nullNotNullList ])> <for(lang <- lngOpt) {>LANGUAGE <toString(lang)><}> <intercalate("", [ toString(calledReturnsOrStrict) | calledReturnsOrStrict <- calledReturnsOrStrictList ])> <intercalate("", [ toString(volatileOrImmutable) | volatileOrImmutable <- volatileOrImmutableList ])>" + " <prettyOptional(memOpt, toString)>" + " <intercalate("", [ toString(commentClause) | commentClause <- commentClauseOpt ])> AS <toString(string)>";

public str toString(ReturnsType::returnsDataType(DataType dataType)) = "<toString(dataType)>";

public str toString(ReturnsType::returnsTable(list[ColDeclList] colDeclList)) = "TABLE ( <for(colDecl <- colDeclList) {><toString(colDecl)><}> )";

public str toString(ColDeclList::colDeclList(list[ColDecl] colDeclList)) = "<intercalate(", ", [ toString(coldecl) | coldecl <- colDeclList ])>";

public str toString(Call::callClause(PropRef objNameOrId, list[ExpList] expListList)) = "CALL <toString(objNameOrId)>( <for(expList <- expListList) {><toString(expList)><}> )";

public str toString(Statement::dropAlertCommand(Identifier id)) = "DROP ALERT <toString(id)>";
public str toString(Statement::dropConnectionCommand(list[IfExists] ifExistsOpt, Identifier id)) = "DROP CONNECTION <for(ifExists <- ifExistsOpt) {><toString(ifExists)><}> <toString(id)>";

public str toString(Statement::dropObjectCommand(list[ObjectType] objectTypeOpt,list[ObjectTypeName] objectTypeNameOpt, list[IfExists] ifExists, IdentifierType idType, list[CascadeRestrict] cascadeRestrictList)) 
= "DROP <for(objectType <- objectTypeOpt) {><toString(objectType)><}> <for(objectTypeName <- objectTypeNameOpt) {><toString(objectTypeName)><}> <for(ifExsts <- ifExists) {><toString(ifExsts)><}> <toString(idType)> <for(cascadeRestrict <- cascadeRestrictList) {><toString(cascadeRestrict)><}>";
public str toString(Statement::dropTableWithCascade(list[IfExists] ifExistsList, TableName tableName, list[CascadeRestrict] cascadeRestrictList)) 
= "DROP TABLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tableName)> <for(cascadeRestrict <- cascadeRestrictList) {><toString(cascadeRestrict)><}>";
public str toString(Statement::dropDynamicTableCommand(Identifier id)) 
= "DROP DYNAMIC TABLE <toString(id)>";
public str toString(Statement::dropExternalTableCommand(list[IfExists] ifExistsList, TableName tablename, list[CascadeRestrict] cascadeRestrictList)) 
= "DROP EXTERNAL TABLE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tablename)> <for(cascadeRestrict <- cascadeRestrictList) {><toString(cascadeRestrict)><}>";
public str toString(Statement::dropFailoverGroupCommand(list[IfExists] ifExistsList, Identifier id)) 
= "DROP FAILOVER GROUP <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)>";

public str toString(Statement::dropFunctionCommand(list[IfExists] ifExistsList, TableName tablename, ArgTypes argTypes)) 
= "DROP FUNCTION <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tablename)> <toString(argTypes)>";

public str toString(Statement::dropManagedAccountCommand(Identifier id))
= "DROP MANAGED ACCOUNT <toString(id)>";

public str toString(Statement::dropMaterializedViewsCommand(list[IfExists] ifExistsList, TableName tablename)) 
= "DROP MATERIALIZED VIEW <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tablename)>";

public str toString(Statement::dropReplicationGroupCommand(list[IfExists] ifExistsList, Identifier id)) 
= "DROP REPLICATION GROUP <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(id)>";

public str toString(Statement::dropResourceMonitorCommand(Identifier id)) 
= "DROP RESOURCE MONITOR <toString(id)>";

public str toString(Statement::dropProcedureCommand(list[IfExists] ifExistsList, TableName tablename, ArgTypes argTypes)) 
= "DROP PROCEDURE <for(ifExists <- ifExistsList) {><toString(ifExists)><}> <toString(tablename)> <toString(argTypes)>";

public str toString(CascadeRestrict::cascadeRestrictOpt1()) = "CASCADE";

public str toString(CascadeRestrict::cascadeRestrictOpt2()) = "RESTRICT";

public str toString(ArgTypes::argTypes(list[DataTypeList] dataTypeList)) = "( <for(dataType <- dataTypeList) {><toString(dataType)><}> )";

public str toString(IntegrationsOptionals::apiIntegrationsOpt()) = "API";
public str toString(IntegrationsOptionals::notificationIntegrationsOpt()) = "NOTIFICATION";
public str toString(IntegrationsOptionals::securityIntegrationsOpt()) = "SECURITY";
public str toString(IntegrationsOptionals::storageIntegrationsOpt()) = "STORAGE";

public str toString(Statement::undropObjectCommand(ObjectTypeName objType, PropRef idname)) = "UNDROP <toString(objType)> <toString(idname)>";

public str toString(ObjectTypeName::roleObjectTypeName()) = "ROLE";
public str toString(ObjectTypeName::shareObjectTypeName()) = "SHARE";
public str toString(ObjectTypeName::userObjectTypeName()) = "USER";
public str toString(ObjectTypeName::warehouseObjectTypeName()) = "WAREHOUSE";
public str toString(ObjectTypeName::integrationObjectTypeName(list[IntegrationsOptionals] intOpt)) = "<for(integration <- intOpt) {><toString(integration)><}> INTEGRATION";
public str toString(ObjectTypeName::networkObjectTypeName()) = "NETWORK POLICY";
public str toString(ObjectTypeName::sessionObjectTypeName()) = "SESSION POLICY";
public str toString(ObjectTypeName::databaseObjectTypeName()) = "DATABASE";
public str toString(ObjectTypeName::schemaObjectTypeName()) = "SCHEMA";
public str toString(ObjectTypeName::tableObjectTypeName()) = "TABLE";
public str toString(ObjectTypeName::viewObjectTypeName()) = "VIEW";
public str toString(ObjectTypeName::stageObjectTypeName()) = "STAGE";
public str toString(ObjectTypeName::fileFormatObjectTypeName()) = "FILE FORMAT";
public str toString(ObjectTypeName::streamObjectTypeName()) = "STREAM";
public str toString(ObjectTypeName::taskObjectTypeName()) = "TASK";
public str toString(ObjectTypeName::maskingObjectTypeName()) = "MASKING POLICY";
public str toString(ObjectTypeName::rowAccessObjectTypeName()) = "ROW ACCESS POLICY";
public str toString(ObjectTypeName::tagObjectTypeName()) = "TAG";
public str toString(ObjectTypeName::pipeObjectTypeName()) = "PIPE";
public str toString(ObjectTypeName::functionObjectTypeName()) = "FUNCTION";
public str toString(ObjectTypeName::procedureObjectTypeName()) = "PROCEDURE";
public str toString(ObjectTypeName::sequenceObjectTypeName()) = "SEQUENCE";

public str toString(FailOrRep::failover()) = "FAILOVER";
public str toString(FailOrRep::replication()) = "REPLICATION";

public str toString(Statement::copyIntoTableCommand(CopyIntoTable copyIntoTable)) = "<toString(copyIntoTable)>";
public str toString(Statement::beginTransactionCommand(BeginTransaction beginTransaction,list[WorkOrTransaction] wotOpt,list[NameId] nidOpt)) = "<toString(beginTransaction)> <intercalate("", [ toString(wot) | wot <- wotOpt ])> <intercalate("", [ toString(nameid) | nameid <- nidOpt ])>";
public str toString(Statement::copyIntoLocationCommand(CopyIntoLocation copyIntoLocation)) = "<toString(copyIntoLocation)>";
public str toString(Statement::commentCommand(Comment comment)) = "<toString(comment)>";
public str toString(Statement::commitCommand(Commit commit)) = "<toString(commit)>";
public str toString(Statement::executeImmediateCommand(Expr exp, list[UsingColumnList] usingColumnList)) = "EXECUTE IMMEDIATE <toString(exp)> <for(usingColumn <- usingColumnList) {><toString(usingColumn)><}>";
public str toString(Statement::executeTaskCommand(PropRef objNameOrId))  = "EXECUTE TASK <toString(objNameOrId)>";
public str toString(Statement::getDMLCommand(InternalOrExternalStage internalOrExternalStage, FilePath filePath, list[Property] parallelList, list[Pattern] patternList)) 
 = "GET <toString(internalOrExternalStage)> <toString(filePath)> <for(parallel <- parallelList) {><toString(parallel)><}> <for(pattern <- patternList) {><toString(pattern)><}>";
public str toString(Statement::listCommand(InternalOrExternalStage internalOrExternalStage, list[Pattern] patternList)) 
= "LIST <toString(internalOrExternalStage)> <for(pattern <- patternList) {><toString(pattern)><}>";
public str toString(Statement::removeCommand(InternalOrExternalStage internalOrExternalStage, list[Pattern] patternList))
= "REMOVE <toString(internalOrExternalStage)> <for(pattern <- patternList) {><toString(pattern)><}>";
public str toString(Statement::setCommand(SetUnset setCom)) = "<toString(setCom)>";
public str toString(Statement::truncateMaterializedViewCommand(PropRef objNameOrId)) = "TRUNCATE MATERIALIZED VIEW <toString(objNameOrId)>";
public str toString(Statement::revokeRoleCommand(RoleName roleName, RoleOrUser roleOrUser)) 
= "REVOKE ROLE <toString(roleName)> FROM <toString(roleOrUser)>";
public str toString(Statement::callCommand(Call call)) = "<toString(call)>";
public str toString(Statement::putCommand(FilePath filePath, InternalOrExternalStage internalOrExternalStage,
                        list[Property] propList
                        )) 
                        = "PUT <toString(filePath)> <toString(internalOrExternalStage)> <for(prop <- propList) {><toString(prop)> <}>";
public str toString(Statement::rollbackCommand(Rollback rollback)) = "<toString(rollback)>";

public str toString(Statement::showAlertsCommand(ShowAlerts showAlerts)) = "<toString(showAlerts)>";
public str toString(Statement::showChannelsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW CHANNELS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showColumnsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW COLUMNS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showConnectionsCommand(list[LikePattern] likePatternOpt)) 
= "SHOW CONNECTIONS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showDatabasesCommand(ShowDatabases showDatabases)) = "<toString(showDatabases)>";
public str toString(Statement::showDatabasesInFailoverGroupCommand(FailOrRep failorrep, Identifier id)) 
= "SHOW DATABASES IN <toString(failorrep)> GROUP <toString(id)>";
public str toString(Statement::showDelegatedAuthorizationsCommand(list[ShowDelegatedAuthorizations] showDelegatedAuthorizations,list[Identifier] idOpt)) 
= "SHOW DELEGATED AUTHORIZATIONS <for(showDelegated <- showDelegatedAuthorizations) {><toString(showDelegated)><}> <for(id <- idOpt) {><toString(id)><}>";
public str toString(Statement::showDynamicTablesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)) 
= "SHOW DYNAMIC TABLES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitRows <- limitRowsList) {><toString(limitRows)><}>";
public str toString(Statement::showEventTablesCommand(ShowEventTables showEventTables)) = "<toString(showEventTables)>";
public str toString(Statement::showExternalFunctionsCommand(list[LikePattern] likePatternOpt)) 
= "SHOW EXTERNAL FUNCTIONS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showExternalTablesCommand(ShowExternalTables showExternalTables)) = "<toString(showExternalTables)>";
public str toString(Statement::showFailoverGroupsCommand(list[InShowOptionals] inShowOptionalsList)) 
= "SHOW FAILOVER GROUPS <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showFileFormatsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW FILE FORMATS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showFunctionsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW FUNCTIONS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showGlobalAccountsCommand(list[LikePattern] likePatternOpt)) 
= "SHOW GLOBAL ACCOUNTS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showGrantsCommand(ShowGrants showGrants)) = "<toString(showGrants)>";
public str toString(Statement::showIntegrationsCommand(list[IntegrationsOptionals] integrationsOptionalsList, list[LikePattern] likePatternOpt)) 
= "SHOW <for(integrationsOptionals <- integrationsOptionalsList) {><toString(integrationsOptionals)><}> INTEGRATIONS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showLocksCommand(list[InAccount] inAccountList)) 
= "SHOW LOCKS <for(inAccount <- inAccountList) {><toString(inAccount)><}>";
public str toString(Statement::showManagedAccountsCommand(list[LikePattern] likePatternOpt)) 
= "SHOW MANAGED ACCOUNTS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showMaskingPoliciesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW MASKING POLICIES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showMaterializedViewsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW MATERIALIZED VIEWS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showNetworkPoliciesCommand()) = "SHOW NETWORK POLICIES";
public str toString(Statement::showObjectsCommand(list[LikePattern] likePatternOpt, list[ShowOptionals] showOptionalsList)) 
= "SHOW OBJECTS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(showOptionals <- showOptionalsList) {><toString(showOptionals)><}>";
public str toString(Statement::showOrganizationAccountsCommand(list[LikePattern] likePatternOpt)) = "SHOW ORGANIZATION ACCOUNTS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showParametersCommand(list[LikePattern] likePatternOpt, list[InOrForShowParameter] inOrForShowParameterList)) 
= "SHOW PARAMETERS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inOrForShowParameter <- inOrForShowParameterList) {><toString(inOrForShowParameter)><}>";
public str toString(Statement::showPipesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW PIPES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showPrimaryKeysCommand(ShowPrimaryKeys showPrimaryKeys)) = "<toString(showPrimaryKeys)>";
public str toString(Statement::showProceduresCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW PROCEDURES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showRegionsCommand(list[LikePattern] likePatternOpt)) 
= "SHOW REGIONS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showReplicationAccountsCommand(list[LikePattern] likePatternOpt)) 
= "SHOW REPLICATION ACCOUNTS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showReplicationDatabasesCommand(list[LikePattern] likePatternOpt, list[WithPrimaryColName] withPrimaryColNameList)) 
= "SHOW REPLICATION DATABASES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(withPrimaryColName <- withPrimaryColNameList) {><toString(withPrimaryColName)><}>";
public str toString(Statement::showReplicationGroupsCommand(list[InShowOptionals] inShowOptionalsList)) 
= "SHOW REPLICATION GROUPS <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showResourceMonitorsCommand(list[LikePattern] likePatternOpt)) 
= "SHOW RESOURCE MONITORS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showRolesCommand(list[LikePattern] likePatternOpt)) 
= "SHOW ROLES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showRowAccessPoliciesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW ROW ACCESS POLICIES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showSchemasCommand(ShowSchemas showSchemas)) = "<toString(showSchemas)>";
public str toString(Statement::showSequencesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW SEQUENCES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showSessionPoliciesCommand()) 
= "SHOW SESSION POLICIES";
public str toString(Statement::showSharesCommand(list[LikePattern] likePatternOpt)) 
= "SHOW SHARES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showSharesInFailoverGroupCommand(FailOrRep forep, Identifier id)) 
= "SHOW SHARES IN <toString(forep)> GROUP <toString(id)>";
public str toString(Statement::showStagesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW STAGES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showStreamsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW STREAMS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showTablesCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW TABLES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showTagsCommand(list[LikePattern] likePatternOpt, list[ShowTagsOptionals] showTagsOptionalsList)) 
= "SHOW TAGS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(showTagsOptionals <- showTagsOptionalsList) {><toString(showTagsOptionals)><}>";
public str toString(Statement::showTasksCommand(ShowTasks showTasks)) = "<toString(showTasks)>";
public str toString(Statement::showTransactionsCommand(list[InAccount] inAccountList)) 
= "SHOW TRANSACTIONS <for(inAccount <- inAccountList) {><toString(inAccount)><}>";
public str toString(Statement::showUserFunctionsCommand(list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList)) 
= "SHOW USER FUNCTIONS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";
public str toString(Statement::showUsersCommand(ShowUsers showUsers)) = "<toString(showUsers)>";
public str toString(Statement::showVariablesCommand(list[LikePattern] likePatternOpt)) 
= "SHOW VARIABLES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";
public str toString(Statement::showViewsCommand(ShowViews showViews)) = "<toString(showViews)>";
public str toString(Statement::showWareHousesCommand(list[LikePattern] likePatternOpt)) 
= "SHOW WAREHOUSES <for(likePattern <- likePatternOpt) {><toString(likePattern)><}>";

public str toString(ShowAlerts::showAlerts(list[Terse] terseOpt,list[LikePattern] likePatternOpt, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)) = "SHOW <for(terse <- terseOpt) {><toString(terse)><}> ALERTS <for(likePattern <- likePatternOpt) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitRows <- limitRowsList) {><toString(limitRows)><}>";

public str toString(LikePattern::likePattern(String string)) = "LIKE <toString(string)>";

public str toString(Terse::terse()) = "TERSE";

public str toString(InShowOptionals::inShowOptionals(ShowOptionals showOptionals)) = "IN <toString(showOptionals)>";

public str toString(ShowOptionals::accountIdShowOpt(list[Identifier] idList)) = "ACCOUNT <for(id <- idList) {><toString(id)><}>";
public str toString(ShowOptionals::databaseIdShowOpt(list[Identifier] idList)) = "DATABASE <for(id <- idList) {><toString(id)><}>";
public str toString(ShowOptionals::tableNameShowOpt(list[PropRef] objNameOrIdList)) = "TABLE <for(objNameOrId <- objNameOrIdList) {><toString(objNameOrId)><}>";
public str toString(ShowOptionals::viewNameShowOpt(list[PropRef] objNameOrIdList)) = "VIEW <for(objNameOrId <- objNameOrIdList) {><toString(objNameOrId)><}>";
public str toString(ShowOptionals::schemaNameShowOpt(list[PropRef] objNameOrIdList)) = "SCHEMA <for(objNameOrId <- objNameOrIdList) {><toString(objNameOrId)><}>";
public str toString(ShowOptionals::objNameShowOpt(PropRef objNameOrId)) = "<toString(objNameOrId)>";

public str toString(StartsWith::startsWith(String string)) = "STARTS WITH <toString(string)>";

public str toString(LimitRows::limitRows(str integer, list[String] stringList)) = "LIMIT <integer> <for(string <- stringList) {>FROM <toString(string)><}>";

public str toString(ShowDatabases::showDatabasesOpt1(list[Terse] terse, list[str] hist,list[LikePattern] likePatternList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)) 
  = "SHOW <intercalate("", [ toString(terseStr) | terseStr <- terse ])> DATABASES <intercalate("", [ history | history <- hist ])> <intercalate("", [ toString(likePattern) | likePattern <- likePatternList ])> <intercalate("", [ toString(startsWith) | startsWith <- startsWithList ])> <intercalate("", [ toString(limitRows) | limitRows <- limitRowsList ])>";

public str toString(ShowDelegatedAuthorizations::showDelegatedAuthorizationsByUser()) = "BY USER";
public str toString(ShowDelegatedAuthorizations::showDelegatedAuthorizationsToSecurity()) = "TO SECURITY INTEGRATION";

public str toString(ShowEventTables::showEventTables(list[Terse] terse, list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)) = "SHOW <intercalate("", [ toString(terseStr) | terseStr <- terse ])> EVENT TABLES <for(likePattern <- likePatternList) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitRows <- limitRowsList) {><toString(limitRows)><}>";

public str toString(ShowExternalTables::showExternalTables(list[Terse] terseOpt, list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)) = "SHOW <intercalate("", [ toString(terseStr) | terseStr <- terseOpt ])> EXTERNAL TABLES <for(likePattern <- likePatternList) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitRows <- limitRowsList) {><toString(limitRows)><}>";

public str toString(ShowGrants::showGrantsOptionals(list[ShowGrantOptionals] showGrantOptionalsList)) = "SHOW GRANTS <for(showGrantOptionals <- showGrantOptionalsList) {><toString(showGrantOptionals)><}>";
public str toString(ShowGrants::showGrantsInSchema(PropRef objNameOrId)) = "SHOW FUTURE GRANTS IN SCHEMA <toString(objNameOrId)>";
public str toString(ShowGrants::showGrantsInDatabase(Identifier id)) = "SHOW FUTURE GRANTS IN DATABASE <toString(id)>";

public str toString(ShowGrantOptionals::onAccountShowGrantOpt()) = "ON ACCOUNT";
public str toString(ShowGrantOptionals::onObjectNameShowGrantOpt(ObjectType objectType, PropRef objNameOrId)) = "ON <toString(objectType)> <toString(objNameOrId)>";
public str toString(ShowGrantOptionals::toRoleShareShowGrantOpt(RoleUserOrShareId roleUserOrShareId)) = "TO <toString(roleUserOrShareId)>";
public str toString(ShowGrantOptionals::ofRoleShowGrantOpt(Identifier id)) = "OF ROLE <toString(id)>";
public str toString(ShowGrantOptionals::ofShareShowGrantOpt(Identifier id)) = "OF SHARE <toString(id)>";

public str toString(RoleUserOrShareId::roleId(ObjectTypeName objectTypeName, Identifier id)) = "<toString(objectTypeName)> <toString(id)>";

public str toString(InAccount::inAccount()) = "IN ACCOUNT";

public str toString(InOrForShowParameter::inOrForShowParameter(InOrFor inOrFor, ShowParameterOptionals showParameterOptionals)) = "<toString(inOrFor)> <toString(showParameterOptionals)>";

public str toString(InOrFor::inOrForOpt1()) = "IN";
public str toString(InOrFor::inOrForOpt2()) = "FOR";

public str toString(ShowParameterOptionals::sessionShowParameterOpt()) = "SESSION";
public str toString(ShowParameterOptionals::accountShowParameterOpt()) = "ACCOUNT";
public str toString(ShowParameterOptionals::userIdShowParameterOpt(list[Identifier] idList)) = "USER <for(id <- idList) {><toString(id)><}>";
public str toString(ShowParameterOptionals::paramObjShowParameterOpt(ShowParameterObjects showParameterObjects)) = "<toString(showParameterObjects)>";
public str toString(ShowParameterOptionals::tableNameShowParameterOpt(PropRef objNameOrId)) = "TABLE <toString(objNameOrId)>";

public str toString(ShowParameterObjects::warehouseIdShowParameterObj(list[Identifier] idList)) = "WAREHOUSE <for(id <- idList) {><toString(id)><}>";
public str toString(ShowParameterObjects::databaseidShowParameterObj(list[Identifier] idList)) = "DATABASE <for(id <- idList) {><toString(id)><}>";
public str toString(ShowParameterObjects::schemaIdShowParameterObj(list[Identifier] idList)) = "SCHEMA <for(id <- idList) {><toString(id)><}>";
public str toString(ShowParameterObjects::taskIdShowParameterObj(list[Identifier] idList)) = "TASK <for(id <- idList) {><toString(id)><}>";

public str toString(ShowPrimaryKeys::showPrimaryKeys(list[Terse] terseOpt,list[InShowOptionals] inShowOptionalsList)) = "SHOW <for(terse <- terseOpt) {><toString(terse)><}> PRIMARY KEYS <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}>";

public str toString(WithPrimaryColName::withPrimaryColName(PropRef objNameOrId)) = "WITH PRIMARY <toString(objNameOrId)>";

public str toString(ShowSchemas::showSchemasOpt1(list[Terse] terseOpt,list[str] histOpt, list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)) = "SHOW <intercalate("", [ toString(terseStr) | terseStr <- terseOpt ])> SCHEMAS <intercalate("", [ history | history <- histOpt ])> <for(likePattern <- likePatternList) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitRows <- limitRowsList) {><toString(limitRows)><}>";

public str toString(ShowTagsOptionals::inAccountShowTagsOpt(InAccount inAccount)) = "<toString(inAccount)>";
public str toString(ShowTagsOptionals::databaseIdShowTagsOpt(list[Identifier] idList)) = "DATABASE <for(id <- idList) {><toString(id)><}>";
public str toString(ShowTagsOptionals::schemaIdShowTagsOpt(list[Identifier] idList)) = "SCHEMA <for(id <- idList) {><toString(id)><}>";
public str toString(ShowTagsOptionals::idShowTagsOpt(Identifier id)) = "<toString(id)>";

public str toString(ShowTasks::showTasks(list[Terse] terseOpt, list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList))
  = "SHOW <for(terse <- terseOpt) {><toString(terse)><}> TASKS <for(likePattern <- likePatternList) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitRows <- limitRowsList) {><toString(limitRows)><}>";

public str toString(ShowUsers::showUsers(list[Terse] terseOpt, list[LikePattern] likePatternList, list[StartsWith] startsWithList, list[LimitInt] limitIntList, list[String] stringList)) 
  = "SHOW <for(terse <- terseOpt) {><toString(terse)><}> USERS <for(likePattern <- likePatternList) {><toString(likePattern)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitInt <- limitIntList) {><toString(limitInt)><}> <for(string <- stringList) {>FROM <toString(string)><}>";

public str toString(LimitInt::limitInt(str integer)) = "LIMIT <integer>";

public str toString(ShowViews::showViews(list[Terse] terse, list[LikePattern] likePatternList, list[InShowOptionals] inShowOptionalsList, list[StartsWith] startsWithList, list[LimitRows] limitRowsList)) = "SHOW <for(terseOpt <- terse) {><toString(terseOpt)><}> VIEWS <for(likePattern <- likePatternList) {><toString(likePattern)><}> <for(inShowOptionals <- inShowOptionalsList) {><toString(inShowOptionals)><}> <for(startsWith <- startsWithList) {><toString(startsWith)><}> <for(limitRows <- limitRowsList) {><toString(limitRows)><}>";

public str toString(Statement::useObjectCommand(ObjectTypeName objType, Expr exp)) = "USE <toString(objType)> <toString(exp)>";
public str toString(Statement::useSecondaryRolesCommand(AllOrNone allOrNone)) = "USE SECONDARY ROLES <toString(allOrNone)>";

public str toString(AllOrNone::allOrNoneOpt1()) = "ALL";
public str toString(AllOrNone::allOrNoneOpt2()) = " NONE";

public str toString(Statement::describeAlertCommand(Describe desc, Identifier id)) = "<toString(desc)> ALERT <toString(id)>";
public str toString(Statement::describeDynamicTableCommand(Describe describe, Identifier id)) = "<toString(describe)> DYNAMIC TABLE <toString(id)>";
public str toString(Statement::describeEventTableCommand(Describe describe, Identifier id)) = "<toString(describe)> EVENT TABLE <toString(id)>";
public str toString(Statement::describeExternalTableCommand(Describe describe, TableName tableName, list[DescribeTableType] describeTableTypeList)) 
= "<toString(describe)> EXTERNAL TABLE <toString(tableName)> <for(describeTableType <- describeTableTypeList) {><toString(describeTableType)><}>";
public str toString(Statement::describeMaterializedViewCommand(Describe describe, TableName tableName)) 
= "<toString(describe)> MATERIALIZED VIEW <toString(tableName)>";
public str toString(Statement::describeResultCommand(DescribeResult describeResult)) = "<toString(describeResult)>";
public str toString(Statement::describeSearchOptimizationCommand(Describe describe, TableName tableName)) 
= "<toString(describe)> SEARCH OPTIMIZATION ON <toString(tableName)>";
public str toString(Statement::describeTransactionCommand(Describe describe, str integer)) 
= "<toString(describe)> TRANSACTION <integer>";
public str toString(Statement::describeObjectCommand(Describe describe,ObjectTypeName object,Expr exp, list[DescribeTableType] dtt,list[ArgTypes] atypes)) 
= "<toString(describe)> <toString(object)> <toString(exp)> <for(descTabType <- dtt) {><toString(descTabType)><}> <for(argType <- atypes) {><toString(argType)><}>";

public str toString(Describe::describeOpt1()) = "DESC";
public str toString(Describe::describeOpt2()) = "DESCRIBE";

public str toString(DescribeTableType::describeTypeColumns()) = "TYPE = COLUMNS";
public str toString(DescribeTableType::describeTypeStage()) = "TYPE = STAGE";

public str toString(DescribeResult::describeResultStr(Describe describe, String string)) = "<toString(describe)> RESULT <toString(string)>";
public str toString(DescribeResult::describeResultLastQuery(Describe describe)) = "<toString(describe)> RESULT LAST_QUERY_ID()";

public str toString(BeginTransaction::beginTransaction()) = "BEGIN";
public str toString(BeginTransaction::startTransaction()) = "START";

public str toString(WorkOrTransaction::workOrTransactionOpt1()) = "WORK";
public str toString(WorkOrTransaction::workOrTransactionOpt2()) = "TRANSACTION";

public str toString(NameId::nameId(Identifier id)) = "NAME <toString(id)>";

public str toString(CopyIntoLocation::copyIntoLocation(InternalOrExternalStage internalOrExternalStage,
                                ObjectNameOrQuery objectNameOrQuery, list[PartitionByClause] partitionByList,
                                list[FileFormat] fileFormatList, list[CopyOptions] copyOptionsList,
                                list[ValidationMode] validationModeList, list[str] headerOpt
                        ))
                        = "COPY INTO <toString(internalOrExternalStage)> FROM <toString(objectNameOrQuery)> <for(partitionBy <- partitionByList) {><toString(partitionBy)><}> <for(fileFormat <- fileFormatList) {><toString(fileFormat)><}> <for(copyOptions <- copyOptionsList) {><toString(copyOptions)><}> <for(validationMode <- validationModeList) {><toString(validationMode)><}> <for(header <- headerOpt) {><header><}>";

public str toString(ObjectNameOrQuery::objectNameOrQueryOpt1(PropRef objNameOrId)) = "<toString(objNameOrId)>";
public str toString(ObjectNameOrQuery::objectNameOrQueryOpt2(QueryExpr query)) = "( <toString(query)> )";

public str toString(Comment::commentFuncSignature(list[IfExists] ifExistsOpt, ObjectTypeName objectTypeName, PropRef objNameOrId, list[ArgTypes] argTypesOpt, String string)) = "COMMENT <for(ifExists <- ifExistsOpt) {><toString(ifExists)><}> ON <toString(objectTypeName)> <toString(objNameOrId)> <for(argTypes <- argTypesOpt) {><toString(argTypes)><}> IS <toString(string)>";
public str toString(Comment::commentColumn(list[IfExists] ifExistsList, PropRef objNameOrId, String string)) = "COMMENT <for(ifExists <- ifExistsList) {><toString(ifExists)><}> ON COLUMN <toString(objNameOrId)> IS <toString(string)>";

public str toString(Commit::commitClause()) = "COMMIT WORK";
public str toString(Commit::commitClauseNoWork()) = "COMMIT";

public str toString(RoleName::idRoleName(Identifier id)) = "<toString(id)>";

public str toString(RoleOrUser::roleOrUserOpt1(ObjectTypeName objectName, RoleName roleName)) = "<toString(objectName)> <toString(roleName)>";

public str toString(FilePath::filePath1(str uri)) = "file:///<uri>";
public str toString(FilePath::filePath2(str windowsPath)) = "file://<windowsPath>";

public str toString(Rollback::rollback(list[str] work)) = "ROLLBACK <for(workStr <- work) {><workStr><}>";

public str toString(FirstOrLast::firstOrLast1()) = "FIRST";
public str toString(FirstOrLast::firstOrLast2()) = "LAST";

public str toString(SampleMethod::rowSamplMethod(RowSampling rowSampling)) = "<toString(rowSampling)>";
public str toString(SampleMethod::blockSampleMethod(BlockSampling blockSampling)) = "<toString(blockSampling)>";

public str toString(ColumnAliasList::columnAliasList(list[Identifier] idList)) = "( <intercalate(", ", [ toString(id) | id <- idList ])> )";

public str toString(SetUnsetTags::unsetTags(SetUnset setUnset, list[Expr] tagDeclList)) = "<toString(setUnset)> TAG <intercalate(", ", [ toString(tagDecl) | tagDecl <- tagDeclList ])>";

public str toString(WithRowAccessPolicy::withRowAccessPolicy(list[WithClause] withOpt,Identifier id, list[Identifier] objNameOrIdList)) = "<intercalate("", [ toString(with) | with <- withOpt ])> ROW ACCESS POLICY <toString(id)> ON ( <intercalate(", ", [ toString(objNameOrId) | objNameOrId <- objNameOrIdList ])> )";

public str toString(CalledReturnsOrStrict::calledOnNull()) = "CALLED ON NULL INPUT";
public str toString(CalledReturnsOrStrict::returnsNull()) = "RETURNS NULL ON NULL INPUT";
public str toString(CalledReturnsOrStrict::returnsStrict()) = "STRICT";
