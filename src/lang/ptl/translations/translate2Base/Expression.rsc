module lang::ptl::translations::translate2Base::Expression
extend  lang::functionLang::ast::Function;
extend lang::ptl::ast::PTL;
import String;
extend lang::exprlang::translations::Expression;
import Type;
import Node;

  
public lang::basesql::ast::BaseSQL::Expr toSQL(typeConvert(Expr e, Type t))=cast(toSQL(e), toSQL(t));
public lang::basesql::ast::BaseSQL::Expr toSQL(castId(list[str] names, Type t))=cast(propRef([toSQL(ent)|ent<-names]), toSQL(t));
public lang::basesql::ast::BaseSQL::Expr toSQL(castLiteral(Expr e, Type t))=cast(toSQL(e), toSQL(t));
public lang::basesql::ast::BaseSQL::Expr toSQL(identifier(list[str] names))= propRef([toSQL(ent)|ent<-names]);
public lang::basesql::ast::BaseSQL::Expr toSQL(boolean(str booleanLiteral)){
    str val = toLowerCase(booleanLiteral); 
    if(val=="true") {
        return \true();
    }
    else return \false();
}

public lang::basesql::ast::BaseSQL::Expr toSQL(\map(list[Mapping] mapEntries))= mapLit([toSQL(ent)|ent<-mapEntries]);
public lang::basesql::ast::BaseSQL::Expr toSQL(not(Expr e))=Expr::not(toSQL(e));
public lang::basesql::ast::BaseSQL::Expr toSQL(like(Expr lhs, Expr rhs))= Expr::like(toSQL(lhs), toSQL(rhs));
public lang::basesql::ast::BaseSQL::Expr toSQL(notlike(Expr lhs, Expr rhs))= Expr::notlike(toSQL(lhs), toSQL(rhs));
public lang::basesql::ast::BaseSQL::Expr toSQL(isNull( Expr e)) = Expr::isNull(toSQL(e));
public lang::basesql::ast::BaseSQL::Expr toSQL(isNullNot(Expr e))= Expr::isNotNull(toSQL(e));
public lang::basesql::ast::BaseSQL::Expr toSQL(and(Expr lhs, Expr rhs))=  Expr::and(toSQL(lhs),toSQL(rhs));
public lang::basesql::ast::BaseSQL::Expr toSQL(logicalNot(Expr e))=  Expr::not(toSQL(e));
public lang::basesql::ast::BaseSQL::Expr toSQL(or(Expr lhs, Expr rhs))= Expr::or(toSQL(lhs),toSQL(rhs));
public lang::basesql::ast::BaseSQL::Expr toSQL( between(Expr e1, Expr e2)){
  return Expr::between(toSQL(e1),toSQL(e2.lhs),toSQL(e2.rhs));
}
public lang::basesql::ast::BaseSQL::Expr toSQL(\if(Expr cond, Expr thenPart, Expr elsePart)) = searchedCase([toSQL(cond,thenPart)], [elseClause(toSQL(elsePart))]);

public lang::basesql::ast::BaseSQL::Identifier toSQL(str id) = regularIdentifier(id);
  
public lang::basesql::ast::BaseSQL::MapEntry toSQL(mapping(Expr k, Expr v)) = mapEntry(toSQL(k),toSQL(v));

public WhenClause toSQL(Expr cond, Expr then){
  return whenClause(toSQL(cond),toSQL(then));
}

    



public lang::basesql::ast::BaseSQL::DataType toSQL(Type t){
   switch(t){
     case Type::booleanType(): return primitiveType(PrimitiveType::booleanType());
     case Type::stringType():return primitiveType(PrimitiveType::stringType());
     case Type::\int():return primitiveType(intType());
     case smallInt(): return primitiveType(smallIntType());
     case bigInt(): return primitiveType(bigIntType());
     case float():return primitiveType(PrimitiveType::floatType());
     case Type::dateType():return primitiveType(PrimitiveType::dateType());
     case Type::mapType(Type k,Type v): return DataType::mapType(toSQL(k),toSQL(v));
     case listType(Type ty):return arrayType(toSQL(ty));
     case Type::timeType():return primitiveType(timestampType());
    
     default:throw TranslationException("Type signature `<getName(t)>` not resolved", typeCast(#loc, getAnnotations(t)["src"]));
   }
}

public PrimitiveType toSQL(Type t){
    switch(t){
     case booleanType(): return booleanType();
     case stringType():return stringType();
     case Type::\int():return intType();
     case smallInt(): return smallIntType();
     case bigInt(): return bigIntType();
     case float():return floatType();
     case dateType():return dateType();
     default:throw TranslationException("Type signature `<getName(t)>` not resolved",typeCast(#loc, getAnnotations(t)["src"]));
    }
}




