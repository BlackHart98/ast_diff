module lang::functionLang::grammar::Function

extend  lang::basesql::grammar::BaseSQL;


syntax Function = callFunction:Identifier "("AggParam?  {Expr ","}* (","AggParam)? ")" OtherFunctionParameters*
                 | conversionFunction: DataType "(" Expr")"
                 ;

syntax AggParam =nullOption:NullOption
              | setQuantifier:SetQuantifier
              ;

syntax AnalyticFunctionClause = analyticFunctionClause: 'OVER' WindowSpecification;

syntax OtherFunctionParameters=
   withinGroup: 'WITHIN' 'GROUP' "("OrderByClause")"
  | filterClause:Filter
  | nullOpt:NullOption;


syntax Filter =\filter :'FILTER'"("WhereClause")";

syntax NullOption 
    = ignore: 'IGNORE' 'NULLS' 
    | respect:'RESPECT' 'NULLS'
    ;
