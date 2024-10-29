module lang::spark::grammar::Query

extend lang::spark::grammar::Functions;


syntax CTEClause 
    = cteClauseWithParam: Identifier"("{Identifier ","}+")" 'AS' "(" QueryOrWith ")"
    | cteClauseNoParam: Identifier 'AS' "(" NestedWith ")";


syntax NestedWith = nestedWith: WithClause {CTEClause ","}+ Query;


syntax Subquery = subqueryWithNested: "(" NestedWith ")";



syntax TableIdOrSubquery = tableIdOrSubqueryNestedWith: "(" NestedWith ")";


syntax SelectClause = selectClauseWithTranform: 'SELECT' SetQuantifier? TransformClause; 

syntax TransformClause 
    =  transform:
        'TRANSFORM'"(" {Expr ","}+ ")" 
        RowFormatClause? ('RECORDWRITER' StringConstant)? 
        'USING' StringConstant TAlias? RowFormatClause? ('RECORDREADER' StringConstant)?
    ;

syntax TAlias= tAlias:'AS' "(" {ColumnSpecification ","}+ cols ")";


syntax QueryExpr
    = querySpark: QuerySpark
    | left queryIntersectSetQuantifier: QueryExpr IntersectWithSetQuantifier QueryExpr
    > left queryExceptDistinct: QueryExpr ExceptDistinct QueryExpr
    > left queryMinusSetquantifier: QueryExpr MinusSetQuantifier QueryExpr
    > :queryUnion
    ;
syntax QuerySpark
    = query: 
        SelectClause  
        FromClause? 
        Distributed? 
        SortedByClause!sortedBy? 
        PivotUnpivot? 
        LateralView* 
        JoinClause?
        WhereClause? 
        GroupByClause? 
        HavingClause?  
        WindowClause? 
        OrderByClause? 
        LimitOffsetClauses? 
        QueryClusterByClause?
    ;

syntax IntersectWithSetQuantifier = intersectWithSetQuantifier: 'INTERSECT' SetQuantifier;
syntax ExceptDistinct = exceptDistinct: 'EXCEPT' SetQuantifier?;
syntax MinusSetQuantifier = minusSetQuantifier: 'MINUS' SetQuantifier?;

syntax SortedByClause = sortByCls: 'SORT' 'BY' "("?{SortedByElem!sortByElem ", "}+")"?;
syntax SortedByElem = sortByElemExpr: Expr SortedByDirection? NullFirstOrLast?;


syntax TableIdOrSubquery 
    = tableIdSubqueryWithAs: "(" QueryExpr ")"'AS' Identifier
    | tableIdWithAs: TableName 'AS' Identifier
    | tableIdWithValue: Value  
    | tableId: TableName Identifier? TableSample
    | tableIdAsExpr: Function VarAssign? TableSample?
    | tableIdLateralSubquery: 'LATERAL' "(" Query ")" VarAssign?
    ; 

syntax TableSample = tableSample: 'TABLESAMPLE' "("SampleQuantifier")";

syntax SampleQuantifier
    = exprPercent: Expr 'PERCENT' 
    | exprRows: Expr 'ROWS'
    | exprBucket: 'BUCKET' Expr 'OUT' 'OF' Expr
    ;



syntax JoinClause
    = semiJoinClause: SemiJoin TableIdOrSubquery JoinCondition JoinClause?
    ; 


syntax SemiJoin = semiJoin: 'SEMI' 'JOIN';

syntax LimitClause = limitClauseAll: 'LIMIT' 'ALL';


syntax PivotUnpivot = pivot: 'PIVOT' "(" {(Function PivotAlias?) ","}+ 'FOR' ColList 'IN' "(" {(ExpressionList PivotAlias?) ","}+ ")" ")"
                    | unpivot: 'UNPIVOT' (IncludeorEx 'NULLS')? "(" ValueColumnUnpivot ")" PivotAlias?;

syntax PivotAlias = pivotAs: 'AS' Identifier;

syntax LateralView
    = lateralView: 'LATERAL' 'VIEW' Outer? Function Identifier 'AS' {Identifier ","}+
    | lateralViewNoId: 'LATERAL' 'VIEW' Outer? Function 'AS' {Identifier ","}+
    ;

syntax ValueColumnUnpivot
    = valueColumnUnpivot: ColList 'For' Identifier name 'IN' "("{(ExpressionList PivotAlias?) ","}+")";

syntax ExpressionList 
    = singleExpr: SingleExpression
    | multipleExpr:"("{Expr ","}+ ")" 
    ;

syntax SingleExpression 
    = Literal 
    | Identifier
    ;


syntax ColList 
    = singleCol:Identifier
    | multipleCol:"("{Identifier ","}+ ")" 
    ;


syntax IncludeorEx 
    = include:'INCLUDE'
    | exclude:'EXCLUDE'
    ;

syntax GroupByClause 
    = groupByClauseGroupingSets: 'GROUP' 'BY' {ExpAsVar ","}+ GroupingSets  WithOption?
    | groupByClauseWithOption: 'GROUP' 'BY' {ExpAsVar ","}+ WithOption
    ;

syntax WithOption = rollupWith: 'WITH ROLLUP' | cubeWith: 'WITH CUBE';
syntax GroupingSets = groupingSets:"("{GroupingSet ","}+ ")" ;
syntax GroupingSet = group: "("{Expr ","}*")";
syntax GroupOption 
    = rollup:'ROLLUP'
    | cube: 'CUBE'
    | sets: 'GROUPING SETS'
    ;

syntax Value = ValuesAs; 


syntax ValuesAs = valuesas: ValuesBuilder VarAssign?;


syntax ValuesBuilder = valuesBuilder: 'VALUES' { ValueSet "," }+;


syntax ValueSet = valset:"(" {Expr ","}+ ")";
