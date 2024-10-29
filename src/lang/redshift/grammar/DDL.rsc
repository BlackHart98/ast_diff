module lang::redshift::grammar::DDL


extend lang::redshift::grammar::Query;

syntax TablePropertiesClause = tablePropertiesClause2: 'TABLE' 'PROPERTIES' "("{TableProperty ", "}+")";

syntax Statement 
    = createDatabase:'CREATE' 'DATABASE' TableName WithClause?
        Owner?
        ConnectionLimit?
        Collate?
        IsolationLevel?
        FromDatashare?
        WithDataCatalog?
        IamRole?
    | createDatashare: 'CREATE' 'DATASHARE' TableName SetAccessible?
    | createExternalFunction: 'CREATE' OrReplace? 'EXTERNAL' 'FUNCTION' TableName "(" {DataType ","}* ")"
        ReturnDatatype
        VolatileStableImmutable
        SageMaker?
        LambdaName?
        IamRole
        RetryTimeout?
        MatchBatchRows?
        MatchBatchSize?
    | createExternalSchema: 'CREATE' 'EXTERNAL' 'SCHEMA' IfNotExists? TableName
        'FROM' 'DATA CATALOG'? ExternalSchemaOpts?
        DatabaseName?
        SchemaName?
        RegionName?
        UriPort?
        IamRole
        SecretArn?
        Auth?
        ClusterArn?
        CatalogRole?
        CreateExternalDB?
        CatalogId?
    | createExternalTableAsQuery1: 'CREATE' 'EXTERNAL' 'TABLE' TableName
        PartitionBy
        RowFormatClause?
        StorageClause?
        LocationClause?
        TablePropertiesClause?
        CreateTableQuery
    | createExternalTableAsQuery2: 'CREATE' 'EXTERNAL' 'TABLE' TableName
        RowFormatClause?
        StorageClause?
        LocationClause
        TablePropertiesClause?
        CreateTableQuery
    | createExternalTableAsQuery3: 'CREATE' 'EXTERNAL' 'TABLE' TableName
        RowFormatClause?
        StorageClause?
        TablePropertiesClause
        CreateTableQuery
    | createExternalView: 'CREATE' 'EXTERNAL' 'PROTECTED' 'VIEW' TableName IfNotExists?  CreateTableQuery
    | createFunction: 'CREATE' OrReplace? 'FUNCTION' TableName BracketNameModeType
        ReturnDatatype
        VolatileStableImmutable
        'AS' '$$' Expr '$$'
        Language
    | createGroup: 'CREATE' 'GROUP' TableName WithUser?
    | createIdentityProvider: 'CREATE' 'IDENTITY' 'PROVIDER' TableName 'TYPE' Identifier
        'NAMESPACE' Expr
        'PARAMETERS' String
    | createLibrary: 'CREATE' OrReplace? 'LIBRARY' TableName Language 'FROM' LibraryOpts 
    | createMaterializedView: 'CREATE' 'MATERIALIZED' 'VIEW' TableName
        Backup?
        TableAttributes?
        AutoRefresh?
        CreateTableQuery
    | createModel: 'CREATE' 'MODEL' TableName
        'FROM' Expr
        Target?
        Function
        ReturnDatatype?
        IamRole
        TypeId+
        Settings?
    | createProcedure: 'CREATE' OrReplace? 'PROCEDURE' TableName 
        BracketNameModeType
        'NONATOMIC'?
        'AS' "$$" Expr "$$" 
        Language
        Security?
    | createRlsPolicy: 'CREATE' 'RLS' 'POLICY' TableName
      WithRls?
      'USING' "(" Expr ")"
    | createRole: 'CREATE' 'ROLE' TableName ExternalId?
    | createSchema: 'CREATE' 'SCHEMA' TableName? 'AUTHORIZATION'? IfNotExists? TableName Quota?
    | createUser: 'CREATE' 'USER' TableName UserId? 'WITH'?
      UserOptions*
    | createViewWithNoSchema: 'CREATE' OrReplace? 'VIEW' TableName BracketCol? CreateTableQuery WithNoSchema
    | createOrReplaceView: 'CREATE' OrReplace 'VIEW' TableName BracketCol? CreateTableQuery 
    ;
 


