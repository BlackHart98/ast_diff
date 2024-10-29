module lang::configlang::prettyprint::Configlang
import lib::Utils;
import lang::configlang::ast::Configlang;
extend lang::exprlang::prettyprint::Expressions;
import List;
import Type;


public str toString(moduleId(list[str] qid)) = "<intercalate(".",[id|id<-qid])>";

public str toString(project(ModuleId \module, 
          list[Import] importList,
          list[Include] includeList,
          list[ConfigBody] body)) ="module <toString(\module)> \n" +
     "<intercalate("",["<toString(imp)>\n"|imp<-importList])>"+
     "<intercalate("",["<toString(inc)>\n"|inc<-includeList])>"+
     "\n<intercalate("",["<toString(b)>\n"|b<-body])> "
    ;

public str toString(cdcPlatform(RuntimePlatform rt, CDCPlatformType c)) = "cdcPlatform:"+
     "\n\truntime : <toString(rt)>"+
     "\n\t<toString(c)>"
;
public str toString(CDCPlatformType::debezium(EnvironmentSpec id))="debezium:\n  datasource: \n\t <toString(id)>";
public str toString(CDCPlatformType::goldenGate(EnvironmentSpec  id))="goldenGate:\n  datasource: \n\t <toString(id)>";


public str toString(\import(ModuleId fileName)) ="import <toString(fileName)>"

;

public str toString(include(ModuleId fileName)) ="include <toString(fileName)>"
;

public str toString(typeDefinition(str id, ConfigType ct))="def type <id> as <toString(ct)>";

public str toString(valDefinition(str id, Expr e))=" val <id>= <toString(e)>";
public str toString(inferredValDefinition(str id, Type t, Expr e))=" val <id>:<toString(t)>= <toString(e)>";

public str toString(typeOnly(Type t))="<toString(t)>";


public str toString(withConstraint(Type ty,WhereClause wherecls))="<toString(ty)> <toString(wherecls)>";

public str toString(whereClause(Expr exp))= "where <toString(exp)>";

public str toString(project(str projectName,list[ProjectAttribute] projectAttributes,list[Configuration] configs))=" configuration <projectName> :
            '   <intercalate("\n",[toString(attribute)|attribute<-projectAttributes])>
            '   <intercalate("\n",[toString(con)|con<-configs])>";

public str toString( EnvironmentAttributes::runtime(str val))="runtime ="+val;

public str toString(target(Target val))="target =<toString(val)>";

public str toString(sqlEngine(str val))="sqlEngine ="+val;

public str toString(onPrem())="OnPrem";

public str toString(cloud())="Cloud";

public str toString(environmentsConfig(Environments env))= toString(env);

public str toString(pipelinesConfig(Pipelines pip))= toString(pip);

// public str toString(sqlenginedecl(str engineType,str number))="SQLEngine ( type = <engineType> , version = <number> )";

public str toString(docker())="Docker";

public str toString(aws())="AWS";

public str toString(gcp())="GCP";

public str toString(azure())="Azure";

// public  str toString(runtime(RuntimePlatform rtp,list[RuntimePlatformDeclaration] runtimeplatformList))=
//    "<toString(rtp)>:"+
//    intercalate("",["\n\t<toString(plat)>"|plat<-runtimeplatformList])
//    ;

// public str toString(platformDecl(str id,list[RuntimeProperties] runtimeProperties))=
//    "<id>:"+
//    intercalate("",["\n\t<toString(prop)>"|prop<-runtimeProperties])
//    ;
public str toString(date(str date))="<date>";

public str toString(ports(Expr ports)) = "ports = <toString(ports)>";
public str toString(environment(Expr environments))= "environment=<toString(environments)>";
public str toString(volumes(Expr volumes)) = "volumes = <toString(volumes)>";
public str toString(envFile(Expr envFile)) = "env-file=<toString(envFile)>";
public str toString(hadoopEnvironmentSpec(Expr host, Expr port, Expr user, Expr password, Expr dbName) ) ="hostName:sparkYarnMaster
njdbCatalog:\n\tpostgres: "
+"\n\thost= <toString(host)>"
+"\n\tport= <toString(port)>"
+"\n\tuser= <toString(user)>"
+"\n\tpassword= <toString(password)>"
+"\n\tdbName= <toString(dbName)>"
;

