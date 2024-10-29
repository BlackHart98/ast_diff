module lang::bigquery::grammar::DDL

extend lang::bigquery::grammar::Query;

syntax Statement 
    = createSchema: 'CREATE' 'SCHEMA' IfNotExists? TableName DefaultCollate? SchemaOptions?
    | createView: 'CREATE' OrReplace? 'VIEW' IfNotExists?
        TableName
        ViewColumnList?
        SchemaOptions?
        'AS' QueryOrWith
    | createMaterialized: 'CREATE' OrReplace? 'MATERIALIZED' 'VIEW' IfNotExists?
        TableName
        PartitionBy?
        ClusterBy?
        SchemaOptions?
        'AS' QueryOrWith
    | createFunction: 'CREATE' OrReplace? TemporaryTable? 'FUNCTION' IfNotExists?
        TableName
        BracketNameType
        BracketNameType?
        ReturnDatatype?
        RemoteWithConnection?
        AsBracketExp?
        SchemaOptions?
    | createJsFunction: 'CREATE' OrReplace? TemporaryTable? 'FUNCTION' IfNotExists?
        TableName
        BracketNameType
        ReturnDatatype
        DeterminismSpecifier?
        'LANGUAGE' "js"
        SchemaOptions?
        'AS' Expr js_code
    | createTableFunction: 'CREATE' OrReplace? 'TABLE' 'FUNCTION' IfNotExists?
        TableName "("{FunctionParameter ","}*")"
        ReturnTableType?
        SchemaOptions?
        ('AS' QueryOrWith)? sql_query
    | createCapacity: 'CREATE' 'CAPACITY' TableName
        SchemaOptions
    | createReservation: 'CREATE' 'RESERVATION' TableName
        SchemaOptions
    | createAssignment: 'CREATE' 'ASSIGNMENT' TableName
        SchemaOptions
    | createSearchIndex: 'CREATE' 'SEARCH' 'INDEX' IfNotExists? TableName
        'ON' TableName"(" ColumnType   ")"
        SchemaOptions?
    | createTableBQ: 'CREATE' OrReplace? TemporaryTable? 'TABLE' IfNotExists?
        TableName 
        TableVariants?
        ListColumnOrConstraint?
        DefaultCollate?
        PartitionBy?
        ClusterBy?
        SchemaOptions?
        CreateTableQuery?
    | createExtern: 'CREATE' OrReplace? ExternalTable 'TABLE' IfNotExists?
        TableName
        ListColumnOrConstraint?
        WithConnection?
        WithPartitionColumns?
        SchemaOptions?
    ;


syntax ColumnType = colName: {Identifier ","}+  | allCols: 'ALL' 'COLUMNS';


syntax ReturnTableType = returnTableType: 'RETURNS' 'TABLE' "\<" {NameType ","}+ "\>";



syntax FunctionParameter 
    = functionParameter: TableName DataType
    | anyType: TableName 'ANY' 'TYPE'
    ;


syntax DeterminismSpecifier 
    = deterministic:  'DETERMINISTIC' 
    | nonDeterministic: 'NOT' 'DETERMINISTIC'
    ;

syntax ReturnDatatype = returnDatatype: 'RETURNS' DataType;

syntax RemoteWithConnection = remoteWithConnection: 'REMOTE' WithConnection;

syntax AsBracketExp = asBracketExp: 'AS' "("Expr")";


syntax ViewColumnList = viewColumn: "(" ExpList ")";


syntax DefaultCollate = defaultCollate: 'DEFAULT' 'COLLATE' Expr;

syntax SchemaOptions = schemaOptions: 'OPTIONS' "(" {TablenameEqExpr ","}+ ")";

syntax TablenameEqExpr = tablenameExpr: TableName "=" Expr;

syntax OrReplace = orReplace: 'OR' 'REPLACE';



syntax TableVariants 
    = tableLike: 'LIKE' TableName
    | tableCopy: 'COPY' TableName 
    | tableClone: 'CLONE' TableName
    ;



syntax ListColumnOrConstraint = colcons: "("{ColumnOrConstraint ","}+")";

syntax ColumnOrConstraint
    = col: Column
    | constraint: {ConstraintDefinition ","}+
    ;


syntax ConstraintDefinition 
    = priKey: PrimaryKey
    | constraintFkey: ConstraintId? {ForeignKey ","}+
    ;


syntax Column = column: Identifier ColumnSchema;

syntax ConstraintId = constraintId: 'CONSTRAINT' Identifier;

syntax PrimaryKey =primaryKey: 'PRIMARY' 'KEY' "(" {Identifier ","}+ ")" 'NOT' 'ENFORCED';
syntax ForeignKey =foreignKey: 'FOREIGN' 'KEY' "(" {Identifier ","}+ ")" ForeignReference;
syntax ForeignReference =foreignRef: 'REFERENCES' Identifier"(" {Identifier ","}+ ")" 'NOT' 'ENFORCED';



syntax ColumnSchema = columnSchema: ReqSchema Enforced? Default? NotNull? SchemaOptions?;




syntax WithConnection = withConnection: 'WITH' 'CONNECTION' TableName;

syntax WithPartitionColumns = withPartitionColumns: 'WITH' 'PARTITION' 'COLUMNS' BracketNameType?;

syntax BracketNameType = bracketNameType: "(" {NameType ","}* ")";
syntax NameType = nameType: TableName DataType;

syntax PartitionBy = partitionBy: 'PARTITION' 'BY' Expr;
syntax ClusterBy = clusterBy: 'CLUSTER' 'BY' {Expr ","}+ ;


syntax TemporaryTable = tempTable: 'TEMP';

syntax NotNull = notnull: 'NOT' 'NULL';

