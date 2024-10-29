module lang::snowflake::grammar::DDL

extend lang::snowflake::grammar::DML;

syntax Statement = AlterCommand
            |  CreateCommand
            | DropCommand
            |  UndropCommand
            |  ShowCommand
            |  UseCommand
            |  DescribeCommand
            ;
syntax UndropCommand = undropObjectCommand: 'UNDROP' ObjectTypeName PropRef
                        ;
syntax AlterCommand = alterAccountCommand: 'ALTER' 'ACCOUNT' AlterAccountOpts
                    | alterSessionCommand: AlterSession
                    | alterDatabaseCommand: AlterDatabase
                    | alterConnectionCommand: 'ALTER' 'CONNECTION' AlterConnectionOptions
                    | alterAlertCommand: AlterAlert
                    | alterUserCommand: 'ALTER' 'USER' IfExists? Identifier AlterUserOptions
                    | alterTagCommand: 'ALTER' 'TAG' IfExists? Identifier AlterTagOptions
                    | alterSchemaCommand: AlterSchema
                    | alterRoleCommand: AlterRole
                    | alterRowAccessPolicyCommand: AlterRowAccessPolicy
                    | alterProcedureCommand: AlterProcedure
                    | alterNetworkPolicyCommand: 'ALTER' 'NETWORK' 'POLICY' AlterNetworkPolicyOpts
                    | alterApiIntegrationCommand: AlterApiIntegration        
                    | alterDynamicTableCommand: 'ALTER' 'DYNAMIC' 'TABLE' Identifier AlterDynamicOpts
                    | alterFailoverGroupCommand:'ALTER' 'FAILOVER' 'GROUP' IfExists? Identifier AlterFailoverGroup
                    | alterFileFormatCommand: AlterFileFormat
                    | alterWareHouseCommand: 'ALTER' 'WAREHOUSE' IfExists? AlterWareHouseOptions                
                    | alterFunctionCommand:'ALTER' 'FUNCTION' IfExists? Identifier "(" DataTypeList? ")" AlterFunction
                    | alterViewCommand: AlterView
                    | alterMaskingPolicyCommand: AlterMaskingPolicy
                    | alterMaterializedViewCommand: 'ALTER' 'MATERIALIZED' 'VIEW' Identifier AlterMaterializedViewOpts
                    | alterPipeCommand: AlterPipe
                    | alterNotificationIntegrationCommand: AlterNotificationIntegration
                    | alterExternalTableCommand: AlterExternalTable
                    | alterResourceMonitorCommand: 'ALTER' 'RESOURCE' 'MONITOR' IfExists? Identifier SetUnset? NotifyTriggers?
                    | alterSequenceCommand: AlterSequence
                    ;
syntax AlterAccountOpts = setAccountOpts: 'SET' Property* 
                        | unsetAccountOpts: 'UNSET' {Identifier ","}+
                        | resourceMonitorAccountOpts: 'SET' 'RESOURCE_MONITOR' "=" Identifier
                        | setTagsAccountOpts: SetUnsetTags
                        | dropUrlAccountOpts: Identifier 'DROP' 'OLD' 'URL'
                        | saveUrlAccountOpts: Identifier 'RENAME' 'TO' Identifier SaveOldUrl?
                        ;

syntax SetUnset = \set:'set' Property? |unset: 'unset' Expr!bracket? ExpListWithBrackets?;




syntax SetUnsetTags = unsetTags: SetUnset 'TAG' {Expr ","}+;



syntax SaveOldUrl = saveOldUrl: 'SAVE_OLD_URL' "=" Boolean;


syntax AlterTable = 
                    alterTableSetTags: 'ALTER' 'TABLE' IfExists? TableName SetUnsetTags
                    | alterTableSwapWith: 'ALTER' 'TABLE' IfExists? TableName 'SWAP' 'WITH' TableName
                    | alterTableDropRow: 'ALTER' 'TABLE' IfExists? TableName 'DROP' 'ROW' 'ACCESS' 'POLICY' Identifier
                    ;
syntax AlterSession = alterSessionSet: 'ALTER' 'SESSION' 'SET' Property
                    | alterSessionUnset: 'ALTER' 'SESSION' 'UNSET' {Identifier ","}+
                    ;

syntax AlterDatabase = alterDatabaseRename: 'ALTER' 'DATABASE' IfExists? Identifier 'RENAME' 'TO' Identifier
                        | alterDatabaseSwap: 'ALTER' 'DATABASE' IfExists? Identifier 'SWAP' 'WITH' Identifier
                        | alterDatabaseSetTags: 'ALTER' 'DATABASE' Identifier SetUnsetTags
                        | alterDatabaseRefresh: 'ALTER' 'DATABASE' Identifier 'REFRESH'
                        | alterDatabaseProperty: 'ALTER' 'DATABASE' IfExists? Identifier 'UNSET' { DatabaseOrSchemaProperty "," }+
                        ;
syntax DatabaseOrSchemaProperty = dataRetentionTimeProp: 'DATA_RETENTION_TIME_IN_DAYS' "=" Int 
                                | maxDataExtentionTimeProp: 'MAX_DATA_EXTENSION_TIME_IN_DAYS' "=" Int 
                                | defaultDdlCollationProp: 'DEFAULT_DDL_COLLATION' "=" String
                                | commentDatabaseOrSchemaProperty: 'COMMENT'
                                ;
syntax CommentClause = commentClause: 'COMMENT' AssignExpr?;
syntax AlterConnectionOptions = alterConnectionPrimary: Identifier 'PRIMARY'
                                | alterConnectionSet: IfExists? Identifier SetUnset CommentClause
                                ;

syntax AlterAlert =  alterAlterResumeSuspend: 'ALTER' 'ALERT' IfExists? Identifier ResumeSuspend
                    | alterAlterSet: 'ALTER' 'ALERT' IfExists? Identifier SetUnset AlertSetClause+
                    | alterAlterModify: 'ALTER' 'ALERT' IfExists? Identifier 'MODIFY' 'CONDITION' 'EXISTS' "(" AlertCondition ")"
                    ;
syntax AlertSetClause = warehouseAlertSetClause: 'WAREHOUSE' AssignExpr?
                        | scheduleAlertSetClause: 'SCHEDULE'  AssignExpr?
                        | commentAlertSetClause: CommentClause
                        ;
syntax AssignExpr = assignExp: "=" Expr !bracket
                    | assignList: '=' "(" ExpList? ")";
syntax Property =property:Identifier AssignExpr;

syntax AlertCondition = selectAlertCondition: QueryExpr

                       | showAlertCondition: ShowCommand
                       | callAlertCondition: Call
                       ;
syntax ResumeSuspend = resumeSuspendOpt1: 'RESUME'
                        | resumeSuspendOpt2: 'SUSPEND'
                        ;
syntax AlterUserOptions = renameToId: 'RENAME' 'TO' Identifier
                        | resetPassword: 'RESET' 'PASSWORD'
                        | abortAllQueries: 'ABORT' 'ALL' 'QUERIES'
                        | addDelegated: 'ADD' 'DELEGATED' 'AUTHORIZATION' 'OF' 'ROLE' Identifier 'TO' 'SECURITY' 'INTEGRATION' Identifier
                        | removeDelegated: 'REMOVE' 'DELEGATED' AuthorizationType 'FROM' 'SECURITY' 'INTEGRATION' Identifier
                        | setTagAlterUserOpt: SetUnsetTags
                        ;

syntax AuthorizationType = ofRoleAuthorizationType: 'AUTHORIZATION' 'OF' 'ROLE' Identifier 
                            | authorizationsType: 'AUTHORIZATIONS'
                            ;


syntax AlterTagOptions = alterTagOptsRename: 'RENAME' 'TO' PropRef
                        | alterTagOptsAddOrDrop: AddOrDrop TagAllowedValues
                        | alterTagOptsUnsetAllowed: 'UNSET' 'ALLOWED_VALUES'
                        | alterTagOptsSetMasking: SetUnset MaskingPolicyIdList 
                        | alterTagOptsSetCommentClause: SetUnset CommentClause
                      
                        ;

syntax Call = callClause: 'CALL' PropRef "(" ExpList? ")";

syntax AddOrDrop = add: 'ADD' 
                    | drop: 'DROP'
                    ;

syntax TagAllowedValues = tagAllowedValues: 'ALLOWED_VALUES' { String "," }+;

syntax WithMaskingPolicy = withMaskingPolicy: WithClause? 'MASKING' 'POLICY' Identifier UsingColumnList?
                            ;

syntax MaskingPolicyIdList = maskingPolicyIdList: {WithMaskingPolicy ","}+;

syntax AlterSchema = alterSchemaRenameTo: 'ALTER' 'SCHEMA' IfExists? Identifier 'RENAME' 'TO' Identifier
                    | alterSchemaSwapWith: 'ALTER' 'SCHEMA' IfExists? Identifier 'SWAP' 'WITH' Identifier
                    | alterSchemaCommentClause: 'ALTER' 'SCHEMA' IfExists? Identifier SetUnset 
                                                            {DatabaseOrSchemaProperty ","}+
                    | alterSchemaSetTags: 'ALTER' 'SCHEMA' IfExists? Identifier SetUnsetTags
                    | alterSchemaEnableDisable: 'ALTER' 'SCHEMA' IfExists? Identifier EnableDisable 'MANAGED' 'ACCESS'
                    ;

syntax EnableDisable = enable: 'ENABLE' 
                    | disable: 'DISABLE'
                    ;

