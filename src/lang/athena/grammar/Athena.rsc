module lang::athena::grammar::Athena

extend lang::athena::grammar::Auxiliary;


start syntax Athena 
  = expression: Expr
  | statements: StatementWithTerminator+
  ;
    
syntax StatementWithTerminator
  = statementWithTerminator: Statement
   Terminator*
  ;


syntax Terminator
  = terminator: ";"
  ;
  


