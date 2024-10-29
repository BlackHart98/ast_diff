module lang::bigquery::grammar::DCL

extend lang::bigquery::grammar::Procedural;


syntax Statement = dclStatement: DCL;

syntax DCL
    = grantCommand: GrantStatement
    | revokeCommand: RevokeStatement
    ;

syntax GrantStatement 
    = grantStatement: 'GRANT' Expr 
    'ON' ResourceType TableName 'TO' {Expr ","}+
    ;

syntax RevokeStatement 
    = revokeStatement: 'REVOKE' Expr 
    'ON' ResourceType TableName 'FROM' {Expr ","}+
    ;

syntax ResourceType
    = schemaType: 'SCHEMA'
    | tableType: 'TABLE'
    | viewType: 'VIEW'
    | externalTableType: 'EXTERNAL' 'TABLE'
    ;

