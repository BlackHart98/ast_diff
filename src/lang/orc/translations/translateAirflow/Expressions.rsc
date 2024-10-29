module lang::orc::translations::translateAirflow::Expressions
extend lang::orc::ast::Orc;
extend lang::python::ast::Python;
import String;
// expression
public Expression toAirflow(Expr e){
  switch(e){
      case integer(str \int):return constant(number(toInt(\int)), nothing());

    case identifier(str regularId):return name(regularId,load());
    case mul(Expr expr1, Expr expr2):return mult(toAirflow(expr1),toAirflow(expr2)) ;
    case div(Expr expr1, Expr expr2):return div(toAirflow(expr1),toAirflow(expr2)) ;

    case sub(Expr expr1, Expr expr2):return sub(toAirflow(expr1),toAirflow(expr2)) ;
    case add(Expr expr1, Expr expr2):return add(toAirflow(expr1),toAirflow(expr2)) ;
   
    case twoEqual(Expr expr1, Expr expr2):return compare(toAirflow(expr1), [eq()],[toAirflow(expr2)]);
    case gt(Expr expr1, Expr expr2):return compare(toAirflow(expr1), [is()],[toAirflow(expr2)]);
    case lt(Expr expr1, Expr expr2):return compare(toAirflow(expr1), [is()],[toAirflow(expr2)]);
    case gte(Expr expr1, Expr expr2):return compare(toAirflow(expr1), [is()],[toAirflow(expr2)]);
    case lte(Expr expr1, Expr expr2):return compare(toAirflow(expr1), [is()],[toAirflow(expr2)]);
    case neq1(Expr expr1, Expr expr2):return compare(toAirflow(expr1), [noteq()],[toAirflow(expr2)]);
    case neq2(Expr expr1, Expr expr2):return compare(toAirflow(expr1), [noteq()],[toAirflow(expr2)]);
   
    case not(Expr expr):return \not( toAirflow(expr)); 
    case and(Expr expr1, Expr expr2):return  and([toAirflow(expr1),toAirflow(expr2)]);
    case or(Expr expr1, Expr expr2):return or([toAirflow(expr1),toAirflow(expr2)]);

    default: throw "<e> not handled";
  }    
    
}
public Statement toAirflow( eq(Expr expr1, Expr expr2))= assign([toAirflow(expr1)] ,toAirflow(expr2),nothing());
