module lang::exprlang::prettyprint::Expressions

import lang::exprlang::ast::Expressions;

public str toString(Expr::integer(str \int)) = "<\int>";
public str toString(Expr::long(str \int)) = "<\int>";
public str toString(Expr::decimal(str decim)) = "<decim>";
public str toString(Expr::string(str strConst)) = "<strConst>";
public str toString(Expr::uMin(Expr exp)) = "-<toString(exp)>";
public str toString(Expr::cct(Expr exp1, Expr exp2)) = "(<toString(exp1)> || <toString(exp2)>)";
public str toString(Expr::mul(Expr exp1, Expr exp2)) = "(<toString(exp1)> * <toString(exp2)>)";
public str toString(Expr::div(Expr exp1, Expr exp2)) = "(<toString(exp1)> / <toString(exp2)>)";
public str toString(Expr::modulus(Expr exp1, Expr exp2)) = "(<toString(exp1)> % <toString(exp2)>)";
public str toString(Expr::sub(Expr exp1, Expr exp2)) = "(<toString(exp1)> - <toString(exp2)>)";
public str toString(Expr::add(Expr exp1, Expr exp2)) = "<toString(exp1)> + <toString(exp2)>";
public str toString(Expr::eq(Expr exp1, Expr exp2)) = "(<toString(exp1)> = <toString(exp2)>)";
public str toString(Expr::twoEqual(Expr exp1, Expr exp2)) = "(<toString(exp1)> == <toString(exp2)>)";
public str toString(Expr::gt(Expr exp1, Expr exp2)) = "(<toString(exp1)> \> <toString(exp2)>)";
public str toString(Expr::lt(Expr exp1, Expr exp2)) = "(<toString(exp1)> \< <toString(exp2)>)";
public str toString(Expr::gte(Expr exp1, Expr exp2)) = "(<toString(exp1)> \>= <toString(exp2)>)";
public str toString(Expr::lte(Expr exp1, Expr exp2)) = "(<toString(exp1)> \<= <toString(exp2)>)";
public str toString(Expr::nullSafeEqual(Expr exp1, Expr exp2)) = "(<toString(exp1)> \<=\> <toString(exp2)>)";
public str toString(Expr::neq1(Expr exp1, Expr exp2)) = "(<toString(exp1)> != <toString(exp2)>)";
public str toString(Expr::neq2(Expr exp1, Expr exp2)) = "(<toString(exp1)> \<\> <toString(exp2)>)";