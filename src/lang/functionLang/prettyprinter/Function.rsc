module lang::functionLang::prettyprinter::Function
extend lang::basesql::prettyprint::BaseSQL;
import List;
extend lang::functionLang::ast::Function;


public str toString(callFunction(Identifier funName, list[AggParam] aggParam1,list[Expr] arguments, list[AggParam] aggParam2,list[OtherFunctionParameters] otherParameterlist))
           ="<toString(funName)>(<prettyOptional(aggParam1,toString)><intercalate(",",[" <toString(e)>"|e<-arguments])><prettyOptional(aggParam2,toString)>)<intercalate(" ",[toString(e)|e<-otherParameterlist])>";

public str toString(conversionFunction(DataType dataType,Expr exp))="<toString(dataType)>(<toString(exp)>)";

public str toString(AggParam::nullOption(NullOption nullOpt))=",<toString(nullOpt)>";

public str toString(ignore())="IGNORE NULLS";

public str toString(respect())="RESPECT NULLS";

public str toString(AggParam::setQuantifier( SetQuantifier setQuant))="<toString(setQuant)>";


public str toString(filterClause(\filter(WhereClause whereClause)))="FILTER(<toString(whereClause)>)";

public str toString(nullOpt(NullOption nullOpt))= toString(nullOpt);

public str toString(withinGroup(OrderByClause orderby))=" WITHIN GROUP (<toString(orderby)>)";
             