module lang::snowflake::grammar::Misc

extend lang::snowflake::grammar::DDL;


syntax Statement = copyIntoTableCommand: CopyIntoTable
                    | beginTransactionCommand: BeginTransaction  WorkOrTransaction? NameId?
                    | copyIntoLocationCommand: CopyIntoLocation
                    | commitCommand: Commit
                    | commentCommand: Comment
                    | executeImmediateCommand: 'EXECUTE' 'IMMEDIATE' Expr UsingColumnList?
                    | executeTaskCommand: 'EXECUTE' 'TASK' PropRef
                    | getDMLCommand: 'GET' InternalOrExternalStage FilePath Property? Pattern?
                    | listCommand: 'LIST' InternalOrExternalStage Pattern?
                    | removeCommand: 'REMOVE' InternalOrExternalStage Pattern?
                    | setCommand: SetUnset
                    | truncateMaterializedViewCommand: 'TRUNCATE' 'MATERIALIZED' 'VIEW' PropRef
                    | revokeRoleCommand: 'REVOKE' 'ROLE' RoleName 'FROM' RoleOrUser
                    | callCommand: Call
                    | putCommand: 'PUT' FilePath InternalOrExternalStage
                               Property*
                    | rollbackCommand: Rollback
                    ;

syntax FilePath = filePath1: "file://" "/" Uri 
                | filePath2: "file://" WindowsPath
                ;

syntax RoleName =  idRoleName: Identifier
                ;

syntax RoleOrUser = roleOrUserOpt1: ObjectTypeName RoleName 
                    ;




syntax BeginTransaction = beginTransaction: 'BEGIN' 
                        | startTransaction: 'START' 
                        ;

syntax WorkOrTransaction = workOrTransactionOpt1: 'WORK'
                            | workOrTransactionOpt2: 'TRANSACTION'
                            ;

syntax NameId = nameId: 'NAME' Identifier;

syntax CopyIntoLocation = copyIntoLocation: 'COPY' 'INTO' InternalOrExternalStage
                                'FROM' ObjectNameOrQuery
                                PartitionByClause?
                                FileFormat?
                                CopyOptions?
                                ValidationMode?
                                'HEADER'?
                        ;


syntax ObjectNameOrQuery = objectNameOrQueryOpt1: PropRef
                            | objectNameOrQueryOpt2: "(" QueryExpr ")"
                            ;

syntax Comment = commentFuncSignature: 'COMMENT' IfExists? 'ON' ObjectTypeName PropRef ArgTypes? 'IS' String
                | commentColumn: 'COMMENT' IfExists? 'ON' 'COLUMN' PropRef 'IS' String
                ;