syntax PartitionBy = partitionBy: 'PARTITIONED' 'BY' BracketNameModeType;

syntax WithUser = withUser: 'WITH' User;
syntax User = user: 'USER' {TableName ","}*;
syntax Language = lang: 'LANGUAGE' LangOpts;
syntax Target = target: 'TARGET' Expr;
syntax LibraryOpts = libOpts: StringConstant IamRole? auth RegionAs? IamRole? ; // check 
syntax TypeId = typeid: Identifier Expr;
syntax RegionAs =regionAs: 'REGION' VarAssignAs? Expr;
syntax WithRls = withRls: 'WITH' BracketNameModeType 'AS'? TableName?;
syntax LangOpts 
    = plpythonu: 'plpythonu'
    | sql: 'sql'
    | plpsql: 'plpgsql'
    ;

syntax Quota = unlimited: 'QUOTA' 'UNLIMITED' | quotaUnit: 'QUOTA' Int ByteFormat?;
syntax Settings = settings: 'SETTINGS' "(" TypeId+ ")";
syntax Security = securityInvoker: 'SECURITY' 'INVOKER' | securityDefiner: 'SECURITY' 'DEFINER';
syntax ExternalId = externalId: 'EXTERNALID' Expr | externalIdTo: 'EXTERNAL' 'ID' 'TO' Identifier | externalIdToStr: 'EXTERNAL' 'ID' 'TO' StringConstant;
syntax BracketNameModeType = bracketNameModeType: "(" {NameModeType ","}+ ")";
syntax AutoRefresh = autoRefresh: 'AUTO' 'REFRESH' YesOrNo;
syntax NameModeType = nameModeType: Identifier arg_name ArgMode? DataType?;
 
syntax CreateNoCreateDb = createDb: 'CREATEDB' | noCreateDb: 'NOCREATEDB';

syntax ArgMode 
    = argIn: 'IN'
    | argout: 'OUT'
    | argInOut: 'INOUT'
    ;



syntax UserOptions
    = createNoCreateDb: CreateNoCreateDb
    | createNoCreateUser: CreateNoCreateUser
    | sysRes:'SYSLOG' 'ACCESS' RestrictedUnrestricted
    | passw:'PASSWORD' UserOptionSecureType Validity?
    | renameId: 'RENAME' 'TO' TableName
    | connlimit: ConnectionLimit
    | sessionTimeout:'SESSION' 'TIMEOUT' SessionLimit
    | settoval: 'SET' Expr ToEq Expr
    | resetAlter: 'RESET' Expr
    | exterId: ExternalId
    | inGroup: 'IN' 'GROUP' {TableName ","}+
    ;

syntax CreateTable
    = createTable2: 'CREATE' 'LOCAL'? TempVariant? 'TABLE' 
      IfNotExists? TableName
      BracketCrtableOpts?
      BracketCol?
      Backup?
      TableAttributes*
      CreateTableQuery?
    ;

syntax CreateNoCreateUser = createUser: 'CREATEUSER' | noCreateUser: 'NOCREATEUSER';
syntax ToEq = to: 'TO' | eq: "=";
syntax PartitionedByClause = 'PARTITIONED' 'BY' "("{Identifier ","}+")";

syntax CreateTableQuery = asSelect: 'AS' QueryOrWith;
syntax BracketCrtableOpts = bracketCrtableOpts: "(" {CreateTableOpts ","}+ ")";
syntax TableAttributes  
    = tableDistStyle: DistStyle
    | tableDistKey: Distkey
    | tableSortKey: SortKey
    | tableEncodeAuto: EncodeAuto 
    ;

syntax DistStyle = distStyle: 'DISTSTYLE' DistOpts;
syntax SortKey = sortKey:  'SORTKEY' BracketCol 'SORTKEY'? 'AUTO'?;
syntax EncodeAuto = encodeAuto: 'ENCODE' 'AUTO';
syntax BracketCol = bracketCol: "(" {Expr ","}+ ")"; 
syntax Distkey = distkey: 'DISTKEY' BracketCol?;
syntax Backup = backup: 'BACKUP' YesOrNo;
syntax YesOrNo = yes: 'YES' | no: 'NO';
syntax OrReplace = orReplace: 'OR' 'REPLACE';
syntax Owner = owner: 'OWNER' "="? TableName;
syntax ConnectionLimit = connectionLimit: 'CONNECTION' 'LIMIT' ConnLimitOptions;

