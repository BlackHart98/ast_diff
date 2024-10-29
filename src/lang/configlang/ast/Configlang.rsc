module lang::configlang::ast::Configlang

extend lang::exprlang::ast::Expressions;

data Config =  
  project(ModuleId \module, 
          list[Import] importList,
          list[Include] includeList,
          list[ConfigBody] body)
;

data ModuleId =  
    moduleId(list[str] name)
;

data Import = 
   \import(ModuleId name)
;

data Include = 
   include(ModuleId name)
;


data ConfigBody = 
       typeDefinition(str id, ConfigType)
       | valDefinition(str id, Expr e)
       | inferredValDefinition(str id, Type t, Expr e)
       | project(str projectName,
                 list[ProjectAttribute] attrs,
                 list[Configuration] configs)
       | view(ModuleId view1, ModuleId view2)
       | viewProperty(ModuleId viewName, list[PipelineAttribute] attributes)
;


data ConfigType = 
    typeOnly(Type)
    | withConstraint(Type ty, WhereClause wherecls)
;

data ModuleId = 
   qualifiedId(list[str] qid)
;

data ProjectAttribute = 
     version(Version version)
     | adeptVersion(Version adeptversion)
     | projectId(str val)
     | srcDir(str val)
     | targetDir(str val)
     | workflow(Workflow wf)
;

data Workflow = 
     reverse()
     | forward()
;

data EnvironmentAttributes = 
     runtime(str rt)
     | target(Target tar)
     | sqlEngine(str engine)
;

data RuntimePlatform = 
     docker()
     | aws()
     | gcp()
     | azure()
;


data RuntimeProperty = 
     ports(Expr ports)
     |  environment(Expr env)
     |  volumes(Expr volumes)
     |  envFile(Expr envFile)
;  

 
data Target = 
     onPrem()
     | cloud()
;


data PipelineAttribute = 
     partitionBy(list[str] partitionBy)
     | materializedAs(MaterializedOption mOption)
     | startDate(Date date)
     | viewRef(ModuleId qid )
     | endDate(Date date)
     | storageFormat(StorageFormat sf)
     | dialect(str engineType)
     | clusteredBy(list[str] clusterby)
     | dataTrigger(str trigger)
     | dependsOn(ModuleId qid)
     | retries(str retries)
     | cadence(Cadence cadence)
     | startTime(ExprOrVariable e)
     | endTime(ExprOrVariable e)
     | timeZone(ExprOrVariable e)
     | props(list[Prop] properties)

;

data Prop =
   prop(str sc, ExprOrVariable e)
;

data ExprOrVariable = 
    exp(Expr exp)
    | variable(Variable var)
;

data Variable 
    = variable(str varId, list[ModuleId]path)
    ;

data StorageFormat = 
   iceberg() 
   | native()
;

data Timer = 
   timer(str integer, str trigger)
;

data Trigger = 
   sec()
   | min()
   | hour()
;

data Pipelines = 
    pipelines(list[PipelineDecl] pl)
;

data Environments = 
    environments(list[EnvironmentDecl] envs);

data EnvironmentDecl = 
      environment(str envName, 
                  list[EnvironmentAttributes] attributesList)
;

data Configuration =
   pipelinesConfig(Pipelines pl)
   | environmentsConfig(Environments env)
;

data PipelineDecl = pipeline(str name, list[PipelineAttribute] pa, list[PipelineDeclEntry] entries)
;


data PipelineDeclEntry =       
    ingestion(Ingestion ingestion)
    | transformationDecl(TransformationDecl transformationDecl)
;


data Ingestion = 
      batch(str name, 
            ModuleId dataFlowId,
            list[KindAttribute] kind,
            list[IngestionDecl] ingestion)
     | realtime(
             MappingAttribute mapping,
             list[RuntimeConf] runtimeConf,
             CDCPlatform cdcPlatform
        )
;

data RuntimeConf =
    transformationPlatform(RuntimePlatform rt, TransformationPlatform tp) 
    | pubSubPlatform(RuntimePlatform rt, PubSubPlatform pubSub)
    | ivmPlatform(RuntimePlatform rt, IVMPlatform ivm) 
    | objectStoragePlatform(RuntimePlatform rt, ObjectStoragePlatform storage)
;


data GoldenGate = 
     goldenGate(str dataSource,  tuple[ModuleId qid, list[str] entities] mappings)       