syntax AlterRole = alterRoleRenameTo: 'ALTER' 'ROLE' IfExists? Identifier 'RENAME' 'TO' Identifier
                    | alterRoleSet: 'ALTER' 'ROLE' IfExists? Identifier SetUnset CommentClause
                    | alterRoleSetTags: 'ALTER' 'ROLE' IfExists? Identifier SetUnsetTags
        
                    ;

syntax AlterRowAccessPolicy = alterRowSetBody: 'ALTER' 'ROW' 'ACCESS' 'POLICY' IfExists? Identifier 'SET' 'BODY' "-\>" Expr
                            | alterRowRenameTo: 'ALTER' 'ROW' 'ACCESS' 'POLICY' IfExists? Identifier 'RENAME' 'TO' Identifier
                            | alterRowSetComment: 'ALTER' 'ROW' 'ACCESS' 'POLICY' IfExists? Identifier 'SET' CommentClause
                            ;
syntax DataTypeList = dataTypeList: { DataType ","}+;

syntax AlterProcedure = alterProcedureRenameTo: 'ALTER' 'PROCEDURE' IfExists? Identifier "(" DataTypeList? ")" 'RENAME' 'TO' Identifier
                        | alterProcedureSetComment: 'ALTER' 'PROCEDURE' IfExists? Identifier "(" DataTypeList? ")" SetUnset CommentClause
                        | alterProcedureExecute: 'ALTER' 'PROCEDURE' IfExists? Identifier "(" DataTypeList? ")" 'EXECUTE' 'AS' CallerOwner
                        ;
syntax AlterView = alterViewAlternative1: 'ALTER' 'VIEW' IfExists? TableName 'RENAME' 'TO' TableName
                        | alterViewAlternative2: 'ALTER' 'VIEW' IfExists? TableName SetUnset CommentClause
                        | alterViewAlternative4: 'ALTER' 'VIEW' TableName SetUnset 'SECURE'
                        | alterViewAlternative6: 'ALTER' 'VIEW' IfExists? TableName SetUnsetTags
                        | alterViewAlternative8: 'ALTER' 'VIEW' IfExists? TableName AddOrDrop 'ROW' 'ACCESS' 'POLICY' Identifier ('ON' Columns)?
                        | alterViewAlternative10: 'ALTER' 'VIEW' IfExists? TableName 'ADD' 'ROW' 'ACCESS' 'POLICY' Identifier 'ON' Columns "," 'DROP' 'ROW' 'ACCESS' 'POLICY' Identifier
                        | alterViewAlternative11: 'ALTER' 'VIEW' IfExists? TableName 'DROP' 'ALL' 'ROW' 'ACCESS' 'POLICIES'
                        | alterViewAlternative12: 'ALTER' 'VIEW' TableName AlterOrModify Column? Identifier 'SET' 'MASKING' 'POLICY' Identifier UsingColumnList?
                        | alterViewAlternative15: 'ALTER' 'VIEW' TableName AlterOrModify Column? Identifier 'SET' 'MASKING' 'POLICY' Identifier UsingColumnList? 'FORCE'
                        | alterViewAlternative17: 'ALTER' 'VIEW' TableName AlterOrModify Column? Identifier 'UNSET' 'MASKING' 'POLICY'
                       | alterViewAlternativeTags: 'ALTER' 'VIEW' TableName AlterOrModify Column? Identifier SetUnsetTags
                        ;

syntax Column = columnStr: 'COLUMN';

syntax CallerOwner = caller: 'CALLER'
                    | owner: 'OWNER'
                    ;

syntax AlterOrModify = alterOrModifyOpt1: 'ALTER' 
                        | alterOrModifyOpt2: 'MODIFY'
                        ;
syntax UsingColumnList = usingColumnList: 'USING' Columns;

syntax AlterFailoverGroup
                //Source Account
                = renameToFailoverGroup:   'RENAME' 'TO' Identifier
                | setFailoverGroup:   'SET' ObjectTypes? Property? 
                | addAllowedFailoverGroup:   'ADD' ColumnList 'TO' 'ALLOWED_DATABASES'
                | moveToFailoverGroup:   'MOVE' 'DATABASES' ColumnList 'TO' 'FAILOVER' 'GROUP' Identifier
                | removeFromFailoverGroup:   'REMOVE' ColumnList 'FROM' 'ALLOWED_DATABASES'
                | allowedSharesFailoverGroup:   'ADD' ColumnList 'TO' 'ALLOWED_SHARES'
                | moveSharesFailoverGroup:   'MOVE' 'SHARES' ColumnList 'TO' 'FAILOVER' 'GROUP' Identifier
                | removeAllowedSharesFailoverGroup:   'REMOVE' ColumnList 'FROM' 'ALLOWED_SHARES'
                | allowedAccountsFailoverGroup:   'ADD' TableName 'TO' 'ALLOWED_ACCOUNTS' IgnoreEditionCheck?
                | removeColumnFailoverGroup:   'REMOVE' TableName 'FROM' 'ALLOWED_ACCOUNTS'
                //Target Account
                | failoverOptFailoverGroup:   AlterFailoverOpts
                ;
syntax AlterNetworkPolicyOpts = alterNetworkIPList: IfExists? Identifier SetUnset
                                       Property*
                                        CommentClause?
                        
                                | alterNetworkRenameTo: Identifier 'RENAME' 'TO' Identifier
                                ;

syntax ObjectTypes = objectTypes: 'OBJECT_TYPES' "="{ObjectType ","}+;

syntax ObjectType = accountParamObjectType: 'ACCOUNT' 'PARAMETERS'
                    | databasesObjectType: 'DATABASES'
                    | integrationsObjectType: 'INTEGRATIONS'
                    | networkPoliciesObjectType: 'NETWORK' 'POLICIES'
                    | resourceMonitorsObjectType: 'RESOURCE' 'MONITORS'
                    | rolesObjectType: 'ROLES'
                    | sharesObjectType: 'SHARES'
                    | usersObjectType: 'USERS'
                    | warehousesObjectType: 'WAREHOUSES'
                    ;

syntax AlterApiIntegration = alterApiArn: 'ALTER' 'API' 'INTEGRATION' IfExists? Identifier SetUnset
                                        CommentClause?
                                | alterNoApiSetTags: 'ALTER' 'Api'? 'INTEGRATION' Identifier SetUnsetTags
                             
                                |  alterNoApiUnset: 'ALTER' 'API'? 'INTEGRATION' IfExists? Identifier 'UNSET' ApiIntegrationPropertyList
                                ;



syntax ApiIntegrationPropertyList = apiIntegrationPropertyList: {ApiIntegrationProperty ","}+;

syntax ApiIntegrationProperty = apiKeyIntegrationProp: 'API_KEY'
                                | enabledIntegrationProp: 'ENABLED'
                                | blockedPrefixesIntegrationProp: 'API_BLOCKED_PREFIXES'
                                | commentIntegrationProp: 'COMMENT'
                                ;

syntax AlterDynamicOpts = resumeSuspendDynamicOpt: ResumeSuspend
                              | refreshDynamicOpt: 'REFRESH'
                              | setDynamicOpt: 'SET' 'WAREHOUSE' "=" Identifier
                              ;                                

syntax IgnoreEditionCheck = ignoreEditionCheck: 'IGNORE' 'EDITION' 'CHECK';

syntax AlterFailoverOpts = refreshFailoverOpts: 'REFRESH'
                                | primaryFailoverOpts: 'PRIMARY' 
                                | suspendFailoverOpts: 'SUSPEND' 
                                | resumeFailoverOpts: 'RESUME'
                                ;

syntax AlterFileFormat = alterFileRenameTo: 'ALTER' 'FILE' 'FORMAT' IfExists? Identifier 'RENAME' 'TO' Identifier
                        | alterFileSet: 'ALTER' 'FILE' 'FORMAT' IfExists? Identifier 'SET' Property* CommentClause?
                        ;

syntax BinaryFormat = binaryFormatHex: 'HEX' 
                    | binaryFormatBase64: 'BASE64'
                    | binaryFormatUtf8: 'UTF8'
                    ;



syntax AlterWareHouseOptions = idSuspendIfAlterWhOpt: Expr? SuspendResumeIf
                                | idAbortAllAlterWhOpt: Expr? 'ABORT' 'ALL' 'QUERIES'
                                | idRenameToAlterWhOpt: Expr 'RENAME' 'TO' Identifier
                                | idSetTagsAlterWhOpt: Expr SetUnsetTags
                                | idUnSetColListAlterWhOpt: Expr 'UNSET' ColumnList
                                ;

syntax SuspendResumeIf = suspendResumeIfOpt1: 'SUSPEND' 
                        | suspendResumeIfOpt2: 'RESUME' IfSuspended?
                        ;

syntax Secure =secure: 'Secure';

syntax IfSuspended = ifSuspended: 'IF' 'SUSPENDED';

syntax AlterFunction = renameToAlterFunction:  'RENAME' 'TO' Identifier
                        | commentAlterFunction:  SetUnset UnsetSecureOrComment
                        | compressionAlterFunction:  SetUnset
                        ;

syntax UnsetSecureOrComment = unsetSecure: 'SECURE' 
                        | unsetComment: CommentClause
                        | setSecureOrComment: 'SET'
                        ;

syntax TranslatorType = requestTranslatorType: 'REQUEST_TRANSLATOR' 
                        | responseTranslatorType: 'RESPONSE_TRANSLATOR'
                        ;

syntax UnsetType = unsetCommentType: 'COMMENT' 
                        | unsetHeadersType: 'HEADERS' 
                        | unsetContextHeadersType: 'CONTEXT_HEADERS' 
                        | unsetMaxBatchType: 'MAX_BATCH_ROWS' 
                        | unsetCompressionType: 'COMPRESSION' 
                        | unsetSecureType: 'SECURE' 
                        | unsetTranslatorType: TranslatorType AssignExpr?
                        ;
