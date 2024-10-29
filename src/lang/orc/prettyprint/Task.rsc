module lang::orc::prettyprint::Task

import lang::orc::ast::Task;
import List;

public str toString(tasks(Task t)) = "<toString(t)>";

public str toString(taskDef(str taskId, TaskDefBody taskDefBody, SchedulerRef schedulerRef)) = "task <taskId>:
                                                                                                '   <toString(taskDefBody)> -\> <toString(schedulerRef)>\n\n";

public str toString(schedulerRef(str schedulerId)) = "<schedulerId>";


// TaskDefBody
public str toString(TaskDefBody tsk){
  switch(tsk){
    case hiveTaskDef(list[TaskDesc] taskDesc): return "HiveAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case pigTaskDef(list[TaskDesc] taskDesc): return "PigAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case javaTaskDef(list[TaskDesc] taskDesc): return "JavaAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case mapReduceTaskDef(list[TaskDesc] taskDesc): return "MapReduceAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case emailTaskDef(list[TaskDesc] taskDesc): return "EmailAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case fsTaskDef(list[TaskDesc] taskDesc): return "FSAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case scoopTaskDef(list[TaskDesc] taskDesc): return "SqoopAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case sparkTaskDef(list[TaskDesc] taskDesc): return "SparkAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case subWorkflowTaskDef(list[TaskDesc] taskDesc): return "SubWorkflowAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";
    case shellTaskDef(list[TaskDesc] taskDesc): return "ShellAction (\n<intercalate("; \n", [ toString(task) | task <- taskDesc ])>;\n)";

    default: return "";
  }
}

// TaskDesc

public str toString(TaskDesc tsk){
  switch(tsk){
    case taskRef(str taskRef): return " taskRef = <taskRef>";
    case master(str master): return " master = <master>";
    case command(str cmd): return " command = <cmd>";
    case mode(str mode): return " mode = <mode>";
    case class(str class): return " class = <class>";
    case resourceManager(str resourceMgr): return " resourceManager = <resourceMgr>";
    case nameNode(str nameNode): return " nameNode = <nameNode>";
    case jar(str jar): return " jar = <jar>";
    case javaOpts(str javaOpts): return " javaOpts = <javaOpts>";
    case sparkOpts(str sparkOpts): return " sparkOpts = <sparkOpts>";
    case prepare(list[PrepareParam] prepareParams): return "  prepare = ( <for(task <- prepareParams) {> <toString(task)> <}> )";
    case jobTracker(str jobTracker): return " jobTracker = <jobTracker>";
    case jobXml(list[str] jobXML): return " jobXML = [ <intercalate(",", [id | id <- jobXML])> ]";
    case configuration(list[ConfigProperty] configPrpty): return "  configuration = ( <intercalate(",", [toString(config) | config <- configPrpty])> )";
    case script(str script): return " script = <script>";
    case query(str query): return " query = <query>";
    case mainClass(str mainClass): return " mainClass = <mainClass>";
    case params(ParamList params): return " params = <toString(params)>";
    case arguments(ArgumentList arglist): return "  arguments = <toString(arglist)>";
    case file(FileList filelist): return "  file = <toString(filelist)>";
    case archive(ArchiveList archive): return " archive = <toString(archive)>";
    case delete(FSTaskOption fsTaskOpt): return " delete = ( <toString(fsTaskOpt)> )";
    case emailTo(str to): return "  to = <to>";
    case emailCc(str cc): return "  cc = <cc>";
    case emailBcc(str bcc): return "  bcc = <bcc>";
    case emailSubject(str subject): return "  subject = <subject>";
    case emailBody(str body): return "  body = <body>";
    case emailContentType(str content): return "  contentType = <content>";
    case emailAttachment(str attachment): return "  attachment = <attachment>";
    case mkDir(FSTaskOption mkDir): return "  mkdir = ( <toString(mkDir)> )";
    case move(FSTaskOption f1, FSTaskOption f2): return " move = ( <toString(f1)>, <toString(f2)> )";
    case launcher(str launcher): return " launcher = <launcher>";
    case exec(str exec): return " exec = <exec>";
    case envVar(EnvVarList envarlist): return " envVar = [ <intercalate(",", [toString(envvar) | envvar <- envarlist])> ]";
    case chmod(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3): return " chmod = ( <toString(f1)>, <toString(f2)>, <toString(f3)> )";
    case chmodRec(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3): return "  chmodRecursive = ( <toString(f1)>, <toString(f2)>, <toString(f3)> )";
    case touchz(FSTaskOption f1): return "  touchz = ( <toString(f1)> )";
    case chgrp(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3): return " chgrp = ( <toString(f1)>, <toString(f2)>, <toString(f3)> )";
    case chgrpRec(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3): return "  chgrpRecursive = ( <toString(f1)>, <toString(f2)>, <toString(f3)> )";
    case setrep( FSTaskOption f1, FSTaskOption f2): return "  setrep = ( <toString(f1)>, <toString(f2)> )";
    case pipes(
            TaskOption t1
            , TaskOption t2
            , TaskOption t3
            , TaskOption t4
            , TaskOption t5
            , TaskOption t6
            ): return " pipes = (<toString(t1)>, <toString(t2)>, <toString(t3)>, <toString(t4)>, <toString(t5)>, <toString(t6)>)";
    case streaming(
            TaskOption t1
            , TaskOption t2
            , TaskOption t3
            , TaskOption t4
            , TaskOption t5
            , TaskOption t6
            ): return " streaming = (<toString(t1)>, <toString(t2)>, <toString(t3)>, <toString(t4)>, <toString(t5)>, <toString(t6)>)";
    case appPath(str appPath): return " appPath = <appPath>";
    case propagateConfig(): return "  @propagateConfiguration";
    case captureOutput(): return "  @captureOutput";

    default: return "";
  }
}