;

data Dataflow = 
   dataflow(list[ActionDecl] actions)
;

data CDCPlatform = 
    cdcPlatform(RuntimePlatform rt, CDCPlatformType c)    
;

data CDCPlatformType = 
    debezium(EnvironmentSpec id)
    | goldenGate(EnvironmentSpec id)
;

data MappingAttribute =
  mappingAttribute(ModuleId id, list[str] ids)
;


data BatchIngestionKind = 
   full()
   | incremental(IncrementalKind kind)
;

data Cadence =
   daily()
   | hourly()
   | weekly()
   | monthly()
   | quarterly()
   | yearly()
;

data IngestionDecl = 
     ingestionDecl(list[KindAttribute] kind, 
                   list[IngestionDeclEntry] mechanism
                   )
;

data IngestionDeclEntry = 
   mapping(MappingAttribute id)
   | source(str datasource)
   | mechanism(IngestionMechanism mappings)
;


data KindAttribute = 
  kindAttribute(BatchIngestionKind kind)
;


data IngestionMechanism =
     sqoop()
     | singer()
;


data ActionDecl = 
   action(ModuleId actionId, ModuleId toAction)
;

data TransformationDecl = 
   transformationDecl(str name, list[PipelineAttribute] attrs)
;


data Version = 
    version(str int1, str int2, str int3)
;

data Date = 
   date(str date)
;

data MaterializedOption = 
     table()
     | view()
     | materializedView()
     | scd(
          str scdtype,
          SCDStrategy strategy,
          str UKey    
     )
     | incremental(
          IncrementalKind incKind,
          IncStrategy incstrategy
     )
;

data SCDStrategy = 
     check(list[str] attributes)
     | time(str updatedAt)
;

data IncrementalKind = 
     byTime(str id, str string)
     | byColumn(str id)
;

data IncStrategy = 
     app()
     | merge()
     | delete()
     | insertOver()
;

data Type =
      \intType()
     | floatType()
     | booleanType()
     | stringType()
     | dateTimeType()
     | dateType()
     | runtime()
     | source()
     | sqlEngine()
     | \setType(Type t)
	| \mapType(Type k, Type t)
	| \listType(Type t)
     | \tupleType(list[Type] dts)
;

data WhereClause = 
   whereClause(Expr e)
;

data Expr = 
     qidExp(ModuleId qid)
     | litname(str name)
     | boolean(str booleanlit)
     | typed(str id, Type t)
     | \list(list[Expr] items)
     | \map(list[Mapping] entries)
     | sqlEngineLiteral(SQLEngineType st, str version)
     | sourceLiteral(DatabaseType dbt, 
                     Expr host, 
                     Expr user, 
                     Expr password)
     | dockerLiteral(Docker containers)

;

data Mapping = 
   mapping(Expr k, Expr v)
;

data Docker =
  docker(list[RuntimeSpec] rt)
;

data RuntimeSpec =
     runtimeSpec(RuntimeType rt, list[RuntimeProperty] pty)
;

data DatabaseType =
    postgres()
    | mysql()
    | oracle()
    | sqlserver()
;


data RuntimeType =
        oltp()
        | redpanda()
        | minio()
        | feldera()
        | kafka()
        | hadoop()
;

data SQLEngineType = 
    spark()
    | hive()
    | bigQuery()
    | athena()
    | snowflake()
    | redshift()
;


data ObjectStoragePlatform =
    minioStore(EnvironmentSpec envSpec)
    | awsS3(EnvironmentSpec envSpec)
    | blobStore(EnvironmentSpec envSpec)
;


data PubSubPlatform =
    redpanda(EnvironmentSpec envSpec)
    | kafka(EnvironmentSpec envSpec)
    | mks(EnvironmentSpec envSpec)
;

data IVMPlatform =
    feldera(EnvironmentSpec envSpec)
;

data TransformationPlatform =
  transformationPlatform(EnvironmentSpec env)
;

data EnvironmentSpec = 
    environmentSpec(Expr user, Expr password)
    |  postgresEnvironmentSpec(Expr host, Expr port, Expr user, Expr password, Expr dbName)  
    |  oracleEnvironmentSpec(Expr host, Expr port, Expr user, Expr password, Expr dbName) 
    |  hadoopEnvironmentSpec(Expr host, Expr port, Expr user, Expr password, Expr dbName) 

;