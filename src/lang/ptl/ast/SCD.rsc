module lang::ptl::ast::SCD


extend lang::ptl::ast::Expressions;

data ModelAnnotation = modelAnnotation(list[ConfigKeyValue] configKeyValue );

data ConfigKeyValue 
    = kindValue(Expr scdType)
    | strategyValue(StrategyOptions strategyOptions)
    | uniqueKeyValue(str uniqueAttribute)
    | strategyAttributes(StrategyAttributes strategyAttributes);

data StrategyOptions 
    = timestampStrategy()
    | checkColumnStrategy();

data StrategyAttributes
    = updatedAt(str updateAtAttribute)
    | checkAttr(list[str] checkListAttributes);
