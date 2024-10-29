module lang::functionLang::ast::Function

extend  lang::basesql::ast::BaseSQL;


data Function = callFunction(Identifier funName, list[AggParam] aggParam1,list[Expr] arguments, list[AggParam] aggParam2,list[OtherFunctionParameters] otherFuntionParamList)
|conversionFunction(DataType dataType,Expr exp);

data OtherFunctionParameters=filterClause(Filter filterOPt)
|nullOpt(NullOption nullOpt)
|withinGroup(OrderByClause);
data AnalyticFunctionClause = analyticFunctionClause(WindowSpecification windowSpecification);

data AggParam =nullOption(NullOption nullopt)
              |setQuantifier( SetQuantifier setQuant)
              ;

data NullOption = ignore()
              | respect()
              ;

data Filter = \filter(WhereClause whereClause);


