module lang::bigquery::grammar::DML


extend lang::bigquery::grammar::DDL;




syntax InsertWithQuery 
    = intoWithValue: 
        'INSERT' 'INTO' Table? TableName IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Value 
    | noIntoOrOverwriteWithValue: 
        'INSERT' Table? TableName IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Value
    | noIntoOrOverwrite:
        'INSERT' Table? TableName PartitionWithOptionValueClause?
  	    ColumnSpecificationForInsert?
  	    QueryOrWith    
    ;

syntax Value = inputValue: 'VALUES' {BracketExp ","}+ ;


syntax BracketExp = bracketExp: "("{ExpOrDefault ","}+")";

syntax ExpOrDefault
  = exp: Expr
  | \default: 'DEFAULT'
  ;

syntax Statement 
    = deleteStatement: 'DELETE' 'FROM'? TableName targetName TableName? alias WhereClause
    | mergeInto: 'MERGE' 'INTO' TableName VarAssign?
        'USING' Expr tblOrSlct VarAssign?
        'ON' Expr
        MergeWhen+ whenCls
    | mergeNoInto: 'MERGE' TableName VarAssign?
        'USING' Expr tblOrSlct VarAssign?
        'ON' Expr
        MergeWhen+ whenCls
    | updateStatement: 'UPDATE' TableName VarAssign?
        'SET' SetClause
        FromClause?
        JoinClause?
        WhereClause
    ;





syntax MergeWhen 
    = matchedClause:'WHEN' 'MATCHED' ByTargetOrSource? AndBool? 'THEN' MergeClause
    | notMatchedClause:'WHEN' 'NOT' 'MATCHED' ByTargetOrSource? AndBool? 'THEN' MergeClause
    ;

syntax AndBool = andBool: 'AND' Expr;


syntax MergeClause 
    = mergeWithUpdate: MergeUpdate
    | mergeWithDelete: MergeDelete
    | mergeWithInsert: MergeInsert
    ;


syntax MergeUpdate = mergeUpdate: 'UPDATE' 'SET' SetClause;
syntax MergeDelete = mergeDelete: 'DELETE';
syntax MergeInsert = mergeInsert: 'INSERT' OptionalColumns? MergeInput;

syntax MergeInput
    = mergeValue: 'VALUES' {BracketExp ","}+ 
    | mergeRow: 'ROW'
    ;


syntax OptionalColumns = optionalColumns: "(" {Identifier ","}+ ")" ;


syntax SetClause = setClause: {SetTo ","}+;

syntax SetTo =setTo: TableName "=" ExpOrDefault;

syntax ByTargetOrSource
    = byTarget: 'BY' 'TARGET'
    | bySource: 'BY' 'SOURCE'
    ;