syntax AlterMaskingPolicy = alterMaskingBody: 'ALTER' 'MASKING' 'POLICY' IfExists? Identifier 'SET' 'BODY' "-\>" Expr
                                | alterMaskingRenameTo: 'ALTER' 'MASKING' 'POLICY' IfExists? Identifier 'RENAME' 'TO' Identifier
                                | alterMaskingSet: 'ALTER' 'MASKING' 'POLICY' IfExists? Identifier 'SET' CommentClause
                                ;

syntax AlterMaterializedViewOpts = alterMaterializedViewOpt1: 'RENAME' 'TO' Identifier
                                        | alterMaterializedViewOpt2: 'CLUSTER' 'BY' ExpListWithBrackets
                                        | alterMaterializedViewOpt3: 'DROP' 'CLUSTERING' 'KEY'
                                        | alterMaterializedOptNoRecluster: ResumeSuspend
                                        | alterMaterializedOptRecluster: ResumeSuspend 'RECLUSTER'
                                        | alterMaterializedOptNoSecure: 'SET' 'Secure'? CommentClause?
                                        
                                        | alterMaterializedViewOpt7: UnsetSecureOrComment+
                                        ;

syntax AlterPipe = alterPipeOpt1: 'ALTER' 'PIPE' IfExists? Identifier 'SET' Property? CommentClause?
                        | alterPipeOpt2: 'ALTER' 'PIPE' Identifier SetUnsetTags
                    
                        | alterPipeOpt4: 'ALTER' 'PIPE' IfExists? Identifier 'UNSET' 'PIPE_EXECUTION_PAUSED' "=" Boolean
                        | alterPipeOpt5: 'ALTER' 'PIPE' IfExists? Identifier 'UNSET' 'COMMENT'
                        | alterPipeOpt6: 'ALTER' 'PIPE' IfExists? Identifier 'REFRESH' Property*
                        ;

                               
syntax AlterNotificationIntegration =  alterNotificationIntegrationOpt2: 'ALTER' 'NOTIFICATION'? 'INTEGRATION' IfExists? Identifier SetUnset
                                       
                                                CloudProviderParamsAuto
                                                CommentClause?
                                        // Push notifications
                                        
                                  
                                        | alterNotificationIntegrationOpt6: 'ALTER' 'NOTIFICATION'? 'INTEGRATION' Identifier SetUnsetTags
                                        ;

syntax CloudProviderParamsAuto
                                //(for Google Cloud Storage)
                                = googleCloudParamAuto: 'NOTIFICATION_PROVIDER' "=" 'GCP_PUBSUB' 'GCP_PUBSUB_SUBSCRIPTION_NAME' "=" String
                                //(for Microsoft Azure Storage)
                                | microsoftAzureParamAuto: 'NOTIFICATION_PROVIDER' "=" 'AZURE_EVENT_GRID' 'AZURE_STORAGE_QUEUE_PRIMARY_URI' "=" String 'AZURE_TENANT_ID' "=" String
                                ;

syntax CloudProviderParamsPush
                                //(for Amazon SNS)
                                = amazonAwsParamPush: 'NOTIFICATION_PROVIDER' "=" 'AWS_SNS'
                                        'AWS_SNS_TOPIC_ARN' "=" String
                                        'AWS_SNS_ROLE_ARN' "=" String
                                //(for Google Pub/Sub)
                                | googleCloudParamPush: 'NOTIFICATION_PROVIDER' "=" 'GCP_PUBSUB'
                                        'GCP_PUBSUB_TOPIC_NAME' "=" String
                                //(for Microsoft Azure Event Grid)
                                | microsoftAzureParamPush: 'NOTIFICATION_PROVIDER' "=" 'AZURE_EVENT_GRID'
                                        'AZURE_EVENT_GRID_TOPIC_ENDPOINT' "=" String
                                        'AZURE_TENANT_ID' "=" String
                                ;

syntax AlterEnabledOrComment = alterEnabled: 'ENABLED' 
                                | alterComment: 'COMMENT'
                                ;

syntax AlterExternalTable = alterExternalTableRefresh: 'ALTER' 'EXTERNAL' 'TABLE' IfExists? TableName 'REFRESH' String?
                                | alterExternalTableAddFiles: 'ALTER' 'EXTERNAL' 'TABLE' IfExists? TableName 'ADD' 'FILES' "(" ExpList ")"
                                | alterExternalTableRemoveFiles: 'ALTER' 'EXTERNAL' 'TABLE' IfExists? TableName 'REMOVE' 'FILES' "(" ExpList ")"
                                | alterExternalTableSet: 'ALTER' 'EXTERNAL' 'TABLE' IfExists? TableName 'SET'
                                        AutoRefresh? 
                                        TagDeclList?
                                | alterExternalTableUnset: 'ALTER' 'EXTERNAL' 'TABLE' IfExists? TableName SetUnsetTags 
                                //Partitions added and removed manually
                                | alterExternalTableAddPartition: 'ALTER' 'EXTERNAL' 'TABLE' TableName IfExists? 'ADD' 'PARTITION' "(" ExpList ")" 'LOCATION' String
                                | alterExternalTableDropPartition: 'ALTER' 'EXTERNAL' 'TABLE' TableName IfExists? 'DROP' 'PARTITION' 'LOCATION' String
                                ;
syntax AutoRefresh = autoRefresh: 'AUTO_REFRESH' "=" Boolean;
syntax TagDeclList = tagDeclList: 'TAG' {TagDecl ","}+;

syntax TagDecl = tagDecl: Identifier "=" String;

syntax AlterSequence = alterSequenceRenameTo: 'ALTER' 'SEQUENCE' IfExists? TableName 'RENAME' 'TO' TableName
                        | alterSequenceSetIncrementBy: 'ALTER' 'SEQUENCE' IfExists? TableName 'SET'? IncrementBy?
                        | alterSequenceSetOrderComment: 'ALTER' 'SEQUENCE' IfExists? TableName SetUnset OrderComment
                        ;

 syntax OrderComment = orderCommentOpt1: OrderNoOrder? CommentClause 
                        | orderCommentOpt2: OrderNoOrder
                        ;

syntax OrderNoOrder = orderNoOrder1: 'ORDER'
                    | orderNoOrder2: 'NOORDER'
                    ;

syntax IncrementBy = incrementByOpt1: 'INCREMENT' "=" Int
                    | incrementByOpt2: 'INCREMENT' 'BY' "=" Int
                    | incrementByOpt3: 'INCREMENT' Int
                    | incrementByOpt4: 'INCREMENT' 'BY' Int
                    ;


syntax NotifyTriggers = notifyTriggers: NotifyUsers Triggers?;

syntax NotifyUsers = notifyUsers: 'NOTIFY_USERS' "=" "(" {Identifier ","}+ ")";

syntax Triggers = triggers: 'TRIGGERS' TriggerDefinition+;

syntax TriggerDefinition = triggerDefinition: 'ON' Int 'PERCENT' 'DO' SuspendType;

syntax SuspendType = suspendTypeOpt1: 'SUSPEND' 
                        | suspendTypeOpt2: 'SUSPEND_IMMEDIATE' 
                        | suspendTypeOpt3: 'NOTIFY'
                        ;

syntax FrequencyOpts = monthlyFrequency: 'MONTHLY' 
                        | dailyFrequency: 'DAILY' 
                        | weeklyFrequency: 'WEEKLY' 
                        | yearlyFrequency: 'YEARLY' 
                        | neverFrequency: 'NEVER'
                        ;
syntax OrReplace = orReplace: 'OR' 'REPLACE';
syntax CloneAtBefore = cloneAtBefore: 'CLONE' TableName CloneOptional?;

syntax CloneOptional = cloneTimeStamp: AtOrBefore "(" 'TIMESTAMP' "=\>" String ")"
                        | cloneOffset: AtOrBefore "(" 'OFFSET' "=\>" String ")"
                        | cloneStatement: AtOrBefore "(" 'STATEMENT' "=\>" Identifier ")"
                        | cloneStream: AtOrBefore "(" 'STREAM' "=\>" String ")"
                        ;

syntax AtOrBefore = atOrBeforeOpt1: 'AT' 
                    | atOrBeforeOpt2: 'BEFORE'
                    ;


