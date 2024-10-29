module lang::snowflake::grammar::DML

extend lang::snowflake::grammar::Query;


syntax Statement = insertDML: InsertStatement
            | insertMultiTableDML: InsertMultiTableStatement
            | updateDML: UpdateStatement
            | deleteDML: DeleteStatement 
            | mergeDML: MergeStatement
            ;

syntax InsertStatement = withQueryandBuilder:InsertWithQuery ValuesBuilder
                 |withoutQuery: 'INSERT' OverWriteOrInto Table? TableName PartitionWithOptionValueClause? IfNotExists? 
  		ColumnSpecificationForInsert? ValuesBuilder?
                        ;
           



syntax InsertMultiTableStatement = insertMultiTableOverwriteAllInto: 'INSERT' OverWriteOrInto? FirstAll IntoValuesList
                                    | insertMultiTableOverwriteFirstWhen: 'INSERT' OverWriteOrInto? FirstAll
                                        WhenPredicateThenValues+
                                        ElseIntoValueslist?
                                        QueryExpr
                                 
                                    ;

syntax FirstAll = first :'first' |\all:'all';

syntax IntoValuesList = intoValuesList: 'INTO' TableName Columns? ValuesBuilder?;


syntax WhenPredicateThenValues = whenPredicateThenValues: 'WHEN' Expr 'THEN' IntoValuesList+;

syntax ElseIntoValueslist = elseIntoValuesList: 'ELSE' IntoValuesList;

syntax UpdateStatement = updateStatement: 'UPDATE'  TableName AsAlias?
                                'SET' SetObjNameList
                                FromClause?
                                WhereClause?
                        ;

syntax SetObjNameList = setObjNameList: {Expr ","}+;


syntax DeleteStatement = deleteStatement: 'DELETE' 'FROM' TableName AsAlias?
                                UsingTableQueryList?
                                WhereClause?
                        ;

syntax MergeStatement = mergeStatement: 'MERGE' 'INTO' TableName AsAlias?
                                'USING' TableIdOrSubquery 'ON' Expr MergeMatches
                        ;

syntax UsingTableQueryList = usingTableQueryList: {('USING' TableIdOrSubquery) ","}+;

syntax MergeMatches = mergeMatches: WhenMatchedThen+ ;

syntax WhenMatchedThen = whenMatchedThen: 'WHEN' Not? 'MATCHED' AndSearchCondition? 'THEN' MergeUpdateOrDelete;


syntax MergeUpdateOrDelete = mergeUpdate: 'UPDATE' 'SET' SetObjNameList
                            | mergeDelete: 'DELETE'
                            | mergeInsert: 'INSERT' ExpListWithBrackets? ValuesBuilder
                            ;

syntax AndSearchCondition = andSearchCondition: 'AND' Expr;