syntax Validity= validUntil: 'VALID' 'UNTIL' Expr;

syntax ConnLimitOptions 
    = limit: Int
    | connunlimited: 'UNLIMITED'
    ; 

syntax SetAccessible = setAccessible: 'SET' 'PUBLICACCESSIBLE' "="? Boolean;
syntax Collate = collate: 'COLLATE' CaseOption;

syntax CaseOption
    = caseSensitive: 'CASE_SENSITIVE'
    | caseInsensitive: 'CASE_INSENSITIVE'
    ;

syntax SessionLimit
    = sessionLimit: Int 
    | timeoutSession: 'RESET' 'SESSION' 'TIMEOUT'
    ;

syntax IsolationLevel = isolationLevel: 'ISOLATION' 'LEVEL' SerializableSnapshot;
syntax FromDatashare  = fromDatashare: WithPermissions? 'FROM' 'DATASHARE' TableName 'OF' AccountId? 'NAMESPACE' Expr;
syntax AccountId = accountId: 'ACCOUNT' Expr; 
syntax WithPermissions = withPermissions: 'WITH' 'PERMISSIONS';
syntax SerializableSnapshot = serializable: 'SERIALIZABLE' | snapshot: 'SNAPSHOT';
syntax WithDataCatalog = withDataCatalog: 'WITH' 'NO'? 'DATA' 'CATALOG' 'SCHEMA' StringConstant?;

syntax IamRole = iAmRole: Identifier IamRoleOptions;

syntax IamRoleOptions 
    = roleDefault: 'default'
    | roleSession: 'SESSION_USER'
    | roleCustom: StringConstant
    ;


syntax ReturnDatatype =returnType: 'RETURNS' DataType;

syntax VolatileStableImmutable
    = volatile: 'VOLATILE'
    | stable: 'STABLE'
    | immutable: 'IMMUTABLE'
    ;


syntax SageMaker = sageMaker: 'SAGEMAKER' StringConstant;
syntax LambdaName = lambdaStr: 'LAMBDA' StringConstant;
syntax RetryTimeout = retryTimeout: 'RETRY_TIMEOUT' Expr milliseconds;
syntax MatchBatchRows = maxBatchRows: 'MAX_BATCH_ROWS' Expr count;

syntax MatchBatchSize = maxBatchSize: 'MAX_BATCH_SIZE' Expr size ByteFormat; 

syntax ByteFormat
    = kb: 'KB'
    | mb: 'MB'
    | gb: 'GB'
    | tb: 'TB'
    ;

syntax ExternalSchemaOpts 
    = hiveMetastore: 'HIVE' 'METASTORE'
    | postgres: 'POSTGRES'
    | mysql: 'MYSQL'
    | kinesis: 'KINESIS'
    | msk: 'MSK'
    | redshift: 'REDSHIFT'
    ;


syntax DatabaseName = databaseName: 'DATABASE' StringConstant;
syntax SchemaName = schemaName: 'SCHEMA' StringConstant;
syntax RegionName = regionName: 'REGION' StringConstant;
syntax UriPort =uriPort: 'URI' StringConstant PortNumber?;
syntax PortNumber = portNumber: 'PORT' Int;
syntax SecretArn = secretArn: 'SECRET_ARN' StringConstant;
syntax Auth = auth: 'AUTHENTICATION' StringConstant;
syntax ClusterArn = clusterArn: 'CLUSTER_ARN' StringConstant;
syntax CatalogRole = catalogRole: 'CATALOG_ROLE' StringConstant;
syntax CatalogId = catalogId: 'CATALOG_ID' StringConstant;
syntax CreateExternalDB = createExternalDB: 'CREATE' 'EXTERNAL' 'DATABASE' IfNotExists;
syntax RestrictedUnrestricted= restricted: 'RESTRICTED' | unrestricted: 'UNRESTRICTED';

syntax DistOpts
    = auto: 'AUTO'
    | even: 'EVEN'
    | key: 'KEY'
    | distall: 'ALL'
    ;

