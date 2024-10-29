module lang::hql::translations::translate2ptl::TranslateProgram
import lang::hql::prettyprint::HQL;
extend lang::hql::translations::translate2ptl::TranslateDeclarations;
import List;
import Type;

list[ViewVariablesOrEmpty] viewVariable=[];
public Program toPTL(HQLStart hqlVar, str moduleName="") {
  // filter through the statements and store the drops to a 
  // map  
  switch(hqlVar) {
    case expression(Expr exp): return lang::ptl::ast::PTL::expression(toPTL(exp));
    case statements(list[StatementWithTerminator] stmts): {
      list[Statement] temp = [ stmt | statementWithTerminator(stmt, _) <- stmts, Statement::dropTable(_, _, _) := stmt ];
      map[str, Drop] dIfExist = (toString(y) : dropIfExist() | Statement::dropTable(list[IfExists] ifExists, y, _) <- temp, size(ifExists) == 1);
      map[str, Drop] dIfNExist = (toString(y) : drop() | Statement::dropTable(list[IfExists] ifExists, y, _) <- temp, size(ifExists) == 0);
      list[ViewVariablesOrEmpty] vars=[ getVars(stmt) | statementWithTerminator(stmt, _) <- stmts, Statement::setStatement(setStatementHive(list[HiveVar] _, str _, SetValue _)) := stmt ];
      viewVariable += vars;
      dict += dIfExist + dIfNExist;
      return \module("<moduleName == "" ? "HQL" : moduleName>", [], [ toPTL(stmt) | statementWithTerminator(stmt, _) <- stmts, Statement::dropTable(_, _, _) !:= stmt && Statement::setStatement(setStatementHive(list[HiveVar] _, str _, SetValue _)) !:= stmt ]);
    }
    default: throw  TranslationException("Tranlation Error: Unresolved Start Statement",hqlVar);
  }
}

