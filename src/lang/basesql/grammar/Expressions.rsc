module lang::basesql::grammar::Expressions

extend lang::basesql::grammar::Names;


syntax Expr 
    = PropRef
    > cast: 'CAST' "(" Expr 'AS' DataType ")"
    > :twoEqual
    > non-assoc eq: Expr lhs "=" Expr rhs
    > :gt
    > :neq2
    > non-assoc like: Expr lhs 'LIKE' Expr rhs
    >  non-assoc notlike: Expr lhs 'NOT' 'LIKE' Expr rhs
    > left between: Expr 'BETWEEN' Expr!and!or 'AND' Expr!and!or
    > right isNull: Expr 'IS' 'NULL'
    > right isNotNull: Expr 'IS' 'NOT' 'NULL' 
    > right not: 'NOT' Expr
    > left and: Expr lhs 'AND' Expr rhs
    > left or: Expr lhs 'OR' Expr rhs
    > simpleCase: 'CASE' Expr WhenClause+ ElseClause? 'END'
    > searchedCase: 'CASE' WhenClause+ ElseClause? 'END' 
    > interval: 'INTERVAL' StringConstant Duration 
    ;

syntax WhenClause = whenClause: 'WHEN' Expr 'THEN' Expr;

syntax ElseClause = elseClause: 'ELSE' Expr;




syntax CommonValueExpr
    = castCVE: 'CAST' "(" CommonValueExpr 'AS' DataType ")"
    ;

syntax DataType
    = primitiveType: PrimitiveType
    | arrayType: 'ARRAY' "\<" DataType "\>"
    | mapType: 'MAP' "\<" PrimitiveType"," DataType "\>"
    | structType: 'STRUCT' "[" {StructTypeFieldSpec ","}+ "]"
    | unionType: 'UNIONTYPE' "\<" {DataType ","}+ "\>"
    ;

syntax PrimitiveType
	= intType : 'INT'
    | smallIntType: 'SMALLINT'
    | bigIntType: 'BIGINT'
    | tinyIntType: 'TINYINT'
    | booleanType: 'BOOLEAN'
    | floatType: 'FLOAT'
    | doubleType: 'DOUBLE'
    | doubleWithPrecisionType: 'DOUBLE PRECISION'
    | stringType: 'STRING'
    | binaryType: 'BINARY'
    | timestampType: 'TIMESTAMP'
    | decimalType: 'DECIMAL' TwoParameterSpec?
    | dateType: 'DATE'
    | varCharType: 'VARCHAR' SingleParameterSpec?
    | charType: 'CHAR' SingleParameterSpec?
    | intervalType: 'INTERVAL'
	;

syntax TwoParameterSpec
    = twoParameterSpec: "(" Int "," Int")"
    ;

syntax SingleParameterSpec 
    = singleParameterSpec: "(" Int ")"
    ;

syntax StructTypeFieldSpec 
    = structTypefieldSpec: Identifier ":" DataType
    ;


syntax ExpAsVarOrStar
  = projectionExpAsVar: ExpAsVar
  | tableNameDotStar: TableName ".*"
  | projectionStar: "*"
  ;

syntax ExpAsVar 
  = expAsVar: Expr VarAssign?
  | namedStructExp: 'NAMED_STRUCT'"(" {NamedStructEntry ","}+")" VarAssign?
  ;

syntax NamedStructEntry 
  = namedStructEntry: QUOTED_IDENTIFIER "," Expr 
  ;



syntax Duration
  = year: 'YEAR'
  | month: 'MONTH'
  | day: 'DAY'
  | hour: 'HOUR'
  | minute: 'MINUTE'
  | second: 'SECOND'
  ;

syntax Not = not: 'NOT';

syntax Distinct = aggregateDistinct: 'DISTINCT';