syntax CreateCommand =  createViewCommand: CreateView
                        | createTableCommand: 'CREATE' OrReplace? TableType? 'TABLE' IfNotExistsObjectName? CloneAtBefore? CreateTableOrCommentClause* ('as' QueryOrWith)?
                       
                        | createTableLikeCommand: CreateTableLike
                        | createDatabaseCommand: CreateDatabase
                        | createSchemaCommand: CreateSchema
                        | createAccountCommand: 'CREATE' 'ACCOUNT' Identifier
                        
                                Property+
                                RegionGroup?
                                SnowflakeRegion?
                                CommentClause?
                        | createUserCommand: 'CREATE' OrReplace? 'USER' IfNotExists? Identifier Property* 
                        | createConnectionCommand: 'CREATE' 'CONNECTION' IfNotExists? Identifier AsReplicaOfObjectName? CommentClause?
                        | createDynamicTableCommand: 'CREATE' OrReplace? 'DYNAMIC' 'TABLE' Identifier
                                'TARGET_LAG' "=" String
                                'WAREHOUSE' "=" Identifier
                                'AS' QueryExpr
                        | createEventTableCommand: 'CREATE' OrReplace? 'EVENT' 'TABLE' IfNotExists? Identifier
                                ClusterBy?
                               Property*
                                CopyGrants?
                                WithRowAccessPolicy?
                                WithTags?
                                WithClause? CommentClause?

                        | createFailoverGroupCommand: CreateFailoverGroup
                        | createManagedAccountCommand: 'CREATE' 'MANAGED' 'ACCOUNT' Identifier
                                                        'ADMIN_NAME' "=" Identifier "," 'ADMIN_PASSWORD' "=" String "," 
                                                        'TYPE' "=" 'READER' ("," CommentClause)?
                        | createNetworkPolicyCommand: 'CREATE' OrReplace? 'NETWORK' 'POLICY' Identifier
                                        Property*
                                        CommentClause?
                        | createApiIntegrationCommand: CreateApiIntegration
                        | createExternalFunctionCommand: CreateExternalFunction 
                        | createExternalTableCommand: CreateExternalTable
                        | createFunctionCommand: CreateFunction
                        | createMaskingPolicyCommand: 'CREATE' OrReplace? 'MASKING' 'POLICY' IfNotExists? PropRef 'AS'
                                        "(" ArgDataTypeList? ")"
                                        'RETURNS' DataType "-\>" Expr
                                        CommentClause?
                        | createNotificationIntegrationCommand: CreateNotificationIntegration
                        | createProcedureCommand: CreateProcedure
                        | createPipeCommand: 'CREATE' OrReplace? 'PIPE' IfNotExists? PropRef
                                Property*
                                CommentClause?
                                'AS' CopyIntoTable
                        | createObjectType: 'CREATE' OrReplace? ObjectTypeName!databaseObjectTypeName!integrationObjectTypeName!networkObjectTypeName!schemaObjectTypeName!sequenceObjectTypeName!tableObjectTypeName!userObjectTypeName 
                                IfNotExists? 
                                Identifier WithTags? 
                                Property*  
                                TagAllowedValues?
                                CommentClause? 
                              
                        | createRowAccessPolicyCommand: 'CREATE' OrReplace? 'ROW' 'ACCESS' 'POLICY' IfNotExists? Identifier 'AS'
                                        "(" ArgDataTypeList? ")"
                                        'RETURNS' 'BOOLEAN' "-\>" Expr
                                        CommentClause?
                        | createReplicationGroupCommand: CreateReplicationGroup
                        | createResourceMonitorCommand: 'CREATE' OrReplace? 'RESOURCE' 'MONITOR' Identifier 'WITH'
                                     Property*
                                        NotifyUsers?
                                        Triggers?
                        | createSequenceCommand: CreateSequence
                       
                        | createStageCommand: CreateStage
                        | createStorageIntegrationCommand: 'CREATE' OrReplace? 'STORAGE' 'INTEGRATION' IfNotExists? Identifier
                                        'TYPE' "=" 'EXTERNAL_STAGE'
                                      
                                      Property+
                                        CommentClause?
                        | createStreamCommand:'CREATE' OrReplace? 'STREAM' IfNotExists?
                                TableName
                                CopyGrants? CreateStream
                        | createObjectCloneCommand: 'CREATE' OrReplace? CreateCloneOpts IfNotExists? PropRef
                                        'CLONE' PropRef
                        ;
syntax CreateCloneOpts = stageCloneOpt: 'STAGE' 
                        | fileFormatCloneOpt: 'FILE' 'FORMAT' 
                        | sequenceCloneOpt: 'SEQUENCE' 
                        | streamCloneOpt: 'STREAM' 
                        | taskCloneOpt: 'TASK'
                        ;
syntax WithWhProperties = withWhProperties: WithClause? WhProperties+
                        ;

syntax WhProperties = warehouseSizeProp: 'WAREHOUSE_SIZE' "=" WarehouseSizeOrId
                        | maxCountProp: 'MAX_CLUSTER_COUNT' "=" Int
                        | minClusterProp: 'MIN_CLUSTER_COUNT' "=" Int
                        | scalingPolicyProp: 'SCALING_POLICY' "=" StandardOrEconomy
                        | autoSuspendProp: 'AUTO_SUSPEND' Expr
                        | autoResumeProp: 'AUTO_RESUME' "=" Boolean
                        | initiallySuspendedProp: 'INITIALLY_SUSPENDED' "=" Boolean
                        | resourceMoinitorProp: 'RESOURCE_MONITOR' "=" Identifier
                        | commentClauseProp: CommentClause
                        | enableQueryProp: 'ENABLE_QUERY_ACCELERATION' "=" Boolean
                        | queryAccelerationProp: 'QUERY_ACCELERATION_MAX_SCALE_FACTOR' "=" Int
                        ;

syntax WarehouseSizeOrId = wareHouseSize: WhSize 
                                | wareHouseId: WhIdentifier
                                ;

syntax WhSize = sizeXsmall: 'XSMALL'
                | sizeSmall: 'SMALL'
                | sizeMedium: 'MEDIUM'
                | sizeLarge: 'LARGE'
                | sizeXlarge: 'XLARGE'
                | sizeXxlarge: 'XXLARGE'
                | sizeXxxlarge: 'XXXLARGE'
                | sizeX4large: 'X4LARGE'
                | sizeX5large: 'X5LARGE'
                | sizeX6large: 'X6LARGE'
                ;
syntax StandardOrEconomy = standardOrEconomyOpt1: 'STANDARD' 
                        | standardOrEconomyOpt2: 'ECONOMY'
                        ;

syntax WhParams = maxConcurrencyParam: 'MAX_CONCURRENCY_LEVEL' "=" Int
                | statementQueuedParam: 'STATEMENT_QUEUED_TIMEOUT_IN_SECONDS' "=" Int
                | statementTimeoutParam: 'STATEMENT_TIMEOUT_IN_SECONDS' "=" Int WithTags?
                ;
syntax RegionGroup = regionGroup: 'REGION_GROUP' "=" Identifier;

syntax SnowflakeRegion = snowflakeRegion: 'REGION' "=" Identifier;
syntax CreateTableOrCommentClause = createTableOrCommentClauseOpt1: CreateTableClause
                                        | createTableOrCommentClauseOpt2: CommentClause
                                        ;


syntax CreateFailoverGroup = createFailoverGroupAsReplica: 'CREATE' 'FAILOVER' 'GROUP' IfNotExists? Identifier AsReplicaOfObjectName
                                | createFailoverGroupObjectTypes: 'CREATE' 'FAILOVER' 'GROUP' IfNotExists? Identifier
                                        'OBJECT_TYPES' "=" ObjectTypeList
                                        AllowedDatabases?
                                        AllowedShares?
                                        AllowedIntegrationTypes?
                                        'ALLOWED_ACCOUNTS' "=" PropRef
                                        IgnoreEditionCheck?
                                        Property? 
                                ;

syntax CreateApiIntegration = apiAwsRole: 'CREATE' OrReplace? 'API' 'INTEGRATION' IfNotExists? Identifier
                                        Property+
                                        CommentClause?
                                ;
syntax AllowedDatabases = allowedDatabases: 'ALLOWED_DATABASES' "=" {Identifier ","}+;

syntax AllowedShares = allowedShares: 'ALLOWED_SHARES' "=" {Identifier ","}+;

syntax AllowedIntegrationTypes = allowedIntegrationTypes: 'ALLOWED_INTEGRATION_TYPES' "=" {IntegrationTypeName ","}+;

syntax IntegrationTypeName =  securityIntegrations: 'SECURITY' 'INTEGRATIONS' 
                                | apiIntegrations: 'API' 'INTEGRATIONS'
                                ;

syntax AsReplicaOfObjectName = asReplicaOfObjectName: 'AS' 'REPLICA' 'OF' PropRef ;


syntax ClusterBy = clusterBy: 'CLUSTER' 'BY' ExpListWithBrackets;


syntax FormatType = csv_: 'CSV'
                    | json_: 'JSON' 
                    | avro_: 'AVRO' 
                    | orc_: 'ORC' 
                    | parquet_: 'PARQUET'
                    | xml_: 'XML'
                    | csv_q: '\'CSV\''
                    | json_q: '\'JSON\'' 
                    | avro_q: '\'AVRO\'' 
                    | orc_q: '\'ORC\'' 
                    | parquet_q: '\'PARQUET\''
                    | xml_q: '\'XML\''
                    ;

syntax CreateTableClause = createTableClause: ColumnDeclItemListWithBrackets
                                        ClusterBy?
                                        StageFileFormat?
                                        StageCopyEqCopyOptions?
                                        Property*
                                        CopyGrants?
                                        WithRowAccessPolicy?
                                        WithTags?
                                ;

syntax StageFileFormat = stageFileFormatOpt1: 'STAGE_FILE_FORMAT' "=" "(" 'FORMAT_NAME' "=" String ")"
                        | stageFileFormatOpt2: 'STAGE_FILE_FORMAT' "=" "(" 'TYPE' "=" FormatType Property+ ")"
                        ;

syntax StageCopyEqCopyOptions = stageCopyEqCopyOptions: 'STAGE_COPY_OPTIONS' "=" "(" CopyOptions ")";

syntax CopyOptions = onErrorOpts: 'ON_ERROR' "=" OnErrorAction
                     |prop:Property
                 
                   
                    ;

syntax OnErrorAction = continueAction: 'CONTINUE'
                        | skipFile: 'SKIP_FILE' 
                        | skipFileInt: 'SKIP_FILE_' Int
                        | skipFileAbort: 'SKIP_FILE_' Int 'ABORT_STATEMENT'
                        ;

