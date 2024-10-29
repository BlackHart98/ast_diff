module lang::ptl::grammar::SCD

extend lang::ptl::grammar::Expressions;

syntax ModelAnnotation = @Foldable modelAnnotation : "@config" "(" ConfigKeyValue+ ")";

syntax ConfigKeyValue 
    = kindValue : "kind" ":" Expr scdType
    | strategyValue : "strategy" ":" StrategyOptions strategyOptions
    | uniqueKeyValue : "unique_key" ":" QID uniqueAttribute
    | strategyAttributes : StrategyAttributes strategyAttributes
    ;

syntax StrategyOptions 
    = timestampStrategy :  "timestamp" 
    | checkColumnStrategy :  "check" 
    ;

syntax StrategyAttributes 
    =  updatedAt : "updated_at" ":" QID updateAtAttribute
    | checkAttr :  "check_attrs" ":" "[" {QID ","}+ "]"
    ;
