module lang::exprlang::ast::Expressions

data Expr
    = integer(str \int) 
    | long(str \int) 
    | decimal(str decim)
    | string(str  strConst)
    | uMin(Expr expr)
    | cct(Expr expr1, Expr expr2)
    | mul(Expr expr1, Expr expr2)
    | div(Expr expr1, Expr expr2)
    | modulus(Expr expr1, Expr expr2)
    | sub(Expr expr1, Expr expr2)
    | add(Expr expr1, Expr expr2)
    | eq(Expr expr1, Expr expr2)
    | twoEqual(Expr expr1, Expr expr2)
    | gt(Expr expr1, Expr expr2)
    | lt(Expr expr1, Expr expr2)
    | gte(Expr expr1, Expr expr2)
    | lte(Expr expr1, Expr expr2)
    | nullSafeEqual(Expr expr1, Expr expr2)
    | neq1(Expr expr1, Expr expr2)
    | neq2(Expr expr1, Expr expr2)
    ;