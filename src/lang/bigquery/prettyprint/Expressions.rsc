module lang::bigquery::prettyprint::Expressions

extend lang::basesql::prettyprint::BaseSQL;
extend lang::bigquery::ast::BigQuery;
import List;

public str toString(schemaNameBigQuery(list[TableNameId] tidList,  TableNameId tid))
        = "<intercalate(".",[toString(tnid)|tnid<-tidList])> .<toString(tid)>.";

public str toString(unquotedIdentifer(str unquotedIdentifer)) = "<unquotedIdentifer>";

public str toString(withAggregationTreshhold(list[AggregationOptions] aggOptions, list[VarAssign] varAssign))
        = "WITH AGGREGATION_THRESHOLD <intercalate("",[toString(aggO)|aggO<-aggOptions])> <intercalate("",[toString(va)|va<-varAssign])>";

public str toString(aggOptions(list[ThresholdOpt] thresholdOpt, list[PrivacyUnitOpt] privacyUnitOpt))
        = "OPTIONS (<intercalate("",[toString(tho)|tho<-thresholdOpt])> <intercalate("",[toString(puo)|puo<-privacyUnitOpt])>)";

public str toString(thresholdOpt(Expr exp, list[str] strConst)) = "threshold = <toString(exp)> <intercalate("",[s|s<-strConst])>";

public str toString(privacyUnitOpt(Identifier columnName)) = "privacy_unit_column = <toString(columnName)>";

public str toString(explist(ExpList exprLit)) = "(<toString(exprLit)>)";

public str toString(structWithType(DataType dataType, list[Expr] exps)) = "<toString(dataType)> (<intercalate(",",[toString(e)|e<-exps])>)";

public str toString(structNoType(list[ExpAsVarStrict1] asexp)) = "STRUCT (<intercalate(",",[toString(asE)|asE<-asexp])>)";

public str toString(baseStruct(list[ExpAsVarStrict2] baseStruct)) = "(<intercalate(",",[toString(bs)|bs<-baseStruct])>)";

public str toString(ifNullExp(Expr lhs, Expr rhs)) = "IFNULL(<toString(lhs)>, <toString(rhs)>)";

public str toString(nullIfExp(Expr lhs, Expr rhs)) = "NULLIF(<toString(lhs)>, <toString(rhs)>)";

public str toString(ifExp(Expr expr1, Expr expr2, Expr expr3)) = "IF(<toString(expr1)>, <toString(expr2)>, <toString(expr3)>)";

public str toString(coalesceExp(list[Expr] exprlist)) = "COALESCE (<intercalate(",",[toString(e)|e<-exprlist])>)";

public str toString(expAsVarStrict1(Expr exp1, list[VarAssignStrictAs] asExps)) = "<toString(exp1)> <intercalate("",[toString(asE)|asE<-asExps])>";
public str toString(expAsVarStrict2(Expr exp1, VarAssignStrictAs asExp)) = "<toString(exp1)> <toString(asExp)>";
public str toString(varAssignStrictAs(VarAssignAs varAs, Identifier id)) = "<toString(varAs)> <toString(id)>";

public str toString(expList(Expr exp, list[Expr] exprList)) = "<toString(exp)>, <intercalate(",",[toString(el)|el<-exprList])>";

public str toString(arrayIndex(Identifier id, Expr expr)) = "<toString(id)> [<toString(expr)>]";

public str toString(arrayWithType(DataType datatype, CompositeLiteral compositeLit)) = "<toString(datatype)> <toString(compositeLit)>";

public str toString(arrayNoType(CompositeLiteral compositeLit)) = "ARRAY <toString(compositeLit)>";

public str toString(arrayNoKeyword(CompositeLiteral compositeLit)) = "<toString(compositeLit)>";

public str toString(structWithType(DataType dataType, list[Expr] exps)) = "<toString(dataType)> (<intercalate(",",[toString(e)|e<-exps])>)";

public str toString(structNoType(list[ExpAsVarStrict1] asexp)) = "STRUCT (<intercalate(",",[toString(asE)|asE<-asexp])>)";

public str toString(baseStruct(list[ExpAsVarStrict2] baseStruct)) = "(<intercalate(",",[toString(bs)|bs<-baseStruct])>)";