syntax Sensitivity = sensitivityOpt1: 'CASE_SENSITIVE'
                    | sensitivityOpt2: 'CASE_INSENSITIVE' 
                    | sensitivityOpt3: 'NONE'
                    ;

syntax CreateView =  createViewSF: 'CREATE' OrReplace? Secure? Materialized? 'VIEW' IfNotExists? TableName
                                        BracketColumnListWithComment?
                                        ViewCol*
                                        WithRowAccessPolicy?
                                        WithTags?
                                        CopyGrants?
                                        CommentClause?
                                        ClusterBy?
                                        'AS' QueryOrWith
                                ;

syntax ViewCol = viewCol: PropRef WithMaskingPolicy WithTags;

syntax ObjectTypeList = objectTypeList: {ObjectType ","}+;

syntax CreateReplicationGroup = replicationGroupAllowed: 'CREATE' 'REPLICATION' 'GROUP' IfNotExists? Identifier
                                        ObjectTypes
                                        AllowedDatabases?
                                        AllowedShares?
                                        AllowedIntegrationTypes?
                                        'ALLOWED_ACCOUNTS' "=" PropRef
                                        IgnoreEditionCheck?
                                        Property?
                                //Secondary Replication Group
                                | replicationGroupReplica: 'CREATE' 'REPLICATION' 'GROUP' IfNotExists? Identifier AsReplicaOfObjectName
                                ;
syntax CreateTableLike = createTableLike: 'CREATE' OrReplace? TableType? 'TABLE' TableName 'LIKE' TableName
                                ClusterBy?
                                CopyGrants?
                       ;
syntax CreateFunction =  createFunction: 'CREATE' OrReplace?  Secure? 'FUNCTION' TableName "(" ArgDataTypeList? ")"
                                'RETURNS' ReturnsType
                                NullNotNull?
                                 ('LANGUAGE' Lang)?
                                CalledReturnsOrStrict?
                                VolatileOrImmutable?
                                'MEMOIZABLE'?
                                CommentClause?
                                'AS' String
                        ;    
syntax ExecuteAs = executeAs: 'EXECUTE' 'AS' CallerOwner;


syntax ReturnsType = returnsDataType: DataType 
                        | returnsTable: 'TABLE' "(" ColDeclList? ")"
                        ;
syntax ColDeclList = colDeclList: {ColDecl ","}+;

syntax CreateStage = createStageParams: 'CREATE' OrReplace? Temporary? 'STAGE' IfNotExists? Expr CloneAtBefore?
                                 ExternalStageParams?
                                StageEncryptionOptsInternal?
                                DirectoryTableInternalParams?
                                DirectoryTableExternalParams?
                                FileFormat?
                                CopyEqCopyOpts?
                                WithTags?
                                CommentClause?
                       
                        ;

syntax ExternalStageParams = externalStageAwsParam: 'URL' "=" S3OrGovAwsPath AwsCredentialEncryption*
                                //(for Google Cloud Storage)
                                | externalStageGcpParam: 'URL' "=" "\'" 'gcs://' Uri "\'" GcpCredentialEncryption*
                                //(for Microsoft Azure)
                                | externalStageAzureParam: 'URL' "=" "\'" 'azure://' Uri "\'" AzCredentialEncryption*
                                ; 

syntax AwsCredentialEncryption = awsCredentialIntegration: AwsCredentialOrStorageIntegration
                                | awsCredentialEncryption: 'ENCRYPTION' "=" "(" Property+ ")"
                                ;
syntax GcpCredentialEncryption = gcpCredentialIntegration: Property
                                | gcpCredentialEncryption: 'ENCRYPTION' "=" "(" GcpEncryptionValue ")"
                                ;

syntax GcpEncryptionValue = typeGcsSseKmsKey: TypeGcsSseKms? 'KMS_KEY_ID' "=" String
                                | kmsTypeGcsSse: 'KMS_KEY_ID' "=" String 'TYPE' "=" '\'GCS_SSE_KMS\''
                                | typeNoneGcp: 'TYPE' "=" '\'NONE\''
                                ;


syntax AwsCredentialOrStorageIntegration = awsStorageIntegration: 'STORAGE_INTEGRATION' "=" Identifier
                                                |  awsCredential: 'CREDENTIALS' "=" "(" Property+ ")"
                                                ; 


syntax TypeGcsSseKms = typeGcsSseKms: 'TYPE' "=" '\'GCS_SSE_KMS\'';

syntax AzCredentialEncryption = azCredentialIntegration: AzCredentialOrStorageIntegration
                                | azCredentialEncryption: 'ENCRYPTION' "=" "(" Property Property? ")"
                                ;

syntax AzCredentialOrStorageIntegration = azureStorageIntegrationId: 'STORAGE_INTEGRATION' "=" Identifier
                                        |  azureSasToken: 'CREDENTIALS' "=" "(" 'AZURE_SAS_TOKEN' "=" String ")"
                                        ;                                
syntax DirectoryTableInternalParams = directoryTableInternalParams: 'DIRECTORY' "=" "(" EnableRefreshOnCreate")";

syntax EnableRefreshOnCreate = enableRefreshOnCreateOpt1: Enable RefreshOnCreate?
                                | enableRefreshOnCreateOpt2: RefreshOnCreate Enable?
                                ;

syntax StageEncryptionOptsInternal = stageEncryptionOptsInternal: 'ENCRYPTION' "=" "(" 'TYPE' "=" SnowFlakeFullSSE ")";

syntax RefreshOnCreate = refreshOnCreate: 'REFRESH_ON_CREATE' "=" Boolean; 

syntax CopyEqCopyOpts = copyEqCopyOpts: 'COPY_OPTIONS' "=" "(" CopyOptions ")";

syntax Temporary = temp: 'TEMP' 
                    | temporary: 'TEMPORARY'
                    ;
syntax Enable = enableTrueOrFalse: 'ENABLE' "=" Boolean; 

syntax DirectoryTableExternalParams = directoryTableExternalParams: 'DIRECTORY' "=" "(" Enable RefreshOnCreateOrAutoRefresh* NotificationIntegration? ")";

syntax SnowFlakeFullSSE = snowflakeFull: 'SNOWFLAKE_FULL' 
                        | snowflakeSSE: 'SNOWFLAKE_SSE'
                        ;
syntax RefreshOnCreateOrAutoRefresh = refreshOnCreateOrAutoRefreshOpt1: AutoRefresh
                                        | refreshOnCreateOrAutoRefreshOpt1: RefreshOnCreate
                                        ;
syntax CalledReturnsOrStrict = calledOnNull: 'CALLED' 'ON' 'NULL' 'INPUT' 
                                | returnsNull: 'RETURNS' 'NULL' 'ON' 'NULL' 'INPUT' 
                                | returnsStrict: 'STRICT'
                                ;
syntax LocalGlobal = local: 'LOCAL'
                    | global: 'GLOBAL'
                    ;
syntax Materialized =material: 'MATERIALIZED' ;
syntax TableType = volatileType: LocalGlobal? 'VOLATILE'
                    | temporaryType: LocalGlobal? Temporary
                    | transientType: 'TRANSIENT'
                    ;
syntax BracketColumnListWithComment = bracketColumnListWithComment: "(" ColumnListWithComment ")";

syntax ColumnListWithComment = columnListWithComment: {ColumnNameWithComment ","}+;

syntax ColumnNameWithComment = columnNameWithComment: PropRef CommentString?;

syntax CommentString = commentString: 'COMMENT' String;

syntax IfNotExistsObjectName = ifNotExistsObjectName: IfNotExists? PropRef 
                                | objectNameIfNotExists: PropRef IfNotExists
                                ;

syntax ColumnDeclItem = fullColItem: FullColDecl
                        | outOfLineConstraintItem: OutOfLineConstraint
                        ;
                        
syntax ColumnDeclItemList = columnDeclItemList: { ColumnDeclItem ","}+;

syntax ColumnDeclItemListWithBrackets = columnDeclItemListWithBrackets: "(" ColumnDeclItemList ")";

syntax FullColDecl = fullColDecl: ColDecl FullColDeclOptionals* WithMaskingPolicy? WithTags? CommentString?;

syntax OutOfLineConstraint = outOfLineConstraint: ConstraintId? OutOfLineConstraintOptionals;
syntax OutOfLineConstraintOptionals = outOfLineConstraintUnique: UniquePrimaryKey ExpListWithBrackets CommonConstraintProperties*
                                    | outOfLineConstraintForeign: 'FOREIGN' 'KEY' ExpListWithBrackets 'REFERENCES' Expr ConstraintProperties
                                    ;
syntax ColDecl = colDecl: IdentifierType DataType;

syntax CreateSchema = createSchemaWithTransient: 'CREATE' OrReplace? TableType? 'SCHEMA' IfExists? TableName
                                CloneAtBefore?
                                WithManagedAccess?
                                Property*
                              
                                WithTags?
                                CommentClause?
                        ;
syntax IdentifierType = identifierTypeOpt1: BinaryOrTernaryBuiltInFunction
                        | identifierTypeOpt2: PropRef
                        ;

syntax StorageAwsObject = storageAwsObject: 'STORAGE_AWS_OBJECT_ACL' "=" String;

syntax CreateExternalFunction = createExternalFunction: 'CREATE' OrReplace? Secure? 'EXTERNAL' 'FUNCTION' 
                                        TableName "(" ArgDataTypeList? ")"
                                        'RETURNS' DataType NullNotNull?
                                        CalledReturnsOrStrict?
                                        VolatileOrImmutable?
                                        CommentClause?
                                        Property*
                                        'AS' String
                                ;
