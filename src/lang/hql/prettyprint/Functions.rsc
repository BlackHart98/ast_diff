module lang::hql::prettyprint::Functions

import lang::hql::ast::HQL;

import List;
import String;

extend lang::hql::prettyprint::Expressions;

// Expr 
public str toString(Expr::function(Function fCall,list[AnalyticFunctionClause] afClauseOpt)) = "<toString(fCall)> <prettyOptional(afClauseOpt,toString)>";

// InBuiltFunction
public str toString(InBuiltFunction::analyticFunction(AnalyticFunction anaFunc)) = "<toString(anaFunc)>";
public str toString(InBuiltFunction::aggregateFunction(AggregateFunction aggFunc)) = "<toString(aggFunc)>";
public str toString(InBuiltFunction::windowFunction(WindowFunction windFunc)) = "<toString(windFunc)>";
public str toString(InBuiltFunction::conditionalFunction(ConditionalFunction condFunc)) = "<toString(condFunc)>";
public str toString(InBuiltFunction::mathFunction(MathFunction mathFunc)) = "<toString(mathFunc)>";
public str toString(InBuiltFunction::dateTimeFunction(DateTimeFunction dateTimeFunc)) = "<toString(dateTimeFunc)>";
public str toString(InBuiltFunction::stringFunction(StringFunction stringFunc)) = "<toString(stringFunc)>";

// AggregateFunction
public str toString(Function::countStar(list[AggParam] distinct)) = "COUNT(" + trim("<prettyOptional(distinct, toString)> *)");
public str toString(AggregateFunction::min(list[Distinct] distinct, Expr expr)) = "MIN(<prettyOptional(distinct, toString)> <toString(expr)>)";
public str toString(AggregateFunction::max(list[Distinct] distinct, Expr expr)) = "MAX(<prettyOptional(distinct, toString)> <toString(expr)>)";
public str toString(AggregateFunction::sum(list[Distinct] distinct, Expr expr)) = "SUM(<prettyOptional(distinct, toString)> <toString(expr)>)";
public str toString(AggregateFunction::avg(list[Distinct] distinct, Expr expr)) = "AVG(<prettyOptional(distinct, toString)> <toString(expr)>)";
public str toString(AggregateFunction::arrayavg(list[Distinct] distinct, Expr expr)) = "ARRAY_AGG(<prettyOptional(distinct, toString)> <toString(expr)>)";
public str toString(AggregateFunction::listagg(list[Distinct] distinct, Expr expr, list[Separator] separator)) = "LISTAGG(<prettyOptional(distinct, toString)> <toString(expr)> <prettyOptional(separator, toString)>)";

// Separator
public str toString(Separator::separator(Expr exp)) = ", <exp>";

// AnalyticFunction
public str toString(AnalyticFunction::rank()) = "RANK()";
public str toString(AnalyticFunction::rowNumber()) = "ROW_NUMBER()";
public str toString(AnalyticFunction::denseRank()) = "DENSE_RANK()";
public str toString(AnalyticFunction::cumeDist()) = "CUME_DIST()";
public str toString(AnalyticFunction::percentRank()) = "PERCENT_RANK()";
public str toString(AnalyticFunction::ntile()) = "NTILE()";

// DateTimeFunction
public str toString(DateTimeFunction::toDate(Expr exp)) = "TO_DATE(<toString(exp)>)";
public str toString(DateTimeFunction::toUtcTimestamp(Expr exp1, Expr exp2)) = "TO_UTC_TIMESTAMP(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::fromUtcTimestamp(Expr exp1, Expr exp2)) = "FROM_UTC_TIMESTAMP(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::fromUnixTimeOneParam(Expr exp)) = "FROM_UNIXTIME(<toString(exp)>)";
public str toString(DateTimeFunction::fromUnixTimeTwoParam(Expr exp1, Expr exp2)) = "FROM_UNIXTIME(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::unixTimestampNoParam()) = "UNIX_TIMESTAMP()";
public str toString(DateTimeFunction::unixTimestampOneParam(Expr exp)) = "UNIX_TIMESTAMP(<toString(exp)>)";
public str toString(DateTimeFunction::unixTimestampTwoParam(Expr exp1, Expr exp2)) = "UNIX_TIMESTAMP(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::dateSub(Expr exp1, Expr exp2)) = "DATE_SUB(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::dateAdd(Expr exp1, Expr exp2)) = "DATE_ADD(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::dateDiff(Expr exp1, Expr exp2)) = "DATEDIFF(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::currentTimeStamp()) = "CURRENT_TIMESTAMP()";
public str toString(DateTimeFunction::currentDate()) = "CURRENT_DATE()";
public str toString(DateTimeFunction::monthsBetween(Expr exp1, Expr exp2)) = "MONTHS_BETWEEN(<toString(exp1)>, <toString(exp2)>)";
public str toString(DateTimeFunction::month(Expr exp)) = "MONTH(<toString(exp)>)";
public str toString(DateTimeFunction::year(Expr exp)) = "YEAR(<toString(exp)>)";
public str toString(DateTimeFunction::addMonths(Expr exp1, Expr exp2)) = "ADD_MONTHS(<toString(exp1)>, <toString(exp2)>)";

