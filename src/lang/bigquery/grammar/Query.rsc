module lang::bigquery::grammar::Query

extend lang::bigquery::grammar::Functions;


syntax WithClause = withRecursiveClause: 'WITH' 'RECURSIVE';

syntax TableIdOrSubquery
  = tableIdOrSubquerySubqueryNoId: "(" QueryOrWith ")" 
  | subqueryWithAsId: "(" QueryOrWith ")" 'AS' Identifier
  | tableIdWithAsId: TableName 'AS' Identifier
  | unnestOperatorWithAs: UnnestOptions VarAssign? UnnestWithOffset? 
  ;

syntax TableSampleOperator = tableSample: 'TABLESAMPLE' 'SYSTEM' "(" Int 'PERCENT' ")";

syntax UnnestOptions 
  = unnestExp: 'UNNEST' "(" Expr array_expression ")"
  | unnestPath: 'UNNEST' "(" Path array_path ")"
  ;

syntax UnnestWithOffset =withOffset: 'WITH' "OFFSET" VarAssign?;



syntax ExpAsVarOrStar = tableNameDotStar: TableName ".*" SelectExcept;
syntax ExpAsVarOrStar = tableNameDotStar: TableName ".*" SelectExcept? SelectReplace;
syntax ExpAsVarOrStar = projectionStar: "*" SelectExcept;
syntax ExpAsVarOrStar = projectionStar: "*" SelectExcept? SelectReplace;


syntax SelectExcept = selectExcept: 'EXCEPT' "(" {Identifier ","}+  ")";

syntax SelectReplace = selectReplace: 'REPLACE' "(" {ExpAsVarStrict2 ","}+ ")";



syntax SelectClause 
    = selectClause: 'SELECT' DiffPrivacyclause? SetQuantifier? 'AS' StructOrValue Projection
    | selectClauseDiffPrivacyclause: 'SELECT' DiffPrivacyclause SetQuantifier? Projection
    ;


syntax StructOrValue = struct: 'STRUCT' |  \value: 'VALUE';

syntax FromTimestamp = fromTimestamp: 'FOR' 'SYSTEM_TIME' 'AS' 'OF' Expr ;

syntax QueryExpr
    = queryBigquery: QueryBigquery
    | left queryExceptDistinct: QueryExpr ExceptDistinct QueryExpr
    > :queryUnion
    ;

syntax QueryBigquery
  = query: 
      SelectClause  
      FromClause? 
      SortedByClause? 
      TableSampleOperator? 
      PivotUnpivot?
      JoinClause? 
      WhereClause? 
      GroupByClause? 
      HavingClause? 
      QualifyClause? 
      WindowClause? 
      OrderByClause? 
      LimitOffsetClauses? 
  ;

syntax ExceptDistinct =exceptDistinct: 'EXCEPT' 'DISTINCT';



syntax JoinClause = outerJoinClause: OuterType Outer? 'JOIN' TableIdOrSubquery JoinClause? ;

syntax JoinCondition = onUsingClause: 'USING' "(" Expr column_list ")";

syntax DiffPrivacyclause = diffPrivacyClause: 'WITH' 'DIFFERENTIAL_PRIVACY' 'OPTIONS' "(" PrivacyParams ")";

syntax PrivacyParams 
  = privacyParams: 'epsilon' '=' Expr ','
                    'delta' '=' Expr ','
                    OptionalParam?
                    'privacy_unit_column' '=' Identifier      
                    ;
syntax OptionalParam = optionalParam: 'max_groups_contributed' '=' Expr ',';


syntax QualifyClause =qualifyClause: 'QUALIFY' Expr bool_exp;


syntax PivotUnpivot = 
    pivot: 'PIVOT' "(" {(AggregateFunction PivotAlias?) ","}+ 'FOR' ColList 'IN' "(" {(ExpressionList PivotAlias?) ","}+ ")" ")"
                    | unpivot: 'UNPIVOT' (IncludeorEx 'NULLS')? "(" ValueColumnUnpivot 
")" PivotAlias?;



syntax PivotAlias = 'AS' Identifier | 'AS' StringConstant;

syntax ValueColumnUnpivot
    = valueColumnUnpivot: ColList 'For' Identifier name 'IN' "("{(ExpressionList PivotAlias?) ","}+")";


syntax ExpressionList 
    = singleExpr: SingleExpression
    | multiple:"("{Expr ","}+ ")" 
    ;

syntax SingleExpression 
    = Literal 
    | Identifier
    ;


syntax ColList 
    = singleCol:Identifier
    | multiple:"("{Identifier ","}+ ")" 
    ;


syntax IncludeorEx 
    = include:'INCLUDE'
    | exclude:'EXCLUDE'
    ;



syntax GroupByClause 
    = groupSetSpecs:'GROUP' 'BY' GroupSet
    | rollupSpecs:'GROUP' 'BY' GroupRollup
    | cubeSpecs: 'GROUP' 'BY' GroupCube
    | groupBracket: 'GROUP' 'BY' "(" ")"
    ;


syntax GroupSet = groupSet: 'GROUPING' 'SETS' "(" {GroupList ","}+ ")";

syntax GroupList 
    = listrollup: GroupRollup
    | listCube: GroupCube
    | groupListItem: ExprOrComposite 
    ;



syntax GroupRollup =groupRollup: 'ROLLUP' "(" {Expr ","}+ ")" ;

syntax GroupCube = groupCube: 'CUBE' "(" {ExprOrComposite ","}+ ")" ;



syntax OrderElem
    = orderExprNullsOptions: Expr NullsOptions
    | ascNullOptions: Expr 'ASC' NullsOptions
    | descNullsOptions: Expr 'DESC' NullsOptions
    ;


syntax NullsOptions 
    = nullsfirst: 'NULLS' 'FIRST' 
    | nullslast: 'NULLS' 'LAST'
    ;




syntax CTEClause = cteClauseNotQuery: Identifier 'AS' "(" Expr!subqueryAsExpression ")";

