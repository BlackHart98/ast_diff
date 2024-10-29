module lang::athena::grammar::DML



extend lang::athena::grammar::DDL;


syntax InsertWithQuery 
    = intoWithValue: 
        'INSERT' 'INTO' Table? TableName PartitionWithOptionValueClause? IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Value 
    | overwriteWithValue: 
        'INSERT' 'OVERWRITE' Table? TableName PartitionWithOptionValueClause? IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Value
    | intoWithValueFromTable: 
        'INSERT' 'INTO' TableName Table TableName PartitionWithOptionValueClause? IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Value 
    | overwriteWithValueFromTable: 
        'INSERT' 'OVERWRITE' TableName Table TableName PartitionWithOptionValueClause? IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Value 
    ;



syntax Value = ValuesAs; 


syntax ValuesAs = valuesas: ValuesBuilder VarAssign?;


syntax ValuesBuilder = valuesBuilder: 'VALUES' { ValueSet "," }+;


syntax ValueSet = valset:"(" {Expr ","}+ ")";


syntax Statement = deleteStatement: 'DELETE' 'FROM' TableName WhereClause?;

syntax Statement = update: 'UPDATE' TableName 'SET' {SetOptions ","}+ WhereClause?;

syntax SetOptions = setOptions: Identifier '=' Expr;



syntax Statement 
    = mergeInto: 'MERGE' 'INTO' Identifier VarAssign?
        'USING' TableOrSelect tblOrSlct VarAssign? asAlias
        'ON' Expr
        WhenClauses whenCls;

syntax TableOrSelect = tableMerge: TableName | queryMerge: QueryOrWith;


syntax WhenClauses = whenClauses: WhenMatchClause* WhenNotMatchClause?; // TODO: Possible fix could be longest match

syntax WhenMatchClause 
    = whenMatchedAndClause: 'WHEN' 'MATCHED' 'AND' Expr 'THEN' UpdateDelete
    | whenMatchedThenClause: 'WHEN' 'MATCHED' 'THEN' UpdateDelete
    ;

syntax WhenNotMatchClause 
    = whenNotMatchedAndClause: 'WHEN' 'NOT' 'MATCHED' 'AND' Expr 'THEN' 'INSERT' ColumnSpecificationForInsert? 'VALUES' '(' { Expr ","}+ ')'
    | whenNotMatchedClause: 'WHEN' 'NOT' 'MATCHED' 'THEN' 'INSERT' ColumnSpecificationForInsert? 'VALUES' '(' { Expr ","}+ ')';

syntax UpdateDelete 
    = updateDelete: 'UPDATE' 'SET' {SetOptions ","}+ 
    | deleteUpdateDelete: 'DELETE'
    ;


syntax Statement = optimizeStatement: 'OPTIMIZE' TableName 'REWRITE' 'DATA' 'USING' 'BIN_PACK' WhereClause?;




syntax Statement
    = explainStmt: 'EXPLAIN' ExplainOptions? Statement
    | explainAnalyze: 'EXPLAIN' 'ANALYZE' ExplainAnalyzeFormat? Statement!analyzeTable
    ;


syntax SelectClause = selectOnly: 'SELECT';


syntax ExplainAnalyzeFormat = formatText: '(' 'FORMAT' 'TEXT' ')'
                     | formatJson: '(' 'FORMAT' 'JSON' ')'
                     ;
syntax ExplainOption = explainFormat: '(' 'FORMAT' ExplainOptionFormat ')'
                     | explainType: '(' 'TYPE' ExplainOptionType ')' 
                     ;

syntax ExplainOptions = explainOptions: { ExplainOption "," }+; 

syntax ExplainOptionType = logical: 'LOGICAL'
                         | distributed: 'DISTRIBUTED'
                         | validate: 'VALIDATE'
                         | io: 'IO'
                         ;

syntax ExplainOptionFormat = fmtText: 'TEXT'
                           | fmtGraphviz: Graphviz
                           | fmtJson: 'JSON'
                           ;

syntax Statement = unload: 'UNLOAD' '(' QueryOrWith ')' 'TO' StringConstant WithExpr;


syntax Graphviz = graphviz: 'GRAPHVIZ';



syntax Statement = prepare: 'PREPARE' Identifier stmt_name 'FROM' Statement stmt;


syntax Statement = execute: 'EXECUTE' Identifier stmt_name UsingClause?;

syntax UsingClause = usingClause: 'USING' { Literal ","}+;


syntax Statement = deallocate: 'DEALLOCATE' 'PREPARE' Identifier stmt_name;