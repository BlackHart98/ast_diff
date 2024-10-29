module lang::orc::prettyprint::Workflow

import lang::orc::ast::Workflow;

extend lang::orc::prettyprint::Expressions;

import List;

public str toString(str id) = "<id>";

public str toString(workflow(WorkflowBuilder workflowBldr)) = "<toString(workflowBldr)>";

public str toString(workflowBuilder(list[WorkflowStep] workflowStep)) = "builder
                                                                         '        .<intercalate("\n.", [toString(workFlow) | workFlow <- workflowStep])>";


public str toString(WorkflowStep w){
  switch(w){
    case startWith(str regularId): return "startWith(<regularId>)";
    case then(str regularId): return "then(<regularId>)";
    case onError(str regularId): return "onError(<regularId>)";
    case \join(str regularId): return "join(<regularId>)";
    case kill(str regularId, str strLit): return "kill(<regularId>, <strLit>)";
    case end(str regularId): return "end(<regularId>)";
    case parallel(list[ParallelStep] parallelStep): return "parallel().<intercalate(".", [toString(step) | step <- parallelStep])>";
    case ifBranch(str branch, list[IfBranchCondition] branchCond): return "branch(<branch>).<intercalate(".", [toString(cond) | cond <- branchCond])>";

    default: return "";
  }
}
// TODO: Expressions and add <> toString below
// IfBranchCondition

public str toString(IfBranchCondition cond){
  switch(cond){
    case ifElseLCondition(Expr e, list[WorkflowStep] w1, list[WorkflowStep] w2): return "if ( <toString(e)> )
                                                                                        '   . do ( then =\> then . <intercalate(".", [toString(w) | w <- w1])> )
                                                                                        '. else ( then =\> then . <intercalate(".", [toString(w) | w <- w2])> )
                                                                                        ";
    case ifElseCondition(Expr e, str regularId1, str regularId2): return "if ( <toString(e)> )
                                                                          '   . then ( <regularId1> )
                                                                          '. else ( <regularId2> )
                                                                          ";
    case ifLCondition(Expr e, list[WorkflowStep] w1): return "if ( <toString(e)> )
                                                              '   . do ( then =\> then <intercalate(".", [toString(w) | w <- w1])> )
                                                              ";
    case ifCondition(Expr e, str regularId): return "if ( <toString(e)> ) . then( <regularId> )";

    default: return "";
  }
}

public str toString(ParallelStep step){
  switch(step){
    case parallelDo(str regularId, list[ParallelStep] parallelStep): return "do ( <regularId> =\> then . <intercalate(".", [toString(stp) | stp <- parallelStep])> )";
    case parallelStartWith(str regularId): return "startWith(<regularId>)";
    case parallelThen(str regularId): return "then ( <regularId> )";
    case parallelOnError(str regularId): return "onError (<regularId>)";
    case parallelKill(str regularId, str strLit ): return "kill(<regularId> , <strLit> )";

    default:return  "";

  }
}




public str toString(\data(str regularId1,str regularId2, Expr e)) = "<regularId1> =\> <toString(e)>, <regularId2> =\> <toString(e)>";

public str toString(orchestrator(str regularId, Combinator combinator)) = "<regularId> \>\> <toString(combinator)>";

public str toString(combinator(list[TaskIdentifier] taskIdentifier)) = "<intercalate("\>\>", [toString(task) | task <- taskIdentifier])>";


// TaskIdentifier
public str toString(parallelTasks(str regularId, list[str] idList )) = "(<regularId> | <intercalate("|", [toString(id) | id <- idList])>)";

public str toString(singleTask(str regularId)) = "<regularId>";

public str toString(TaskIdentifier task){
  switch(task){
    case parallelTasks(str regularId, list[str] idList ): return "(<regularId> | <intercalate("|", [toString(id) | id <- idList])>)";
    case singleTask(str regularId): return "<regularId>";

    default: return "";
  }
}