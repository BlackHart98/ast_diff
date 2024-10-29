module lang::hql::prettyprint::HQL

import lang::hql::ast::HQL;
import String;

extend lang::hql::prettyprint::DDL;


public str toString(statements(list[StatementWithTerminator] stmts)) = "<for (stmt <- stmts) {><trim(toString(stmt))>\n
                                                                        '<}>";
public str toString(expression(Expr e)) = toString(e);

public str toString(StatementWithTerminator::statementWithTerminator(Statement stmt, list[Terminator] terms)) = "<toString(stmt)><for(term <- terms) {><toString(term)>
                                                                                                                                     '<}>";

public str toString(Terminator::terminator()) = ";"; 

