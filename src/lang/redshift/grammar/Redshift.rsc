module lang::redshift::grammar::Redshift

extend lang::redshift::grammar::DML;



start syntax Redshift 
    = expression: Expr
    | statements: StatementWithTerminator+
    ;
    
syntax StatementWithTerminator
    = statementWithTerminator: Statement!dropTable!dropView
    Terminator*
    ;


syntax Terminator
    = terminator: ";"
    ;


syntax Statement 
    = abort: 'ABORT' WorkOrTransaction?
    | analyze: 'ANALYZE' 'VERBOSE'? TableName? BracketCol? AnalyzeCols?
    | analyzeCompression: 'ANALYZE' 'COMPRESSION' TableName? BracketCol? Comprows? 
    | attachRlsPolicy: 'ATTACH' 'RLS' 'POLICY' TableName 'ON' 'TABLE'? {TableName ","}+ 'TO'? {GrantTo ","}*
    ;

syntax AnalyzeCols 
    = predicateCol: 'PREDICATE' 'COLUMNS'
    | allColumns: 'ALL' 'COLUMNS'
    ;



syntax Comprows = comprows: 'COMPROWS' Expr;
syntax Statement = beginStatement: BeginStart WorkOrTransaction? IsolationLevel? ReadOpts?;

syntax BeginStart 
    = begin: 'BEGIN'
    | \start: 'START'
    ;

syntax ReadOpts 
    = readwrite: 'READ' 'WRITE'
    | readonly: 'READ' 'ONLY'
    ;

syntax Statement 
    = call: 'CALL' TableName "(" {Expr ","}* ")"
    | cancel: 'CANCEL' Expr StringConstant?
    | close: 'CLOSE' Expr
    | comment: 'COMMENT' 'ON' CommentOpts 'IS' Expr
    | commit: 'COMMIT' WorkOrTransaction?
    | copy: 'COPY' TableName Expr? 'FROM' Expr IamRole+ FormatAs? 
    | end: 'END' WorkOrTransaction?
    ;

syntax FormatAs = formatAs: 'FORMAT'? 'AS'? Expr;


syntax CommentOpts 
    = commentTable: 'TABLE' TableName
    | commentColumn: 'COLUMN' TableName
    | commentConstraint: 'CONSTRAINT' TableName 'ON' TableName
    | commentDatabase: 'DATABASE' TableName
    | commentView: 'VIEW' TableName
    ;

syntax Prepare = prepare: 'PREPARE';
syntax FromWord = fromWord: 'FROM';

syntax Statement = deallocate: 'DEALLOCATE' Prepare? Identifier;

syntax Statement 
    = delete: WithClauseDel? 'DELETE' FromWord? TableName UsingClause? WhereClause?
    | declareCursor: 'DECLARE' Identifier 'CURSOR' 'FOR' Query
    | descDataShare: 'DESC' 'DATASHARE' Identifier DtShNameSpace?
    | descIDProvider: 'DESC' 'IDENTITY' 'PROVIDER' Identifier
    ;


syntax DtShNameSpace =  dtShNamespace: 'OF' AccountId? 'NAMESPACE' Identifier;

syntax WithClauseDel = withClauseDel: WithClause {CTEClause ","}+;

syntax Statement
    = detachMaskingPolicy: 'DETACH' 'MASKING' 'POLICY' Identifier 'ON'  TableName  "(" {Identifier ","}+ ")" 'FROM' DetachMaskingPolicyNames
    | detachRLSPolicy: 'DETACH' 'RLS' 'POLICY' Identifier 'ON' 'TABLE'? {TableName ","}+ 'FROM' {DetachMaskingPolicyNames ","}+
    ;


syntax DetachMaskingPolicyNames
    = username: Identifier 
    | roleNameType: 'ROLE' Identifier 
    | publicNameType: 'PUBLIC' 
    ;