public str toString(listLiteral(list[ExprOrComposite] exprList)) = "[<intercalate(",",[toString(el)|el<-exprList])>]";

public str toString(exprLit(Expr expLit)) = "<toString(expLit)>";

public str toString(compositeLit(CompositeLiteral compLit)) = "<toString(compLit)>";

public str toString(primitiveType(PrimitiveType pType)) = "<toString(pType)>";

public str toString(notlike(Expr expr1, Expr expr2)) = "<toString(expr1)> NOT LIKE <toString(expr2)>";

public str toString(nullType()) = "NULL";
public str toString(timeType()) = "TIME";
public str toString(stringType(ExprInBrackets exprInBrackets)) = "STRING <toString(exprInBrackets)>";
public str toString(jsonType()) = "JSON";
public str toString(intervalType()) = "INTERVAL";
public str toString(int64Type()) = "INT64";
public str toString(geographyType()) = "GEOGRAPHY";
public str toString(floatType()) = "FLOAT64";
public str toString(dateType()) = "DATE";
public str toString(bytesType(list[ExprInBrackets] exprsOpt)) = "BYTES <intercalate("",[toString(exp)|exp<-exprsOpt])>";
public str toString(boolType()) = "BOOL";
public str toString(bignumericType(list[ExprInBrackets] exprsOpt)) = "BIGNUMERIC <intercalate("",[toString(exp)|exp<-exprsOpt])>";
public str toString(numericType(list[ExprInBrackets] exprsOpt)) = "NUMERIC <intercalate("",[toString(exp)|exp<-exprsOpt])>";
public str toString(expInBrackets(list[Expr] exprs)) = "(<intercalate(",",[toString(exp)|exp<-exprs])>)";

// Function
public str toString(function(FunctionCall funcCall)) = "<toString(funcCall)>";

public str toString(udf(list[PackageName] pkgNameOpt, str funcName, list[Expr] exprList))
        = "<intercalate("",[toString(pname)|pname<-pkgNameOpt])> <funcName> ( <intercalate(",",[toString(exp)|exp<-exprList])> )";

public str toString(inBuiltFunction(InBuiltFunction inBuiltFunction, list[AnalyticFunctionClause] analyticFunctionClauseOpt))
        = "<toString(inBuiltFunction)> <intercalate("",[toString(afcls)|afcls<-analyticFunctionClauseOpt])>";

public str toString(analyticFunctionClause(WindowSpecification windowSpecification))
        = "OVER <toString(windowSpecification)>";

public str toString(aggregateFunction(AggregateFunction aggregateFunction)) = "<toString(aggregateFunction)>";

public str toString(approximateAggregateFunc(ApproximateAggregateFunc approximateAggregateFunc)) = "<toString(approximateAggregateFunc)>";

public str toString(conversionFunction(ConversionFunctions conversionFunction)) = "<toString(conversionFunction)>";

public str toString(dateFunction(DateFunctions dateFunction)) = "<toString(dateFunction)>";

public str toString(navigationFunctions(NavigationFunctions navigationFunctions)) = "<toString(navigationFunctions)>";

public str toString(numberingFunctions(NumberingFunctions numberingFunctions)) = "<toString(numberingFunctions)>";

public str toString(statisticalAggregateFunctions(StatisticalAggregateFunctions statisticalAggregateFunctions)) = "<toString(statisticalAggregateFunctions)>";

public str toString(tableFunctions(TableFunctions tableFunctions)) = "<toString(tableFunctions)>";

public str toString(textAnalysisFunctions(TextAnalysisFunctions textAnalysisFunctions)) = "<toString(textAnalysisFunctions)>";

public str toString(arrayFunctions(ArrayFunctions arrayFunctions)) = "<toString(arrayFunctions)>";

public str toString(anyvalue(Expr exp, list[HavingExp] havingexp)) = "ANY_VALUE ( <toString(exp)> <intercalate("",[toString(hve)|hve<-havingexp])>)";