syntax CreateTableOpts 
    = cr1: TableName DataType AttrOrConst*
    | cr2: TableConstraints
    | cr3: 'LIKE' TableName IncludingOrExcluding
    ;

syntax AttrOrConst = colAttr: ColumnAttributes | colConst: ColumnConstraints;
syntax TableConstraints = tableConstraints: UniqOrPrimOrFrgn;
syntax IncludingOrExcluding = including: 'INCLUDING' 'DEFAULTS' | excluding: 'EXCLUDING' 'DEFAULTS';


syntax ColumnAttributes 
    = colOrAttrDef:  DefaultExpr
    | colOrAttrId: Identity
    | colOrAttrGen: GeneratedBy
    | colOrAttrEnc: Encode
    | colOrAttrDist: Distkey
    | colOrAtttrSort: Sortkey
    | colOrAttrColl: Collate
    ;


syntax DefaultExpr = defaultExpr: 'DEFAULT' Expr;
syntax Identity = identity: 'IDENTITY' ExprExpr?;
syntax ExprExpr = exprexpr: "("Expr "," Expr ")";
syntax GeneratedBy = generatedBy: 'GENERATED' 'BY' 'DEFAULT' 'AS' 'IDENTITY' ExprExpr?;
syntax References = references: 'REFERENCES' Identifier BracketCol?;
syntax Encode = encode: 'ENCODE' Expr;
syntax Sortkey = sortkey: 'SORTKEY';
syntax TableProperties = tableProperties: 'TABLE' 'PROPERTIES' Options;
syntax ColumnConstraints 
    = nullOpt: NullOptions
    | upf: UniqOrPrimOrFrgn
    | ref: References
    ;

syntax UniqOrPrimOrFrgn
    = unique: 'UNIQUE' BracketCol?
    | primaryKey: 'PRIMARY' 'KEY' BracketCol?
    | foreignKey: 'FOREIGN' 'KEY' BracketCol References
    ;

syntax NullOptions 
    = null: 'NULL'
    | notNull: 'NOT' 'NULL'
    ; 

syntax Options = options: "(" {OptionParam ","}+ ")";
syntax OptionParam = Identifier "=" Expr | StringConstant "=" Expr;
syntax Function = function: 'FUNCTION' TableName ("(" {DataType ","}+ ")")?;
syntax UserOptionSecureType = disable: 'DISABLE' | passExpr: Expr;
syntax UserId = userId: ":"Identifier;
syntax WithNoSchema = withNoSchema: 'WITH' 'NO' 'SCHEMA' 'BINDING';




syntax AlterTable
    = addConstraints: 'ALTER' 'TABLE' TableName 'ADD' Constraints? TableConstraints
    | dropConstraints: 'ALTER' 'TABLE' TableName 'DROP' 'CONSTRAINT' Identifier CascadeOrForceOrRestrict?
    | changeOwner: 'ALTER' 'TABLE' TableName 'OWNER' 'TO' Identifier
    | renameColumn: 'ALTER' 'TABLE' TableName 'RENAME' 'COLUMN' Identifier 'TO' Identifier
    | alterColumnType: 'ALTER' 'TABLE' TableName 'ALTER' 'COLUMN' Identifier 'TYPE' Expr
    | alterColumnEncode: 'ALTER' 'TABLE' TableName 'ALTER' 'COLUMN' Identifier 'ENCODE' {Identifier ","}+
    | distAndSortKeyList: {DistAndSortKey ","}+
    | encodeAutoAlter: 'ALTER' 'ENCODE' 'AUTO'
    | addColumn: 'ALTER' 'TABLE' TableName 'ADD' 'COLUMN'? Identifier Identifier DefaultExpr? Encode? NullOptions? CollateOpt?
    | dropColumn: 'ALTER' 'TABLE' TableName 'DROP' 'COLUMN'? Identifier CascadeOrForceOrRestrict?
    | rowLevelSecurity: 'ALTER' 'TABLE' TableName 'ROW' 'LEVEL' 'SECURITY' OnOrOff CjnTypes?
    | setLocation: 'ALTER' 'TABLE' TableName SetLocation
    | setFileFormat: 'ALTER' 'TABLE' TableName 'SET' 'FILE' 'FORMAT' Identifier
    | setExternalTableProperties: 'ALTER' 'TABLE' TableName 'SET' 'TABLE' 'PROPERTIES' "(" AlterPropsVal ")"
    | setExternalPartition: 'ALTER' 'TABLE' TableName 'PARTITION' "(" {AlterPropsVal ","}+ ")" SetLocation
    ;

