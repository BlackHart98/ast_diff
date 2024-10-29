module lang::bigquery::grammar::Names

extend lang::bigquery::grammar::Literals;

syntax SchemaNameDot
  = schemaNameBigQuery: {TableNameId "."}+  "." TableNameId "."
  ;


syntax Path
  = path: {PathExpr "."}+
  ;

syntax PathExpr 
  = pathExpr: Identifier? "/" SubsequentPart PathExtra+
  ;

syntax PathExtra =pathExtra: SubPre SubsequentPart;

syntax SubPre 
  = slash: "/"
  | colon: ":"
  | hyphen: "-"
  ;
syntax SubsequentPart
  = id: Identifier 
  | number: Number
  ;

syntax Identifier = unquotedIdentifer: UNQUOTEDIDENTIFIER;

lexical UNQUOTEDIDENTIFIER =  ([a-z A-Z _] !<< "_" [a-z A-Z 0-9 @ _ \-]* !>> [a-z A-Z 0-9 _]) \ Keywords;

lexical FUNCTIONNAME = REGULARIDENTIFIER \ IMPLEMENTED_FUNCTIONNAME;

syntax Literal
    = Date
    | Time
    | Timestamp
    | illegalNull: 'null'
    | Boolean
    ;

syntax Date
  = date: 'DATE' StringConstant
  ;


syntax Time
  = time: 'TIME' StringConstant
  ;


syntax Timestamp
  = timeStamp: 'TIMESTAMP' StringConstant
  ;


keyword IMPLEMENTED_FUNCTIONNAME 
  = 'SUM' 
  | 'AVG'
  | 'COUNT'
  | 'ANY_VALUE'
  | 'ARRAY_AGG'
  ;

keyword Keywords
	  = 'INT'
    | 'ALL'
    | 'AND'
    | 'ANY'
    | 'ARRAY'
    | 'AS'
    | 'ASC'
    | 'ASSERT_ROWS_MODIFIED'
    | 'AT'
    | 'BETWEEN'
    | 'BREAK'
    | 'BY'
    | 'CASE'
    | 'CAST'
    | 'COLLATE'
    | 'CONTAINS'
    | 'CREATE'
    | 'CROSS'
    | 'CUBE'
    | 'CURRENT'
    | 'DEFAULT'
    | 'DEFINE'
    | 'DESC'
    | 'DISTINCT'
    | 'ELSE'
    | 'END'
    | 'ENUM'
    | 'ESCAPE'
    | 'EXCEPT'
    | 'EXCLUDE'
    | 'EXISTS'
    | 'EXTRACT'
    | 'FALSE'
    | 'FETCH'
    | 'FOLLOWING'
    | 'FOR'
    | 'FROM'
    | 'FULL'
    | 'FUNCTION'
    | 'GROUP'
    | 'GROUPING'
    | 'GROUPS'
    | 'HASH'
    | 'HAVING'
    | 'IF'
    | 'IGNORE'
    | 'IN'
    | 'INNER'
    | 'INTERSECT'
    | 'INTERVAL'
    | 'INTO'
    | 'IS'
    | 'JOIN'
    | 'LATERAL'
    | 'LEFT'
    | 'LIKE'
    | 'LIMIT'
    | 'LOOKUP'
    | 'MERGE'
    | 'NATURAL'
    | 'NEW'
    | 'NO'
    | 'NOT'
    | 'NULL'
    | 'NULLS'
    | 'OF'
    | 'ON'
    | 'OR'
    | 'ORDER'
    | 'OUTER'
    | 'OVER'
    | 'PARTITION'
    | 'PRECEDING'
    | 'PROTO'
    | 'QUALIFY'
    | 'RANGE'
    | 'RECURSIVE'
    | 'RESPECT'
    | 'RIGHT'
    | 'ROLLUP'
    | 'ROWS'
    | 'SELECT'
    | 'SET'
    | 'SOME'
    | 'STRUCT'
    | 'TABLESAMPLE'
    | 'THEN'
    | 'TO'
    | 'TREAT'
    | 'TRUE'
    | 'UNBOUNDED'
    | 'UNION'
    | 'UNNEST'
    | 'USING'
    | 'WHEN'
    | 'WHERE'
    | 'WINDOW'
    | 'WITH'
    | 'WITHIN'
    | 'ROLLBACK'
    | 'COMMIT'
    | 'IFNULL'
    | 'NULLIF'
    | 'COALESCE'
  ;