public str toString(arrayagg(list[Distinct] distinct, Expr exp, list[IgnoreRespect] ignorerespect, list[OrderBy] orderby, list[Limit] limit)) = "ARRAY_AGG(<intercalate("",[toString(dst)|dst<-distinct])> <toString(exp)> <intercalate("",[toString(igr)|igr<-ignorerespect])> <intercalate(",",[toString(ordr)|ordr<-orderby])> <intercalate("",[toString(l)|l<-limit])>)";

public str toString(arrayconcatagg(Expr exp, list[OrderBy] orderby, list[Limit] limit)) = "ARRAY_CONCAT_AGG (<toString(exp)> <intercalate(",",[toString(ordr)|ordr<-orderby])> <intercalate("",[toString(l)|l<-limit])>)";

public str toString(avg(list[Distinct] distinct, list[Expr] explist)) = "AVG (<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(bitAnd(Expr exp)) = "BIT_AND(<toString(exp)>)";

public str toString(bitOr(Expr exp)) = "BIT_OR(<toString(exp)>)";

public str toString(bitXor(list[Distinct] distinct, Expr exp)) = "<intercalate("",[toString(dst)|dst<-distinct])> <toString(exp)>";

public str toString(countAll()) = "COUNT(*)";

public str toString(count(list[Distinct] distinct, Expr exp)) = "COUNT(<intercalate("",[toString(dst)|dst<-distinct])> <toString(exp)>)";

public str toString(countIf(Expr exp)) = "COUNTIF(<toString(exp)>)";

public str toString(grouping(Expr exp)) = "GROUPING(<toString(exp)>)";

public str toString(logicalAnd(Expr exp)) = "LOGICAL_AND(<toString(exp)>)";

public str toString(logicalOr(Expr exp)) = "LOGICAL_OR(<toString(exp)>)";

public str toString(max(Expr exp)) = "MAX(<toString(exp)>)";

