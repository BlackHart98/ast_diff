module lang::exprlang::translations::Expression
extend lang::exprlang::ast::Expressions;
import Type;
extend lib::Utils;

public Expr toSQL(Expr e){
    switch(e){
      case  integer(str \int):return integer(\int) ;
      case long(str \int):return  long(\int);
      case decimal(str decim):return decimal(decim);
      case string(str  strConst):return string(strConst);
      case uMin(Expr expr):return uMin(toSQL(expr));
      case cct(Expr expr1, Expr expr2):return cct(toSQL(expr1),toSQL(expr2));
      case mul(Expr expr1, Expr expr2):return mul(toSQL(expr1), toSQL(expr2));
      case div(Expr expr1, Expr expr2):return div(toSQL(expr1), toSQL(expr2));
      case modulus(Expr expr1, Expr expr2):return modulus(toSQL(expr1),toSQL(expr2));
      case sub(Expr expr1, Expr expr2):return sub(toSQL(expr1), toSQL( expr2));
      case add(Expr expr1, Expr expr2):return add(toSQL(expr1), toSQL( expr2));
      case eq(Expr expr1, Expr expr2):return eq(toSQL(expr1), toSQL( expr2));
      case gt(Expr expr1, Expr expr2):return gt(toSQL(expr1), toSQL( expr2));
      case lt(Expr expr1, Expr expr2):return lt(toSQL(expr1), toSQL( expr2));
      case gte(Expr expr1, Expr expr2):return gte(toSQL(expr1), toSQL( expr2));
      case lte(Expr expr1, Expr expr2):return lte(toSQL(expr1), toSQL( expr2));
      case nullSafeEqual(Expr expr1, Expr expr2):return nullSafeEqual(toSQL(expr1), toSQL( expr2));
      case neq1(Expr expr1, Expr expr2):return neq1(toSQL(expr1), toSQL( expr2));
      case neq2(Expr expr1, Expr expr2):return neq2(toSQL(expr1), toSQL( expr2));
      default: throw TranslationException("message:unhandled expression ",typeCast(#node,e).src);
    }
}

public Expr toSQL(Expr::twoEqual(Expr expr1, Expr expr2))= twoEqual(toSQL(expr1), toSQL( expr2));
