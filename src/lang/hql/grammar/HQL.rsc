module lang::hql::grammar::HQL


extend lang::hql::grammar::DDL;


start syntax HQLStart 
  = expression: Expr
  | statements: StatementWithTerminator+
  ;


syntax StatementWithTerminator
  = statementWithTerminator: Statement Terminator+
  ;


syntax Terminator
  = terminator: ";"
  ;

