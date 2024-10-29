module lang::hql::grammar::DDL

extend lang::hql::grammar::Query;



syntax Statement = setStatement: SetStatement;


syntax SetStatement = setStatementHive: 'SET' HiveVar?  EXPANDEDIDENTIFIER "=" SetValue;


syntax HiveVar = hivevar: 'HIVEVAR:';


syntax SetValue
  = unquotedSetValue: UNQUOTEDCHARSEQUENCE
  ;