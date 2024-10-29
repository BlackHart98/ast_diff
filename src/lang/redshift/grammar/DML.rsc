module lang::redshift::grammar::DML

extend lang::redshift::grammar::DDL;

syntax Statement 
    = insertWithValue: InsertWithValue
    | mergeStatement: 'MERGE' 'INTO' TableName
      'USING' TableName VarAssign?
      'ON' Expr
      MergeOpts?
    | refreshMaterialized: 'REFRESH' 'MATERIALIZED' 'VIEW' TableName
    | reset: 'RESET' NameOrAll
    | rollback: 'ROLLBACK' WorkOrTransaction?
    | revoke:'REVOKE' GrantOptFor? GrantOpts
      GrantFor?
      GrantOnStmt?
      GrantToStmt?
      'RESTRICT'?
    ;


syntax InsertWithValue 
    = intoValue: 'INSERT' 'INTO' TableName BracketCol? {InsertOpts ","}+
    ;

syntax GrantOptFor = grantOptionFor: 'GRANT' 'OPTION' 'FOR';


syntax WorkOrTransaction 
    = work: 'WORK'
    | transaction: 'TRANSACTION' 
    ;

syntax NameOrAll
    = nameopt: TableName
    | allopt: 'ALL'
    ;


syntax InsertOpts
    = defvalue: 'DEFAULT' 'VALUES'
    | valExpr: 'VALUES' {ArrayLiteral ","}+
    ;


syntax MergeOpts 
    = mergeOpts: 'WHEN' 'MATCHED' 'THEN' MatchedOpts
      'WHEN' 'NOT' 'MATCHED' 'THEN' 'INSERT' MatchedOpts
    ;

syntax MatchedOpts 
    = thenupdate: 'UPDATE' 'SET' Expr "=" {Expr ","}+ 
    | thenDelete: 'DELETE'
    | thenVals: BracketCol? 'VALUES' "(" {Expr ","}+ ")"
    | thenRemove: 'REMOVE' 'DUPLICATES'
    ;


syntax GrantOpts 
    = grantExpr: {Expr ","}+ BracketCol?
    | allPrivileges: Privilege BracketCol?
    | usage: 'USAGE'
    | grantModel: 'CREATE' 'MODEL'
    | grantExplain: 'EXPLAIN' 'RLS'
    | grantInclude: 'INCLUDE' 'RLS'
    | grantSelect: 'SELECT' 'ON' 'TABLE'? {TableName ","}+ 
    | grantExecute: {GrantExecute ","}+
    ;

syntax GrantExecute = grantExecute: 'EXECUTE';
syntax Privilege = privilege: 'ALL' 'PRIVILEGES'?;

syntax GrantOn
    = gTable: 'TABLE' {TableName ","}+
    | gAllTables: 'ALL' 'TABLES' 'IN' 'SCHEMA' {TableName ","}*
    | gDatabase: 'DATABASE' {TableName ","}+ 
    | gSchema: 'SCHEMA' {TableName ","}+ 
    | gFunction: 'FUNCTION' {TableName ","}+ BracketNameModeType
    | gAllFuncs: 'ALL' 'FUNCTIONS' 'IN' 'SCHEMA' {TableName ","}+
    | gLanguage: 'LANGUAGE' {TableName ","}+
    | gExternal: 'EXTERNAL' 'TABLE' {TableName ","}+
    | gDatashare: 'DATABASE'
    | gModel: 'MODEL' TableName
    ;

syntax GrantFor 
    = grantFor: 'FOR' Expr 'IN' GrantOn*
    ;

syntax GrantOnStmt = grantOnStmt: 'ON' GrantOn;

syntax GrantToStmt = grantToStmt: 'TO' {GrantTo ","}+ WithGrantOption? WithAdminOption?;

syntax GrantTo 
    = grantToUsername: TableName
    | grantToRole: 'ROLE' TableName?
    | grantToGroup: 'GROUP' TableName
    | grantToPublic: 'PUBLIC'
    | grantToIamRole: IamRole
    | grantToNamespace: 'NAMESPACE' {StringConstant ","}+
    | grantToAccount: 'ACCOUNT' StringConstant ViaDataCatalog?
    ;

syntax ViaDataCatalog = viadatacatalog: 'VIA' 'DATA' 'CATALOG';

syntax WithGrantOption = withGrantOption: 'WITH' 'GRANT' 'OPTION' ;

syntax WithAdminOption = withAdminOption: 'WITH' 'ADMIN' 'OPTION' ;


syntax Statement 
    = setStatement: 'SET' SetOptions
    | setSessionAuth: 'SET' 'LOCAL'? 'SESSION' 'AUTHORIZATION' Expr
    ;

syntax SetOptions 
    =  setOpt: SessionLocal? TableName ToEq Expr
    ;

syntax SeedOrName 
    = seedname: TableName
    ; 

syntax SessionLocal 
    = session: 'SESSION'
    | local: 'LOCAL'
    ;

syntax To 
    = to: 'TO'
    | equalTo: '='
    ;


syntax Statement 
    = show: 'SHOW' TableName
    | showColumns: 'SHOW' 'COLUMNS' 'FROM' 'TABLE' TableName? ShowLike? LimitClause?
    | showExternalTable: 'SHOW' 'EXTERNAL' 'TABLE' TableName 'PARTITION'?
    | showDatabasesWithLike: 'SHOW' 'DATABASES' 'FROM' 'DATA' 'CATALOG'  ShowLike IamRole?
    | showDatabasesWithIamRole: 'SHOW' 'DATABASES' 'FROM' 'DATA' 'CATALOG' IamRole
    | showModel: 'SHOW' 'MODEL' NameOrAll
    | showDatashares: 'SHOW' 'DATASHARES' ShowLike?
    | showProcedure: 'SHOW' 'PROCEDURE' TableName BracketNameModeType? // check
    | showSchemas: 'SHOW' 'SCHEMAS' 'FROM' 'DATABASE' TableName ShowLike? LimitClause?
    | showTable: 'SHOW' 'TABLE' TableName
    | showTables: 'SHOW' 'TABLES' 'FROM' 'SCHEMA' TableName ShowLike? LimitClause?
    | showView: 'SHOW' 'VIEW' TableName
    ;




syntax ShowLike = showLike: 'LIKE' Expr;