syntax DistAndSortKey
    = altTbDist: 'ALTER' 'DISTKEY' Identifier
    | altTbDistStyle: 'ALTER' 'DISTSTYLE' AltTbDstStyleOption
    | sortKey: 'ALTER' AltTbCmpd? 'SORTKEY' AltTbSrtOpt
    ;


syntax SetLocation
    = setLoc: 'SET' 'LOCATION' String
    ;

syntax AlterPropsVal
    = altPropsVal: "\'" { Identifier "."}+ "\'" "=" Expr
    ;

syntax CjnTypes
    = cjnTypes: 'CONJUNCTION' 'TYPE' AndOr FrDtShare?
    ;

syntax FrDtShare
    = frDtShare: 'FOR' 'DATASHARES'
    ;


syntax CascadeOrForceOrRestrict
    = cascade: 'CASCADE'
    | force: 'FORCE'
    | restrict: 'RESTRICT'
    ;

syntax CollateOpt = collOpt: 'COLLATE' CaseOption;
syntax Constraints = constraint: 'CONSTRAINT' Identifier;
syntax OnOrOff = on: 'ON'| off: 'OFF';
syntax AndOr = and: 'AND'| or: 'OR';


syntax AltTbDstStyleOption
    = dstAll: 'ALL'
    | dstEven: 'EVEN'
    | dstAuto: 'AUTO'
    | dstKey: 'KEY' 'DISTKEY' Identifier
    ;

syntax AltTbSrtOpt
    = srtAuto: 'AUTO'
    | srtNone: 'NONE'
    | withColName: "(" {Identifier ","}+ ")"
    ;

syntax AltTbCmpd = compound: 'COMPOUND';


syntax Statement
    = alterDatabase: 'ALTER' 'DATABASE' TableName? AlterDBOptions
    | alterAddOrRemoveObjects: 'ALTER' 'DATASHARE' Identifier AddOrRemoveObjects AlterDataShareOptions 
    | alterConfigPropsOpt: 'ALTER' 'DATASHARE' Identifier SetPubAcc? SetIncNew?
    | alterExternalView: 'ALTER' 'EXTERNAL' 'VIEW' TableName 'FORCE'? CreateTableQuery? RemoveDefinition?
    | alterDefaultPrivileges: 'ALTER' 'DEFAULT' 'PRIVILEGES' ForUser? InSchema? GrantOrRevoke
    | alterMaskingPolicy: 'ALTER' 'MASKING' 'POLICY' TableName 'USING' "(" Expr ")" //TODO: work on Exp as masking expression 
    | alterIdentityProvider: 'ALTER' 'IDENTITY' 'PROVIDER' TableName 'PARAMETERS' StringConstant
    | alterGroup: 'ALTER' 'GROUP' TableName AlterGroupOption
    | alterMaterializedView: 'ALTER' 'MATERIALIZED' 'VIEW' Identifier AutoRefresh? RowLevelSecurity?
    | alterRlsPolicy: 'ALTER' 'RLS' 'POLICY' Identifier 'USING' "(" Expr ")"
    | alterRole: 'ALTER' 'ROLE' Identifier 'WITH'? {AlterRoleOption ","}* ExternalId?
    | alterProcedure: 'ALTER' 'PROCEDURE' TableName AlterProcedureOptions? RenameOrChange 'TO' ProcedureToOption
    | alterSchema: 'ALTER' 'SCHEMA' Identifier AlterSchemaOptions
    | alterSystem: 'ALTER' 'SYSTEM' 'SET' SystemLvlConf "=" SysLvlConfVal
    | alterUser: 'ALTER' 'USER' TableName UserId? 'WITH'? UserOptions*
    ;

syntax Statement = dropStmt: DropStatement;

