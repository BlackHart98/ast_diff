module lang::basesql::grammar::Query

extend lang::basesql::grammar::Functions;


syntax QueryExpr
  = bracket "(" QueryExpr ")"
  |  left  queryUnion: QueryExpr Union QueryExpr
  > left queryIntersect: QueryExpr Intersect QueryExpr	
  ;

syntax Query
  = query:
        SelectClause FromClause? JoinClause? WhereClause? GroupByClause? HavingClause?
        WindowClause? OrderByClause? LimitOffsetClauses? QueryClusterByClause?
  | bracket "(" Query ")"
  ;

syntax Union =union: 'UNION' SetQuantifier?;

syntax Intersect = intersect: 'INTERSECT';

syntax Local = local: 'LOCAL';

syntax DirectoryPath 
  = referenceOnly: "\'""${" REGULARIDENTIFIER "}""\'"
  | directoryReference: "\'""${" REGULARIDENTIFIER "}""/"Identifier"\'"
  | directoryPath: "\'""/"{Identifier "/"}+"\'"
  ;




syntax SetQuantifier
  = \all: 'ALL'
  | distinct: 'DISTINCT'
  ;


syntax SelectClause
  = selectClause: 'SELECT' SetQuantifier? Projection
  ;

syntax Projection = expAsVars: {ExpAsVarOrStar ","}+;




syntax RecordReaderClause = recordReaderClause: 'RECORDREADER' StringConstant;

syntax FromClause =  fromClause: 'FROM' {TableIdOrSubquery ","}+;

syntax TableIdOrSubquery
  = tableId: TableName Identifier?
  | tableIdOrSubquerySubquery: "(" QueryExpr ")" Identifier 
  ;




syntax JoinClause
  = innerJoinClause: Inner? 'JOIN' TableIdOrSubquery JoinCondition? JoinClause? 
  | outerJoinClause: OuterType Outer? 'JOIN' TableIdOrSubquery JoinCondition JoinClause? 
  | leftSemiJoinClause: LeftSemiJoin TableIdOrSubquery JoinCondition JoinClause?
  | crossJoinClause: CrossJoin TableIdOrSubquery JoinCondition? JoinClause?
  ;


syntax Inner  = inner: 'INNER';

syntax Outer = outer: 'OUTER';

syntax JoinCondition = joinCondition: 'ON' Expr;

syntax OuterType
  = left: 'LEFT'
  | right: 'RIGHT'
  | full: 'FULL'
  ;

syntax LeftSemiJoin = leftSemiJoin:'LEFT' 'SEMI' 'JOIN';

syntax CrossJoin = crossJoin: 'CROSS' 'JOIN';

syntax WhereClause = whereClause: 'WHERE' Expr;


syntax QueryClusterByClause = insertWithClusterByClause: 'CLUSTER' 'BY' {Identifier ","}+;

syntax WithClause = withClause: 'WITH';

syntax CTEClause = cteClause: Identifier 'AS' "(" QueryExpr ")";


syntax CTEAction
  = selectAction: QueryExpr
  | fromAction: 
        'FROM' TableName
        SelectClause
  | cteActionInsertWithSelect: 
        'FROM' TableName  'INSERT' OverWriteOrInto TableName PartitionWithOptionValueClause? 
        SelectClause
  | cteActionInsertWithQuery: 
        'INSERT' OverWriteOrInto TableName PartitionWithOptionValueClause?
        ColumnSpecificationForInsert? 
        QueryExpr
  ; 

syntax OverWriteOrInto
  = overWriteOrIntoOverwrite: 'OVERWRITE' Table?
  | overWriteOrIntoInto: 'INTO' Table?
  ;

syntax ColumnSpecificationForInsert = columnSpecificationForInsert: "("{Identifier ","}+ ")";

syntax InsertWithQuery
  = overwrite: 
        'INSERT' 'OVERWRITE' Table? TableName PartitionWithOptionValueClause? IfNotExists? 
  		ColumnSpecificationForInsert?
  		QueryExpr
  | into:
        'INSERT' 'INTO' Table? TableName PartitionWithOptionValueClause?
  	    ColumnSpecificationForInsert?
  	    QueryExpr   
  ; 





syntax Expr
  = :searchedCase 
  > scalarSubquery: Subquery
  > exists: 'EXISTS' Subquery
  > left inSubquery: Expr Not? 'IN' Subquery
  > :interval
  ;

syntax Subquery = subquery: "(" QueryExpr ")";
