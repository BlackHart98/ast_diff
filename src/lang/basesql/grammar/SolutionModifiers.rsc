module lang::basesql::grammar::SolutionModifiers

extend lang::basesql::grammar::Expressions;


syntax GroupByClause = groupByClause: 'GROUP' 'BY' {ExpAsVar ","}+;


syntax HavingClause = havingClause: 'HAVING' Expr;


syntax OrderByClause = orderByClause: 'ORDER' 'BY' {OrderElem ","}+;


syntax OrderElem
  = orderExpr: Expr
  | asc: Expr 'ASC'
  | desc: Expr 'DESC'
  ;



syntax LimitOffsetClauses
  = limitOffsetClauses: LimitClause OffsetClause?
  | offsetLimitClauses: OffsetClause LimitClause?
  ;

syntax LimitClause = limitClause: 'LIMIT' Expr;

syntax OffsetClause = offsetClause: 'OFFSET' Expr;

