module lang::hql::prettyprint::DDL

import lang::hql::ast::HQL;
import List;
import String;

extend lang::hql::prettyprint::Query;


public str toString(Statement::setStatement(SetStatement setStatement)) = "<toString(setStatement)>";


// HiveVar
public str toString(HiveVar::hivevar()) = "HIVEVAR:";

public str toString(SetStatement::setStatementHive(list[HiveVar] hivevar, str expandedId, SetValue setVal)) = "SET <prettyOptional(hivevar, toString)><expandedId> = <toString(setVal)>";


// SetValue
public str toString(SetValue::unquotedSetValue(str unquotedCharSeq)) = unquotedCharSeq;