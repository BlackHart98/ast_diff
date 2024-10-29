module lang::basesql::grammar::DML

extend lang::basesql::grammar::DDL;


syntax Statement
      = with: WithClause {CTEClause ","}+ CTEAction 
      | statementQuery: QueryExpr
      | insertOverwriteDirectory: 
            'INSERT' 'OVERWRITE' Local? 'DIRECTORY' DirectoryPath 
                  RowFormatClause?
                  StoredAs?
                  QueryExpr
      | insertWithQuery: InsertWithQuery 
      ;