syntax BinaryOrTernaryBuiltInFunction = ifNullBuiltInFunction: 'IFNULL' 
                                | nvlBuiltInFunction: 'NVL'
                                | getBuiltInFunction: 'GET'
                                | leftBuiltInFunction: 'LEFT'
                                | rightBuiltInFunction: 'RIGHT'
                                | datePartBuiltInFunction: 'DATE_PART'
                                | splitBuiltInFunction: 'SPLIT'
                                | nullIfBuiltInFunction: 'NULLIF'
                                | equalNullBuiltInFunction: 'EQUAL_NULL'
                                | containsBuiltInFunction: 'CONTAINS'
                                | collateBuiltInFunction: 'COLLATE'
                                | toDateBuiltInFunction: 'TO_DATE'
                                | dateBuiltInFunction: 'DATE'
                                | charIndexBuiltInFunction: 'CHARINDEX'
                                | replaceBuiltInFunction: 'REPLACE'
                                | substringBuiltInFunction: 'SUBSTRING' 
                                | substrBuiltInFunction: 'SUBSTR'
                                | likeBuiltInFunction: 'LIKE' 
                                | ilikeBuiltInFunction: 'ILIKE'
                                ;

syntax FullColDeclOptionals = fullColDeclOptCollate: 'COLLATE' String
                            | fullColDeclOptInline: InlineConstraint
                            | fullColDeclOptDefault: DefaultValue
                            | fullColDeclOptNullNotNull: NullNotNull
                            ;
syntax CascadeRestrict = cascadeRestrictOpt1: 'CASCADE'
                        | cascadeRestrictOpt2: 'RESTRICT'
                        ;
syntax DropCommand = 
 dropAlertCommand: 'DROP' 'ALERT' Identifier
                    | dropConnectionCommand: 'DROP' 'CONNECTION' IfExists? Identifier
                    | dropObjectCommand: 'DROP' ObjectType? ObjectTypeName!tableObjectTypeName!viewObjectTypeName? IfExists? IdentifierType CascadeRestrict?
                    | dropTableWithCascade: 'DROP' 'TABLE' IfExists? TableName CascadeRestrict
                    | dropDynamicTableCommand: 'DROP' 'DYNAMIC' 'TABLE' Identifier
                    | dropExternalTableCommand: 'DROP' 'EXTERNAL' 'TABLE' IfExists? TableName CascadeRestrict?
                    | dropFailoverGroupCommand: 'DROP' 'FAILOVER' 'GROUP' IfExists? Identifier
                    | dropFunctionCommand: 'DROP' 'FUNCTION' IfExists? TableName ArgTypes
                    | dropManagedAccountCommand: 'DROP' 'MANAGED' 'ACCOUNT' Identifier
                    | dropMaterializedViewsCommand: 'DROP' 'MATERIALIZED' 'VIEW' IfExists? TableName
                    | dropReplicationGroupCommand: 'DROP' 'REPLICATION' 'GROUP' IfExists? Identifier
                    | dropResourceMonitorCommand: 'DROP' 'RESOURCE' 'MONITOR' Identifier
                    | dropProcedureCommand: 'DROP' 'PROCEDURE' IfExists? TableName ArgTypes
                   
                    ;

syntax CloudProviderParamsAuto
                                //(for Google Cloud Storage)
                                = googleCloudParamAuto: 'NOTIFICATION_PROVIDER' "=" 'GCP_PUBSUB' 'GCP_PUBSUB_SUBSCRIPTION_NAME' "=" String
                                //(for Microsoft Azure Storage)
                                | microsoftAzureParamAuto: 'NOTIFICATION_PROVIDER' "=" 'AZURE_EVENT_GRID' 'AZURE_STORAGE_QUEUE_PRIMARY_URI' "=" String 'AZURE_TENANT_ID' "=" String
                                ;

syntax CloudProviderParamsPush
                                //(for Amazon SNS)
                                = amazonAwsParamPush: 'NOTIFICATION_PROVIDER' "=" 'AWS_SNS'
                                        'AWS_SNS_TOPIC_ARN' "=" String
                                        'AWS_SNS_ROLE_ARN' "=" String
                                //(for Google Pub/Sub)
                                | googleCloudParamPush: 'NOTIFICATION_PROVIDER' "=" 'GCP_PUBSUB'
                                        'GCP_PUBSUB_TOPIC_NAME' "=" String
                                //(for Microsoft Azure Event Grid)
                                | microsoftAzureParamPush: 'NOTIFICATION_PROVIDER' "=" 'AZURE_EVENT_GRID'
                                        'AZURE_EVENT_GRID_TOPIC_ENDPOINT' "=" String
                                        'AZURE_TENANT_ID' "=" String
                                ;
syntax CreateNotificationIntegration =  createNotification: 'CREATE' OrReplace? 'NOTIFICATION' 'INTEGRATION' IfNotExists? Identifier
                                        Property+
                                        CloudProviderParamsPush?
                                        CommentClause?
                                ;
syntax ArgTypes = argTypes: "(" DataTypeList? ")";

syntax ShowCommand = showAlertsCommand: ShowAlerts
                    | showChannelsCommand: 'SHOW' 'CHANNELS' LikePattern? InShowOptionals?
                    | showColumnsCommand: 'SHOW' 'COLUMNS' LikePattern? InShowOptionals?
                    | showConnectionsCommand: 'SHOW' 'CONNECTIONS' LikePattern?
                    | showDatabasesCommand: ShowDatabases
                    | showDatabasesInFailoverGroupCommand: 'SHOW' 'DATABASES' 'IN' FailOrRep 'GROUP' Identifier
                    | showDelegatedAuthorizationsCommand:'SHOW' 'DELEGATED' 'AUTHORIZATIONS' ShowDelegatedAuthorizations? Identifier?
                    | showDynamicTablesCommand: 'SHOW' 'DYNAMIC' 'TABLES' LikePattern? InShowOptionals? StartsWith? LimitRows?
                    | showEventTablesCommand: ShowEventTables
                    | showExternalFunctionsCommand: 'SHOW' 'EXTERNAL' 'FUNCTIONS' LikePattern?
                    | showExternalTablesCommand: ShowExternalTables
                    | showFailoverGroupsCommand: 'SHOW' 'FAILOVER' 'GROUPS' InShowOptionals?
                    | showFileFormatsCommand: 'SHOW' 'FILE' 'FORMATS' LikePattern? InShowOptionals?
                    | showFunctionsCommand: 'SHOW' 'FUNCTIONS' LikePattern? InShowOptionals?
                    | showGlobalAccountsCommand: 'SHOW' 'GLOBAL' 'ACCOUNTS' LikePattern?
                    | showGrantsCommand: ShowGrants
                    | showIntegrationsCommand: 'SHOW' IntegrationsOptionals? 'INTEGRATIONS' LikePattern?
                    | showLocksCommand: 'SHOW' 'LOCKS' InAccount?
                    | showManagedAccountsCommand: 'SHOW' 'MANAGED' 'ACCOUNTS' LikePattern?
                    | showMaskingPoliciesCommand: 'SHOW' 'MASKING' 'POLICIES'  LikePattern? InShowOptionals?
                    | showMaterializedViewsCommand: 'SHOW' 'MATERIALIZED' 'VIEWS' LikePattern? InShowOptionals?
                    | showNetworkPoliciesCommand: 'SHOW' 'NETWORK' 'POLICIES'
                    | showObjectsCommand: 'SHOW' 'OBJECTS' LikePattern? ShowOptionals?
                    | showOrganizationAccountsCommand: 'SHOW' 'ORGANIZATION' 'ACCOUNTS' LikePattern?
                    | showParametersCommand: 'SHOW' 'PARAMETERS' LikePattern? InOrForShowParameter?
                    | showPipesCommand: 'SHOW' 'PIPES' LikePattern? InShowOptionals?
                    | showPrimaryKeysCommand: ShowPrimaryKeys
                    | showProceduresCommand: 'SHOW' 'PROCEDURES' LikePattern? InShowOptionals?
                    | showRegionsCommand: 'SHOW' 'REGIONS' LikePattern?
                    | showReplicationAccountsCommand: 'SHOW' 'REPLICATION' 'ACCOUNTS' LikePattern?
                    | showReplicationDatabasesCommand: 'SHOW' 'REPLICATION' 'DATABASES' LikePattern? WithPrimaryColName?
                    | showReplicationGroupsCommand: 'SHOW' 'REPLICATION' 'GROUPS' InShowOptionals?
                    | showResourceMonitorsCommand: 'SHOW' 'RESOURCE' 'MONITORS' LikePattern?
                    | showRolesCommand: 'SHOW' 'ROLES' LikePattern?
                    | showRowAccessPoliciesCommand: 'SHOW' 'ROW' 'ACCESS' 'POLICIES' LikePattern? InShowOptionals?
                    | showSchemasCommand: ShowSchemas
                    | showSequencesCommand: 'SHOW' 'SEQUENCES' LikePattern? InShowOptionals?
                    | showSessionPoliciesCommand: 'SHOW' 'SESSION' 'POLICIES'
                    | showSharesCommand: 'SHOW' 'SHARES' LikePattern?
                    | showSharesInFailoverGroupCommand: 'SHOW' 'SHARES' 'IN' FailOrRep 'GROUP' Identifier
                    | showStagesCommand: 'SHOW' 'STAGES' LikePattern? InShowOptionals?
                    | showStreamsCommand: 'SHOW' 'STREAMS' LikePattern? InShowOptionals?
                    | showTablesCommand: 'SHOW' 'TABLES' LikePattern? InShowOptionals?
                    | showTagsCommand: 'SHOW' 'TAGS' LikePattern? ShowTagsOptionals?
                    | showTasksCommand: ShowTasks
                    | showTransactionsCommand: 'SHOW' 'TRANSACTIONS' InAccount?
                    | showUserFunctionsCommand: 'SHOW' 'USER' 'FUNCTIONS' LikePattern? InShowOptionals?
                    | showUsersCommand: ShowUsers
                    | showVariablesCommand: 'SHOW' 'VARIABLES' LikePattern?
                    | showViewsCommand: ShowViews
                    | showWareHousesCommand: 'SHOW' 'WAREHOUSES' LikePattern?
                    ;
