module lang::ptl::grammar::Expressions

extend lang::exprlang::grammar::Expressions;

extend lang::ptl::grammar::Literals;

      
syntax Expr 
    = FunctionCall
    | identifier: {Id "."}+ qName
    > CastFunc
    > :uMin
    > :neq2
    > right exist: "exists" Expr 
    > \set: "set{" {Expr ","}* el "}" 
	  > \list: "[" {Expr ","}* el "]"
    > \tuple: "\<" {Expr ","}+ el "\>" 
	  > \map:  "{" {Mapping ","}+ entries "}" 
    > left listIndex: Expr "[" Expr index "]"
    > left setIndex: Expr "{" Expr index "}"
    > left mapIndex: Expr".get" "(" Expr key ")"
    > right not: "!" Expr
    > right logicalNot: 'not' Expr
    > left and: Expr lhs "and" Expr rhs
    > right or: Expr lhs "or" Expr rhs
    > non-assoc block: "{" {Expr ";"}+ exprs "}" ";"
    > non-assoc like: Expr lhs "like" Expr rhs
    > non-assoc notlike: Expr lhs "not like" Expr rhs
    > right lambda: Id arg "=\>" Expr exp
    > non-assoc between: Expr e1 "between" Expr e2
    > left \in: Expr lhs "in" Expr rhs
    > left notIn: Expr lhs "not in" Expr rhs
    > right isNull: Expr "is" "null"
    > right isNullNot: Expr "is" "not" "null"
    > @Foldable match: "(" Expr e ")" "match" "{" Case+ cases Default? d "}"
    > block: "{" {Expr ";"}+ exprs "}" 
    > \if: "if" Expr cond "then" Expr thenPart "else" Expr elsePart 
    ;

syntax FunctionCall 
  = functioncallSimple: Id name "(" {Expr!eq ","}*  args ")" AnalyticFunctionClause?
  | functioncallWithKeyWord: Id name "(" {Expr!eq ","}+  args "," {KWParam ","}+ ")" AnalyticFunctionClause?
  | functioncallKWOnly: Id name "(" {KWParam ","}+  ")" AnalyticFunctionClause?
   | countStar:"count""(" "*" ")";
  
syntax KWParam = keywordParam: Id name "=" Expr
               | distinct: "distinct" "=" Expr
                ;

syntax CastFunc 
    = typeConvert: "(" Expr!bracket ")" "::" Type
    | castId: {Id "."}+ "::" Type
    | castLiteral: Literal lit "::" Type
    | functionCast: FunctionCall "::" Type
    ;


syntax Separator 
    = separator: "," Expr
    ;

syntax DistinctOrAll
    = distinct: "distinct"
    |\all:"all"
    ;


syntax Distinct = distinct: "distinct";

syntax Block = block: "{" {Expr ";"}+ exprs "}";

syntax Case
    = @Foldable \case: "case" Expr e1 "=\>" Expr e2 ";"
    ;


syntax Default
    = @Foldable \default: "default" "=\>" Expr e ";"
    ;

syntax Type 
    = Primitive 
    | Reference 
    | Collection
    |  \any: "Any"
    // | NumericType
    | generic: '&'Captial ('\<:'Type)?
    ;


syntax NumericType =
    IntType
    | FloatType
    ;

syntax IntType = \int: "Int" 
    | smallInt: "SmallInt"
    | bigInt: "BigInt"
    ;


syntax FloatType = float: "Float";

syntax Collection
    = \setType: "Set" "[" Type t "]"
    | \mapType: "Map" "[" Type k "," Type v "]"
    | \listType: "List""[" Type t "]"
    | \tupleType: "Tuple" "[" {Type ","}+ ty "]"
    | structType: "Struct" "["{(Id Type) ","}+"]"
    ;


syntax Primitive
    = booleanType: "Bool"
    | byteType:"Byte"
    | stringType: "Str"  
    | dateTimeType: "Datetime" 
    | timeType:"Timestamp"
    | charType:"Char"
    | varCharType:"Varchar"
    | intervalType:"Interval"
    | dateType: "Date"
    | \int: "Int" 
    | smallInt: "SmallInt"
    | bigInt: "BigInt"
    | float: "Float"
    ;

syntax Reference
    = objectType: "Object"
    | referenceType: Id entityName
    | nullType: "Null"
    ;

syntax Mapping
     = mapping: Expr k "-\>" Expr v
  ;

syntax AnalyticFunctionClause = analyticFunctionClause: "over" WindowSpecification;


syntax WindowSpecification 
    = windowSpecification: "("PartitionByClause? OrderByClauseOpt? WindowFrameClause?")"
    | namedWindow: Id
    ;


syntax OrderByClauseOpt = orderByClause: "order" "by" {OrderElement ","}+ el;


syntax OrderByClause = orderByClause: "order" "by" {OrderElem ","}+;

syntax OrderElem
    = orderExpr: Expr
    | asc: Expr "asc"
    | desc: Expr "desc"
    ;


syntax OrderElement = orderElement: AscOrDescOpt e;


syntax AscOrDescOpt = having:  "having" Expr e;

syntax AscOrDescOpt
    = ascending:Expr "ascending" 
    | asc:Expr "asc" 
    | descending:Expr "descending" 
    | desc:Expr "desc"
    ;


syntax PartitionByClause = partitionByClause: "partition" "by" {Expr ","}+;  

syntax WindowFrameClause = windowFrameClause: RowsOrRange FrameStartOrBetween;

syntax RowsOrRange 
  = rows: "rows"
  | range: "range"
  ;
syntax FrameStartOrBetween
  = frameStart: FrameStart
  | frameBetween: FrameBetween
  ; 

syntax FrameBetween
  = frameBetweenUnboundedPreceding: "between" UnboundedPreceding "and" FrameEndA
  | frameBetweenNumericPreceding: "between" NumericPreceding "and" FrameEndA
  | frameBetweenCurrentRow: "between" CurrentRow "and" FrameEndB
  | frameBetweenNumericFollowing: "between" NumericFollowing "and" FrameEndC
  ;

syntax FrameStart
  = frameStartUnboundedPreceding: UnboundedPreceding
  | frameStartNumericPreceding: NumericPreceding
  | frameStartCurrentRow: CurrentRow
  ;


syntax FrameEndA
  = frameEndANumericPreceding: NumericPreceding
  | frameEndACurrentRow: CurrentRow
  | frameEndANumericFollowing: NumericFollowing
  | frameEndAUnboundedFollowing: UnboundedFollowing
  ;

syntax FrameEndB
  = frameEndBCurrentRow: CurrentRow
  | frameEndBNumericFollowing: NumericFollowing
  | frameEndBUnboundedFollowing: UnboundedFollowing
  ; 


syntax FrameEndC
  = frameEndCNumericFollowing: NumericFollowing
  | frameEndCUnboundedFollowing: UnboundedFollowing
  ; 


syntax UnboundedPreceding = unboundedPreceding: "unbounded" "preceding"; 

syntax NumericPreceding = numericPreceding: IntegerLiteral "preceding";

syntax UnboundedFollowing = unboundedFollowing: "unbounded" "following";

syntax NumericFollowing = numericFollowing: IntegerLiteral "following";

syntax CurrentRow = currentRow: "current" "row";