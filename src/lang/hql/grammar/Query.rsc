module lang::hql::grammar::Query

extend lang::hql::grammar::Functions;


syntax QueryExpr
  =  queryHQL: QueryHQL
  > :queryUnion
  ;

syntax QueryHQL
  = query:
      SelectClause 
      FromClause?
      LateralView*
      JoinClause?
      WhereClause?
      GroupByClause?
      HavingClause?
      OrderByClause?
      WindowClause?
      LimitOffsetClauses?
      QueryClusterByClause?
      ;



syntax LateralView
  = lateralView: 'LATERAL' 'VIEW' Outer? Function Identifier 'AS' {Identifier ","}+
  ;



syntax SelectClause
  = transform: 'SELECT' 'TRANSFORM'"(" {Expr ","}+ ")"
    RowFormatClause?
    'USING' StringConstant
    'AS' "(" {TransformColumnSpecification ","}+ ")"
    RowFormatClause?
    RecordReaderClause?
  ;


syntax TransformColumnSpecification = transformColumnSpecification: Identifier DataType?;