// StringFunction
public str toString(StringFunction::regExpReplace(Expr exp1, Expr exp2, Expr exp3)) = "REGEXP_REPLACE(<toString(exp1)>, <toString(exp2)>, <toString(exp3)>)";
public str toString(StringFunction::length(Expr exp)) = "LENGTH(<toString(exp)>)";
public str toString(StringFunction::concat(Expr exp1, list[Expr] exprList)) = "CONCAT(<toString(exp1)>, <intercalate(",", [toString(exp) | exp <- exprList])>)";
public str toString(StringFunction::instr(Expr exp1, Expr exp2)) = "INSTR(<toString(exp1)>, <toString(exp2)>)";
public str toString(StringFunction::substring(Expr exp1, Expr exp2)) = "SUBSTRING(<toString(exp1)>, <toString(exp2)>)";
public str toString(StringFunction::substringWithEnd(Expr exp1, Expr exp2, Expr exp3)) = "SUBSTRING(<toString(exp1)>, <toString(exp2)>, <toString(exp3)>)";
public str toString(StringFunction::substr(Expr exp1, Expr exp2)) = "SUBSTR(<toString(exp1)>, <toString(exp2)>)";
public str toString(StringFunction::substrWithEnd(Expr exp1, Expr exp2, Expr exp3)) = "SUBSTR(<toString(exp1)>, <toString(exp2)>, <toString(exp3)>)";
public str toString(StringFunction::upper(Expr exp)) = "UPPER(<toString(exp)>)";
public str toString(StringFunction::uCase(Expr exp)) = "UCASE(<toString(exp)>)";
public str toString(StringFunction::lower(Expr exp)) = "LOWER(<toString(exp)>)";
public str toString(StringFunction::lCase(Expr exp)) = "LCASE (<toString(exp)>)";
public str toString(StringFunction::getJsonObject(Expr exp1, Expr exp2)) = "GET_JSON_OBJECT(<toString(exp1)>, <toString(exp2)>)";

// ConditionalFunction
public str toString(ConditionalFunction::nvlFunction(Expr exp1, Expr exp2)) = "NVL(<toString(exp1)>, <toString(exp2)>)";
public str toString(ConditionalFunction::ifFunction(Expr exp1, Expr exp2, Expr exp3)) = "IF(<toString(exp1)>, <toString(exp2)>, <toString(exp3)>)";
public str toString(ConditionalFunction::coalesce(Expr exp1, list[Expr] exprList)) = "COALESCE(<toString(exp1)>, <intercalate(",", [toString(exp) | exp <- exprList])>)";

// MathFunction
public str toString(MathFunction::ceilFunction(Expr exp)) = "CEIL(<toString(exp)>)";
public str toString(MathFunction::ceilingFunction(Expr exp)) = "CEILING(<toString(exp)>)";
public str toString(MathFunction::exponent(Expr exp)) = "EXP(<toString(exp)>)";

// WindowFunction
public str toString(WindowFunction::lead(Expr expr, list[LeadLagOffSet] leadLagOffSet)) = "LEAD(<toString(expr)> <prettyOptional(leadLagOffSet, toString)>)";
public str toString(WindowFunction::lag(Expr expr,  list[LeadLagOffSet] leadLagOffSet)) = "LAG(<toString(expr)> <prettyOptional(leadLagOffSet, toString)>)";
public str toString(WindowFunction::firstValue(Identifier id, list[CommaThenBoolean] commaThenBoolean)) = "FIRST_VALUE(<toString(id)> <prettyOptional(commaThenBoolean, toString)>)";
public str toString(WindowFunction::lastValue(Identifier id, list[CommaThenBoolean] commaThenBoolean)) = "LAST_VALUE(<toString(id)> <prettyOptional(commaThenBoolean, toString)>)";

// LeadLagOffSet
public str toString(LeadLagOffSet::leadLagOffSet(str \int, list[LeadLagDefault] leadLagDefault)) = ", <\int> <prettyOptional(leadLagDefault, toString)>";

// LeadLagDefault
public str toString(LeadLagDefault::leadLagDefault(Expr expr)) = ", <toString(expr)>";

// CommaThenBoolean
public str toString(CommaThenBoolean::commaThenBoolean(Boolean boolean)) = ", <toString(boolean)>";

// AnalyticFunctionClause
public str toString(AnalyticFunctionClause::analyticFunctionClause(WindowSpecification windSpec)) = "OVER <toString(windSpec)>";

