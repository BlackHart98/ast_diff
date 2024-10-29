module lang::basesql::grammar::Names

extend lang::basesql::grammar::Literals;
extend lang::exprlang::grammar::Expressions;




syntax PropRef
  = propRef: {Identifier "."}+
  ;

syntax VarAssign
  = varAssign: VarAssignAs? Identifier
  ;

syntax VarAssignAs
  = as: 'AS'
  ;


syntax Identifier
  = varReference: "${"REGULARIDENTIFIER"}"
  | regularIdentifier: REGULARIDENTIFIER
  | quotedIdentifier: BACKQUOTED_IDENTIFIER
  ;




syntax TableName
  = LocalOrSchemaQualifiedName
  ;


syntax LocalOrSchemaQualifiedName
  = name: SchemaNameDot? TableNameId
  ;

syntax SchemaNameDot
  = schemaName: TableNameId "."
  ;

syntax TableNameId = tabId: Identifier;



syntax Url
  = url: SchemePart? DirectoryPart? FileNamePart
  | urlVarReference: "${"REGULARIDENTIFIER "}"
  ;


syntax SchemePart
  = schemePart: Scheme"://"
  | noScheme: "/"
  ;

syntax Scheme
  = hdfs: 'hdfs'
  ;


syntax DirectoryPart
  = directoryPart: {Identifier "/"}+ "/"
  ;



syntax FileNamePart
  = fileNamePart: Identifier"."Identifier
  ;




lexical REGULARIDENTIFIER =  id: ([a-z A-Z] !<< [a-z A-Z] [a-z A-Z 0-9 @ _ \-]* !>> [a-z A-Z 0-9 _]) \ Keywords;
lexical EXPANDEDIDENTIFIER = [a-z A-Z 0-9 _ . \-]*;
lexical UNQUOTEDCHARSEQUENCE = (![;])*;
lexical BACKQUOTED_IDENTIFIER = [`]![`]*[`]; 
lexical QUOTED_IDENTIFIER = [\'][a-z A-Z][a-z A-Z 0-9 _]* [\'];


lexical SPACES = " "+;



keyword Keywords
	= 'INT'
  | 'SMALLINT'
  | 'BIGINT'
  | 'TINYINT'
	| 'STRING'
	| 'BOOLEAN'
  | 'DOUBLE'
	| 'BINARY'
  | 'DECIMAL'
  | 'WHEN'
  | 'CASE'
  | 'END'
  | 'DECIMAL'
  | 'VARCHAR'
  | 'CHAR'
  | 'DISTINCT'
  | 'MAP'
  | 'LEFT'
  | 'RIGHT'
  | 'FULL'
  | 'SEMI'
  | 'INNER'
  | 'CROSS'
  | 'JOIN'
  | 'WHERE'
  | 'USE'
  | 'NULL'
  | 'LATERAL'
  | 'VIEW'
  | 'CREATE'
  | 'TRUE'
  | 'FALSE'
  | 'ROW'
  | 'ANALYZE'
  | 'ADD'
  | 'FILE'
  | 'ALTER'
  | 'DROP'
  | 'REPAIR'
  | 'DEFINED'
  | 'PARTITION'
  | 'THEN'
  | 'AS'
	;