syntax DropStatement
    = dropFunction: 'DROP' 'FUNCTION' IfExists? Identifier BracketNameModeType2 CascadeOrForceOrRestrict?
    | dropTable: 'DROP' 'TABLE' IfExists? TableName CascadeOrForceOrRestrict?
    ;


syntax SystemLvlConf
    = dtCat: 'data_catalog_auto_mount'
    | mtSec: 'metadata_security'
    ;


syntax DropStatement 
    = dropStatement: 'DROP' DropOptions IfExists? {TableName ","}+ DropExternalDatabase? BracketNameModeType? IfExists? CascadeOrForceOrRestrict? TableName?
    ;

syntax BracketNameModeType2 
    = bracketNameModeType: "(" {NameModeType2 ","}+ ")";

syntax NameModeType2 = nameModeType2: Identifier? arg_name ArgMode? DataType;

syntax DropOptions
    = dDatabase: 'DATABASE'
    | dDatashare: 'DATASHARE'
    | dExternalView: 'EXTERNAL' 'VIEW'
    // | dFunction: 'FUNCTION'
    | dGroup: 'GROUP'
    | dIdentityProvider: 'IDENTITY' 'PROVIDER'
    | dLibrary: 'LIBRARY'
    | dMaskingPolicy: 'MASKING' 'POLICY'
    | dModel: 'MODEL'
    | dMaterializedView: 'MATERIALIZED' 'VIEW'
    | dProcedure: 'PROCEDURE'
    | dRlsPolicy: 'RLS' 'POLICY'
    | dRole: 'ROLE'
    | dSchema: 'SCHEMA' 
    // | dTable: 'TABLE'
    | dUser: 'USER'
    | dView: 'VIEW'
    ;

syntax DropExternalDatabase = dropExternalDatabase: 'DROP' 'EXTERNAL' 'DATABASE';

syntax SysLvlConfVal
    = trueVal2: 'T'
    | falseVal2: 'F'
    | onOff: OnOrOff
    | booleanVal: Boolean
    ;

syntax AlterSchemaOptions
    = renameSchema: 'RENAME' 'TO' Identifier
    | changeSchemaOwner: 'OWNER' 'TO' Identifier
    | quota:  Quota
    ;

syntax AlterRoleOption
    = renameToRole: 'RENAME' 'TO' Identifier
    | ownerToId: 'OWNER' 'TO' Identifier
    ;


syntax AlterProcedureOptions
    = altProcOptionParenthesis: "(" {AlterProcOptionArg ","}* ")"
    ;

syntax ProcedureToOption
    = newOwner: Identifier
    | currentUser: 'CURRENT_USER'
    | sessionUser: 'SESSION_USER' 
    ;


syntax AlterProcOptionArg = alterProcOptionArg: Identifier? ArgMode? DataType;


syntax RenameOrChange = renameAlter: 'RENAME' | ownerAlter: 'OWNER';

syntax RowLevelSecurity = rowLevelSecurity: 'ROW' 'LEVEL' 'SECURITY' OnOrOff ConjuctionType? ForDtShares?;
syntax AddOrRemoveObjects = addObject: 'ADD' | removeObject: 'REMOVE';

syntax ConjuctionType = conjuctionType: 'CONJUCTION' 'TYPE' AndOr;


syntax ForDtShares = forDataShares: 'FOR' 'DATA' 'SHARES';


syntax AlterDBOptions
    = rnOpt: 'RENAME' 'TO' Identifier
    | chOwnOpt: 'OWNER' 'TO' Identifier
    | conOpt: 'CONNECTION' 'LIMIT' ConnectionLimitOptions
    | colOpt: 'COLLATE' CaseOption
    | isoOpt: 'ISOLATION' 'LEVEL' SerializableSnapshot
    | integrOpt: 'INTEGRATION' 'REFRESH' AllOrInerror 'TABLES' IntegrationRefreshOptions?
    ;

syntax ConnectionLimitOptions
    = conOptInt: Int 
    | conOptUnlimited: 'UNLIMITED' 
    ;

syntax AllOrInerror
    = aall: 'ALL'
    | inError: 'IN' 'ERROR'
    ;


syntax IntegrationRefreshOptions
    = intRefInSchema: 'IN' 'SCHEMA' {TableName ","}+
    | intRefTable: 'TABLE' {TableName ","}+
    ;