public str toString(maxBy(list[Expr] explist)) = "MAX_BY(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(minBy(list[Expr] explist)) = "MIN_BY(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(min(Expr exp)) = "MIN(<toString(exp)>)";

public str toString(stringAgg(list[Distinct] distinct, list[Expr] explist, list[OrderBy] orderBy, list[Limit] limit)) = "STRING_AGG(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])> <intercalate(",",[toString(ordr)|ordr<-orderBy])> <intercalate("",[toString(l)|l<-limit])>)";

public str toString(sum(list[Distinct] distinct, Expr exp)) = "SUM(<intercalate("",[toString(dst)|dst<-distinct])> <toString(exp)>)";

public str toString(approxCountDistinct(Expr exp)) = "APPROX_COUNT_DISTINCT(<toString(exp)>)";

public str toString(approxQuantiles(list[Distinct] distinct, list[Expr] explist, list[IgnoreRespect] ignorerespect)) = "APPROX_QUANTILES(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])> <intercalate("",[toString(igr)|igr<-ignorerespect])>)";

public str toString(approxTopCount(list[Expr] explist)) = "APPROX_TOP_COUNT(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(approxTopSum(list[Expr] explist)) = "APPROX_TOP_SUM(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(array(Expr expr)) = "ARRAY(<toString(expr)>)";

public str toString(array(QueryOrWith qryWith)) = "ARRAY(<toString(qryWith)>)";

public str toString(safeCast(Expr exp, DataType datatype, list[FormatClause] formatClause)) = "SAFE_CAST(<toString(exp)> AS <toString(datatype)> <intercalate("",[toString(fc)|fc<-formatClause])>)";

public str toString(castAsTimestamp(Expr exp1, DataType datatype, list[FormatClause] formatClause, Expr exp2)) = "CAST(<toString(exp1)> AS <toString(datatype)> <intercalate("",[toString(fc)|fc<-formatClause])> AT TIME ZONE <toString(exp2)>)";

public str toString(parseBignumeric(Expr exp)) = "PARSE_BIGNUMERIC(<toString(exp)>)";

public str toString(parseNumeric(Expr exp)) = "PARSE_NUMERIC(<toString(exp)>)";

public str toString(currentDate(list[Expr] exp)) = "CURRENT_DATE(<intercalate("",[toString(e)|e<-exp])>)";

public str toString(extract(Expr exp1, Expr exp2)) = "EXTRACT( <toString(exp1)> FROM <toString(exp2)> )";

public str toString(firstValue(Expr exp, list[IgnoreRespect] ignorerespect)) = "FIRST_VALUE(<toString(exp)> <intercalate("",[toString(igr)|igr<-ignorerespect])>)";

public str toString(lag(list[Expr] explist)) = "LAG(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(lastValue(list[Expr] explist, list[IgnoreRespect] ignorerespect)) = "LAST_VALUE(<intercalate(",",[toString(exp)|exp<-explist])> <intercalate("",[toString(igr)|igr<-ignorerespect])>)";

public str toString(lead(list[Expr] explist)) = "LEAD(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(nthvalue(list[Expr] explist, list[IgnoreRespect] ignorerespect)) = "NTH_VALUE(<intercalate(",",[toString(exp)|exp<-explist])> <intercalate("",[toString(igr)|igr<-ignorerespect])>)";

public str toString(percentileCont(list[Expr] explist, list[IgnoreRespect] ignorerespect)) = "PERCENTILE_CONT(<intercalate(",",[toString(exp)|exp<-explist])> <intercalate("",[toString(igr)|igr<-ignorerespect])>)";

public str toString(percentileDisc(list[Expr] explist, list[IgnoreRespect] ignorerespect)) = "PERCENTILE_DISC(<intercalate(",",[toString(exp)|exp<-explist])> <intercalate("",[toString(igr)|igr<-ignorerespect])>)";

public str toString(cumeDist()) = "CUME_DIST()";

public str toString(denseRank()) = "DENSE_RANK()";

public str toString(ntile()) = "NTILE()";

public str toString(percentRank()) = "PERCENT_RANK()";

public str toString(rank()) = "RANK()";

public str toString(rowNumber()) = "ROW_NUMBER()";

public str toString(corr(list[Expr] explist)) = "CORR(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(covarPop(list[Expr] explist)) = "COVAR_POP(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(covarSamp(list[Expr] explist)) = "COVAR_SAMP(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(stddev(list[Distinct] distinct,list[Expr] explist)) = "STDDEV(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(stddevPop(list[Distinct] distinct,list[Expr] explist)) = "STDDEV_POP(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(stddevSamp(list[Distinct] distinct,list[Expr] explist)) = "STDDEV_SAMP(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(varPop(list[Distinct] distinct,list[Expr] explist)) = "VAR_POP(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(varSamp(list[Distinct] distinct,list[Expr] explist)) = "VAR_SAMP(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(variance(list[Distinct] distinct,list[Expr] explist)) = "VARIANCE(<intercalate("",[toString(dst)|dst<-distinct])> <intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(bagOfWords(list[Expr] explist)) = "BAG_OF_WORDS(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(textAnalyze(list[Expr] explist)) = "TEXT_ANALYZE(<intercalate(",",[toString(exp)|exp<-explist])>)";

public str toString(tfIdf(list[Expr] explist)) = "TF_IDF(<intercalate(",",[toString(exp)|exp<-explist])>) OVER()";

public str toString(appends(Expr exp1, Expr exp2)) = "APPENDS(TABLE <toString(exp1)>, <toString(exp2)>)";

public str toString(externalObjectTransform(Expr exp1, Expr exp2)) = "EXTERNAL_OBJECT_TRANSFORM(TABLE <toString(exp1)>, <toString(exp2)>)";

public str toString(distinct()) = "DISTINCT";

public str toString(limit(int integer)) = "LIMIT <integer>";

public str toString(ignoreNulls()) = "IGNORE NULLS";

public str toString(respectNulls()) = "RESPECT NULLS";

public str toString(havingExp(MaxMin maxmin, Expr exp)) = "HAVING <toString(maxmin)> <toString(exp)>";

public str toString(max()) = "MAX";

public str toString(min()) = "MIN";

public str toString(partitionByExp(Expr exp)) = "PARTITION BY <toString(exp)>";

public str toString(orderSpecs(Expr exp, list[AscDesc] ascdesc)) = "ORDER BY <toString(exp)> <intercalate("",[toString(a)|a<-ascdesc])>";

public str toString(AscDesc::asc()) = "ASC";

public str toString(AscDesc::desc()) = "DESC";

public str toString(formatClause(Expr expr)) = "FORMAT <toString(expr)>";