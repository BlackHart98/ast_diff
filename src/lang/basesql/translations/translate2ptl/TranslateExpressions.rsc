module lang::basesql::translations::translate2ptl::TranslateExpressions
extend lib::Utils;
import lang::basesql::ast::BaseSQL;
import lang::ptl::ast::Expressions;
import lang::basesql::prettyprint::BaseSQL;
import List;
import Type;
extend lang::exprlang::translations::translate2ptl::TranslateExpressions;

public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::propRef(list[Identifier] ids)) = lang::ptl::ast::Expressions::identifier([ toString(id) | id <- ids ]);
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::like(Expr exp1, Expr exp2)) = lang::ptl::ast::Expressions::like(toPTL(exp1), toPTL(exp2));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::notlike(Expr lhs, Expr rhs)) = lang::ptl::ast::Expressions::notlike(toPTL(lhs), toPTL(rhs));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::between(Expr exp1, Expr exp2, Expr exp3)) = lang::ptl::ast::Expressions::between(toPTL(exp1), and(toPTL(exp2), toPTL(exp3)));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::isNull(Expr exp)) = lang::ptl::ast::Expressions::isNull(toPTL(exp));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::isNotNull(Expr exp)) = lang::ptl::ast::Expressions::isNullNot(toPTL(exp));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::not(Expr exp)) = lang::ptl::ast::Expressions::not(toPTL(exp));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::and(Expr exp1, Expr exp2)) = lang::ptl::ast::Expressions::and(toPTL(exp1), toPTL(exp2));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::or(Expr exp1, Expr exp2)) = lang::ptl::ast::Expressions::or(toPTL(exp1), toPTL(exp2));
public lang::ptl::ast::Expressions::Expr toPTL(lang::basesql::ast::BaseSQL::searchedCase(list[WhenClause] whenCls, list[ElseClause] elseCls)) = toPTL(whenCls, elseCls);

public lang::ptl::ast::Expressions::Expr toPTL(cast(Expr exp, DataType dt)) = lang::ptl::ast::Expressions::typeConvert(toPTL(exp), toPTL(dt));

public lang::ptl::ast::Expressions::Distinct toPTL(aggregateDistinct()) = lang::ptl::ast::Expressions::distinct();


Expr toPTL(list[WhenClause] whenCls, [elseClause(Expr exp)]) {

  processWhen = reverse(whenCls); // reverse list

  if (whenClause(Expr exp1, Expr exp2) := processWhen[0]) {
    result = lang::ptl::ast::Expressions::\if(toPTL(exp1), toPTL(exp2), toPTL(exp));

    return (result | lang::ptl::ast::Expressions::\if(toPTL(exp1), toPTL(exp2), it) | whenClause(Expr exp1, Expr exp2) <- tail(processWhen));
  } else throw TranslationException("message:Unresolved translation",typeCast(#node,processWhen[0]).src);

}

public lang::ptl::ast::Expressions::Type toPTL(DataType dType) {
  switch(dType) {
    case primitiveType(PrimitiveType pt): return toPTL(pt);
    case arrayType(DataType dt): return \listType(toPTL(dt));
    case mapType(PrimitiveType primType, DataType dType): return \mapType(toPTL(primType), toPTL(dType));
    default: throw TranslationException("message:Unresolved translation ",typeCast(#node,dType).src);
  }
}

public lang::ptl::ast::Expressions::Type toPTL(PrimitiveType pType) {
  switch(pType) {
    case PrimitiveType::intType(): return Type::\int();
    case PrimitiveType::smallIntType(): return Type::smallInt();
    case PrimitiveType::bigIntType(): return Type::bigInt();
    case PrimitiveType::tinyIntType(): return Type::smallInt();
    case PrimitiveType::booleanType(): return Type::booleanType();
    case PrimitiveType::floatType(): return Type::float();
    case PrimitiveType::decimalType(_): return Type::float();
    case PrimitiveType::doubleType(): return Type::float();
    case PrimitiveType::doubleWithPrecisionType(): return Type::float();
    case PrimitiveType::stringType(): return Type::stringType();
    case PrimitiveType::varCharType(_): return Type::varCharType();
    case PrimitiveType::charType(_): return Type::charType();
    case PrimitiveType::timestampType(): return Type::timeType();
    case PrimitiveType::dateType(): return Type::dateType();
    case PrimitiveType::binaryType(): return Type::listType(byteType());
    case PrimitiveType::intervalType(): return Type::intervalType();
    default: throw TranslationException("message:Unresolved translation",typeCast(#node,pType).src);
  }
}