syntax CreateDatabase = createDatabase: 'CREATE' OrReplace? TableType? 'DATABASE' IfNotExists? Identifier
                                        CloneAtBefore?
                                       Property*
                                        WithTags?
                                        CommentClause?
                        
                        ;
syntax ShowSchemas = showSchemasOpt1: 'SHOW' Terse? 'SCHEMAS' 'HISTORY'? LikePattern? InShowOptionals? StartsWith? LimitRows?
                        ;

syntax ShowTagsOptionals = inAccountShowTagsOpt: InAccount
                            | databaseIdShowTagsOpt: 'DATABASE' Identifier?
                            | schemaIdShowTagsOpt: 'SCHEMA' Identifier?
                            | idShowTagsOpt: Identifier
                            ;

syntax ShowTasks = showTasks: 'SHOW' Terse? 'TASKS' LikePattern? InShowOptionals? StartsWith? LimitRows?
                        ;

syntax InOrForShowParameter = inOrForShowParameter: InOrFor ShowParameterOptionals;

syntax InOrFor = inOrForOpt1: 'IN'
                | inOrForOpt2: 'FOR'
                ;
 
syntax ShowParameterOptionals = sessionShowParameterOpt: 'SESSION' 
                                | accountShowParameterOpt: 'ACCOUNT' 
                                | userIdShowParameterOpt: 'USER' Identifier? 
                                | paramObjShowParameterOpt: ShowParameterObjects 
                                | tableNameShowParameterOpt: 'TABLE' PropRef
                                ;

syntax ShowParameterObjects = warehouseIdShowParameterObj: 'WAREHOUSE' Identifier?
                                | databaseidShowParameterObj: 'DATABASE' Identifier?
                                | schemaIdShowParameterObj: 'SCHEMA' Identifier?
                                | taskIdShowParameterObj: 'TASK' Identifier?
                                ;

syntax ShowPrimaryKeys =  showPrimaryKeys:'SHOW' Terse? 'PRIMARY' 'KEYS' InShowOptionals?
                        ;
syntax InShowOptionals = inShowOptionals: 'IN' ShowOptionals;

syntax ShowOptionals = accountIdShowOpt: 'ACCOUNT' Identifier?
                            | databaseIdShowOpt: 'DATABASE' Identifier? 
                            | tableNameShowOpt: 'TABLE' PropRef?
                            | viewNameShowOpt: 'VIEW' PropRef?
                            | schemaNameShowOpt: 'SCHEMA' PropRef?
                            | objNameShowOpt: PropRef
                            ;

syntax WithPrimaryColName = withPrimaryColName: 'WITH' 'PRIMARY' PropRef;

syntax TableFormatEqDelta = tableFormatEqDelta: 'TABLE_FORMAT' "=" 'DELTA';

syntax WithTags = withTags: WithClause? 'TAG' "(" {TagDecl ","}+ ")";

syntax FailOrRep = failover: 'failover'|replication:'replication';

syntax LikePattern = likePattern: 'LIKE' String;

syntax ShowDatabases = showDatabasesOpt1: 'SHOW' Terse? 'DATABASES' 'HISTORY'? LikePattern? StartsWith? LimitRows?
                        ;
syntax Terse ='TERSE';

syntax ShowEventTables = showEventTables: 'SHOW' Terse? 'EVENT' 'TABLES' LikePattern? InShowOptionals? StartsWith? LimitRows?
                        ;

syntax ShowExternalTables = showExternalTables: 'SHOW' Terse? 'EXTERNAL' 'TABLES' LikePattern? InShowOptionals? StartsWith? LimitRows?
                                ;

 syntax OnErrorAction = continueAction: 'CONTINUE'
                        | skipFile: 'SKIP_FILE' 
                        | skipFileInt: 'SKIP_FILE_' Int
                        | skipFileAbort: 'SKIP_FILE_' Int 'ABORT_STATEMENT'
                        ;

syntax Sensitivity = sensitivityOpt1: 'CASE_SENSITIVE'
                    | sensitivityOpt2: 'CASE_INSENSITIVE' 
                    | sensitivityOpt3: 'NONE'
                    ;
syntax InAccount = inAccount: 'IN' 'ACCOUNT';

syntax ExternalTableColumnDeclList = externalTableColumnDeclList: {ExternalTableColumnDecl ","}+;

syntax ExternalTableColumnDecl = externalTableColumnDecl: PropRef DataType 'AS' Expr InlineConstraint?;
syntax StartsWith = startsWith: 'STARTS' 'WITH' String;

syntax LimitRows = limitRows: 'LIMIT' Int ('from' String)?;

syntax CopyGrants = copyGrants: 'COPY' 'GRANTS';

syntax WithRowAccessPolicy = withRowAccessPolicy: WithClause? 'ROW' 'ACCESS' 'POLICY' Identifier 'ON' "(" { Identifier ","}+ ")"
                            ;   
syntax InlineConstraint = inlineConstraintUnique: ConstraintId? UniquePrimaryKey CommonConstraintProperties*
                        | inlineConstraintForeign: NullNotNull? ConstraintId? 'FOREIGN' 'KEY' 'REFERENCES' Expr ConstraintProperties
                        ;
syntax LocationEqInternalOrExternalStage = withLocation: WithClause? 'LOCATION' "=" InternalOrExternalStage
                                                ;   
syntax ShowGrants = showGrantsOptionals: 'SHOW' 'GRANTS' ShowGrantOptionals?
                    | showGrantsInSchema: 'SHOW' 'FUTURE' 'GRANTS' 'IN' 'SCHEMA' PropRef
                    | showGrantsInDatabase: 'SHOW' 'FUTURE' 'GRANTS' 'IN' 'DATABASE' Identifier
                    ;

syntax ShowGrantOptionals = onAccountShowGrantOpt: 'ON' 'ACCOUNT'
                            | onObjectNameShowGrantOpt: 'ON' ObjectType PropRef
                            | toRoleShareShowGrantOpt: 'TO' RoleUserOrShareId
                            | ofRoleShowGrantOpt: 'OF' RoleUserOrShareId
                            ;

syntax RoleUserOrShareId = roleId: ObjectTypeName Identifier 
                          ;
syntax CreateExternalTable = createExternalTableAuto: 'CREATE' OrReplace? 'EXTERNAL' 'TABLE' IfNotExists?
                                        TableName "(" ExternalTableColumnDeclList ")"
                                        Property*
                                        PartitionByClause?
                                        LocationEqInternalOrExternalStage
                                        RefreshOnCreate?
                                        AutoRefresh?
                                        Pattern?
                                        FileFormat
                                     Property?
                                        CopyGrants?
                                        WithRowAccessPolicy?
                                        WithTags?
                                        CommentClause?
                                // Partitions added and removed manually
                                
                                | createExternalTableDeltaLake: 'CREATE' OrReplace? 'EXTERNAL' 'TABLE' IfNotExists?
                                        TableName "(" ExternalTableColumnDeclList ")"
                                        Property+
                                        PartitionByClause?
                                        LocationEqInternalOrExternalStage
                                        'PARTITION_TYPE' "=" 'USER_SPECIFIED'
                                        FileFormat
                                        TableFormatEqDelta?
                                        CopyGrants?
                                        WithRowAccessPolicy?
                                        WithTags?
                                        CommentClause?
                                ;
                    
syntax CreateProcedure = createProcedureLang: 'CREATE' OrReplace? Secure? 'PROCEDURE' PropRef "(" ArgDataTypeList? ")"
                                'RETURNS' ReturnsType
                                NullNotNull?
                                'LANGUAGE' Lang
                                CalledReturnsOrStrict?
                                VolatileOrImmutable? // Note: VOLATILE and IMMUTABLE are deprecated.
                                CommentClause?
                                ExecuteAs?
                                'AS' String
                        
                        ;


syntax ShowDelegatedAuthorizations =   showDelegatedAuthorizationsByUser:  'BY' 'USER' 
                                    | showDelegatedAuthorizationsToSecurity:  'TO' 'SECURITY' 'INTEGRATION'
                                    ;
syntax Lang =sql: 'sql' |js: 'javascript';

syntax ArgDataTypeList = argDataTypeList: {(Identifier DataType) ","}+;

syntax VolatileOrImmutable = volatileOpt: 'VOLATILE' 
                                | immutableOpt: 'IMMUTABLE'
                                ;

syntax Files = fileEq: 'FILES' "=" "(" { String "," }+ ")";

syntax CopyIntoTable = copyIntoTableFromStage: 'COPY' 'INTO' PropRef
                                ('FROM' InternalOrExternalStage)?
                                Files?
                                Pattern?
                                FileFormat?
                                CopyOptions*
                                ValidationMode?
                      
                        ;

syntax ValidationMode = validationMode: 'VALIDATION_MODE' "=" ReturnValidationType;

syntax ReturnValidationType = returnValidationTypeOpt1: 'RETURN_' Int '_ROWS' 
                            | returnValidationTypeOpt2: 'RETURN_ERRORS'
                            | returnValidationTypeOpt3: 'RETURN_ALL_ERRORS'
                            ;


