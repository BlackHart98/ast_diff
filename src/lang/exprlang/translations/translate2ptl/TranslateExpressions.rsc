module lang::exprlang::translations::translate2ptl::TranslateExpressions

import lang::exprlang::ast::Expressions;

public Expr toPTL(integer(str \int)) = integer(\int);
public Expr toPTL(long(str \int)) = long(\int);
public Expr toPTL(decimal(str decim)) = decimal(decim);
public Expr toPTL(string(str strConst)) = string(strConst);
public Expr toPTL(uMin(Expr expr)) = uMin(toPTL(expr));
public Expr toPTL(cct(Expr expr1, Expr expr2)) = cct(toPTL(expr1), toPTL(expr2));
public Expr toPTL(mul(Expr expr1, Expr expr2)) = mul(toPTL(expr1), toPTL(expr2));
public Expr toPTL(div(Expr expr1, Expr expr2)) = div(toPTL(expr1), toPTL(expr2));
public Expr toPTL(modulus(Expr expr1, Expr expr2)) = modulus(toPTL(expr1), toPTL(expr2));
public Expr toPTL(sub(Expr expr1, Expr expr2)) = sub(toPTL(expr1), toPTL(expr2));
public Expr toPTL(add(Expr expr1, Expr expr2)) = add(toPTL(expr1), toPTL(expr2));
public Expr toPTL(Expr::eq(Expr expr1, Expr expr2)) = Expr::twoEqual(toPTL(expr1), toPTL(expr2));
public Expr toPTL(twoEqual(Expr expr1, Expr expr2)) = twoEqual(toPTL(expr1), toPTL(expr2));
public Expr toPTL(gt(Expr expr1, Expr expr2)) = gt(toPTL(expr1), toPTL(expr2));
public Expr toPTL(lt(Expr expr1, Expr expr2)) = lt(toPTL(expr1), toPTL(expr2));
public Expr toPTL(gte(Expr expr1, Expr expr2)) = gte(toPTL(expr1), toPTL(expr2));
public Expr toPTL(lte(Expr expr1, Expr expr2)) = lte(toPTL(expr1), toPTL(expr2));
public Expr toPTL(nullSafeEqual(Expr expr1, Expr expr2)) = nullSafeEqual(toPTL(expr1), toPTL(expr2));
public Expr toPTL(neq1(Expr expr1, Expr expr2)) = neq1(toPTL(expr1), toPTL(expr2));
public Expr toPTL(neq2(Expr expr1, Expr expr2)) = neq2(toPTL(expr1), toPTL(expr2));