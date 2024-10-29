module lang::redshift::grammar::Functions

extend lang::redshift::grammar::Expressions;


syntax Expr = function: FunctionCall;
syntax FunctionCall = inBuiltFunction: InBuiltFunction AnalyticFunctionClause?;


syntax FunctionCall 
  = udf: PackageName? FUNCTIONNAME"(" {Expr ","}* ")" AnalyticFunctionClause?
  ;

syntax AnalyticFunctionClause = analyticFunctionClause: 'OVER' WindowSpecification;
syntax InBuiltFunction = aggregateFunction: AggregateFunction;

syntax AggregateFunction
    = anyvalue: 'ANY_VALUE'"(" SetQuantifier? Expr ")"
    | approximatePercentileDisc: 'APPROXIMATE' 'PERCENTILE_DISC' "(" Expr ")" WithinGroup
    | avg: 'AVG'"(" SetQuantifier? Expr ")"
    | countAll: 'COUNT'"(""*"")"
    | count: 'COUNT'"("SetQuantifier? Expr")"
    | approximatecount: 'APPROXIMATE' 'COUNT' "("SetQuantifier Expr")"
    | listagg: 'LISTAGG' "(" SetQuantifier? Expr ")" WithinGroup
    | max: 'MAX'"(" SetQuantifier? Expr ")"
    | median: 'MEDIAN'"(" Expr ")"
    | min: 'MIN'"(" SetQuantifier? Expr ")"
    | percentileCont: 'PERCENTILE_CONT'"(" Expr ")" WithinGroup
    | stddev: 'STDDEV'"(" SetQuantifier? Expr ")" 
    | stddevSamp: 'STDDEV_SAMP'"(" SetQuantifier? Expr ")" 
    | stddevpop: 'STDDEV_POP'"(" SetQuantifier? Expr ")" 
    | variance: 'VARIANCE'"(" SetQuantifier? Expr ")" 
    | varsamp: 'VAR_SAMP'"(" SetQuantifier? Expr ")" 
    | varPop: 'VAR_POP'"(" SetQuantifier? Expr ")" 
    | sum: 'SUM'"(" SetQuantifier? Expr ")" 
    ;



syntax WithinGroup =withinGroup: 'WITHIN' 'GROUP' "(" 'ORDER' 'BY' Expr ")";
