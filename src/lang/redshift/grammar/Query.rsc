module lang::redshift::grammar::Query

extend lang::redshift::grammar::Functions;

syntax Subquery = subqueryWithClause: "(" QueryOrWith!queryOrWithQuery ")";
syntax WithClause = withRecursiveClause: 'WITH' 'RECURSIVE';
syntax CTEClause = cteClauseRecursive: Identifier"("{Identifier ","}*")" 'AS' "(" QueryOrWith ")";

syntax QueryExpr 
    =queryRedshift: QueryRedshift
    > :queryUnion
    ;

syntax QueryRedshift 
    = query: 
        SelectClause
        IntoTable?  
        FromClause? 
        SortedByClause? 
        PivotUnpivot?
        JoinClause? 
        WhereClause? 
        StartAndConnect?
        GroupByClause? 
        HavingClause?
        QualifyClause?  
        WindowClause? 
        OrderByClause? 
        LimitOffsetClauses? 
        QueryClusterByClause?
    ;


syntax SelectClause = selectClauseWithTop: 'SELECT' TopNumber SetQuantifier? Projection;
syntax TopNumber = topNumber: 'TOP' Int;
syntax PivotUnpivot = pivot: PivotOperator | unpivot: UnpivotOperator;


syntax IntoTable = intoTable: 'INTO' TempVariant? Table? TableName;

syntax TempVariant
    = temp: 'TEMP'
    | temporary: 'TEMPORARY'
    ;

syntax PivotOperator 
    = pivotOperator: 
     'PIVOT' "(" 
      ExpAsVar
      'FOR' Identifier
      'IN' "("{ExpAsVar ","}*")"
    ")" {VarAssign ","}* ;


syntax StartAndConnect = startAndConnect: StartWith? 'CONNECT' 'BY' ConnectOperators  Expr StartWith?;
syntax StartWith = startWith: 'START' 'WITH' Expr;
syntax ConnectOperators = level: 'LEVEL' | prior: 'PRIOR';

syntax TableIdOrSubquery 
    = subqueryNoId: "(" Query ")" 
    | tableWithStringId: TableName 'AS'? StringConstant
    | subqueryWithString: "(" Query ")" 'AS'? StringConstant 
    ;


syntax TableIdOrSubquery
  = subqueryWithAs: "(" Query ")" 'AS' Identifier BracketColumnAlias? 
  | tableIdWithAs:  TableName 'AS' Identifier BracketColumnAlias?
  ;


syntax UnpivotOperator 
        = unpivotOperator:
          'UNPIVOT' AddNulls? "(" ColumnUnpivot ")" VarAssign?
        ;

syntax AddNulls 
    = includenulls: 'INCLUDE' 'NULLS'
    | excludenulls: "EXCLUDE" 'NULLS'
    ;


syntax ColumnUnpivot = singleUnpivot: Identifier values_column 'FOR' Identifier nameColumn 'IN' "(" {ColumnsToUnpivot ","}* ")";
syntax ColumnsToUnpivot = toUnpivot: Expr unpivot_column {VarAssign ","}* ;
syntax QualifyClause = qualifyClause: 'QUALIFY' Expr bool_exp;


syntax BracketColumnAlias = bracketColumnAlias: "(" {Identifier ","}+ ")";

syntax GroupByClause 
    = groupByClauseSpecs:'GROUP' 'BY' {GroupSpecs ","}+;

syntax GroupSpecs 
    = groupSetSpecs: GroupSet
    | groupBracket: "(" ")"
    ;

syntax GroupSet = groupSet: 'GROUPING' 'SETS' "(" {GroupList ","}+ ")";
syntax GroupList = groupListItem: Expr;
syntax GroupRollup = groupRollup: 'ROLLUP' "(" {Expr","}+ ")" ;
syntax GroupCube = groupCube: 'CUBE' "(" {Expr ","}+ ")" ;

syntax JoinCondition = using: UsingClause;
syntax UsingClause = usingClause: 'USING' Expr column_list;

