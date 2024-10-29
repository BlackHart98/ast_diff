module lang::configlang::grammar::Configlang

extend lang::configlang::grammar::Expressions;



start syntax Config =
     @Foldable project: "module" ModuleId
                         Import* imports 
                         Include* includes 
                         ConfigBody* body
;


syntax ModuleId
    = moduleId: {Id "."}+ moduleName
;

syntax Import
	= \import: "import" ModuleId
;


syntax Expr = 
    sqlEngineLiteral: "SQLEngine" "(" "type" "=" SQLEngineType "," "version" "=" Number ")"
    | sourceLiteral: "Database" "(" "type" "=" DatabaseType ","
                                    "host"  "=" Expr  ","
                                    "user" "="  Expr  ","
                                    "password" "=" Expr
                                ")"

    | dockerLiteral: "Docker" ":"
                         Docker

;

syntax Docker = 
    docker:
      RuntimeSpec+   
;

 
syntax RuntimeSpec =
   runtimeSpec:
        RuntimeType ":" 
           RuntimeProperty*
;

syntax RuntimeProperty =  
    ports: "ports" "=" Expr
    | environment: "environment" "=" Expr
    | volumes: "volumes" "=" Expr
    | envFile: "envFile" "=" Expr
;  


syntax RuntimeType =
         oltp: "oltp"
         | redpanda: "redpanda"
         | minio: "minio"
         | feldera: "feldera"
         | kafka: "kafka"
         | hadoop: "hadoop"
;
    
syntax Include = 
   include: "include" ModuleId 
;
syntax ConfigBody = 
    typeDefinition: "type" Id "as" ConfigType 
    | valDefinition: "val" Id "=" Expr 
    | inferredValDefinition: "val" Id ":" Type "=" Expr 
    | ProjectDeclaration
    | Override
;

syntax Override = 
    override: "override" ModuleId "with" ModuleId
    | viewProperty : "override" ModuleId "with"
           PipelineAttribute+
;

     
syntax ProjectDeclaration = 
    project: "configuration" Id projectName ":"
             ProjectAttribute+
              Configuration+
;

syntax Configuration =
    environmentsConfig: Environments 
    | pipelinesConfig:  Pipelines
;



syntax ProjectAttribute =
   version: "version" "=" Version
    | adeptVersion: "adeptVersion" "=" Version
    | projectId: "projectId" "=" StringConstant
    | srcDir : "srcDir" "=" StringConstant
    | targetDir: "targetDir" "=" StringConstant
    | workflow: "workflow" "=" Workflow "engineering"
;

syntax Workflow = 
    reverse: "reverse"
    | forward: "forward"
;

syntax Environments = 
    environments: "environments" ":"
                      EnvironmentDecl+
;

syntax EnvironmentDecl = 
    environment: "environment" Id name ":"
                     EnvironmentAttribute+
;


syntax EnvironmentAttribute = 
    runtime: "runtime" "=" Id
    | target: "target" "=" Target
    | sqlEngine: "sqlEngine" "=" Id
;


syntax RuntimePlatform  = 
    docker: "Docker"
    | aws: "AWS"
    | gcp: "GCP"
    | azure: "Azure"
;

 
syntax Target = 
    onPrem:"OnPrem"
    | cloud: "Cloud"
;


syntax SQLEngineType = 
    spark: "Spark"
    | hive: "Hive"
    | bigQuery: "BigQuery"
    | athena: "Athena"
    | snowflake: "Snowflake"
    | redshift: "Redshift"
;

syntax Pipelines = 
    pipelines: "pipelines" ":"
         PipelineDecl+
;

syntax PipelineDecl = 
    pipeline: "pipeline" Id name":"
        PipelineAttribute*
        PipelineDeclEntry+
;

syntax PipelineDeclEntry =       
    ingestion: Ingestion
    | transformationDecl: TransformationDecl
;

 syntax Ingestion = 
    batch: "ingestion" Id ":"
               "batch" ":"
                "dataflow" ModuleId
                  KindAttribute?
                  IngestionDecl+
    | realtime: "realtime" ":" 
                   MappingAttribute
                   RuntimeConf*
                   CDCPlatform 
                   
; 

syntax RuntimeConf =
   objectStoragePlatform:
        "objectStoragePlatform" ":" 
            "runtime" ":" RuntimePlatform
             ObjectStoragePlatform
   | pubSubPlatform: 
        "pubSubPlatform" ":" 
            "runtime" ":" RuntimePlatform
             PubSubPlatform
   |  ivmPlatform: 
        "ivmPlatform" ":" 
            "runtime" ":" RuntimePlatform 
             IVMPlatform
   |  transformationPlatform:
         "transformationPlatform" ":" 
            "runtime" ":" RuntimePlatform 
             TransformationPlatform
;

syntax ObjectStoragePlatform =
    minioStore: "minio" ":" 
                  EnvironmentSpec 
    | awsS3: "s3" ":"
                EnvironmentSpec 
    | blobStore: "blobStore" ":"
                    EnvironmentSpec
;


syntax PubSubPlatform =
    redpanda: "redpanda" ":"
               EnvironmentSpec
    | kafka: "kafka" ":"
                EnvironmentSpec
    | mks: "mks" ":"
               EnvironmentSpec
;


syntax IVMPlatform =
    feldera: "feldera" ":"
               EnvironmentSpec
;

syntax TransformationPlatform =
    transformationPlatform: "hadoop" ":"
                              EnvironmentSpec
