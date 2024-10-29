module lang::bigquery::grammar::Expressions


extend lang::bigquery::grammar::Names;


syntax ExpList = expList: Expr!bracket "," {Expr ","}*;


syntax Expr 
    = Struct
    | cast: 'CAST'"(" Expr 'AS' DataType FormatClause")"
    | Array
    | explist: "(" ExpList ")"
    > interval: 'INTERVAL' Int Duration
    > ifNullExp: 'IFNULL' "(" Expr cond_expr "," Expr null_result ")"
    > nullIfExp: 'NULLIF' "(" Expr cond_expr "," Expr expr_to_match ")"
    > ifExp: 'IF' "(" Expr cond_expr "," Expr true_result "," Expr else_result ")"
    > coalesceExp: 'COALESCE' "(" {Expr ","}+ ")"
    ;

syntax FormatClause = formatClause: 'FORMAT' Expr ;

syntax ExpAsVar 
  = expAsVar: Expr!subqueryAsExpression VarAssign?
  | withAggregationTreshhold: 'WITH' 'AGGREGATION_THRESHOLD' AggregationOptions? VarAssign?;


syntax AggregationOptions = aggOptions: 'OPTIONS' "(" ThresholdOpt? PrivacyUnitOpt?")";

syntax ThresholdOpt = thresholdOpt: 'threshold' "=" Expr ","?;

syntax PrivacyUnitOpt = privacyUnitOpt: "privacy_unit_column" "=" Identifier;


syntax ArrayIndex = arrayIndex: Identifier "["Expr"]";


syntax Identifier = ArrayIndex;




syntax Struct
    = structWithType: 
        DataType!primitiveType!arrayType!mapType!unionType("(" {Expr ","}*  ")")
    | structNoType: "STRUCT" "(" {ExpAsVarStrict1 ","}* ")"
    | baseStruct:"(" {ExpAsVarStrict2 ","}+ ")"
    ;


syntax ExpAsVarStrict1 = expAsVarStrict1: Expr VarAssignStrictAs?;

syntax ExpAsVarStrict2 = expAsVarStrict2: Expr VarAssignStrictAs;


syntax VarAssignStrictAs = varAssignStrictAs: VarAssignAs Identifier;




syntax Array
    = arrayWithType: DataType!primitiveType!structTypeType!mapType!unionType CompositeLiteral!structLiteral
    | arrayNoType: 'ARRAY' CompositeLiteral!structLiteral
    | arrayNoKeyword: CompositeLiteral!structLiteral
    ;


syntax DataType = structType: 'STRUCT' "\<" {StructTypeFieldSpec ","}+ "\>";


syntax StructTypeFieldSpec = structTypefieldSpec: Identifier  DataType;



syntax CompositeLiteral 
    = listLiteral: "["{ExprOrComposite ","}*"]"
    ;


syntax ExprOrComposite = exprLit: Expr | compositeLit: CompositeLiteral
;


syntax PrimitiveType 
    = bignumericType: 'BIGNUMERIC'ExprInBrackets?
    | boolType: 'BOOL'
    | bytesType: 'BYTES'ExprInBrackets?
    | dateType: 'DATE'
    | floatType: 'FLOAT64'
    | geographyType: 'GEOGRAPHY'
    | int64Type: 'INT64'
    | intervalType: 'INTERVAL'
    | jsonType: 'JSON'
    | numericType: 'NUMERIC'ExprInBrackets?
    | stringType: 'STRING'ExprInBrackets
    | timeType: 'TIME'
    | nullType: 'NULL'
    ;


syntax ExprInBrackets = expInBrackets: "(" {Expr ","}+ ")";

lexical Formats
    = 'R'
    | 'B'
    | 'RB'
    | 'BR'
    ;

syntax String = string: StringConstant;


lexical StringConstant 
    = @category="Constant" Formats? "\"\"\"" StringCharacter* "\"\"\""
    | @category="Constant" Formats? "\'\'\'" SingleQuoteStringCharacter* "\'\'\'"
    | @category="Constant" Formats [\"] StringCharacter* [\"]
    | @category="Constant" Formats [\'] SingleQuoteStringCharacter* [\']
    ;