public str toString(PipelineAttribute ta){

      switch(ta){
        case viewRef(ModuleId val):return "viewRef =<toString(val)>";

        case partitionBy(list[str] val):return "partitionedBy =[<intercalate(",",[v|v<-val])>]";

        case materializedAs(MaterializedOption mOpt):return "materializedAs =<toString(mOpt)>";

        case startDate(Date val):return "start =<toString(val)>";

        case endDate(Date val):return "end =<toString(val)>";

        case storageFormat(StorageFormat val):return "storageFormat = <toString(val)>";

        case dialect(str val):return "dialect = <val>";

        case clusteredBy(list[str] val):return "clusteredBy = [<intercalate(",",[v|v<-val])>]";
        
        case dataTrigger(str val):return "dataTrigger = <val>";

        case startTime(ExprOrVariable e): return "$start = <toString(e)>";
        case endTime(ExprOrVariable e):  return "$end = <toString(e)>";

        case timeZone(ExprOrVariable e):return "utc = <toString(e)>";
        
        case props(list[Prop] properties): return "properties:"+
        "\n\t<intercalate("\n",["<toString(p)>"|p<-properties])>";
       
        case  cadence(Cadence cadence): return "cadence="+ toString(cadence);
        
        default: throw ToStringException("Error:Unresolved node",typeCast(#node,ta).src);
      } 
}
public str toString(Cadence e){
   switch(e){
    case daily():return "@daily";
    case hourly():return "@hourly";
    case weekly():return "@weekly";
    case monthly():return "@monthly";
    case quarterly(): return "@quaterly";
    case yearly(): return "@yearly";

    default: throw "";
   }
}
   

public str toString(exp(Expr exp))=toString(exp);
public str toString(variable(variable(str varId, list[ModuleId]path)))= "${<varId>}<intercalate("",["#<toString(p)>"|p<-path])>"
    ;

public str toString(prop(str sc, ExprOrVariable e))= "<sc>=<toString(e)>";

public str toString(timer(str integer,str trigger))= "<integer><trigger>";
public str toString(retries(str val))="retries = " +val;
public str toString(iceberg() )="iceberg";
public str toString(native() )="native";

public str toString(realtime(
         MappingAttribute mapping,
             list[RuntimeConf] runtimeConf,
             CDCPlatform cdcPlatform
        ))="realtime:"+
           "\n\t<toString(mapping)>"+
           intercalate("\n",[toString(conf)|conf<-runtimeConf])+
           "\n\t<toString(cdcPlatform)>"
           
           ;
public str toString(mappingAttribute(ModuleId mid,list[str] ids))= "mapping =<toString(mid)>[<intercalate(",",[id|id<-ids])>]";

public str toString(pipelines(list[PipelineDecl] pipelineList))="pipelines :
           '   <intercalate("\n",[toString(pipeline)|pipeline<-pipelineList])>";

public str toString(environments(list[EnvironmentDecl] enviromentList))="environments:
           '   <intercalate("\n",[toString(enviroment)|enviroment<-enviromentList])> ";

public str toString(environment(str envName ,list[EnvironmentAttributes] attributesList))= "environment <envName> :
           '   <intercalate("\n",[toString(attribute)|attribute<-attributesList])>";

public str toString(pipeline(str name, list[PipelineAttribute] pa, list[PipelineDeclEntry] entries))=
          "pipeline <name> :"
           
           +   "<intercalate("",["\n\t<toString(d)>"|d<-pa])>
           '   <intercalate("\n",[toString(ent)|ent<-entries])>";
          
public str toString(transformationDecl(str transformationName,list[PipelineAttribute] attributeList))="view <transformationName> :
           '    <intercalate("\n",[toString(attribute)|attribute<-attributeList])>";

public str toString(ingestion(Ingestion ingestion))=toString(ingestion);

public str toString(transformationDecl(TransformationDecl transformationDecl))=toString(transformationDecl);

public str toString( ProjectAttribute pa){

    switch(pa){
         case version(Version val):return "version = <toString(val)>";
         case adeptVersion(Version val):return "adeptVersion = <toString(val)>";
         case projectId(str val):return "project_id = <val>";
         case srcDir(str val):return "src_dir = <val>";
         case targetDir(str val):return "target_dir = <val>
         ";
         case workflow(Workflow wf): return "workflow = <toString(wf)> engineering";

         default: throw "";
    }
    
}

public str toString(reverse())= "reverse";
public str toString(forward())= "forward";
public str toString(\list(list[Expr] items))= "["+intercalate(",",[toString(item)|item <-items])+"]";
// public str toString(object(lrel[Expr key,Expr val] props)) ="{"+intercalate(",",["<toString(prop.key)>:<toString(prop.val)>"|prop <-props])+"}";
    
public str toString(version(str int1,str int2,str int3 ))="<int1>.<int2>.<int3>";

public str toString(view(ModuleId view1,ModuleId view2)) = "override <toString(view1)> with <toString(view2)>";

public str toString(viewProperty(ModuleId viewName, list[PipelineAttribute] attributeList)) = "\noverride <toString(viewName)> with " +
    "<intercalate("",["\n\t<toString(attr)>"|attr<-attributeList])>"
 ;





public str toString(table())="Table";
public str toString(view())="View";
public str toString(RuntimeConf::transformationPlatform(RuntimePlatform rt, TransformationPlatform tp))="transformationPlatform:"+ 
        "\n\truntime:<toString(rt)>"
        +"\n\t<toString(tp)>"
        ;
public str toString(pubSubPlatform(RuntimePlatform rt, PubSubPlatform pubSub))="\npubSubPlatform:"+
          "\n\truntime:<toString(rt)>"+
          "\n\t<toString(pubSub)>"
          ;
public str toString(ivmPlatform(RuntimePlatform rt, IVMPlatform ivm))="ivmPlatform:"+
          "\n\truntime:<toString(rt)>"+
           "\n\t<toString(ivm)>"
          ;
public str toString(objectStoragePlatform(RuntimePlatform rt, ObjectStoragePlatform storage))="objectStoragePlatform:"+
          "\n\truntime:<toString(rt)>"+
          "\n\t<toString(storage)>"
          
          ;

 public str toString(minioStore(EnvironmentSpec envSpec))="minio: \n\t<toString(envSpec)>";
public str toString(awsS3(EnvironmentSpec envSpec))="s3: \n\t<toString(envSpec)>";
public str toString(blobStore(EnvironmentSpec envSpec))="blobStore: \n\t<toString(envSpec)>"
;


public str toString(redpanda(EnvironmentSpec envSpec))="redpanda:\n\t<toString(envSpec)> ";
public str toString(kafka(EnvironmentSpec envSpec))="kafka: \n\t<toString(envSpec)>";
public str toString(mks(EnvironmentSpec envSpec)
)="mks: \n\t<toString(envSpec)>";

public str toString( feldera(EnvironmentSpec envSpec))="feldera: \n\t<toString(envSpec)>"
;

public str toString(transformationPlatform(EnvironmentSpec env))="hadoop:  \n\t<toString(env)>"
;

public str toString(environmentSpec(Expr user, Expr password))="user =<toString(user)> \n password =<toString(password)>";
public str toString( postgresEnvironmentSpec(Expr host, Expr port, Expr user, Expr password, Expr dbName)  )="postgres: "
+"\n\thost= <toString(host)>"
+"\n\tport= <toString(port)>"
+"\n\tuser= <toString(user)>"
+"\n\tpassword= <toString(password)>"
+"\n\tdbName= <toString(dbName)>"
;
public str toString( oracleEnvironmentSpec(Expr host, Expr port, Expr user, Expr password, Expr dbName)) ="oracle: "
+"\n\thost= <toString(host)>"
+"\n\tport= <toString(port)>"
+"\n\tuser= <toString(user)>"
+"\n\tpassword= <toString(password)>"
+"\n\tdbName= <toString(dbName)>"
;
 

public str toString(materializedView()) = "Materialized View";

public str toString(scd(str scdtypes ,
          SCDStrategy  strategy,
          str UKey
         )) = "SCD("
            + "\n\t type = <scdtypes>,"
            + " \n\t <toString(strategy)>,"
            +  "\n\t unique_key = <UKey>
           ) ";

public str toString(check(list[str] attributes)) = "strategy = Check,"
           + "\n\t check_attributes = [<intercalate(",",[attribute|attribute<-attributes])>]"
           ;

public str toString(time( str updated_at))="strategy = Timestamp,"
          + "\nupdated_at = <updated_at>"
          ;

public str toString(incremental(
          IncrementalKind incKind,
          IncStrategy incstrategy
     )) =  "Incremental("
      +"\n  kind = <toString(incKind)>"
     + "\n ,strategy= <toString(incstrategy)>"
   + ")"
   ;
public str toString(byTime( str id, str string))= "By_time(" 
      +"\n\t attribute = <id>"+
     "\n\t,data_format = <string>"+
   ")"
   ;

public str toString(kindAttribute(BatchIngestionKind kind))="kind ="+ toString(kind);

public str toString(batch(str name, 
            ModuleId dataFlowId,
            list[KindAttribute] kind,
            list[IngestionDecl] ingestion))=
   "Ingestion <name>:"+
   "<toString(dataFlowId)>"+
   "\n\tBatch :"+
   intercalate("",["\n\tkind=<toString(ka)>"|ka<-kind])+
   intercalate("",["\n\t<toString(idl)>"|idl<-ingestion])
;


public str toString(ingestionDecl(list[KindAttribute] kind, 
                   list[IngestionDeclEntry] mechanism
                   ))=
    "\nsourcegrouping :"
    +"\n\t<intercalate("",["<toString(ka)>"|ka<-kind])>"
    +"\n\t<intercalate("\n\t",["<toString(ka)>"|ka<-mechanism])>"
    
    ;
public str toString(full())="Full";

public str toString( mapping(MappingAttribute id))=toString(id);
public str toString(source(str datasource))="datasource =<datasource>";
public str toString(mechanism(IngestionMechanism mappings))="mechanism = <toString(mappings)>";

public str toString(incremental(IncrementalKind inK))= toString(inK);

public str toString(sqoop())="Sqoop";
public str toString(singer())="Singer";

public str toString(app())="Append";

public str toString(merge())="Merge";

public str toString(delete())="DeleteAndInsert";

// public str toString(datasource(str id, Expr \type,QualifiedId host,Expr user,Expr password))=
//     "<id>("+
//       "\n\ttype= <toString(\type)>"+
//       "\n\thost= <toString(host)>"+
//       "\n\tuser= <toString(user)>"+
//       "\n\tpassword= <toString(password)>"+
//     ")";

public str toString(insertOver())="InsertOverwrite";

public str toString(Type t){
  switch(t){
    case Type::\intType(): return "Int";
    case booleanType(): return "Bool";
    case stringType(): return "Str";
    case dateTimeType(): return "Datetime";
    case dateType(): return "Date";
    case runtime(): return "Runtime";
    case source(): return "Source";
    case sqlEngine():return "SQLEngine";
    case \setType(Type t):return "Set[ <toString(t)>]";
    case \mapType(Type k, Type t): return "Map [<toString(k)>,<toString(t)>]";
    case \listType(Type t):return "List[<toString(t)>]";
    case \tupleType(list[Type] dts): return "Tuple[<intercalate(",",[toString(t)|t<-dts])>]";

    default: throw ToStringException("Unhandled Data Type",typeCast(#node,t).src);
  }
}

public str toString(Expr e){
  switch(e){
    case qidExp(ModuleId qid): return "<toString(qid)>";
    case litname(str name): return "<name>";
    case boolean(str booleanlit): return "<booleanlit>";
    case typed(str id ,Type t ): return "<id>:<toString(t)>";

    default: throw ToStringException("Unhandled Expression",typeCast(#node,e).src);

  }
}
public str toString(qualifiedId(list[str] ids))="<intercalate(".",[id|id<-ids])>";