//PrepareParam
public str toString(PrepareParam prep){
  switch(prep){
    case deletePrepare(str delete): return "delete = <delete>";
    case mkDirPrepare(str mkDir): return "mkdir = <mkDir>";

    default: return "";
  }
}

public str toString(paramList(list[str] paramList)) = "[ <intercalate(",", [ l | l <- paramList ])> ]";
public str toString(argumentList(list[str] argumentList)) = "[ <intercalate(",", [ l | l <- argumentList ])> ]";
public str toString(fileList(list[str] fileList)) = "[ <intercalate(",", [ l | l <- fileList ])> ]";
public str toString(archiveList(list[str] archiveList)) = "[ <intercalate(",", [ l | l <- archiveList ])> ]";
public str toString(deletePrepareList(list[str] deletePrepareList)) = "[ <intercalate(",", [ l | l <- deletePrepareList ])> ]";
public str toString(mkDirPrepareList(list[str] mkDirPrepareList)) = "[ <intercalate(",", [ l | l <- mkDirPrepareList ])> ]";
public str toString(envVarList(list[str] envVarList)) = "[ <intercalate(",", [ l | l <- envVarList ])> ]";
public str toString(javaOptList(list[str] javaOptList)) = "[ <intercalate(",", [ l | l <- javaOptList ])> ]";

// Identifier
public str toString(str id) = "<id>";


//config property

public str toString(ConfigProperty cfg){
  switch(cfg){
    case property(PropertyName, PropertyValue): return "property = ( <toString(PropertyName)>, <toString(PropertyValue)> )";
    case propertyWithDesc(PropertyName, PropertyValue, PropertyDesc): return "property = ( <toString(PropertyName)>, <toString(PropertyValue)>, <toString(PropertyDesc)> )";

    default: return "";
  }
}


public str toString(propertyName(str name)) = "name = <name>";

public str toString(propertyValue(str \value)) = "value = <\value>";

public str toString(propertyDesc(str description)) = "description = <description>";


// FSTaskOption
public str toString(FSTaskOption fst){
  switch(fst){
    case fsPath(str path): return "path = <path>";
    case fsSkipTrash(str skipTrash): return "skipTrash = <skipTrash>";
    case fsSourcePath(str srcPath): return "source = <srcPath>";
    case fsTargetPath(str target): return "target = <target>";
    case fsPermissions(str permissions): return "permissions = <permissions>";
    case fsGroup(str group): return "group = <group>";
    case fsDirFiles(str dirFiles): return "dirFiles = <dirFiles>";
    case replicationFactors(str replicationFactors): return "replicationFactors = <replicationFactors>";
    
    default: return "";
  }
}


// TaskOption
public str toString(TaskOption tsk){
  switch(tsk){
    case streamMapper(str strmMapper): return "mapper = <strmMapper>";
    case streamReducer(str strmReducer): return "reducer = <strmReducer>";
    case streamRecordReader(str strmRecordReader): return "recordReader = <strmRecordReader>";
    case streamRecordReaderMapping(RecordReaderMappingList recordRdrMapList): return "recordReaderMapping = [ <intercalate(",", [toString(record) | record <- recordRdrMapList])> ]";
    case streamEnv(EnvList envlist): return "env = [ <intercalate(",", [toString(env) | env <- envlist])> ]";
    case pipeMap(str pipeMap): return "map = <pipeMap>";
    case pipeReduce(str pipeReduce): return "reduce = <pipeReduce>";
    case pipeInputFormat(str pipeInputFmt): return "inputFormat = <pipeInputFmt>";
    case pipePartitioner(str pipePartitioner): return "partitioner = <pipePartitioner>";
    case pipeWriter(str pipeWrtr): return "writer = <pipeWrtr>";
    case pipeProgram(str pipePrgm): return "program = <pipePrgm>";
    // no syntax
    case noTaskOption(): return "";

    
    default: return "";
  }
}






// TaskType

public str toString(TaskOption tsk){
  switch(tsk){
    case hiveAction(): return "HiveAction";
    case pigAction(): return "PigAction";
    case javaAction(): return "JavaAction";
    case mapReduceAction(): return "MapReduceAction";
    case emailAction(): return "EmailAction";
    case fsAction(): return "FSAction";
    case scoopAction(): return "ScoopAction";
    case sparkAction(): return "SparkAction";
    case subWorkflowAction(): return "SubWorkflowAction";
    case shellAction(): return "ShellAction";
    case distCpAction(): return "DistCpAction";

    
    default: return "";
  }
}


