module lang::spark::grammar::DDL

extend lang::spark::grammar::Query;


syntax Statement 
    = createViewWithReplace: 'CREATE' OrReplaceOrTemporary 'VIEW' IfNotExists? TableName
        CreateViewClause* 'AS' QueryOrWith
    | createDb:'CREATE' DatabaseOrSchema IfNotExists? Identifier
        CommentLiteral?
        LocationClause?
        WithDB?
    | createFunction:'CREATE' OrReplaceOrTemporary? 'FUNCTION' IfNotExists?
        {Identifier ","}+ 'AS' StringConstant ResourceLocation?
    | setStatement: SetStatement
    ;


syntax CreateTable
    = fromSource:'CREATE' 'TABLE' IfNotExists? TableName?
        Columns?
        UsingClause
        PartitionedByClause?
        (ClusteredByClause?
            SortedByClause?
            'INTO' Expr 'BUCKETS' )?
        LocationClause?
        CommentLiteral?
            TablePropertiesClause?
        AsSelect?
    ;

syntax DatabaseOrSchema 
    = database:'DATABASE'
    | schemaKeyword : 'SCHEMA'
    | databases: 'DATABASES'
    ;

syntax ColumnKeyword 
    = col:'COLUMN'
    | cols:'COLUMNS'
    ;



syntax UsingClause = usingClause: 'USING' StoredAsType Option?;

syntax Option = option: 'OPTIONS'"("{Options ","}+ ")";

syntax Options 
    = optionStr: String "=" String
    | pair: Identifier Expr 
    | storageLevel: String Expr
    ;

syntax AsSelect
    = withAs: 'AS' QueryOrWith
    | cte:("(" QueryOrWith ")")
    ;

syntax OrReplaceOrTemporary 
    = orReplace: 'OR' 'REPLACE'
    | temporary: TemporaryTable
    | replaceTemporary: 'OR' 'REPLACE' TemporaryTable
    ;



syntax TemporaryTable = globalTemporaryTable : 'GLOBAL' 'TEMPORARY';

syntax CreateViewClause 
    = columnLevel : "(" {(Identifier CommentLiteral?) "," }+  ")"
    | viewLevel :CommentLiteral
    | tbl:TablePropertiesClause
    ;

syntax TBLPROPERTIES =tbl: 'TBLPROPERTIES' "("{TblProp ","}+ ")";

 syntax TblProp = String "=" String;


 syntax StoredAsType = hive: 'HIVE';



 syntax ColumnSpecification = columnNoType: Expr;



 syntax WithDB = with: 'WITH' 'DBPROPERTIES' "(" {(Identifier "=" Expr) ","}*  ")" ;




 syntax ResourceLocation = rLoc: 'USING' RType StringConstant;


 syntax RType
    = jar:'JAR'
    | file: 'FILE'
    | archive :'ARCHIVE'
    ;



syntax AlterTable
  = alterOrChange:'ALTER' 'TABLE' TableName AlterOrChange ColumnKeyword? Identifier column_name Identifier? alterColumnAction CommentLiteral
  | addColumn: 'ALTER' 'TABLE' TableName 'ADD'  'columns' "(" { (Identifier DataType? type) ","}+ ")"
  | renameColumn: 'ALTER' 'TABLE' TableName  'RENAME' 'COLUMN' Identifier 'TO' Identifier
  | replaceColumn: 'ALTER' 'TABLE' TableName PartitionClause? 'REPLACE' 'COLUMNS' "(" {(Identifier DataType type) ","}+ CommentLiteral ")" //visit again, the brackets are optional
  | dropColumn: 'ALTER' 'TABLE' TableName 'DROP' ColumnKeyword "("{Identifier","}+ ")"
  | setTableProperties : 'ALTER' 'TABLE' TableName 'SET' 'TBLPROPERTIES' "(" {TblProp ","}+ properties  ")"
  | unsetTableProperties : 'ALTER' 'TABLE' TableName 'UNSET' 'TBLPROPERTIES' "(" {UNQUOTEDCHARSEQUENCE ","}+ keys  ")"
  | setSerdeProp :'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'SERDEPROPERTIES' "(" {TblProp ","}+ properties  ")"
  | setSerdePropWith :'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'SERDE' String SerdePropertiesClause?
  | setFileFormat : 'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'FILEFORMAT' StoredAsType
  | setLocation : 'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'LOCATION' UNQUOTEDCHARSEQUENCE
  | recover: 'ALTER' 'TABLE' TableName 'RECOVER' 'PARTITIONS'
  ;


syntax Statement 
    = alterview: 'ALTER' 'VIEW' AlterView
    | alterdb:'ALTER' AlterSelectors Identifier SetStatement
    ;


syntax AlterView
    = rename: TableName 'RENAME' 'TO' TableName
    | setView: TableName 'SET' 'TBLPROPERTIES' "(" {(String "=" String) ","}+ ")"
    | unsetView: TableName 'UNSET' 'TBLPROPERTIES' IfExists? "(" {String ","}+ ")"
    | selectView : TableName 'AS' QueryOrWith
    ;

syntax AlterSelectors
    = schema : 'SCHEMA'
    | db : 'DATABASE'
    | namespace : 'NAMESPACE'
    ;


syntax SetStatement
    = setProperty: 'SET' PropertyType? "(" {TblProp ","}+ ")"
    | noValue : 'SET' Output?
    ;


syntax PropertyType 
    = dbprop :'DBPROPERTIES'
    | prop: 'PROPERTIES'
    ;

syntax Output = v:"-v";


syntax AlterOrChange 
    = alter:'ALTER'
    | change: 'CHANGE'
    ;


syntax Statement
    = dropDb:'DROP' DatabaseOrSchema IfExists? Identifier RestrictOrCascade?
    | dropFunction:'DROP' TemporaryOrGlobal? 'FUNCTION' IfExists? {Identifier "."}+
    | dropTable : 'DROP' 'TABLE' IfExists? TableName Purge?
    | repair: 'REPAIR' 'TABLE' TableName AddDropSync?;



syntax RestrictOrCascade
    = restrict:'RESTRICT'
    | cascade: 'CASCADE'
    ;


syntax TemporaryOrGlobal
    = temporary:'TEMPORARY'
    | globalTemporary : 'GLOBAL' 'TEMPORARY'
    ;


syntax SetStatement
    = setLocation:  'SET' 'LOCATION' StringConstant
    | setStatementSpark: 'SET'  EXPANDEDIDENTIFIER "=" SetValue
    ;

syntax SetValue
  = unquotedSetValue: UNQUOTEDCHARSEQUENCE
  ;

syntax AddDropSync
    = add:'ADD' 'PARTITIONS'
    | drop:'DROP' 'PARTITIONS'
    | sync : 'SYNC' 'PARTITIONS'
    ;

