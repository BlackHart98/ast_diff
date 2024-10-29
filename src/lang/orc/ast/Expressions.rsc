module lang::orc::ast::Expressions
extend lang::exprlang::ast::Expressions;


// expression
data Expr = 
    not(Expr expr)
    | and(Expr expr1, Expr expr2)
    | or(Expr expr1, Expr expr2)
    ;

data Literal = 
  idExp(list[str] ids)
;
