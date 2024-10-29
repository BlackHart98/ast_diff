module lang::orc::prettyprint::Expressions
import List;
import lang::orc::ast::Expressions;
extend lang::exprlang::prettyprint::Expressions;

public str toString(Expr e){
  switch(e){
    
    case not(Expr expr): return "not <toString(expr)>";
    case and(Expr expr1, Expr expr2): return "<toString(expr1)> and <toString(expr2)>";
    case or(Expr expr1, Expr expr2): return "<toString(expr1)> or <toString(expr2)>";

    
    default: return "";
  }
}

public str toString(idExp(list[str] ids))=intercalate(".",[id|id<-ids]);


