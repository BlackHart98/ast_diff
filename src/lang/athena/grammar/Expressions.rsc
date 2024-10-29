module lang::athena::grammar::Expressions


extend lang::athena::grammar::Names;



syntax Expr 
    = function: FunctionCall
    > :uMin
    > :notlike 
    > left inPredicate: Expr Not? 'IN' ArrayLiteral
    > :between
    ;

syntax ArrayLiteral
  = Array
  ;


syntax Array
  = array: "(" {Expr ","}+ ")"
  ;

syntax FunctionCall 
    = udf: PackageName? FUNCTIONNAME"(" {Expr ","}* ")"
    ;


syntax CommentLiteral = comment: 'COMMENT' StringConstant;

syntax Literal = QuestionMark;

syntax QuestionMark = questionMark: "?";

// String Literals
lexical StringCharacter
    = "\\" [\" ( ) ; % /] 
    ;