module lang::spark::grammar::DML

extend lang::spark::grammar::DDL;

syntax Statement
    = insertOverwriteDirectory: 
        'INSERT' 'OVERWRITE' Local? 'DIRECTORY'
  			UsingClause?
  			StoredAs?
  			Query
    | insertOverwriteDirectoryPath: 
        'INSERT' 'OVERWRITE' Local? 'DIRECTORY' DirectoryPath 
  			UsingClause
  			StoredAs?
  			Query
    | loadInto:'LOAD' 'DATA' Local? 'INPATH' StringConstant  'INTO' 'TABLE' TableName PartitionClause?
    | loadOverwrite:'LOAD' 'DATA' Local? 'INPATH' StringConstant 'OVERWRITE' Expr? 'INTO' 'TABLE' TableName PartitionClause?
    ;



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
    | intoFromTable: 
        'INSERT' 'INTO' TableName Table TableName PartitionWithOptionValueClause? IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Query? 
    | overwriteFromTable: 
        'INSERT' 'OVERWRITE' TableName Table TableName PartitionWithOptionValueClause? IfNotExists? 
  		    ColumnSpecificationForInsert?
  		    Query? 
    | intoWithReplace: 'INSERT' 'INTO' Table? TableName? Columns? 'REPLACE' 'WHERE' Expr QueryOrWith
    ;




