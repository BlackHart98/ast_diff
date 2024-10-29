module lang::hql::grammar::Functions


extend lang::hql::grammar::Expressions;


syntax Expr = function: Function AnalyticFunctionClause?;

syntax Function =countStar:'COUNT'"("AggParam? "*"")";
syntax CommonValueExpr = functionCVE: Function;



syntax AnalyticFunctionClause = analyticFunctionClause: 'OVER' WindowSpecification;



syntax InBuiltFunction
  = analyticFunction: AnalyticFunction
  | aggregateFunction: AggregateFunction
  | windowFunction: WindowFunction
  | conditionalFunction: ConditionalFunction
  | mathFunction: MathFunction
  | dateTimeFunction: DateTimeFunction
  | stringFunction: StringFunction
  ;


syntax AggregateFunction
  = count: 'COUNT'"("Distinct? StarOrExpr")"
  | min: 'MIN'"("Distinct? Expr")"
  | max: 'MAX'"("Distinct? Expr ")"
  | sum: 'SUM'"(" Distinct? Expr ")"
  | avg: 'AVG'"("Distinct? Expr")"
  | arrayavg: 'ARRAY_AGG'"("Distinct? Expr")"
  | listagg: 'LISTAGG'"("Distinct? Expr Separator?")"
  ;

syntax Separator = separator: "," Expr;


syntax AnalyticFunction
  = rank: 'RANK'"("")"
  | rowNumber: 'ROW_NUMBER'"("")"
  | denseRank: 'DENSE_RANK'"("")"
  | cumeDist: 'CUME_DIST'"("")"
  | percentRank: 'PERCENT_RANK'"("")"
  | ntile: 'NTILE'"("")"
  ;

syntax DateTimeFunction
  = toDate: 'TO_DATE'"("Expr")"
  | toUtcTimestamp: 'TO_UTC_TIMESTAMP'"("Expr "," Expr")"
  | fromUtcTimestamp: 'FROM_UTC_TIMESTAMP'"("Expr "," Expr")"
  | fromUnixTimeOneParam: 'FROM_UNIXTIME'"("Expr")"
  | fromUnixTimeTwoParam: 'FROM_UNIXTIME'"("Expr "," Expr")"
  | unixTimestampNoParam: 'UNIX_TIMESTAMP'"("")"
  | unixTimestampOneParam: 'UNIX_TIMESTAMP'"("Expr")"
  | unixTimestampTwoParam: 'UNIX_TIMESTAMP'"("Expr "," Expr")"
  | dateSub: 'DATE_SUB'"("Expr "," Expr")"
  | dateAdd: 'DATE_ADD'"("Expr "," Expr")"
  | dateDiff: 'DATEDIFF'"("Expr "," Expr")"
  | currentTimeStamp: 'CURRENT_TIMESTAMP'"("")"
  | currentDate: 'CURRENT_DATE'"("")"
  | monthsBetween: 'MONTHS_BETWEEN'"("Expr","Expr")"
  | month: 'MONTH'"("Expr")"
  | year: 'YEAR'"("Expr")"
  | addMonths: 'ADD_MONTHS'"("Expr","Expr")"
  ;


syntax StringFunction
  = regExpReplace: 'REGEXP_REPLACE'"("Expr","Expr","Expr")"
  | length: 'LENGTH'"("Expr")"
  | concat: 'CONCAT'"("Expr","{Expr ","}+")"
  | instr: 'INSTR'"("Expr","Expr")"
  | substring: 'SUBSTRING'"("Expr","Expr")"
  | substringWithEnd: 'SUBSTRING'"("Expr","Expr","Expr")"
  | substr: 'SUBSTR'"("Expr","Expr")"
  | substrWithEnd: 'SUBSTR'"("Expr","Expr","Expr")"
  | upper: 'UPPER'"("Expr")"
  | uCase: 'UCASE'"("Expr")"
  | lower: 'LOWER'"("Expr")"
  | lCase: 'LCASE'"("Expr")"
  | getJsonObject: 'GET_JSON_OBJECT'"("Expr","Expr")"
  ;


syntax ConditionalFunction
  = nvlFunction: 'NVL'"("Expr","Expr")"
  | ifFunction: 'IF'"("Expr"," Expr"," Expr")"
  | coalesce: 'COALESCE'"("Expr","{Expr ","}+")"
  ;


syntax MathFunction
  = ceilFunction: 'CEIL'"("Expr")" 
  | ceilingFunction: 'CEILING'"("Expr")"
  | exponent: 'EXP'"("Expr")" 
  ;

syntax WindowFunction
  = lead: 'LEAD'"("Expr LeadLagOffSet?")"
  | lag: 'LAG'"("Expr LeadLagOffSet?")"
  | firstValue: 'FIRST_VALUE'"("Identifier CommaThenBoolean?")"
  | lastValue: 'LAST_VALUE'"("Identifier CommaThenBoolean?")"
  ;


syntax LeadLagOffSet = leadLagOffSet: "," Int LeadLagDefault?;

syntax LeadLagDefault = leadLagDefault: ","Expr;

syntax CommaThenBoolean = commaThenBoolean: ","Expr;