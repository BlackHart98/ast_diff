module lang::spark::grammar::Expressions

extend lang::spark::grammar::Names;

syntax Expr 
    = setIndex: Expr "{" Expr index "}"
    | mapIndex: Expr".get" "(" Expr key ")"
    | arrayLit: ArrayLiteral
    > :uMin
    > exist: 'EXISTS' Expr!scalarSubquery
    > :cct
    > :neq2 
    > :like
    > :notlike
    > non-assoc likeEsc: Expr lhs 'LIKE' Expr rhs EscapeEx
    > non-assoc  rlike: Expr  RLikeOrRegex Expr  EscapeEx
    > non-assoc  rlikeNoEsc: Expr  RLikeOrRegex Expr
    > non-assoc  ilike: Expr 'ILIKE' Expr EscapeEx?
    > non-assoc  likeAll: Expr lhs 'LIKE' 'ALL' "(" {Expr ","}+ ")"
    > non-assoc notlikeAll: Expr lhs 'NOT' 'LIKE' 'ALL' "(" {Expr ","}+ ")"
    > non-assoc  likeSome: Expr 'LIKE' 'SOME' "(" {Expr ","}+ ")"
    > non-assoc  notlikeSome: Expr 'NOT' 'LIKE' 'SOME' "(" {Expr ","}+ ")"
    > non-assoc lambda: Identifier arg "=\>" Expr expr
    > optValue: OptionValue
    // > non-assoc inPredicate: Expr Not? 'IN' 
    > non-assoc inPredicate: Expr Not? 'in' "("{Expr ","}+")" 
    > :between
    > :isNotNull
    > not: "!" Expr
    > :and
    > :interval
    > non-assoc @Foldable match: "(" Expr e ")" 'MATCH' "{" Case+ cases Default? d "}"  
    ;


syntax RLikeOrRegex 
    = rLike:'RLIKE'
    | regexp:'REGEXP'
    ;

// DataType
syntax PrimitiveType 
    = boolType: 'BOOL'	
    | timestampNTZType : 'TIMESTAMP_NTZ'
    | realType:'REAL'
    | byteType: 'BYTE'
    | shortType: 'SHORT'
    | longType: 'LONG'
    | decType : 'DEC'
    | numericType: 'NUMERIC'
    ;

syntax Timestamp = timestamp:'TIMESTAMP'| ltz: 'TIMESTAMP_LTZ';


syntax EscapeEx = escape:'ESCAPE' Expr;


syntax CommentLiteral = comment: 'COMMENT' StringConstant;

syntax ArrayLiteral = arraySpark: 'ARRAY'"(" {Expr ","}+ ")";


syntax OptionValue 
    = none:'NONE'
    | disk1:'DISK_ONLY'
    | disk2:'DISK_ONLY_2'
    | disk3:'DISK_ONLY_3'
    | memory1:'MEMORY_ONLY'
    | memory2:'MEMORY_ONLY_2'
    | memoryOnlyser: 'MEMORY_ONLY_SER'
    | memoryOnlyser2: 'MEMORY_ONLY_SER_2'
    | memAndDisk: 'MEMORY_AND_DISK'
    | memoryAndDisk2:'MEMORY_AND_DISK_2'
    | memoryAndDiskSer: 'MEMORY_AND_DISK_SER'
    | memoryAndDiskSer2: 'MEMORY_AND_DISK_SER_2'
    | offHeap:'OFF_HEAP'
    ;

syntax Default
    = @Foldable \default: 'DEFAULT' "=\>" Expr e ";"
    ;

syntax Case
    = @Foldable \case: 'CASE' Expr e1 "=\>" Expr e2 ";"
    ;

syntax NullFirstOrLast = nullsFirst: 'NULLS' 'FIRST' | nullsLast: 'NULLS' 'LAST';

syntax OrderElem 
    = orderExprNulls: Expr NullFirstOrLast 
    | ascNulls: Expr 'ASC' NullFirstOrLast 
    | descNulls: Expr 'DESC' NullFirstOrLast
    ;

syntax StarOrExpr 
  = aggExpr: Expr
  | star: "*"
  ;
  