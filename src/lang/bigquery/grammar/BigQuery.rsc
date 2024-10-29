module lang::bigquery::grammar::BigQuery

extend lang::bigquery::grammar::DCL;


start syntax BigQuery 
  = expression: Expr!subqueryAsExpression
  | statements: StatementWithTerminator+
  ;
    