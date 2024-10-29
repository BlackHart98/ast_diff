module lang::snowflake::grammar::Expressions
 extend lang::snowflake::grammar::Literals;

extend lang::snowflake::grammar::Names;

syntax Expr = 
             functionCallExp: FunctionCall
            | :uMin
            | plusExp: "+" Expr
          
            > arrayAccess: Expr "[" Expr "]" //array access
            > arrayExp: ArrayLiteral
            > left jsonAccess: Expr ":" Expr //json access
            > jsonLiteral: JsonLiteral
            > expCollateString: Expr 'COLLATE' String
            > castExp: Expr "::" DataType //cast
            > overClauseExp: Expr OverClause
            > tryCastExp: TryCastExp
            >:cct
            > iffExp: IffExp
            > :neq2 
            > :like
            > :notlike
            > non-assoc expNotInList: Expr Not? 'IN' "(" ExpList ")"
            > left expNotIlikeEscape: Expr Not? LikeIlike Expr EscapeExp?
        
            > left expNotRlike: Expr Not? 'RLIKE' Expr 
            > non-assoc ( :between
            |  expNotBetween: Expr 'NOT' 'BETWEEN' Expr )
            > :isNotNull    
            > :and
            > :interval
            ;
syntax TryCastExp = tryCastExpression: 'TRY_CAST' "(" Expr 'AS' DataType ")";

syntax LikeIlike = like: 'LIKE' 
                    | ilike: 'ILIKE'
                    ;
syntax ColumnList = columnList: {PropRef ","}+;

syntax JsonLiteral = jsonKvPair: "{" {KvPair ","}* "}"
                    ;
syntax IffExp = iffExpression: 'IFF' "(" Expr "," Expr "," Expr ")";

syntax KvPair = kvPair: String ":" Expr;

syntax ArrayLiteral = arrayExpList: "[" ExpList? "]";
syntax ExpList = expList: {Expr ","}+;
syntax EscapeExp = escapeExp: 'ESCAPE' Expr;

syntax OverClause = overPartitionBy: 'OVER' "(" PartitionByClause? OrderByClause? ")"
                    ;

syntax FunctionCall = rankingWindowedFunc: RankingWindowedFunction
                    | aggregateFunc: AggregateFunction
                    | listOpFunc: ListOperator "(" ExpList ")"
                    | binaryOrTernaryBuiltInFunc: BinaryOrTernaryBuiltInFunction "(" ExpList ")"
                    ;
syntax NullNotNull = nullNotNull: Not? 'NULL'
                
                    ;
syntax RankDenseRowNumber = rank: 'RANK' 
                            | denseRank: 'DENSE_RANK'
                            | rowNumber: 'ROW_NUMBER'
                            ;

syntax LeadOrLag = lead: 'LEAD'
                | lag: 'LAG'
                ;
syntax RankingWindowedFunction = rankDenseRowNumberFunc: RankDenseRowNumber "("")" OverClause
                                | ntileFunc: 'NTILE' "(" Expr ")" OverClause
                                | leadOrLagFunc: LeadOrLag "(" ExpList? ")" IgnoreOrRepectNulls? OverClause
                                | firstValueOrLastValueFunc: FirstValueOrLastValue "(" Expr ")" IgnoreOrRepectNulls? OverClause
                                ;
syntax ListOperator = concat: 'CONCAT'
                        | concatWS: 'CONCAT_WS'
                        | coalesce: 'COALESCE'
                        ;

syntax AggregateFunction = idDistinct: PropRef "(" 'DISTINCT' ExpList? ")"
                            | idStar: PropRef "(" "*" ")"
                            | idNoDistinct: PropRef "(" {Expr ","}* ")"
                            | listOrArrayAggNoDistinct: ListAggOrArrayAgg "(" {Expr ","}+ ")" WithinGroupOrder?
                            | listOrArrayAgg: ListAggOrArrayAgg "(" 'DISTINCT' {Expr ","}+ ")" WithinGroupOrder?
                            ;

syntax WithinGroupOrder = withinGroupOrder: 'WITHIN' 'GROUP' "(" OrderByClause ")";