syntax FileFormat = fileFormat: 'FILE_FORMAT' "=" "(" Property+ ")";

syntax InternalOrExternalStage = stageAtId: "@" Identifier "/"
                                | stageAtIdNoSlash: "@" Identifier
                                | externallocation: ExternalLocation
                                ;

syntax ExternalLocation = externalLocationOpt1: S3OrGovAwsPath
                        | externalLocationOpt2: "\'" 'gcs://' Uri "\'"
                        | externalLocationOpt3: "\'" 'azure://' Uri "\'"
                        ;

syntax S3OrGovAwsPath = s3Path: "\'" 's3://' Uri "\'"
                        | s3govPath: "\'" 's3gov://' Uri "\'"
                        ;

syntax CreateSequence = createSequence: 'CREATE' OrReplace? 'SEQUENCE' IfNotExists? PropRef
                               WithClause?
                                StartWith?
                                IncrementBy?
                                OrderNoOrder?
                                CommentClause?
                        ;

syntax StartWithIncrementBy = startWithIncrementByOpt1: ExpListWithBrackets 
                            | startWithIncrementByOpt2: StartWith 
                            | startWithIncrementByOpt3: IncrementBy 
                            | startWithIncrementByOpt4: StartWith IncrementBy
                            ;

syntax StartWith = startWithOpt1: 'START' Int
                    | startWithOpt2: 'START' 'WITH' "=" Int
                    | startWithOpt3: 'START' "=" Int
                    | startWithOpt4: 'START' 'WITH' Int
                    ;
syntax CreateStream
                        = createStreamOnTable: 
                                'ON' StreamType TableName
                                CloneOptional?
                                AppendOnly?
                                InsertOnly?
                                ShowInitialRows?
                                CommentClause?
                        
                        ;
syntax InsertOnly = insertOnly: 'INSERT_ONLY' "=" 'TRUE';

syntax ShowInitialRows = showInitialRows: 'SHOW_INITIAL_ROWS' "=" Boolean;

syntax AppendOnly = appendOnly: 'APPEND_ONLY' "=" Boolean;

syntax CloneOptional = cloneTimeStamp: AtOrBefore "(" 'TIMESTAMP' "=\>" String ")"
                        | cloneOffset: AtOrBefore "(" 'OFFSET' "=\>" String ")"
                        | cloneStatement: AtOrBefore "(" 'STATEMENT' "=\>" Identifier ")"
                        | cloneStream: AtOrBefore "(" 'STREAM' "=\>" String ")"
                        ;
syntax StreamType = table: External? 'Table' |stage :'Stage' |view :'View';

syntax External = 'external';
syntax NotificationIntegration = notificationIntegration: 'NOTIFICATION_INTEGRATION' "=" String;

syntax ConstraintId = constraintId: 'CONSTRAINT' Identifier;
syntax DefaultValue = defaultExpVal: 'DEFAULT' Expr 
                    | autoIncrementVal: 'AUTOINCREMENT' StartWithIncrementBy? OrderNoOrder?
                    | identityVal: 'IDENTITY' StartWithIncrementBy? OrderNoOrder?
                    ;

syntax WithManagedAccess = withManagedAccess: 'WITH' 'MANAGED' 'ACCESS';


syntax UniquePrimaryKey = uniquePrimaryKeyOpt1: 'UNIQUE' 
                        | uniquePrimaryKeyOpt2: 'PRIMARY' 'KEY'
                        ;

syntax CommonConstraintProperties = enforcedConstraintProp: EnforcedNotEnforced ValidateNoValidate?
                                    | defferableConstraintProp: DeferrableNotDeferrable
                                    | initiallyConstraintProp: InitiallyDeferredOrImmediate
                                    | enableConstraintProp: EnableDisable ValidateNoValidate?
                                    | relyConstraintProp: 'RELY'
                                    | norelyConstraintProp: 'NORELY'
                                    ;

syntax EnforcedNotEnforced = enforcedNotEnforced: Not? 'ENFORCED'
                            ;

syntax DeferrableNotDeferrable = deferrableNotDeferrable: Not? 'DEFERRABLE'
                                ;

syntax ValidateNoValidate = validateNoValidateOpt1: 'VALIDATE' 
                            | validateNoValidateOpt2: 'NOVALIDATE'
                            ;

syntax InitiallyDeferredOrImmediate = initiallyDeferred: 'INITIALLY' 'DEFERRED' 
                                    | initiallyImmediate: 'INITIALLY' 'IMMEDIATE'
                                    ;

syntax ConstraintProperties = constraintPropStar: CommonConstraintProperties*
                            | constraintPropForeign: ForeignKeyOnActionToggle+
                            ;

syntax ForeignKeyOnActionToggle = foreignKeyOnActionToggleOpt1: ForeignKeyMatch 
                                | foreignKeyOnActionToggleOpt2: 'ON' 'UPDATE' OnAction 
                                | foreignKeyOnActionToggleOpt3: 'ON' 'DELETE' OnAction
                                ;

syntax ForeignKeyMatch = matchFull: 'MATCH' 'FULL' 
                        | matchPartial: 'MATCH' 'PARTIAL'
                        | matchSimple: 'MATCH' 'SIMPLE'
                        ;

syntax OnAction = cascadeAction: CascadeRestrict
                | setNullAction: 'SET' 'NULL' 
                | setDefaultAction: 'SET' 'DEFAULT'
                | noAction: 'NO' 'ACTION'
                ;
syntax IntegrationsOptionals = apiIntegrationsOpt: 'API' 
                                    | notificationIntegrationsOpt: 'NOTIFICATION' 
                                    | securityIntegrationsOpt: 'SECURITY' 
                                    | storageIntegrationsOpt: 'STORAGE'
                                    ;
syntax ShowAlerts = showAlerts: 'SHOW' Terse? 'ALERTS' LikePattern? InShowOptionals? StartsWith? LimitRows?
                        ;

syntax ShowUsers = showUsers: 'SHOW' Terse? 'USERS' LikePattern? StartsWith? LimitInt? ('From'String)?
                        ;

syntax LimitInt = limitInt: 'LIMIT' Int;

syntax ShowViews = showViews: 'SHOW' Terse? 'VIEWS' LikePattern? InShowOptionals? StartsWith? LimitRows?
                        ;

syntax UseCommand = useObjectCommand: 'USE' ObjectTypeName Expr
                    | useSecondaryRolesCommand: 'USE' 'SECONDARY' 'ROLES' AllOrNone
                    ;

syntax AllOrNone = allOrNoneOpt1: 'ALL' 
                | allOrNoneOpt2: 'NONE'
                ;

syntax DescribeCommand = describeAlertCommand: Describe 'ALERT' Identifier
                        | describeDynamicTableCommand: Describe 'DYNAMIC' 'TABLE' Identifier
                        | describeEventTableCommand: Describe 'EVENT' 'TABLE' Identifier
                        | describeExternalTableCommand: Describe 'EXTERNAL' 'TABLE' TableName DescribeTableType?
                        | describeMaterializedViewCommand: Describe 'MATERIALIZED' 'VIEW' TableName
                      
                        | describeResultCommand: DescribeResult
                        | describeSearchOptimizationCommand: Describe 'SEARCH' 'OPTIMIZATION' 'ON' TableName
                     
                        | describeTransactionCommand: Describe 'TRANSACTION' Int
                        | describeObjectCommand: Describe ObjectTypeName Expr!functionCallExp DescribeTableType? ArgTypes?
                       
                        ;

syntax Describe = describeOpt1: 'DESC'
                | describeOpt2: 'DESCRIBE'
                ;

syntax DescribeTableType = describeTypeColumns: 'TYPE' "=" 'COLUMNS' 
                            | describeTypeStage: 'TYPE' "=" 'STAGE'
                            ;

syntax DescribeResult = describeResultStr: Describe 'RESULT' String 
                        | describeResultLastQuery: Describe 'RESULT' 'LAST_QUERY_ID' "(" ")"
                        ;


syntax ObjectTypeName = roleObjectTypeName: 'ROLE'
                       |shareObjectTypeName: 'share'
                        | userObjectTypeName: 'USER'
                        | warehouseObjectTypeName: 'WAREHOUSE'
                        | integrationObjectTypeName: IntegrationsOptionals? 'INTEGRATION'
                        | networkObjectTypeName: 'NETWORK' 'POLICY'
                        | sessionObjectTypeName: 'SESSION' 'POLICY'
                        | databaseObjectTypeName: 'DATABASE'
                        | schemaObjectTypeName: 'SCHEMA'
                        | tableObjectTypeName: 'TABLE'
                        | viewObjectTypeName:  'VIEW'
                        | stageObjectTypeName: 'STAGE'
                        | fileFormatObjectTypeName: 'FILE' 'FORMAT'
                        | streamObjectTypeName: 'STREAM'
                        | taskObjectTypeName: 'TASK'
                        | maskingObjectTypeName: 'MASKING' 'POLICY'
                        | rowAccessObjectTypeName: 'ROW' 'ACCESS' 'POLICY'
                        | tagObjectTypeName: 'TAG'
                        | pipeObjectTypeName: 'PIPE'
                        | functionObjectTypeName: 'FUNCTION'
                        | procedureObjectTypeName: 'PROCEDURE'
                        | sequenceObjectTypeName: 'SEQUENCE'
                        ;

syntax Commit = commitClause: 'COMMIT' 'WORK'
                | commitClauseNoWork: 'COMMIT'
                ;

syntax Rollback = rollback: 'ROLLBACK' 'WORK'?
                ;