;



syntax EnvironmentSpec = 
    environmentSpec: "user" "=" Expr
                       "password" "=" Expr
    | postgresEnvironmentSpec: 
           "postgres" ":"
                        "host" "=" Expr
                        "port" "=" Expr
                        "user" "=" Expr
                        "password" "=" Expr
                        "dbName" "=" Expr  
    | oracleEnvironmentSpec: 
           "oracle" ":"
                        "host" "=" Expr
                        "port" "=" Expr
                        "user" "=" Expr
                        "password" "=" Expr
                        "dbName" "=" Expr  

    | hadoopEnvironmentSpec:
            "hostName" ":" "sparkYarnMaster"
            "jdbcCatalog" ":" 
              "postgres" ":"
                        "host" "=" Expr
                        "port" "=" Expr
                        "user" "=" Expr
                        "password" "=" Expr
                        "dbName" "=" Expr  
                                   
    ;


syntax KindAttribute = 
    kindAttribute: "kind" "=" BatchIngestionKind
;

syntax MappingAttribute = 
   mappingAttribute: "mapping" "=" ModuleId "[" {EId ","}+ "]"
;

syntax IngestionDecl = 
    ingestionDecl: "sourceGrouping" ":"
             KindAttribute?
             IngestionDeclEntry+
;

syntax IngestionDeclEntry = 
    mechanism: "mechanism" "=" IngestionMechanism
    | mapping: MappingAttribute
    | source:  "datasource" "=" Id
;


syntax IngestionMechanism = 
   sqoop: "Sqoop" 
   | singer: "Singer"
;


syntax BatchIngestionKind = 
    full: "Full"
    | incremental: IncrementalKind
;


syntax DatabaseType = 
    postgres: "Postgres" 
    | mysql: "MySQL"
    | oracle: "Oracle"
    | sqlserver: "SQLServer"
;

syntax TransformationDecl = 
   transformationDecl: "view" Id name ":"
    PipelineAttribute+
    
;

syntax PipelineAttribute = 
     retries: "retries" "=" Expr
    | viewRef: "viewRef" "=" ModuleId
    | partitionBy: "partitionedBy" "=" "["{EId ","}*"]"
    | materializedAs: "materializedAs" "=" MaterializedOption
    // | startDate: "start" "=" Date
    // | endDate: "end" "=" Date
    | storageFormat:"storageFormat" "=" StorageFormat
    | dialect: "dialect" "=" Id
    | clusteredBy: "clusteredBy" "=" "["{EId ","}*"]"
    | dataTrigger: "dataTrigger" "=" StringConstant
    | dependsOn: "dependsOn" "=" ModuleId 
    | cadence: "cadence" "=" Cadence
    | startTime: "$start" "=" ExprOrVariable
    | endTime: "$end" "=" ExprOrVariable
    | timeZone: "utc" "=" ExprOrVariable
    | props: "properties" ":"
             Prop+

;

syntax Prop =
   prop: StringConstant "=" ExprOrVariable   
;

syntax ExprOrVariable = 
   exp: Expr
   | variable: Variable
   
;

syntax Variable  =  
   variable: "${" Id "}"("#" ModuleId)*
;
lexical Date = 
    date:[0-9][0-9]"-"[0-9][0-9]"-"[0-9][0-9][0-9][0-9] 
;

syntax Cadence = 
    daily: "@daily"
    | hourly: "@hourly"
    | weekly: "@weekly"
    | monthly: "@monthly"
    | quarterly: "@quarterly"
    | yearly: "@yearly"
;

syntax Version = 
   version: Int "."Int"." Int 
;


syntax Trigger = 
    sec: "sec"
    | min: "min"
    | hour: "hour"
;

syntax Timer = 
  timer: Int Trigger
;

syntax CDCPlatform = 
   cdcPlatform: 
        "cdcPlatform:" 
           "runtime" ":" RuntimePlatform
            CDCPlatformType
;

syntax CDCPlatformType = 
    debezium: "debezium" ":" 
        "datasource" ":" 
           EnvironmentSpec 
    | goldenGate: "goldenGate:" 
        "datasource" ":" 
          EnvironmentSpec
;
syntax StorageFormat = 
    iceberg: "Iceberg"
    | native: "Native"
;

syntax MaterializedOption = 
    table: "Table"
    | view: "View"
    | materializedView: "MaterializedView"
    | SCD
    | Incremental
    | embedded: "Embedded"
;

     

syntax SCD 
     = scd:"SCD" "("
          "type" "=" SCDType ","    
          SCDStrategy ","  
          "uniqueKey" "=" Id
     ")"
;


syntax Incremental 
   = incremental: "Incremental" "("
      "kind" "=" IncrementalKind "," 
      "strategy" "=" IncStrategy
   ")"
;


syntax IncStrategy
   = app: "Append"
   | merge: "Merge"
   | delete: "DeleteAndInsert"
   | insertOver: "InsertOverwrite"
;

syntax SCDStrategy
   = check:"strategy" "=" "Check" ","
           "checkAttributes" "=" "["{EId "," }+"]"
   | time: "strategy" "=" "Timestamp" ","
           "updatedAt" "=" EId
;

syntax IncrementalKind = 
    byTime : "ByTime" "("
      "attribute" "=" EId "," 
      "dataFormat" "=" StringConstant
   ")"
   | byColumn: "ByColumn" "("
      "attribute" "=" EId
   ")"
;
