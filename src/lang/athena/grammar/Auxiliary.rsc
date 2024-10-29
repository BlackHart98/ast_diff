module lang::athena::grammar::Auxiliary


extend lang::athena::grammar::DML;


syntax Statement = describeStatement: Describe;


syntax Describe 
    = describe: 'DESCRIBE' ExtendedOrFormatted? TableName PartitionClause? Identifier?
    | showColumns :'SHOW' ColumnKeyword FromOrIn FromOrIn?
    | showCreateTable :'SHOW' 'CREATE' 'TABLE'  TableName (VarAssignAs 'SERDE')?
    | showDatabases:'SHOW' DatabaseOrSchema  ('like' Expr)?
    | showPartitions: 'SHOW' 'PARTITIONS' TableName PartitionClause?
    | showTableExtended : 'SHOW' 'TABLE' 'EXTENDED' FromOrIn? 'LIKE' Expr
        PartitionClause?
    | showTables: 'SHOW' 'TABLES' FromOrIn!from? Expr?
    | showTableProperties: 'SHOW' 'TBLPROPERTIES' TableName ("(" UnquotedOrString")")?
    | showViews: 'SHOW' 'VIEWS' FromOrIn? ('LIKE' Expr)?
    | showCreateView: 'SHOW' 'CREATE' 'VIEW' FromOrIn?  Expr?
    ; 

syntax UnquotedOrString = unquote:UNQUOTEDCHARSEQUENCE;


syntax ExtendedOrFormatted 
    = extended: 'EXTENDED'
    | formatted: 'FORMATTED'
    ;



syntax FromOrIn 
    = from: 'FROM'{Identifier "."}+ 
    | \in : 'IN' {Identifier "."}+ 
    ;
