module lang::athena::grammar::DDL


extend lang::athena::grammar::Expressions;

syntax QueryExpr =queryAthena: Query;

syntax Statement 
    = createViewWithReplace: 'CREATE' OrReplaceOrTemporary 'VIEW' IfNotExists? TableName
         'AS' QueryOrWith
    | createDb:'CREATE' DatabaseOrSchema IfNotExists? Identifier
        CommentLiteral?
        LocationClause?
        WithDB?
    | msck: 'MSCK' 'REPAIR' 'TABLE' Identifier tblName
    | alterdb:'ALTER' AlterSelectors Identifier SetStatement
    ;

syntax WithDB 
    = withId: 'WITH' 'DBPROPERTIES' "(" {(Identifier "=" Expr) ","}*  ")" 
    | withString: 'WITH' 'DBPROPERTIES' "(" {(StringConstant "=" Expr) ","}*  ")" 
    ;

syntax OrReplaceOrTemporary 
    = orReplace: 'OR' 'REPLACE'
    | temporary: TemporaryTable
    | replaceTemporary: 'OR' 'REPLACE' TemporaryTable
    ;

syntax AlterSelectors
    = schema : 'SCHEMA'
    | db : 'DATABASE'
    | namespace : 'NAMESPACE'
    ;

syntax SetStatement
    = setLocation:  'SET' 'LOCATION' StringConstant
    | setStatementSpark: 'SET'  EXPANDEDIDENTIFIER "=" SetValue
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


syntax SetValue
  = unquotedSetValue: UNQUOTEDCHARSEQUENCE
  ;


syntax AlterTable 
    = addPartitionNoComma: 'ALTER' 'TABLE' TableName 'ADD' IfNotExists?  PartitionClauseWithLocation PartitionClauseWithLocation+
    | setTableProperties : 'ALTER' 'TABLE' TableName 'SET' 'TBLPROPERTIES' "(" {PropValue ","}+ properties  ")"
    | addColumn: 'ALTER' 'TABLE' TableName PartitionClause? 'ADD'  'COLUMNS' "(" { (Identifier DataType? type) ","}+ ")"
    | renameColumn: 'ALTER' 'TABLE' TableName  'RENAME' 'COLUMN' Identifier 'TO' Identifier
    | replaceColumn: 'ALTER' 'TABLE' TableName PartitionClause? 'REPLACE' 'COLUMNS' "(" {(Identifier DataType type) ","}+ CommentLiteral? ")" //visit again, the brackets are optional
    | dropColumn: 'ALTER' 'TABLE' TableName 'DROP' ColumnKeyword "("{Identifier","}+ ")"
    | unsetTableProperties : 'ALTER' 'TABLE' TableName 'UNSET' 'TBLPROPERTIES' "(" {UNQUOTEDCHARSEQUENCE ","}+ keys  ")"
    | setSerdeProp :'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'SERDEPROPERTIES' "(" {PropValue ","}+ properties  ")"
    | setSerdePropWith :'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'SERDE' StringConstant SerdePropertiesClause?
    | setFileFormat : 'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'FILEFORMAT' StoredAsType
    | setLocation : 'ALTER' 'TABLE' TableName PartitionClause? 'SET' 'LOCATION' UNQUOTEDCHARSEQUENCE
    ;

syntax TblProp = String "=" String;

syntax Statement
    = dropDb:'DROP' DatabaseOrSchema IfExists? Identifier RestrictOrCascade?
    ;



syntax RestrictOrCascade
    = restrict:'RESTRICT'
    | cascade: 'CASCADE'
    ;




syntax DatabaseOrSchema 
    = database:'DATABASE'
    | schemaKeyword : 'SCHEMA'
    | databases: 'DATABASES'
    | schemasKeyword: 'SCHEMAS'
    ;




syntax ColumnKeyword 
    = col:'COLUMN'
    | cols:'COLUMNS'
    ;



syntax WithExpr = withExpr: 'WITH' "(" {PropValue ","}+ ")";

syntax WithNoData = withNoData: 'WITH' No? 'DATA';

syntax CreateTable = createTableAsWithExp: 'CREATE' 'TABLE' Identifier 
                        WithExpr 'AS' QueryOrWith WithNoData?;


syntax PropValue = formatPropValue: 'FORMAT' "=" Literal
                 | partPropValue: 'PARTITIONED_BY' "=" 'ARRAY' '[' { Literal ","}+ ']'
                 | propValue: Identifier "=" Literal
                 | stringPropValue: StringConstant "=" Literal
                 ;


syntax No = no: 'NO';