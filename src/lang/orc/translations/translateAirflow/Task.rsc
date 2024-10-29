module lang::orc::translations::translateAirflow::Task
import lang::orc::ast::Task;
import lang::python::ast::Python;

public Statement  toAirflow(tasks(Task t))=toAirflow(t);

public Statement toAirflow(taskDef(str taskId, TaskDefBody taskDefBody, schedulerRef(str schedulerId))){
    return assign([name(taskId,load())],buildTaskBody(taskDefBody,schedulerId),nothing());
}
  
public Expression buildTaskBody(hiveTaskDef(list[TaskDesc] taskDesc),str schedulerId)=call(name("HiveOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody(pigTaskDef(list[TaskDesc] taskDesc),str schedulerId)=call(name("DataprocPigOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody(javaTaskDef(list[TaskDesc] taskDesc),str schedulerId)=call(name("BashOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody( mapReduceTaskDef(list[TaskDesc] taskDesc),str schedulerId)=call(name("DataprocSubmitJobOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody(emailTaskDef(list[TaskDesc] taskDesc),str schedulerId)=call(name("EmailOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody(fsTaskDef(list[TaskDesc] taskDesc),str schedulerId)=call(name("HdfsMkdirFileOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody(sparkTaskDef(list[TaskDesc] taskDesc),str schedulerId)=call(name("SparkSubmitOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody(subWorkflowTaskDef(list[TaskDesc] taskDesc),str schedulerId)= call(name("BashOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public Expression buildTaskBody(scoopTaskDef(list[TaskDesc] taskDesc),str schedulerId)= call(name("SqoopOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);
public  Expression buildTaskBody(shellTaskDef(list[TaskDesc] taskDesc),str schedulerId)= call(name("BashOperator",load()),[],[toAirflow(desc)|desc<-taskDesc]+[\keyword(just("dag"),name(schedulerId,load()))]);


  

public Keyword toAirflow(taskRef(str taskRef))=\keyword(just("task_id"),constant(string(taskRef),nothing()));
public Keyword toAirflow(master(str master))=\keyword(just("master"),constant(string(master),nothing()));
public Keyword toAirflow(command(str cmd))=\keyword(just("bash_command"),constant(string(cmd),nothing()));
public Keyword toAirflow(mode(str mode))=\keyword(just("deploy_mode"),constant(string(mode),nothing()));
public Keyword toAirflow(class(str clas))=\keyword(just("java_class"),constant(string(clas),nothing()));
public Keyword toAirflow(nameNode(str nameNode))=\keyword(just("name"),constant(string(nameNode),nothing()));
public Keyword toAirflow(jar(str jar))=\keyword(just("jars"),constant(string(jar),nothing()));
public Keyword toAirflow(jobXml(list[str] jobXML))=\keyword(just("bash_command"),constant(listConst([string(job)|job<-jobXML]),nothing()));
public Keyword toAirflow(configuration(list[ConfigProperty] configPrpty)){

        keys=[];
        values=[];
        for(property(
                PropertyName key
                , PropertyValue val
        )<-configPrpty){
            keys=keys+ toAirflow(key);
            values= values+toAirflow(val);
        }
   return \keyword(just("conf"),constant(dictConst(keys,values),nothing()));
}
public Keyword toAirflow(script(str script))=\keyword(just("python_callable"),name(script,load()));

public Keyword toAirflow(query(str query))=\keyword(just("sql"),constant(string(query),nothing()));

public Keyword toAirflow(mainClass(str mainClass))=\keyword(just("main_class"),constant(string(mainClass),nothing()));

public Keyword toAirflow(file(fileList(list[str] fileList)))=\keyword(just("files"),constant(listConst([string(file)|file<-fileList]),nothing()));

public Keyword toAirflow(emailTo(str to))=\keyword(just("to"),constant(\listConst([string(to)]),nothing()));

public Keyword toAirflow(emailCc(str cc))=\keyword(just("cc"),constant(\listConst([string(cc)]),nothing()));

public Keyword toAirflow(emailBcc(str bcc))=\keyword(just("bcc"),constant(\listConst([string(bcc)]),nothing()));

public Keyword toAirflow(emailSubject(str subject))=\keyword(just("subject"),constant(string(subject),nothing()));

public Keyword toAirflow(emailBody(str body))=\keyword(just("body"),constant(string(body),nothing()));

public Keyword toAirflow(emailContentType(str content))=\keyword(just("html_content"),constant(string(content),nothing()));

public Keyword toAirflow(emailAttachment(str attachment))=\keyword(just("files"),constant(\listConst([string(attachment)]),nothing()));

public Keyword toAirflow(launcher(str launcher))=\keyword(just("launcher"),constant(string(launcher),nothing()));

public Keyword toAirflow(exec(str exec))=\keyword(just("executor"),constant(string(exec),nothing()));

public Keyword toAirflow(envVar(envVarList(list[str] envVarList)))=\keyword(just("env_vars"),constant(listConst([string(file)|file<-envVarList]),nothing()));


data PrepareParam 
    = deletePrepare(str delete)
    | mkDirPrepare(str mkDir)
    ;
  
  

  
public Constant toAirflow(propertyName(str name))= string(name);

public Constant toAirflow(propertyValue(str name))= string(name);

