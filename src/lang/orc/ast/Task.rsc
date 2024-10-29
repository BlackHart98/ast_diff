module lang::orc::ast::Task

data Declaration = tasks(Task t);

data Task 
    = taskDef(str taskId, TaskDefBody taskDefBody, SchedulerRef schedulerRef)
    ;
  
data SchedulerRef = schedulerRef(str schedulerId);
  
data TaskDefBody 
    = hiveTaskDef(list[TaskDesc] taskDesc)
    | pigTaskDef(list[TaskDesc] taskDesc)
    | javaTaskDef(list[TaskDesc] taskDesc)
    | mapReduceTaskDef(list[TaskDesc] taskDesc)
    | emailTaskDef(list[TaskDesc] taskDesc)
    | fsTaskDef(list[TaskDesc] taskDesc)
    | scoopTaskDef(list[TaskDesc] taskDesc)
    | sparkTaskDef(list[TaskDesc] taskDesc)
    | subWorkflowTaskDef(list[TaskDesc] taskDesc)
    | shellTaskDef(list[TaskDesc] taskDesc)
    ;  


data TaskDesc 
    = taskRef(str taskRef)
    | master(str master)
    | command(str cmd)
    | mode(str mode)
    | class(str class)
    | resourceManager(str resourceMgr)
    | nameNode(str nameNode)
    | jar(str jar)
    | javaOpts(str javaOpts)
    | sparkOpts(str sparkOpts)
    | prepare(list[PrepareParam] prepareParams)
    | jobTracker(str jobTracker)
    | jobXml(list[str] jobXML)
    | configuration(list[ConfigProperty] configPrpty)
    | script(str script) 
    | query(str query)
    | mainClass(str mainClass)
    | params(ParamList params)
    | arguments(ArgumentList arglist)
    | file(FileList filelist)
    | archive(ArchiveList archive)
    | delete(FSTaskOption fsTaskOpt)
    | emailTo(str to)
    | emailCc(str cc)
    | emailBcc(str bcc)
    | emailSubject(str subject)
    | emailBody(str body)
    | emailContentType(str content)
    | emailAttachment(str attachment)
    | mkDir(FSTaskOption mkDir)
    | move(FSTaskOption f1, FSTaskOption f2)
    | launcher(str launcher)
    | exec(str exec)
    | envVar(EnvVarList envarlist)
    | chmod(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3) 
    | chmodRec(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3) 
    | touchz(FSTaskOption f1) 
    | chgrp(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3) 
    | chgrpRec(FSTaskOption f1, FSTaskOption f2, FSTaskOption f3) 
    | setrep( FSTaskOption f1, FSTaskOption f2)
    | pipes(
            TaskOption t1
            , TaskOption t2
            , TaskOption t3
            , TaskOption t4
            , TaskOption t5
            , TaskOption t6
            )
    | streaming(
            TaskOption t1
            , TaskOption t2
            , TaskOption t3
            , TaskOption t4
            , TaskOption t5
            , TaskOption t6
            )
    | appPath(str appPath)
    | propagateConfig()
    | captureOutput()
    ;


data PrepareParam 
    = deletePrepare(str delete)
    | mkDirPrepare(str mkDir)
    ;
  
  
data ParamList = paramList(list[str] paramList);
  
data ArgumentList = argumentList(list[str] argumentList);

data FileList = fileList(list[str] fileList);

data ArchiveList = archiveList(list[str] archiveList);
  
data DeletePrepareList = deletePrepareList(list[str] deletePrepareList);

data MkDirPrepareList = mkDirPrepareList(list[str] mkDirPrepareList);

data EnvVarList = envVarList(list[str] envVarList);
  
data  JavaOptList = javaOptList(list[str] javaOptList);
  
data ConfigProperty 
    = property(
                PropertyName
                , PropertyValue
        )
    | propertyWithDesc(
                PropertyName
                , PropertyValue
                , PropertyDesc
        )
    ; 

  
data PropertyName = propertyName(str name);

data PropertyValue = propertyValue(str \value);

data PropertyDesc = propertyDesc(str description);
    
  
data FSTaskOption 
    = fsPath(str path)
    | fsSkipTrash(str skipTrash)
    | fsSourcePath(str srcPath)
    | fsTargetPath(str target)
    | fsPermissions(str permissions)
    | fsGroup(str group)
    | fsDirFiles(str dirFiles)
    | replicationFactors(str replicationFactors)
    ;

  
data TaskOption 
  = streamMapper(str strmMapper)
  | streamReducer(str strmReducer)
  | streamRecordReader(str strmRecordReader)
  | streamRecordReaderMapping(RecordReaderMappingList recordRdrMapList)
  | streamEnv(EnvList envlist)
  | pipeMap(str pipeMap)
  | pipeReduce(str pipeReduce)
  | pipeInputFormat(str pipeInputFmt)
  | pipePartitioner(str pipePartitioner)
  | pipeWriter(str pipeWrtr)
  | pipeProgram(str pipePrgm)
  | noTaskOption()    
  ;  


data EnvList 
    = envList(list[str] envlist)
    ;   

data RecordReaderMappingList
    = recordReaderMappingList(list[str] recordReaderMappingList)
    ;

data TaskType 
    = hiveAction()
    | pigAction()
    | javaAction()
    | mapReduceAction()
    | emailAction()
    | fsAction()
    | scoopAction()
    | sparkAction()
    | subWorkflowAction()
    | shellAction()
    | distCpAction()
    ;