syntax Enforced 
  = enforced: 'PRIMARY' 'KEY' 'NOT' 'ENFORCED'
  | enforcedRef: 'REFERENCES' TableName"("Identifier")" 'NOT' 'ENFORCED'
  ;

syntax Default = \default: 'DEFAULT' Expr;


syntax ReqSchema 
    = typeSchema: SimpleType 
    | structSchema:'STRUCT'"\<"{FieldList ","}+"\>" 
    | arraySchema:'ARRAY'"\<"ArraySchema"\>" 
    ;


syntax SimpleType 
    = simpleDataType: DataType!arrayType!structType
    | stringCollate: 'STRING' 'COLLATE' Expr
    ;


syntax ArraySchema 
    = simpleArraySchema: SimpleType NotNull?
    | structArraySchema: 'STRUCT'"\<"FieldList"\>" NotNull?
    ;


syntax FieldList = fieldList: Identifier ReqSchema Enforced? Default? NotNull? SchemaOptions? ;


syntax Statement 
    = createSnapshot: 'CREATE' 'SNAPSHOT' 'TABLE' IfNotExists? TableName
    'CLONE' TableName FromTimestamp? SchemaOptions?
    ;



// ALTER

syntax Statement = alterTable: AlterTable;
syntax AlterTable 
    = renameTable: 'ALTER' 'TABLE' IfExists? TableName 'RENAME' 'TO' TableName
    | addColumns: 'ALTER' 'TABLE' TableName {AddColumn ","}+
    | renameColumns: 'ALTER' 'TABLE' IfExists? TableName {RenameColumn ","}+
    | setSchemaOptions: 'ALTER' 'TABLE' IfExists? TableName 'SET' SchemaOptions
    | columnDropDefault: 'ALTER' 'TABLE' IfExists? TableName
        'ALTER' 'COLUMN' IfExists? TableName
        'DROP' 'DEFAULT' 
    | setDefault: 'ALTER' 'TABLE' TableName 'SET' 'DEFAULT' 'COLLATE' Expr
    | columnSetDefault: 'ALTER' 'TABLE' IfExists? TableName
        'ALTER' 'COLUMN' IfExists? TableName
        'SET' 'DEFAULT' Expr 
    | columnSetDataType: 'ALTER' 'TABLE' IfExists? TableName
        'ALTER' 'COLUMN' IfExists? TableName
        'SET' 'DATA' 'TYPE' DataType
    | dropPrimaryKey: 'ALTER' 'TABLE' TableName
        'DROP' 'PRIMARY' 'KEY' IfExists?
    | addKeys: 'ALTER' 'TABLE' TableName {AddConstraintDef ","}+
    | dropConstraints: 'ALTER' 'TABLE' TableName {DropConstraint ","}+
    | tableColumnSet: 'ALTER' 'TABLE' IfExists? TableName
        'ALTER' 'COLUMN' IfExists? TableName
        'SET' SchemaOptions
    ;


syntax AddColumn = addColumn: 'ADD' 'COLUMN' IfNotExists? Column;
syntax RenameColumn = renameColumn: 'RENAME' 'COLUMN' IfExists? Identifier 'TO' Identifier;


syntax Statement 
    = alterSchemaSetDefault: 'ALTER' 'SCHEMA' IfExists? TableName
        'SET' 'DEFAULT' 'COLLATE' Expr
    | alterSchemaSetOptions: 'ALTER' 'SCHEMA' IfExists? TableName
        'SET' SchemaOptions
    | alterSchemaAddReplica: 'ALTER' 'SCHEMA' IfExists? TableName
        'ADD' 'REPLICA' TableName SchemaOptions?
    | alterSchemaDropReplica: 'ALTER' 'SCHEMA' IfExists? TableName
        'DROP' 'REPLICA' TableName SchemaOptions?
    | alterViewSetOptions: 'ALTER' 'VIEW' IfExists? TableName
        'SET' SchemaOptions
    | alterMaterializedViewSetOptions: 'ALTER' 'MATERIALIZED' 'VIEW' IfExists? TableName
        'SET' SchemaOptions
    | alterSetorganization: 'ALTER' 'ORGANIZATION' 'SET' SchemaOptions
    | alterSetProject: 'ALTER' 'PROJECT' TableName 'SET' SchemaOptions
    | alterSetBiCapacity: 'ALTER' 'BI_CAPACITY' TableName 'SET' SchemaOptions
    | alterSetCapacity: 'ALTER' 'CAPACITY' TableName 'SET' SchemaOptions
    | alterSetReservation: 'ALTER' 'RESERVATION' TableName 'SET' SchemaOptions
    | alterViewColumnSet: 'ALTER' 'VIEW' IfExists? TableName
        'ALTER' 'COLUMN' IfExists? TableName
        'SET' SchemaOptions
    ;


syntax DropConstraint = dropConstraint: 'DROP' 'CONSTRAINT' IfExists? TableName;
syntax AddConstraintDef = addConstraintDef: 'ADD' ConstraintDefinition;


syntax Statement
    = dropMaterializedView: 'DROP' 'MATERIALIZED' 'VIEW' IfExists? TableName
    | dropFunction: 'DROP' 'FUNCTION' IfExists? TableName
    | dropTableFunction: 'DROP' 'TABLE' 'FUNCTION' IfExists? TableName
    | dropExternalTable: 'DROP' 'EXTERNAL' 'TABLE' IfExists? TableName
    | dropSearchIndex: 'DROP' 'SEARCH' 'INDEX' IfExists? TableName 'ON' TableName
    | dropRowAccessPolicy: 'DROP' 'ROW' 'ACCESS' 'POLICY' IfExists? TableName 'ON' TableName
    | dropSnapshot: 'DROP' 'SNAPSHOT' 'TABLE' IfExists? TableName
    ;

