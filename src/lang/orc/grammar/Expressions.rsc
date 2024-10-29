module lang::orc::grammar::Expressions

extend lang::orc::grammar::Literals;
extend lang::exprlang::grammar::Expressions;

syntax Expr =  
  :neq2
  > right not: "not" Expr
  > left and: Expr lhs "and" Expr rhs
  > left or: Expr lhs "or" Expr rhs
;

syntax Variable  =  
   variable: "${" Id "}"("#" ModuleId)?
   | simpleId: Id
   | refId: Id "." {Id "."}+ name
;

syntax ModuleId
    = moduleId: {Id "."}+ name
;