syntax IgnoreOrRepectNulls = ignoreOrRepectNulls: IgnoreOrRespect 'NULLS';

syntax IgnoreOrRespect = ignore: 'IGNORE' 
                        | respect: 'RESPECT'
                        ;

syntax FirstValueOrLastValue = firstValue: 'FIRST_VALUE' 
                                | lastValue: 'LAST_VALUE'
                                ;
syntax ListAggOrArrayAgg = listAgg: 'LISTAGG'
                            | arrayAgg: 'ARRAY_AGG'
                            ;

syntax BinaryOrTernaryBuiltInFunction = ifNullBuiltInFunction: 'IFNULL' 
                                | nvlBuiltInFunction: 'NVL'
                                | getBuiltInFunction: 'GET'
                                | leftBuiltInFunction: 'LEFT'
                                | rightBuiltInFunction: 'RIGHT'
                                | datePartBuiltInFunction: 'DATE_PART'
                                | splitBuiltInFunction: 'SPLIT'
                                | nullIfBuiltInFunction: 'NULLIF'
                                | equalNullBuiltInFunction: 'EQUAL_NULL'
                                | containsBuiltInFunction: 'CONTAINS'
                                | collateBuiltInFunction: 'COLLATE'
                                | toDateBuiltInFunction: 'TO_DATE'
                                | dateBuiltInFunction: 'DATE'
                                | charIndexBuiltInFunction: 'CHARINDEX'
                                | replaceBuiltInFunction: 'REPLACE'
                                | substringBuiltInFunction: 'SUBSTRING' 
                                | substrBuiltInFunction: 'SUBSTR'
                                | likeBuiltInFunction: 'LIKE' 
                                | ilikeBuiltInFunction: 'ILIKE'
                                ;

syntax DataType =  numberAlias: NumberAlias
            
                | varCharAlias: VarCharAlias DataTypeSize?
                | dateTimeDataType: 'DATETIME' DataTypeSize?
                | timeDataType: 'TIME' DataTypeSize?
                | timeStampDataType: 'TIMESTAMP' DataTypeSize
                | timeStamp_LTZ: 'TIMESTAMP_LTZ' DataTypeSize?
                | timeStampLTZ: 'TIMESTAMPLTZ' DataTypeSize?
                | timeStamp_NTZ: 'TIMESTAMP_NTZ' DataTypeSize?
                | timeStampNTZ: 'TIMESTAMPNTZ' DataTypeSize?
                | timeStamp_TZ: 'TIMESTAMP_TZ' DataTypeSize?
                | timeStampTZ: 'TIMESTAMPTZ' DataTypeSize?
                | charAlias: CharAlias DataTypeSize?
                | binaryAlias: BinaryAlias DataTypeSize?
                | variantDataType: 'VARIANT'
                | objectDataType: 'OBJECT'
                | arrayDataType: 'ARRAY'
                | geographyDataType: 'GEOGRAPHY'
                | geometryDataType: 'GEOMETRY'
                ;
syntax PrimitiveType = integerType: 'INTEGER'
                | byteIntType: 'BYTEINT'
                | float4Type: 'FLOAT4' 
                | float8Type: 'FLOAT8'     
                | realType: 'REAL'
                ;
syntax ExpListWithBrackets = expListWithBrackets: "(" ExpList ")";

syntax NumberAlias = numberType: 'NUMBER' ExpListWithBrackets?
                    | numericType: 'NUMERIC' ExpListWithBrackets?
                    | decimalType: 'DECIMAL' ExpListWithBrackets?
                    ;
   

syntax VarCharAlias = charVarying: 'CHAR' 'VARYING' 
                    | ncharVarying: 'NCHAR' 'VARYING'
                    | nvarchar2: 'NVARCHAR2'
                    | nvarchar: 'NVARCHAR' 
                    | textVarChar: 'TEXT'
               ;

syntax DataTypeSize = dataTypeSize: "(" Int ")";

syntax CharAlias =  ncharType: 'NCHAR'
                    | characterType: 'CHARACTER'
                    ;

syntax BinaryAlias = binaryType: 'BINARY'
                    | varBinaryType: 'VARBINARY'
                    ;

syntax VarList = varList: {(":" Identifier) ","}+;
