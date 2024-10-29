module lang::basesql::grammar::BaseSQL



extend lang::basesql::grammar::DML;





syntax Statement
      = use: 'USE' Identifier
      | truncateTable: 'TRUNCATE' Table? TableName PartitionClause?
      | msckRepair:  'MSCK' Repair? TableName MsckRepairActionClause?
      | analyzeTable: 
            'ANALYZE' 'TABLE' TableName PartitionClause? 'COMPUTE' 'STATISTICS' ForColumns? CacheMetadata? NoScan?
      ;



