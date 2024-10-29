module lang::hql::grammar::Expressions

extend lang::hql::grammar::Names;

syntax Expr 
    = :notlike 
    > left inPredicate: Expr Not? 'IN' ArrayLiteral
    > :between
    ;


syntax ArrayLiteral
  = Array
  ;

syntax Array
  = array: "(" {Expr ","}+ ")"
  ;

syntax Literal
  =  Map
  ;



syntax Map
  = mapLit: 'MAP' "(" {MapEntry ","}* ")"
  ;


syntax MapEntry 		
  = mapEntry: Expr "," Expr
  ;

syntax StarOrExpr 
  = aggExpr: Expr
  | star: "*"
  ;
  