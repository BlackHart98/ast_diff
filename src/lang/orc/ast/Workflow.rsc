module lang::orc::ast::Workflow

extend lang::orc::ast::Expressions;

data Declaration = workflow(WorkflowBuilder workflowBldr);

  
data WorkflowBuilder = workflowBuilder(list[WorkflowStep] workflowStep);
  
data WorkflowStep 
    = startWith(str regularId)
    | then(str regularId)
    | onError(str regularId)
    | \join(str regularId)
    | kill(str regularId, str strLit) 
    | end(str regularId)
    | parallel(list[ParallelStep] parallelStep)
    | ifBranch(str branch, list[IfBranchCondition] branchCond)
    ;

data IfBranchCondition 
    = ifElseLCondition(Expr e, list[WorkflowStep] w1, list[WorkflowStep] w2)
    | ifElseCondition(Expr e, str regularId1, str regularId2)
    | ifLCondition(Expr e, list[WorkflowStep] w1)                         
    | ifCondition(Expr e, str regularId)
    ;  

   
data ParallelStep 
    = parallelDo(str regularId, list[ParallelStep] parallelStep)
    | parallelStartWith(str regularId)
    | parallelThen(str regularId)
    | parallelOnError(str regularId)
    | parallelKill(str regularId, str strLit )
    ;  
  
data Input = \data(str regularId1,str regularId2, Expr e);
  
data WorkflowBuilder = orchestrator(str regularId, Combinator combinator);
  
data Combinator = combinator(list[TaskIdentifier] taskIdentifier);
  
data TaskIdentifier 
    = parallelTasks(str regularId, list[str] idList )
    | singleTask(str regularId)
    ;