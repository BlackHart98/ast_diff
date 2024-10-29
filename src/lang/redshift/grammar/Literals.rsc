module lang::redshift::grammar::Literals

extend lang::basesql::grammar::BaseSQL;


syntax Literal
    = Date
    | Time
    | Timestamp
    | illegalNull: 'null'
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