syntax SetPubAcc = setPubAcc: 'SET' 'PUBLIC' 'ACCESSIBLE' '='? Boolean;

syntax SetIncNew = setInNew: 'SET' 'INCLUDE' 'NEW' '='? Boolean 'FOR' 'SCHEMA' Identifier;

syntax AlterDataShareOptions
    = tableOpt: 'TABLE' {TableName ","}+
    | schemaOpt: 'SCHEMA' {TableName ","}+
    | funcOpt: 'FUNCTION' {Expr ","}+
    | allTbInSchema: 'ALL' 'TABLES' 'IN' 'SCHEMA' {TableName ","}+
    | allFnInSchema: 'ALL' 'FUNCTIONS' 'IN' 'SCHEMA' {TableName ","}+
    ;



syntax GrantOrRevoke
    = grantPrivileges: 'GRANT' GrantPrivileges
    | revokePrivileges: 'REVOKE' RevokePrivileges
    ;


syntax GrantPrivileges
    = grantOnTables: CommandListOrAll 'ON' 'TABLES' 'TO' {T1 ","}+
    | grantOnFn: ExecuteOrAll 'ON' 'FUNCTIONS' 'TO' {T1 ","}+
    | grantOnProced: ExecuteOrAll 'ON' 'PROCEDURES' 'TO' {T1 ","}+
    ;
syntax ForUser = forUser: 'FOR' 'USER' {Identifier ","}+;
syntax InSchema = inSchema: 'IN' 'SCHEMA' {Identifier ","}+;


syntax RevokePrivileges
    = revokeUserOnTable: GrantOptionFor? CommandListOrAll 'ON' 'TABLES' 'FROM' {Identifier ","}+ Restrict?
    | revokeCategoryOnTable: CommandListOrAll 'ON' 'TABLES' 'FROM' {GroupRoles ","}+ Restrict?
    | revokeUserOnFunctions: GrantOptionFor? ExecuteOrAll 'ON' 'FUNCTIONS' 'FROM' {Identifier ","}+ Restrict?
    | revokeCategoryOnFunctions: ExecuteOrAll 'ON' 'FUNCTIONS' 'FROM' {GroupRoles ","}+ Restrict?
    | revokeUserOnProcedures: GrantOptionFor? ExecuteOrAll 'ON' 'PROCEDURES' 'FROM' {Identifier ","}+ Restrict?
    | revokeCategoryOnPocedures: ExecuteOrAll 'ON' 'PROCEDURES' 'FROM' {GroupRoles ","}+ Restrict?
    ;

syntax T1 
    = gUser: Identifier WithGrant?
    | groupRoles: GroupRoles
    ;
syntax CommandListOrAll
    = command: {Command ","}+
    | allPrivOnTb: AllPrivileges
    ;

syntax AllPrivileges = allPrivileges: 'ALL' 'PRIVILEGES'?;

syntax GrantOptionFor = grantOptionFor: 'GRANT' 'OPTION' 'FOR';
syntax Restrict = restrictKey: 'RESTRICT';

syntax ExecuteOrAll
    = execute: 'EXECUTE'
    | allPrivOnFn: AllPrivileges
    ;

syntax GroupRoles
    = groupRole: 'ROLE' Identifier
    | groupGroup: 'GROUP' Identifier
    | groupPublic: 'PUBLIC'
    ;

syntax WithGrant
    =  withGrant: 'WITH' 'GRANT' 'OPTIONS'
    ;

syntax Command //TODO: replace commands with actual commands
    = selectCmd: 'SELECT'
    | insertCmd: "Insert" 
    | updateCmd: 'UPDATE' 
    | deleteCmd: "Delete" 
    | dropCmd: DropStatement
    | referenceCmd: 'REFERENCES' 
    | truncateCmd: 'TRUNCATE'
    ;

syntax RemoveDefinition = removeDefinition: 'REMOVE' 'DEFINITION';


syntax AlterGroupOption
    = addUser: 'ADD' 'USER' {Identifier ","}+
    | altdropUser: 'DROP' 'USER' {Identifier ","}+
    | altrenameGroup: 'RENAME' 'TO' Identifier
    ;