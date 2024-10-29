module lang::snowflake::grammar::SnowFlake

extend lang::snowflake::grammar::Misc;


start syntax SnowFlakeBatch =  snowFlakeBatch: { Statement!createView!createTable  ";"}+ ";";



syntax Statement = createTaskCommand: 'CREATE' OrReplace? 'TASK' IfNotExists? PropRef
                                 TaskParameters*
                                CommentClause?
                                CopyGrants?
                                AfterColumnList?
                                WhenSearchCondition?
                                'AS' Statement
                        | createAlertCommand: 'CREATE' OrReplace? 'ALERT' IfNotExists? PropRef
                               Property+
                                'IF' "(" 'EXISTS' "(" AlertCondition ")" ")"
                                'THEN' Statement
                        ;

syntax TaskParameters = taskParam: {Property ","}+
                        ;

syntax AfterColumnList = afterColumnList: 'AFTER' ColumnList*;

syntax WhenSearchCondition = whenSearchCondition: 'WHEN' Expr;



syntax AlterAlert = alterAlertAction: 'ALTER' 'ALERT' IfExists? Identifier 'MODIFY' 'ACTION' Statement;

syntax Statement = explainCommand: 'EXPLAIN' UsingExplainOpts? Statement;

syntax UsingExplainOpts = usingExplainOpts: 'USING' ExplainOpts;

syntax ExplainOpts = tabularExplainOpt: 'TABULAR' 
                    | jsonExplainOpt: 'JSON' 
                    | textExplainOpt: 'TEXT'
                    ;

